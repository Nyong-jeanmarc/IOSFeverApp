//
//  feelingConfidentNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 26/11/2024.
//

import Foundation
import UIKit
import CoreData
class feelingConfidentNetworkManager {
    static let shared = feelingConfidentNetworkManager()
    func fetchEditingFeelingConfidentLocal(byId feelingConfidentId: Int64) -> Confidence_levelLocal? {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Confidence_levelLocal> = Confidence_levelLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "confidenceLevelId == %d", feelingConfidentId)

        do {
            // Execute fetch request
            let results = try context.fetch(fetchRequest)
            // Return the first result if found
            return results.first
        } catch {
            print("Error fetching Confidence_levelLocal with ID \(feelingConfidentId): \(error.localizedDescription)")
            return nil
        }
    }

    func updateConfidenceLevel(for confidenceLevelId: Int64, to newConfidenceLevel: String, completion: @escaping (Bool) -> Void) {
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false) // Fail if the app delegate is not available
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        // Perform the fetch and update asynchronously
        context.perform {
            let fetchRequest: NSFetchRequest<Confidence_levelLocal> = Confidence_levelLocal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "confidenceLevelId == %d", confidenceLevelId)
            fetchRequest.fetchLimit = 1 // Ensure only one object is fetched

            do {
                // Fetch the object
                let results = try context.fetch(fetchRequest)

                // Check if the object exists
                guard let confidenceLevelObject = results.first else {
                    print("No object found with confidenceLevelId \(confidenceLevelId).")
                    completion(false) // Failure if no object is found
                    return
                }

                // Update the confidenceLevel attribute
                confidenceLevelObject.confidenceLevel = newConfidenceLevel

                // Save the changes
                try context.save()
                print("Confidence level updated successfully.")
                completion(true) // Success
            } catch {
                print("Failed to fetch or update confidenceLevel: \(error.localizedDescription)")
                completion(false) // Failure in case of an error
            }
        }
    }
    func updateFeelingDate(for confidenceLevelId: Int64, to newDate: Date, completion: @escaping (Bool) -> Void) {
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false) // Fail if the app delegate is not available
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        // Perform the fetch and update asynchronously
        context.perform {
            let fetchRequest: NSFetchRequest<Confidence_levelLocal> = Confidence_levelLocal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "confidenceLevelId == %d", confidenceLevelId)
            fetchRequest.fetchLimit = 1 // Ensure only one object is fetched

            do {
                // Fetch the object
                let results = try context.fetch(fetchRequest)

                // Check if the object exists
                guard let confidenceLevelObject = results.first else {
                    print("No object found with confidenceLevelId \(confidenceLevelId).")
                    completion(false) // Failure if no object is found
                    return
                }

                // Update the confidenceLevel attribute
                confidenceLevelObject.timeOfObservation = newDate

                // Save the changes
                try context.save()
                print("Confidence level date updated successfully.")
                completion(true) // Success
            } catch {
                print("Failed to fetch or update confidenceLevel date: \(error.localizedDescription)")
                completion(false) // Failure in case of an error
            }
        }
    }
    func syncFeelingConfidentObject(
        onlineEntryId: Int64,
        confidenceLevel: String?,
        timeOfObservation: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/confidenceLevel/\(onlineEntryId)") else {
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
        
        if let confidenceLevel = confidenceLevel {
            requestBody["confidenceLevel"] = confidenceLevel
        }
        if let timeOfObservation = timeOfObservation {
            requestBody["timeOfObservation"] = timeOfObservation
        }
        
        // Serialize the request body into JSON
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

}
