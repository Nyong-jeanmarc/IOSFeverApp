//
//  updateRashWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateRashWorker{
    static let shared = updateRashWorker()
    func syncUpdatedRashObjects(completion: @escaping (Bool) -> Void) {
        // Access the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RashLocal> = RashLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isRashUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedRashObjects = try context.fetch(fetchRequest)
            
            // If no objects to sync, return success
            if updatedRashObjects.isEmpty {
                print("No updated Rash objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated Rash object
            for rashObject in updatedRashObjects {
                let rashId = Int(rashObject.onlineRashId) // Use onlineRashId for server requests
                let rashes = rashObject.rashes as? [String]
                
                // Convert rashTime to ISO8601 string
                let rashTimeString = rashObject.rashTime != nil
                    ? ISO8601DateFormatter().string(from: rashObject.rashTime!)
                    : nil
                
                // Enter the dispatch group before making the network call
                dispatchGroup.enter()
                
                updateRashNetworkManager.shared.updateRash(
                    rashId: rashId,
                    rashes: rashes,
                    rashDateTime: rashTimeString
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update isRashUpdated flag to false
                            rashObject.isRashUpdated = false
                            print("Successfully synced rashId: \(rashId)")
                        } else {
                            // Keep isRashUpdated as true
                            rashObject.isRashUpdated = true
                            print("Failed to sync rashId: \(rashId)")
                            syncSuccess = false
                        }
                        
                        // Save changes to Core Data
                        do {
                            try context.save()
                            print("Changes saved to Core Data.")
                        } catch {
                            print("Error saving Core Data: \(error)")
                            syncSuccess = false
                        }
                        
                        // Leave the dispatch group
                        dispatchGroup.leave()
                    }
                }
            }
            
            // Notify when all network calls are complete
            dispatchGroup.notify(queue: .main) {
                print("All sync operations completed.")
                completion(syncSuccess)
            }
            
        } catch {
            print("Failed to fetch updated Rash objects: \(error)")
            completion(false)
        }
    }

   
}
