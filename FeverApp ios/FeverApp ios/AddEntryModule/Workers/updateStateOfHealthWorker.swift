//
//  updateStateOfHealthWorker.swift
//  FeverApp ios
//
//  Created by NEW on 15/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateStateOfHealthWorker{
    static let shared = updateStateOfHealthWorker()
    func syncUpdatedStateOfHealthObjects( completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Fetch all local StateOfHealth objects where `isStateOfHealthUpdated` is true
        let fetchRequest: NSFetchRequest<StateOfHealthLocal> = StateOfHealthLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isStateOfHealthUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedStateOfHealthObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedStateOfHealthObjects.isEmpty {
                print("No updated StateOfHealth objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated object
            for stateOfHealthObject in updatedStateOfHealthObjects {
                // Set values, allowing them to be nil if they don't exist
                let stateOfHealth = stateOfHealthObject.stateOfHealth
                let dateTimeString = stateOfHealthObject.stateOfHealthDateTime != nil
                    ? ISO8601DateFormatter().string(from: stateOfHealthObject.stateOfHealthDateTime!)
                    : nil
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                updateStateOfHealthNetworkManager.shared.updateStateOfHealth(
                    stateOfHealthId: Int(stateOfHealthObject.onlineStateOfHealthId),
                    stateOfHealth: stateOfHealth,
                    stateOfHealthDateTime: dateTimeString
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isStateOfHealthUpdated flag to false
                            stateOfHealthObject.isStateOfHealthUpdated = false
                            print("Successfully synced stateOfHealthId: \(stateOfHealthObject.onlineStateOfHealthId)")
                        } else {
                            // Keep the isStateOfHealthUpdated flag as true and mark failure
                            stateOfHealthObject.isStateOfHealthUpdated = true
                            print("Failed to sync stateOfHealthId: \(stateOfHealthObject.onlineStateOfHealthId)")
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
                        
                        // Leave the group after processing
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
            print("Failed to fetch updated state of health objects: \(error)")
            completion(false)
        }
    }

    
}
