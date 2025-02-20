//
//  temperatureNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 22/11/2024.
//

import Foundation
import UIKit
import CoreData
class temperatureNetworkManager{
    static let shared = temperatureNetworkManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func updateTemperatureComparedToForehead(temperatureId: Int64, newComparisonValue: String, completion: @escaping (Bool) -> Void) {
      
        let fetchRequest = NSFetchRequest<TemperatureLocal>(entityName: "TemperatureLocal")
        fetchRequest.predicate = NSPredicate(format: "temperatureId == %lld", temperatureId)
        
        do {
            if let temperature = try context.fetch(fetchRequest).first {
                // Update the attribute
                temperature.temperatureComparedToForehead = newComparisonValue
                
                // Save the changes to the context
                try context.save()
                
                print("TemperatureLocal object with ID \(temperatureId) updated successfully.")
                completion(true)
            } else {
                print("No TemperatureLocal object found with ID \(temperatureId).")
                completion(false)
            }
        } catch {
            print("Error updating TemperatureLocal: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateTemperatureValue(for temperatureId: Int64, with newValue: Double, completion: @escaping (Bool) -> Void) {
        // Create a context for the operation
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to access AppDelegate")
            completion(false)
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        // Create a fetch request for TemperatureLocal
        let fetchRequest: NSFetchRequest<TemperatureLocal> = TemperatureLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "temperatureId == %d", temperatureId)

        do {
            // Fetch the results
            let results = try context.fetch(fetchRequest)
            if let temperatureObject = results.first {
                // Update the temperatureValue attribute
                temperatureObject.temperatureValue = Float(newValue)

                // Save the context
                try context.save()
                print("Temperature value updated successfully.")
                completion(true)
            } else {
                print("No TemperatureLocal object found with the given temperatureId.")
                completion(false)
            }
        } catch {
            print("Failed to fetch or update TemperatureLocal: \(error.localizedDescription)")
            completion(false)
        }
    }
    func saveTemperatureValueDate(temperatureId: Int64, temperatureDate: Date, completion: @escaping (Bool) -> Void) {
        do {
            // Fetch the StateOfHealthLocal entity by stateOfHealthId
            let fetchRequest = NSFetchRequest<TemperatureLocal>(entityName: "TemperatureLocal")
            fetchRequest.predicate = NSPredicate(format: "temperatureId == %lld", temperatureId)
            
            if let temperatureEntity = try context.fetch(fetchRequest).first {
                // Update the stateOfHealthDateTime attribute
                temperatureEntity.temperatureDateTime = temperatureDate
                
                // Save the changes
                try context.save()
                print("temperature value date \(temperatureDate) was saved for temperature object with id \(temperatureId)")
                completion(true)
            } else {
                print("No temperature found with the specified ID \(temperatureId).")
                completion(false)
            }
        } catch {
            print("Error saving temperature date: \(error)")
            completion(false)
        }
    }
    func updateWayOfDealingWithFever(temperatureId: Int64, newWayOfDealing: String, completion: @escaping (Bool) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TemperatureLocal>(entityName: "TemperatureLocal")
        fetchRequest.predicate = NSPredicate(format: "temperatureId == %lld", temperatureId)
        
        do {
            if let temperature = try context.fetch(fetchRequest).first {
                // Update the attribute
                temperature.wayOfDealingWithTemperature = newWayOfDealing
                
                // Save the changes to the context
                try context.save()
                
                print("TemperatureLocal object with ID \(temperatureId) updated successfully.")
                completion(true)
            } else {
                print("No TemperatureLocal object found with ID \(temperatureId).")
                completion(false)
            }
        } catch {
            print("Error updating TemperatureLocal: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateTemperatureLocation(
        temperatureId: Int64,
        newLocation: String,
        completion: @escaping (Bool) -> Void) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.perform { // Perform the operation on the context's queue
                do {
                    // Step 1: Fetch the TemperatureLocal object with the given temperatureId
                    let fetchRequest: NSFetchRequest<TemperatureLocal> = TemperatureLocal.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "temperatureId == %d", temperatureId)
                    fetchRequest.fetchLimit = 1
                    
                    guard let temperatureObject = try context.fetch(fetchRequest).first else {
                        print("Error: No TemperatureLocal object found with temperatureId \(temperatureId)")
                        completion(false) // Notify failure
                        return
                    }
                    
                    // Step 2: Update the temperatureMeasurementLocation attribute
                    temperatureObject.temperatureMeasurementLocation = newLocation
                    
                    // Step 3: Save the changes
                    try context.save()
                    print("Successfully updated temperatureMeasurementLocation to '\(newLocation)' for temperatureId \(temperatureId)")
                    completion(true) // Notify success
                } catch {
                    print("Error updating TemperatureLocal object: \(error.localizedDescription)")
                    completion(false) // Notify failure
                }
            }
        }
    
    func syncTemperatureObject(
        onlineEntryId: Int64,
        temperatureComparedToForehead: String?,
        wayOfDealingWithTemperature: String?,
        temperatureDateTime: String?,
        temperatureValue: String?,
        temperatureMeasurementUnit: String?,
        temperatureMeasurementLocation: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/temperature/\(onlineEntryId)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the request body, dynamically excluding nil values
        var requestBody: [String: Any] = [:]
        
        if let temperatureComparedToForehead = temperatureComparedToForehead {
            requestBody["temperatureComparedToForehead"] = temperatureComparedToForehead
        }
        if let wayOfDealingWithTemperature = wayOfDealingWithTemperature {
            requestBody["wayOfDealingWithTemperature"] = wayOfDealingWithTemperature
        }
        if let temperatureDateTime = temperatureDateTime {
            requestBody["temperatureDateTime"] = temperatureDateTime
        }
        if let temperatureValue = temperatureValue {
            requestBody["temperatureValue"] = temperatureValue
        }
        if let temperatureMeasurementUnit = temperatureMeasurementUnit {
            requestBody["temperatureMeasurementUnit"] = temperatureMeasurementUnit
        }
        if let temperatureMeasurementLocation = temperatureMeasurementLocation {
            requestBody["temperatureMeasurementLocation"] = temperatureMeasurementLocation
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Unexpected server response")
                let statusError = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])
                completion(.failure(statusError))
                return
            }
            
            guard let data = data else {
                print("No data received")
                let dataError = NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(dataError))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    completion(.success(jsonResponse))
                } else {
                    print("Invalid JSON structure")
                    let jsonError = NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                    completion(.failure(jsonError))
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func fetchEditingTemperatureLocal(byId id: Int64) -> TemperatureLocal? {
           // Access the Core Data context
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           
           // Create a fetch request for the `TemperatureLocal` entity
           let fetchRequest: NSFetchRequest<TemperatureLocal> = TemperatureLocal.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "temperatureId == %d", id)
           
           do {
               // Execute the fetch request
               let results = try context.fetch(fetchRequest)
               return results.first // Return the first matching result (if any)
           } catch {
               print("Error fetching TemperatureLocal object: \(error)")
               return nil
           }
       }
    
}
