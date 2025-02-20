//
//  symptomsWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class symptomsWorker {
    static let shared = symptomsWorker()
    
    func syncUnsyncedSymptoms(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced SymptomsLocal objects
        let fetchRequest: NSFetchRequest<SymptomsLocal> = SymptomsLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isSymptomsSynced == nil"),
            NSPredicate(format: "isSymptomsSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedSymptoms = try context.fetch(fetchRequest)
            
            guard !unsyncedSymptoms.isEmpty else {
                print("No unsynced symptoms objects found.")
                completion(true)
                return
            }
            
            // Sync symptoms to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for symptom in unsyncedSymptoms {
                // Ensure all required attributes are available
                guard
                    let localEntry = symptom.localEntry,
               localEntry.onlineEntryId != 0 // Ensure online entry ID is valid
                else {
                    print("Skipping symptoms object with missing or invalid attributes.")
                    continue
                }
                
                // Prepare the symptom data for sync
                let symptoms = symptom.symptoms as? [String] // Optional
                let otherSymptoms = symptom.otherSymptoms as? [String] // Optional
                let symptomsDateTimeString = symptom.symptomsTime != nil ? ISO8601DateFormatter().string(from: symptom.symptomsTime!) : nil

                dispatchGroup.enter()
                
                // Call the syncSymptomsObject function
                symptomsNetworkManager.shared.syncSymptomsObject(
                    onlineEntryId: localEntry.onlineEntryId,
                    symptoms: symptoms,
                    otherSymptoms: otherSymptoms,
                    symptomsDateTime: symptomsDateTimeString
                ) { result in
                    switch result {
                    case .success(let response):
                        if let symptomsResponse = response["symptoms"] as? [String: Any],
                           let symptomsId = symptomsResponse["symptomsId"] as? Int64 {
                            // Update the symptoms object in Core Data
                            symptom.onlineSymptomsId = symptomsId
                            symptom.isSymptomsSynced = true
                            
                            do {
                                try context.save()
                                print("Successfully synced symptoms with ID: \(symptomsId)")
                            } catch {
                                print("Failed to update symptoms in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync symptoms: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced symptoms objects: \(error.localizedDescription)")
            completion(false)
        }
    }

}
