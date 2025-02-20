//
//  rashNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
import CoreData
class rashNetworkManager{
    static let shared = rashNetworkManager()
    func fetchEditingRashLocal(byId rashId: Int64) -> RashLocal? {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RashLocal> = RashLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rashId == %d", rashId)

        do {
            // Execute fetch request
            let results = try context.fetch(fetchRequest)
            // Return the first result if found
            return results.first
        } catch {
            print("Error fetching RashLocal with ID \(rashId): \(error.localizedDescription)")
            return nil
        }
    }

    func saveRashes(
        with rashId: Int64,
        rashes : [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the rash Local entity
        let fetchRequest: NSFetchRequest<RashLocal> = RashLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rashId == %d", rashId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the rash local object
                if let rashLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    rashLocal.rashes = rashes as NSObject
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No rash Local object found for the given rashId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func updateObservationTime(for rashId: Int64, to newTime: Date, completion: @escaping (Bool) -> Void) {
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false) // Fail if the app delegate is not available
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        // Perform the fetch and update asynchronously
        context.perform {
            let fetchRequest: NSFetchRequest<RashLocal> = RashLocal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "rashId == %d", rashId)
            fetchRequest.fetchLimit = 1 // Ensure only one object is fetched

            do {
                // Fetch the object
                let results = try context.fetch(fetchRequest)

                // Check if the object exists
                guard let rashObject = results.first else {
                    print("No object found with rashId \(rashId).")
                    completion(false) // Failure if no object is found
                    return
                }

                // Update the observationTime attribute
               rashObject.rashTime = newTime

                // Save the changes
                try context.save()
                print("Observation time updated successfully.")
                completion(true) // Success
            } catch {
                print("Failed to fetch or update observationTime: \(error.localizedDescription)")
                completion(false) // Failure in case of an error
            }
        }
    }
    
    func syncRashObject(
        onlineEntryId: Int64,
        rashes: [String]?,
        rashDateTime: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/rash/\(onlineEntryId)") else {
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
        
        if let rashes = rashes {
            requestBody["rashes"] = rashes
        }
        if let rashDateTime = rashDateTime {
            requestBody["rashDateTime"] = rashDateTime
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

    
}
