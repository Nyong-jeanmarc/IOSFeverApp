//
//  updateDiarrheaNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateDiarrheaNetworkManager{
    static let shared = updateDiarrheaNetworkManager()
    func markDiarrheaUpdated(diarrheaId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DiarrheaLocal> = DiarrheaLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "diarrheaId == %d", diarrheaId)
        
        do {
            // Fetch the diarrhea object with the given ID
            let result = try context.fetch(fetchRequest)
            
            if let diarrhea = result.first {
                // Update the isDiarrheaUpdated property
                diarrhea.isDiarrheaUpdated = true
                
                // Update the associated local entry if it exists
                if let localEntry = diarrhea.localEntry {
                    localEntry.isEntryUpdated = true
                }
                
                // Save changes to the context
                try context.save()
                print("Diarrhea object and associated local entry marked as updated.")
            } else {
                print("No diarrhea object found with ID \(diarrheaId).")
            }
        } catch {
            print("Failed to fetch diarrhea object with ID \(diarrheaId): \(error.localizedDescription)")
        }
    }
    func updateDiarrhea(
        diarrheaId: Int,
        diarrheaAndOrVomiting: String?,
        observationTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/diarrhea/\(diarrheaId)") else {
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
        if let diarrheaAndOrVomiting = diarrheaAndOrVomiting {
            requestBody["diarrheaAndOrVomiting"] = diarrheaAndOrVomiting
        }
        if let observationTime = observationTime {
            requestBody["observationTime"] = observationTime
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
                print("Invalid response from server.")
                completion(false)
            }
        }
        task.resume()
    }

}
