//
//  updateLiquidWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateLiquidWorker{
    static let shared = updateLiquidWorker()
    
    func syncUpdatedLiquidObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all local Liquid objects where isLiquidUpdated is true
        let fetchRequest: NSFetchRequest<LiquidsLocal> = LiquidsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLiquidUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedLiquidObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedLiquidObjects.isEmpty {
                print("No updated Liquid objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated Liquid object
            for liquidObject in updatedLiquidObjects {
                // Extract properties, allowing them to be nil if they don't exist
                let dehydrationSigns = liquidObject.dehydrationSigns as? [String]
                let liquidTimeString = liquidObject.liquidTime != nil
                    ? ISO8601DateFormatter().string(from: liquidObject.liquidTime!)
                    : nil
                let onlineLiquidId = Int(liquidObject.onlineLiquidId)
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                updateLiquidNetworkManager.shared.updateLiquid(
                    liquidId: onlineLiquidId,
                    dehydrationSigns: dehydrationSigns,
                    liquidTime: liquidTimeString
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isLiquidUpdated flag to false
                            liquidObject.isLiquidUpdated = false
                            print("Successfully synced liquidId: \(onlineLiquidId)")
                        } else {
                            // Keep the isLiquidUpdated flag as true and mark failure
                            liquidObject.isLiquidUpdated = true
                            print("Failed to sync liquidId: \(onlineLiquidId)")
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
            print("Failed to fetch updated Liquid objects: \(error)")
            completion(false)
        }
    }

}
