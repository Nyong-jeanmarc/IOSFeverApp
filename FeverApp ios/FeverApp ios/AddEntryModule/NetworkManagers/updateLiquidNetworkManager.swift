//
//  updateLiquidNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateLiquidNetworkManager{
    static let shared = updateLiquidNetworkManager()
    
    func markedLiquidUpdated(liquidId: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LiquidsLocal> = LiquidsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "liquidId == %d", liquidId)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let liquid = result.first {
                // Update the isLiquidUpdated property
                liquid.isLiquidUpdated = true
                
                // Update the associated local entry if it exists
                if let localEntry = liquid.localEntry {
                    localEntry.isEntryUpdated = true
                }
                
                // Save changes to the context
                try context.save()
            } else {
                print("No liquid found with id \(liquidId)")
            }
        } catch {
            print("Failed to fetch liquid object with id \(liquidId): \(error.localizedDescription)")
        }
    }
    func updateLiquid(
        liquidId: Int,
        dehydrationSigns: [String]?,
        liquidTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/liquids/\(liquidId)") else {
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
        if let dehydrationSigns = dehydrationSigns {
            requestBody["dehydrationSigns"] = dehydrationSigns
        }
        if let liquidTime = liquidTime {
            requestBody["liquidTime"] = liquidTime
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
                print("No valid response received.")
                completion(false)
            }
        }
        task.resume()
    }

}
