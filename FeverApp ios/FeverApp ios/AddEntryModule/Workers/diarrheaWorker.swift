//
//  diarrheaWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class diarrheaWorker{
    static let shared = diarrheaWorker()
    
    func syncUnsyncedDiarrheaObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced DiarrheaLocal objects
        let fetchRequest: NSFetchRequest<DiarrheaLocal> = DiarrheaLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isDiarrheaSynced == nil"),
            NSPredicate(format: "isDiarrheaSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedDiarrheaObjects = try context.fetch(fetchRequest)
            
            guard !unsyncedDiarrheaObjects.isEmpty else {
                print("No unsynced diarrhea objects found.")
                completion(true)
                return
            }
            
            // Sync diarrhea objects to the server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for diarrhea in unsyncedDiarrheaObjects {
                // Ensure all required attributes are available
                guard
                    let localEntry = diarrhea.localEntry,
                    localEntry.onlineEntryId != 0 // Ensure online entry ID is valid
                else {
                    print("Skipping diarrhea object with missing or invalid attributes.")
                    continue
                }
                
                let onlineEntryId = localEntry.onlineEntryId
                let diarrheaAndOrVomiting = diarrhea.diarrheaAndOrVomiting
                let observationTimeString = diarrhea.observationTime != nil ? ISO8601DateFormatter().string(from: diarrhea.observationTime!) : nil
                
                dispatchGroup.enter()
                
                // Call the syncDiarrheaObject function
                diarrheaNetworkManager.shared.syncDiarrheaObject(
                    onlineEntryId: Int(onlineEntryId),
                    diarrheaAndOrVomiting: diarrheaAndOrVomiting,
                    observationTime: observationTimeString
                ) { result in
                    switch result {
                    case .success(let response):
                        if
                            let diarrheaResponse = response["diarrhea"] as? [String: Any],
                            let diarrheaId = diarrheaResponse["diarrheaId"] as? Int64 {
                            
                            // Update the diarrhea object in Core Data
                            diarrhea.onlineDiarrheaId = diarrheaId
                            diarrhea.isDiarrheaSynced = true
                            
                            do {
                                try context.save()
                                print("Successfully synced diarrhea with ID: \(diarrheaId)")
                            } catch {
                                print("Failed to update diarrhea in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync diarrhea: \(error.localizedDescription)")
                        syncErrors.append(error)
                    }
                    
                    dispatchGroup.leave()
                }
            }

            // Completion handler when all tasks are done
            dispatchGroup.notify(queue: .main) {
                if syncErrors.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } catch {
            print("Failed to fetch unsynced diarrhea objects: \(error.localizedDescription)")
            completion(false)
        }
    }

}
