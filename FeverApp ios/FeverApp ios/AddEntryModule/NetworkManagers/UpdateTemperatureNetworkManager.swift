//
//  UpdateTemperatureNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class UpdateTemperatureNetworkManager{
    static let shared = UpdateTemperatureNetworkManager()
    
    func markedTemperatureUpdated(temperatureId: Int64) {
           // Access the Core Data context
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           
           // Fetch the TemperatureLocal object
           let fetchRequest: NSFetchRequest<TemperatureLocal> = TemperatureLocal.fetchRequest()
           fetchRequest.predicate = NSPredicate(format: "temperatureId == %d", temperatureId)
           
           do {
               // Execute fetch request
               if let temperature = try context.fetch(fetchRequest).first {
                   // Update the isTemperatureUpdated flag
                   temperature.isTemperatureUpdated = true
                   
                   // Fetch the associated LocalEntry and update its isUpdated flag
                   if let associatedEntry = temperature.localEntry {
                       associatedEntry.isEntrySynced = true
                   }
                   
                   // Save changes to Core Data
                   try context.save()
                   print("Marked TemperatureLocal and associated LocalEntry as updated.")
               } else {
                   print("No TemperatureLocal found with ID: \(temperatureId)")
               }
           } catch {
               print("Error fetching or updating TemperatureLocal object: \(error)")
           }
       }
    func updateTemperature(
        temperatureId: Int,
        temperatureComparedToForehead: String?,
        wayOfDealingWithTemperature: String?,
        temperatureDateTime: String?,
        temperatureValue: String?,
        temperatureMeasurementUnit: String?,
        temperatureMeasurementLocation: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/temperature/\(temperatureId)") else {
            print("Invalid URL")
            completion(false)
            return
        }

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the request body dynamically
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

        // Ensure the request body is not empty
        guard !requestBody.isEmpty else {
            print("Request body is empty. Nothing to send.")
            completion(false)
            return
        }

        // Encode the request body to JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        } catch {
            print("Error encoding JSON: \(error)")
            completion(false)
            return
        }

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Check for response and status code
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Update successful: \(httpResponse.statusCode)")
                    completion(true)
                } else {
                    print("Server error: \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        task.resume()
    }

}
