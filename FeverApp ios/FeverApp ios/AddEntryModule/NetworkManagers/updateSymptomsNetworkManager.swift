//
//  updateSymptomsNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateSymptomsNetworkManager{
    static let shared = updateSymptomsNetworkManager()
    
    func markSymptomsUpdated(symptomsId: Int64) {
        // Access the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create a fetch request for the SymptomsLocal entity
        let fetchRequest: NSFetchRequest<SymptomsLocal> = SymptomsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symptomsId == %d", symptomsId)

        do {
            // Execute the fetch request
            let result = try context.fetch(fetchRequest)

            // Check if a symptoms object exists
            if let symptoms = result.first {
                // Update the isUpdated property
                symptoms.isSymptomsUpdated = true

                // Update the associated local entry if it exists
                if let localEntry = symptoms.localEntry {
                    localEntry.isEntryUpdated = true
                }

                // Save changes to the context
                try context.save()
                print("Symptoms object and associated local entry updated successfully.")
            } else {
                print("No symptoms object found with id \(symptomsId).")
            }
        } catch {
            // Handle fetch or save error
            print("Failed to fetch or update symptoms object with id \(symptomsId): \(error.localizedDescription)")
        }
    }
    
    func updateSymptoms(
        symptomsId: Int,
        symptoms: [String]?,
        otherSymptoms: [String]?,
        symptomsTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/symptoms/\(symptomsId)") else {
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
        if let symptoms = symptoms {
            requestBody["symptoms"] = symptoms
        }
        if let otherSymptoms = otherSymptoms {
            requestBody["otherSymptoms"] = otherSymptoms
        }
        if let symptomsTime = symptomsTime {
            requestBody["symptomsTime"] = symptomsTime
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
