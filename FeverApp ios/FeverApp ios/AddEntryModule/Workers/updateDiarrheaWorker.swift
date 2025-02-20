//
//  updateDiarrheaWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateDiarrheaWorker{
    static let shared = updateDiarrheaWorker()
    
    func syncUpdatedDiarrheaObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all DiarrheaLocal objects where isDiarrheaUpdated == true
        let fetchRequest: NSFetchRequest<DiarrheaLocal> = DiarrheaLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isDiarrheaUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedDiarrheaObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedDiarrheaObjects.isEmpty {
                print("No updated Diarrhea objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated Diarrhea object
            for diarrheaObject in updatedDiarrheaObjects {
                // Extract properties needed for the API call
                let diarrheaId = Int(diarrheaObject.onlineDiarrheaId)
                let diarrheaAndOrVomiting = diarrheaObject.diarrheaAndOrVomiting
                let observationTimeString = diarrheaObject.observationTime != nil
                    ? ISO8601DateFormatter().string(from: diarrheaObject.observationTime!)
                    : nil
                
                // Use DispatchGroup to track each API request
                dispatchGroup.enter()
                
                updateDiarrheaNetworkManager.shared.updateDiarrhea(
                    diarrheaId: diarrheaId,
                    diarrheaAndOrVomiting: diarrheaAndOrVomiting,
                    observationTime: observationTimeString
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Mark the object as synced
                            diarrheaObject.isDiarrheaUpdated = false
                            print("Successfully synced diarrheaId: \(diarrheaId)")
                        } else {
                            // Keep the flag as true and mark failure
                            diarrheaObject.isDiarrheaUpdated = true
                            print("Failed to sync diarrheaId: \(diarrheaId)")
                            syncSuccess = false
                        }
                        
                        // Save changes to Core Data
                        do {
                            try context.save()
                            print("Core Data changes saved.")
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
            print("Failed to fetch updated Diarrhea objects: \(error)")
            completion(false)
        }
    }
}
