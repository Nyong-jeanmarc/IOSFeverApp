//
//  rashWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class rashWorker{
    static let shared = rashWorker()
    
    func syncUnsyncedRashes(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced RashLocal objects
        let fetchRequest: NSFetchRequest<RashLocal> = RashLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isRashSynced == nil"),
            NSPredicate(format: "isRashSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedRashes = try context.fetch(fetchRequest)
            
            guard !unsyncedRashes.isEmpty else {
                print("No unsynced rash objects found.")
                completion(true)
                return
            }
            
            // Sync rashes to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for rash in unsyncedRashes {
                // Ensure all required attributes are available
                guard
                    let localEntry = rash.localEntry,
                    localEntry.onlineEntryId != 0 // Ensure online entry ID is valid
                else {
                    print("Skipping rash object with missing or invalid attributes.")
                    continue
                }

                // Use optional binding or default values for non-critical properties
                let rashes = rash.rashes as? [String] // Optional
                let rashDateTime = rash.rashTime != nil ? ISO8601DateFormatter().string(from: rash.rashTime!) : nil
                let onlineEntryId = localEntry.onlineEntryId

                dispatchGroup.enter()
                
                // Call the syncRashObject function
                rashNetworkManager.shared.syncRashObject(
                    onlineEntryId: onlineEntryId,
                    rashes: rashes,
                    rashDateTime: rashDateTime
                ) { result in
                    switch result {
                    case .success(let response):
                        if let rashResponse = response["rash"] as? [String: Any],
                           let rashId = rashResponse["rashId"] as? Int64 {
                            // Update the rash object in Core Data
                            rash.onlineRashId = rashId
                            rash.isRashSynced = true
                            
                            do {
                                try context.save()
                                print("Successfully synced rash with ID: \(rashId)")
                            } catch {
                                print("Failed to update rash in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync rash: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced rash objects: \(error.localizedDescription)")
            completion(false)
        }
    }

}
