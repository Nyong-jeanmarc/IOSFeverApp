//
//  updateTemperatureWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateTemperatureWorker{
    static let shared = updateTemperatureWorker()
    func syncUpdatedTemperatureObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all local Temperature objects where `isTemperatureUpdated` is true
        let fetchRequest: NSFetchRequest<TemperatureLocal> = TemperatureLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isTemperatureUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedTemperatureObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedTemperatureObjects.isEmpty {
                print("No updated Temperature objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated object
            for temperatureObject in updatedTemperatureObjects {
                // Set values, allowing them to be nil if they don't exist
                let temperatureId = Int(temperatureObject.onlineTemperatureId)
                let temperatureComparedToForehead = temperatureObject.temperatureComparedToForehead
                let wayOfDealingWithTemperature = temperatureObject.wayOfDealingWithTemperature
                let temperatureDateTime = temperatureObject.temperatureDateTime != nil
                    ? ISO8601DateFormatter().string(from: temperatureObject.temperatureDateTime!)
                    : nil
                let temperatureValue = String(temperatureObject.temperatureValue)
                let temperatureMeasurementUnit = temperatureObject.temperatureMeasurementUnit
                let temperatureMeasurementLocation = temperatureObject.temperatureMeasurementLocation
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                UpdateTemperatureNetworkManager.shared.updateTemperature(
                    temperatureId: temperatureId,
                    temperatureComparedToForehead: temperatureComparedToForehead,
                    wayOfDealingWithTemperature: wayOfDealingWithTemperature,
                    temperatureDateTime: temperatureDateTime,
                    temperatureValue: temperatureValue,
                    temperatureMeasurementUnit: temperatureMeasurementUnit,
                    temperatureMeasurementLocation: temperatureMeasurementLocation
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isTemperatureUpdated flag to false
                            temperatureObject.isTemperatureUpdated = false
                            print("Successfully synced temperatureId: \(temperatureId)")
                        } else {
                            // Keep the isTemperatureUpdated flag as true and mark failure
                            temperatureObject.isTemperatureUpdated = true
                            print("Failed to sync temperatureId: \(temperatureId)")
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
                print("All temperature sync operations completed.")
                completion(syncSuccess)
            }
            
        } catch {
            print("Failed to fetch updated Temperature objects: \(error)")
            completion(false)
        }
    }

}
