//
//  warningSignsWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class warningSignsWorker{
    static let shared = warningSignsWorker()
    
    func syncUnsyncedWarningSigns(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced WarningSignsLocal objects
        let fetchRequest: NSFetchRequest<WarningSignsLocal> = WarningSignsLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isWarningSignsSynced == nil"),
            NSPredicate(format: "isWarningSignsSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedWarningSigns = try context.fetch(fetchRequest)

            guard !unsyncedWarningSigns.isEmpty else {
                print("No unsynced warning signs objects found.")
                completion(true)
                return
            }

            // Sync warning signs to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for warningSign in unsyncedWarningSigns {
                // Ensure all required attributes are available
                guard
                    let localEntry = warningSign.localEntry,
                   localEntry.onlineEntryId != 0
                else {
                    print("Skipping warning signs object with missing or invalid attributes.")
                    continue
                }

                // Use optional binding or default values for non-critical properties
                let warningSigns = warningSign.warningSigns as? [String] ?? nil // Optional
                let warningSignsTime = warningSign.warningSignsTime != nil ? ISO8601DateFormatter().string(from: warningSign.warningSignsTime!) : nil
     
                dispatchGroup.enter()

                // Call the syncWarningSignsObject function
                warningSignsNetworkManager.shared.syncWarningSignsObject(
                    onlineEntryId: localEntry.onlineEntryId,
                    warningSigns: warningSigns,
                    warningSignsTime: warningSignsTime
                ) { result in
                    switch result {
                    case .success(let response):
                        if let warningSignsResponse = response["warningSigns"] as? [String: Any],
                           let warningSignsId = warningSignsResponse["warningSignsId"] as? Int64 {
                            // Update the warning signs object in Core Data
                            warningSign.onlineWarningSignsId = warningSignsId
                            warningSign.isWarningSignsSynced = true

                            do {
                                try context.save()
                                print("Successfully synced warning signs with ID: \(warningSignsId)")
                            } catch {
                                print("Failed to update warning signs in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync warning signs: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced warning signs objects: \(error.localizedDescription)")
            completion(false)
        }
    }

    
}
