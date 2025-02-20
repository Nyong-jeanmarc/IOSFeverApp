//
//  symptomsNetworkManager .swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
import CoreData
class symptomsNetworkManager {
    static let shared = symptomsNetworkManager()
    func saveSymptoms(
        with symptomsId: Int64,
        symptoms : [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the liquidLocal entity
        let fetchRequest: NSFetchRequest<SymptomsLocal> = SymptomsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symptomsId == %d", symptomsId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the symptom Local object
                if let symptomLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    symptomLocal.symptoms = symptoms as NSObject
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No symptom Local object found for the given symptomId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func saveOtherSymptoms(
        with symptomsId: Int64,
        symptoms : [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the liquidLocal entity
        let fetchRequest: NSFetchRequest<SymptomsLocal> = SymptomsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symptomsId == %d", symptomsId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the symptom Local object
                if let symptomLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    symptomLocal.otherSymptoms = symptoms as NSObject
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No symptom Local object found for the given symptomId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func saveSymptomsDate(
        with symptomsId: Int64,
        symptomDate : Date,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the liquidLocal entity
        let fetchRequest: NSFetchRequest<SymptomsLocal> = SymptomsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symptomsId == %d", symptomsId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the symptom Local object
                if let symptomLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    symptomLocal.symptomsTime = symptomDate
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No symptom Local object found for the given symptomId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    
    func syncSymptomsObject(
        onlineEntryId: Int64,
        symptoms: [String]?,
        otherSymptoms: [String]?,
        symptomsDateTime: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/symptoms/\(onlineEntryId)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the request body, dynamically excluding nil values
        var requestBody: [String: Any] = [:]
        
        if let symptoms = symptoms {
            requestBody["symptoms"] = symptoms
        }
        if let otherSymptoms = otherSymptoms {
            requestBody["otherSymptoms"] = otherSymptoms
        }
        if let symptomsDateTime = symptomsDateTime {
            requestBody["symptomsDateTime"] = symptomsDateTime
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
    func fetchEditingSymptomsLocal(byId symptomsId: Int64) -> SymptomsLocal? {
        // Access the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create a fetch request for the SymptomsLocal entity
        let fetchRequest: NSFetchRequest<SymptomsLocal> = SymptomsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symptomsId == %d", symptomsId)

        do {
            // Execute the fetch request
            let result = try context.fetch(fetchRequest)

            // Return the first object if found
            if let symptomsObject = result.first {
                return symptomsObject
            } else {
                print("No symptoms object found with id \(symptomsId)")
                return nil
            }
        } catch {
            // Handle fetch error
            print("Failed to fetch symptoms object with id \(symptomsId): \(error.localizedDescription)")
            return nil
        }
    }
}
