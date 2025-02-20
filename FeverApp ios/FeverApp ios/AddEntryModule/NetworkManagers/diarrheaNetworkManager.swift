//
//  diahreaNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
import CoreData
class diarrheaNetworkManager{
    static let shared = diarrheaNetworkManager()

    func updateDiarrheaAndOrVomiting(withId id: Int64,
                             newValue: String,
                             completion: @escaping (Bool) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the DiarrheaLocal entity
        let fetchRequest: NSFetchRequest<DiarrheaLocal> = DiarrheaLocal.fetchRequest()
        
        // Add a predicate to filter by the given ID
        fetchRequest.predicate = NSPredicate(format: "diarrheaId == %d", id)
        
        do {
            // Fetch the results
            let results = try context.fetch(fetchRequest)
            
            // Check if an object exists with the given ID
            if let diarrheaLocal = results.first {
                // Update the `diarrheaAndOrVomiting` attribute
                diarrheaLocal.diarrheaAndOrVomiting = newValue
                
                // Save the context to persist changes
                do {
                    try context.save()
                    print("Updated diarrheaAndOrVomiting for ID \(id) to '\(newValue)'.")
                    completion(true) // Call the completion handler with success
                } catch {
                    print("Failed to save changes: \(error)")
                    completion(false) // Call the completion handler with failure
                }
            } else {
                print("No DiarrheaLocal object found with ID \(id).")
                completion(false) // No object found
            }
        } catch {
            print("Failed to fetch DiarrheaLocal object: \(error)")
            completion(false) // Fetch failed
        }
    }
    func updateObservationTime(for diarrheaId: Int64, to newTime: Date, completion: @escaping (Bool) -> Void) {
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false) // Fail if the app delegate is not available
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        // Perform the fetch and update asynchronously
        context.perform {
            let fetchRequest: NSFetchRequest<DiarrheaLocal> = DiarrheaLocal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "diarrheaId == %d", diarrheaId)
            fetchRequest.fetchLimit = 1 // Ensure only one object is fetched

            do {
                // Fetch the object
                let results = try context.fetch(fetchRequest)

                // Check if the object exists
                guard let diarrheaObject = results.first else {
                    print("No object found with diarrheaId \(diarrheaId).")
                    completion(false) // Failure if no object is found
                    return
                }

                // Update the observationTime attribute
                diarrheaObject.observationTime = newTime

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
    
    func syncDiarrheaObject(
        onlineEntryId: Int,
        diarrheaAndOrVomiting: String?,
        observationTime: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/diarrhea/\(onlineEntryId)") else {
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

        if let diarrheaAndOrVomiting = diarrheaAndOrVomiting {
            requestBody["diarrheaAndOrVomiting"] = diarrheaAndOrVomiting
        }
        if let observationTime = observationTime {
            requestBody["observationTime"] = observationTime
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
    func fetchEditingDiarrheaLocal(byId diarrheaId: Int64) -> DiarrheaLocal?  {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DiarrheaLocal> = DiarrheaLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "diarrheaId == %d", diarrheaId)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Failed to fetch liquid object with id \(diarrheaId): \(error.localizedDescription)")
            return nil
        }
    }
}
