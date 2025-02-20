//
//  updatePainWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updatePainWorker{
    static let shared = updatePainWorker()
    func syncUpdatedPainObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all local Pain objects where isPainUpdated == true
        let fetchRequest: NSFetchRequest<PainLocal> = PainLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isPainUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedPainObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedPainObjects.isEmpty {
                print("No updated Pain objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated object
            for painObject in updatedPainObjects {
                // Extract values, allowing them to be nil if they don't exist
                let painValue = painObject.painValue as? [String]
                let otherPlaces = painObject.otherPlaces
                let painSeverityScale = painObject.painSeverityScale
                let painDateTimeString = painObject.painDateTime != nil
                    ? ISO8601DateFormatter().string(from: painObject.painDateTime!)
                    : nil
                let onlinePainId = Int(painObject.onlinePainId)
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                // Call the update function for each object
                UpdatePainNetworkManager.shared.updatePain(
                    painId: onlinePainId,
                    painValue: painValue,
                    otherPlaces: otherPlaces,
                    painSeverityScale: painSeverityScale,
                    painDateTime: painDateTimeString
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isPainUpdated flag to false
                            painObject.isPainUpdated = false
                            print("Successfully synced painId: \(onlinePainId)")
                        } else {
                            // Keep the isPainUpdated flag as true and mark failure
                            painObject.isPainUpdated = true
                            print("Failed to sync painId: \(onlinePainId)")
                            syncSuccess = false
                        }
                        
                        // Save changes to Core Data
                        do {
                            try context.save()
                            print("Changes saved to Core Data for painId: \(onlinePainId)")
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
                print("All sync operations for Pain objects completed.")
                completion(syncSuccess)
            }
            
        } catch {
            print("Failed to fetch updated Pain objects: \(error)")
            completion(false)
        }
    }

}
