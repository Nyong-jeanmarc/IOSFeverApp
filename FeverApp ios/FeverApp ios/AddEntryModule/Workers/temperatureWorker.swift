//
//  temperatureWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData

class temperatureWorker{
    static let shared = temperatureWorker()
    
    func syncUnsyncedTemperatures(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced TemperatureLocal objects
        let fetchRequest: NSFetchRequest<TemperatureLocal> = TemperatureLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isTemperatureSynced == nil"),
            NSPredicate(format: "isTemperatureSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedTemperatures = try context.fetch(fetchRequest)
            
            guard !unsyncedTemperatures.isEmpty else {
                print("No unsynced temperature objects found.")
                completion(true)
                return
            }
            
            // Sync temperatures to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for temperature in unsyncedTemperatures {
                // Ensure all required attributes are available
                guard
                    let localEntry = temperature.localEntry,
                    localEntry.onlineEntryId != 0 // Ensure online entry ID is valid
                else {
                    print("Skipping temperature object with missing or invalid attributes.")
                    continue
                }
                
                // Use optional binding or default values for non-critical properties
                   let temperatureComparedToForehead = temperature.temperatureComparedToForehead // Optional
                   let wayOfDealingWithTemperature = temperature.wayOfDealingWithTemperature // Optional
                   let temperatureDateTime = temperature.temperatureDateTime // Optional
                   let temperatureMeasurementUnit = temperature.temperatureMeasurementUnit // Optional
                   let temperatureMeasurementLocation = temperature.temperatureMeasurementLocation // Optional

                   // Handle optional values: Use defaults if needed
                   let onlineEntryId = localEntry.onlineEntryId
                   let temperatureDateTimeString = temperatureDateTime != nil ? ISO8601DateFormatter().string(from: temperatureDateTime!) : nil
                   let temperatureValueString = String(temperature.temperatureValue)
                
                dispatchGroup.enter()
                
                // Call the syncTemperatureObject function
                temperatureNetworkManager.shared.syncTemperatureObject(
                    onlineEntryId: onlineEntryId,
                    temperatureComparedToForehead: temperatureComparedToForehead,
                    wayOfDealingWithTemperature: wayOfDealingWithTemperature,
                    temperatureDateTime: temperatureDateTimeString,
                    temperatureValue: temperatureValueString,
                    temperatureMeasurementUnit: temperatureMeasurementUnit,
                    temperatureMeasurementLocation: temperatureMeasurementLocation
                ) { result in
                    switch result {
                    case .success(let response):
                       
                      if  let temperatureResponse = response["temperature"] as? [String: Any],
                                  let temperatureId = temperatureResponse["temperatureId"] as? Int64 {
                            // Update the temperature object in Core Data
                            temperature.onlineTemperatureId = temperatureId
                            temperature.isTemperatureSynced = true
                                  
                            do {
                                try context.save()
                                print("Successfully synced temperature with ID: \(temperatureId)")
                            } catch {
                                print("Failed to update temperature in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync temperature: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced temperature objects: \(error.localizedDescription)")
            completion(false)
        }
    }

    
}
