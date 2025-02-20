//
//  updateStateOfHealthNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import CoreData
import UIKit
class updateStateOfHealthNetworkManager{
    static let shared = updateStateOfHealthNetworkManager()
    func markedStateOfHealthUpdated(stateId : Int64){
        // Assuming `context` is your NSManagedObjectContext from AppDelegate or a persistent container.
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     let stateOfHealthId = stateId
        
        // Fetch the local state of health object
        let fetchRequest: NSFetchRequest<StateOfHealthLocal> = StateOfHealthLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stateOfHealthId == %d", stateOfHealthId)
        
        do {
            if let stateOfHealthLocal = try context.fetch(fetchRequest).first {
                stateOfHealthLocal.isStateOfHealthUpdated = true
                if let localEntry = stateOfHealthLocal.localEntry {
                    localEntry.isEntryUpdated = true
                }
                try context.save()
                print("State of health and associated entry marked as updated.")
            }
        } catch {
            print("Error marking state of health as updated: \(error)")
        }
    }
    func updateStateOfHealth(
        stateOfHealthId: Int,
        stateOfHealth: String?,
        stateOfHealthDateTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/stateOfHealth/\(stateOfHealthId)") else {
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
        if let stateOfHealth = stateOfHealth {
            requestBody["stateOfHealth"] = stateOfHealth
        }
        if let stateOfHealthDateTime = stateOfHealthDateTime {
            requestBody["stateOfHealthDateTime"] = stateOfHealthDateTime
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
