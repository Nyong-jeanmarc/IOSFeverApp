//
//  updateMeasureWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateMeasureWorker{
    static let shared = updateMeasureWorker()
    
    func syncUpdatedMeasureObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all local Measures objects where isMeasuresUpdated is true
        let fetchRequest: NSFetchRequest<MeasuresLocal> = MeasuresLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isMeasuresUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedMeasuresObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedMeasuresObjects.isEmpty {
                print("No updated Measures objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated object
            for measureObject in updatedMeasuresObjects {
                let measureId = Int(measureObject.onlineMeasuresId)
                let takeMeasures = measureObject.takeMeasures
                let measures = measureObject.measures as? [String]
                let otherMeasures = measureObject.otherMeasures
                let measureTime = measureObject.measureTime != nil
                    ? ISO8601DateFormatter().string(from: measureObject.measureTime!)
                    : nil
                
                // Use DispatchGroup to track each network call
                dispatchGroup.enter()
                
                updateMeasuresNetworkManager.shared.updateMeasureObject(
                    measureId: measureId,
                    takeMeasures: takeMeasures,
                    measures: measures,
                    otherMeasures: otherMeasures,
                    measureTime: measureTime
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isMeasuresUpdated flag to false
                            measureObject.isMeasuresUpdated = false
                            print("Successfully synced measureId: \(measureId)")
                        } else {
                            // Keep the isMeasuresUpdated flag as true and mark failure
                            measureObject.isMeasuresUpdated = true
                            print("Failed to sync measureId: \(measureId)")
                            syncSuccess = false
                        }
                        
                        // Save changes to Core Data
                        do {
                            try context.save()
                            print("Changes saved to Core Data for measureId: \(measureId).")
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
            print("Failed to fetch updated Measures objects: \(error)")
            completion(false)
        }
    }

}
