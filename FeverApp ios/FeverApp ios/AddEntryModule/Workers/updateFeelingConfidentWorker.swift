//
//  updateFeelingConfidentWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateFeelingConfidentWorker{
    static let shared = updateFeelingConfidentWorker()
    
    func syncUpdatedConfidenceLevelObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all local ConfidenceLevel objects where isConfidenceLevelUpdated is true
        let fetchRequest: NSFetchRequest<Confidence_levelLocal> = Confidence_levelLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isConfidenceLevelUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedConfidenceLevelObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedConfidenceLevelObjects.isEmpty {
                print("No updated ConfidenceLevel objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated object
            for confidenceLevelObject in updatedConfidenceLevelObjects {
                // Set values, allowing them to be nil if they don't exist
                let confidenceLevel = confidenceLevelObject.confidenceLevel
                let timeOfObservationString = confidenceLevelObject.timeOfObservation != nil
                    ? ISO8601DateFormatter().string(from: confidenceLevelObject.timeOfObservation!)
                    : nil
                
                let onlineConfidenceLevelId = Int(confidenceLevelObject.onlineConfidenceLevelId)
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                updateFeelingConfidentNetworkManager.shared.updateConfidenceLevel(
                    confidenceLevelId: onlineConfidenceLevelId,
                    confidenceLevel: confidenceLevel,
                    timeOfObservation: timeOfObservationString
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isConfidenceLevelUpdated flag to false
                            confidenceLevelObject.isConfidenceLevelUpdated = false
                            print("Successfully synced confidenceLevelId: \(confidenceLevelObject.onlineConfidenceLevelId)")
                        } else {
                            // Keep the isConfidenceLevelUpdated flag as true and mark failure
                            confidenceLevelObject.isConfidenceLevelUpdated = true
                            print("Failed to sync confidenceLevelId: \(confidenceLevelObject.onlineConfidenceLevelId)")
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
            print("Failed to fetch updated ConfidenceLevel objects: \(error)")
            completion(false)
        }
    }
}
