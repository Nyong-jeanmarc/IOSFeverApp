//
//  updateWarningSignsNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateWarningSignsNetworkManager{
    static let shared = updateWarningSignsNetworkManager()
    func markedWarningSignsUpdated(warningSignsId: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WarningSignsLocal> = WarningSignsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "warningSignsId == %d", warningSignsId)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let warningSigns = result.first {
                // Update the isWarningSignsUpdated property
                warningSigns.isWarningSignsUpdated = true
                
                // Update the associated local entry if it exists
                if let localEntry = warningSigns.localEntry {
                    localEntry.isEntryUpdated = true
                }
                
                // Save changes to the context
                try context.save()
            } else {
                print("No warning signs found with id \(warningSignsId)")
            }
        } catch {
            print("Failed to fetch warning signs object with id \(warningSignsId): \(error.localizedDescription)")
        }
    }
    func updateWarningSigns(
        warningSignsId: Int,
        warningSigns: [String]?,
        warningSignsTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/warningSigns/\(warningSignsId)") else {
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
        if let warningSigns = warningSigns {
            requestBody["warningSigns"] = warningSigns
        }
        if let warningSignsTime = warningSignsTime {
            requestBody["warningSignsTime"] = warningSignsTime
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
