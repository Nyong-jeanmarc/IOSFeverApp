//
//  updateWarningSignsWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateWarningSignsWorker{
    static let shared = updateWarningSignsWorker()
    
    func syncUpdatedWarningSignsObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all local WarningSigns objects where isWarningSignsUpdated is true
        let fetchRequest: NSFetchRequest<WarningSignsLocal> = WarningSignsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isWarningSignsUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedWarningSignsObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedWarningSignsObjects.isEmpty {
                print("No updated WarningSigns objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated object
            for warningSignsObject in updatedWarningSignsObjects {
                // Set values, allowing them to be nil if they don't exist
                let warningSigns = warningSignsObject.warningSigns as? [String]
                let warningSignsTime = warningSignsObject.warningSignsTime != nil
                    ? ISO8601DateFormatter().string(from: warningSignsObject.warningSignsTime!)
                    : nil
                
                let onlineWarningSignsId = Int(warningSignsObject.onlineWarningSignsId)
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                updateWarningSignsNetworkManager.shared.updateWarningSigns(
                    warningSignsId: onlineWarningSignsId,
                    warningSigns: warningSigns,
                    warningSignsTime: warningSignsTime
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isWarningSignsUpdated flag to false
                            warningSignsObject.isWarningSignsUpdated = false
                            print("Successfully synced warningSignsId: \(onlineWarningSignsId)")
                        } else {
                            // Keep the isWarningSignsUpdated flag as true and mark failure
                            warningSignsObject.isWarningSignsUpdated = true
                            print("Failed to sync warningSignsId: \(onlineWarningSignsId)")
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
            print("Failed to fetch updated WarningSigns objects: \(error)")
            completion(false)
        }
    }
}
