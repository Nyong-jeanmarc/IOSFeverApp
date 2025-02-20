//
//  feverPhaseWorker.swift
//  FeverApp ios
//
//  Created by NEW on 03/12/2024.
//

import Foundation
import UIKit
import CoreData
class feverPhaseWorker{
    static let shared = feverPhaseWorker()
    func syncUnsyncedFeverPhases(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced FeverPhaseLocal objects
        let fetchRequest: NSFetchRequest<FeverPhaseLocal> = FeverPhaseLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isFeverPhaseSynced == nil"),
            NSPredicate(format: "isFeverPhaseSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedFeverPhases = try context.fetch(fetchRequest)
            
            guard !unsyncedFeverPhases.isEmpty else {
                print("No unsynced fever phase objects found.")
                completion(true)
                return
            }
            
            // Sync fever phases to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for feverPhase in unsyncedFeverPhases {
                

                let feverPhaseStartDate = feverPhase.feverPhaseStartDate != nil ? ISO8601DateFormatter().string(from: feverPhase.feverPhaseStartDate!) : nil
                let feverPhaseEndDate = feverPhase.feverPhaseEndDate != nil ? ISO8601DateFormatter().string(from: feverPhase.feverPhaseEndDate!) : nil

                dispatchGroup.enter()

                // Call the syncFeverPhaseObject function
                feverPhaseNetworkManager.shared.syncFeverPhaseObject(
                    profileId: 3,
                    feverPhaseStartDate: feverPhaseStartDate,
                    feverPhaseEndDate: feverPhaseEndDate
                ) { result in
                    switch result {
                    case .success(let response):
                        if let feverPhaseId = response["feverPhaseId"] as? Int64 {
                            // Update the fever phase object in Core Data
                            feverPhase.onlineFeverPhaseId = feverPhaseId
                            feverPhase.isFeverPhaseSynced = true
                                  
                            do {
                                try context.save()
                                print("Successfully synced fever phase with ID: \(feverPhaseId)")
                            } catch {
                                print("Failed to update fever phase in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync fever phase: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced fever phase objects: \(error.localizedDescription)")
            completion(false)
        }
    }

    
    
}
