//
//  stateOfHealthWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class stateOfHealthWorker{
    static let shared = stateOfHealthWorker()
    func syncUnsyncedStateOfHealthObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced StateOfHealthLocal objects
        let fetchRequest: NSFetchRequest<StateOfHealthLocal> = StateOfHealthLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isStateOfHealthSynced == nil"),
            NSPredicate(format: "isStateOfHealthSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedStateOfHealthObjects = try context.fetch(fetchRequest)

            guard !unsyncedStateOfHealthObjects.isEmpty else {
                print("No unsynced state of health objects found.")
                completion(true)
                return
            }

            // Sync state of health objects to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for stateOfHealth in unsyncedStateOfHealthObjects {
                guard let stateOfHealthValue = stateOfHealth.stateOfHealth,
                      let stateOfHealthDateTime = stateOfHealth.stateOfHealthDateTime,
                      let associatedEntry = stateOfHealth.localEntry,
                      associatedEntry.onlineEntryId != 0 else {
                    print("Skipping state of health object with missing or invalid data.")
                    continue
                }

                dispatchGroup.enter()

                stateOfHealthNetworkManager.shared.syncStateOfHealth(
                    onlineEntryId: associatedEntry.onlineEntryId,
                    stateOfHealth: stateOfHealthValue,
                    stateOfHealthDateTime: ISO8601DateFormatter().string(from: stateOfHealthDateTime)
                ) { result in
                    switch result {
                    case .success(let response):
                        if let serverStateOfHealthId = response["stateOfHealthId"] as? Int64 {
                            // Update the state of health object in Core Data
                            stateOfHealth.onlineStateOfHealthId = serverStateOfHealthId
                            stateOfHealth.isStateOfHealthSynced = true

                            do {
                                try context.save()
                                print("Successfully synced state of health object with ID: \(serverStateOfHealthId)")
                            } catch {
                                print("Failed to update state of health object in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response from server: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync state of health object: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced state of health objects: \(error.localizedDescription)")
            completion(false)
        }
    }

}
