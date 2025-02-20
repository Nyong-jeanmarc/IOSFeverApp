//
//  AddEntryWorker.swift
//  FeverApp ios
//
//  Created by NEW on 30/11/2024.
//

import Foundation
import UIKit
import CoreData
class AddEntryWorker{
   static let shared = AddEntryWorker()
    func syncUnsyncedEntries(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch unsynced LocalEntry objects
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isEntrySynced == nil"),
            NSPredicate(format: "isEntrySynced == %@", NSNumber(value: false))
        ])
        
        do {
            // Perform the fetch request
            let unsyncedEntries = try context.fetch(fetchRequest)
            
            guard !unsyncedEntries.isEmpty else {
                print("No unsynced entries found.")
             completion(true)
                return
            }
            
            // Sync entries to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []
            
            for entry in unsyncedEntries {
                guard let entryDate = entry.entryDate else {
                    print("Skipping entry with missing date")
                    continue
                }
                
                dispatchGroup.enter()
                
                AddEntryNetworkManager.shared.createOnlineEntry(entryDate: ISO8601DateFormatter().string(from: entryDate)) { result in
                    switch result {
                    case .success(let response):
                        if let onlineEntryId = response["entryId"] as? Int64 {
                            // Update the entry in Core Data
                            entry.onlineEntryId = onlineEntryId
                            entry.isEntrySynced = true
                            
                            do {
                                try context.save()
                                print("Successfully synced entry with id: \(onlineEntryId)")
                            } catch {
                                print("Failed to update entry in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response from server: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync entry: \(error.localizedDescription)")
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
       completion(false)
        }
    }

}
