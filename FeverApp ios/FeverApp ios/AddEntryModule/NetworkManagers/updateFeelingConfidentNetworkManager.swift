//
//  updateFeelingConfidentNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateFeelingConfidentNetworkManager{
    static let shared = updateFeelingConfidentNetworkManager()
    
    func markedFeelingConfidentUpdated(feelingConfidentId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Confidence_levelLocal> = Confidence_levelLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "confidenceLevelId == %d", feelingConfidentId)

        do {
            // Execute fetch request
            let results = try context.fetch(fetchRequest)
            if let confidenceLevelObject = results.first {
                // Mark the confidence level object as updated
                confidenceLevelObject.isConfidenceLevelUpdated = true

                // Also mark the associated LocalEntry as updated
                if let localEntry = confidenceLevelObject.localEntry {
                    localEntry.isEntryUpdated = true
                }

                // Save the context
                try context.save()
            }
        } catch {
            print("Error marking Confidence_levelLocal with ID \(feelingConfidentId) and associated entry as updated: \(error.localizedDescription)")
        }
    }
    func updateConfidenceLevel(
        confidenceLevelId: Int,
        confidenceLevel: String?,
        timeOfObservation: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/confidenceLevel/\(confidenceLevelId)") else {
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
        if let confidenceLevel = confidenceLevel {
            requestBody["confidenceLevel"] = confidenceLevel
        }
        if let timeOfObservation = timeOfObservation {
            requestBody["timeOfObservation"] = timeOfObservation
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
