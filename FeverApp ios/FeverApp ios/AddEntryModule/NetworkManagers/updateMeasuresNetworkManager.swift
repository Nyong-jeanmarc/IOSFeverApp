//
//  updateMeasuresNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateMeasuresNetworkManager{
    static let shared = updateMeasuresNetworkManager()
    
    func markedMeasuresUpdated(measureId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch the measure object with the specified ID
        let fetchRequest: NSFetchRequest<MeasuresLocal> = MeasuresLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "measureId == %d", measureId)

        do {
            if let measure = try context.fetch(fetchRequest).first {
                // Update the isMeasuresUpdated property
                measure.isMeasuresUpdated = true
                
                // Update the isEntryUpdated property of the associated LocalEntry object
                if let localEntry = measure.localEntry {
                    localEntry.isEntryUpdated = true
                }
                
                // Save the context
                try context.save()
                print("Measures and associated entry marked as updated for ID \(measureId).")
            } else {
                print("No MeasuresLocal object found with ID \(measureId).")
            }
        } catch {
            print("Error updating MeasuresLocal with ID \(measureId): \(error.localizedDescription)")
        }
    }
    func updateMeasureObject(
        measureId: Int,
        takeMeasures: String?,
        measures: [String]?,
        otherMeasures: String?,
        measureTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/measures/\(measureId)") else {
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
        if let takeMeasures = takeMeasures {
            requestBody["takeMeasures"] = takeMeasures
        }
        if let measures = measures, !measures.isEmpty {
            requestBody["measures"] = measures
        }
        if let otherMeasures = otherMeasures {
            requestBody["otherMeasures"] = otherMeasures
        }
        if let measureTime = measureTime {
            requestBody["measureTime"] = measureTime
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
