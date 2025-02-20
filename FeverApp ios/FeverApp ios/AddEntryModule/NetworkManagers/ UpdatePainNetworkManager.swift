//
//   UpdatePainNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class  UpdatePainNetworkManager {
    static let shared = UpdatePainNetworkManager()
    
    func markPainUpdated(painId: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PainLocal> = PainLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "painId == %d", painId)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            // If PainLocal object is found
            if let painObject = results.first {
                // Update isUpdated property for PainLocal
                painObject.isPainUpdated = true
                
                // If LocalEntry is associated with this PainLocal object
                if let localEntry = painObject.localEntry {
                    localEntry.isEntryUpdated = true // Update the associated LocalEntry's isUpdated property
                }
                
                // Save changes to context
                try context.save()
                print("Pain and associated LocalEntry marked as updated.")
            } else {
                print("Pain object not found with ID \(painId).")
            }
        } catch {
            print("Error fetching or updating Pain object with ID \(painId): \(error.localizedDescription)")
        }
    }
    func updatePain(
        painId: Int,
        painValue: [String]?,
        otherPlaces: String?,
        painSeverityScale: String?,
        painDateTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/pain/\(painId)") else {
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
        if let painValue = painValue {
            requestBody["painValue"] = painValue
        }
        if let otherPlaces = otherPlaces {
            requestBody["otherPlaces"] = otherPlaces
        }
        if let painSeverityScale = painSeverityScale {
            requestBody["painSeverityScale"] = painSeverityScale
        }
        if let painDateTime = painDateTime {
            requestBody["painDateTime"] = painDateTime
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
