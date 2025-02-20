//
//  stateOfHealthNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 20/11/2024.
//

import Foundation
import UIKit
import CoreData
class stateOfHealthNetworkManager{
    // Assuming `context` is your NSManagedObjectContext from AppDelegate or a persistent container.
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let shared = stateOfHealthNetworkManager()
    
    func fetchAndUpdateStateOfHealth(for stateOfHealthId: Int64, newStateOfHealth: String, completion: @escaping (Bool) -> Void) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

        guard let context = context else {
            print("Failed to get Core Data context.")
            completion(false)
            return
        }

        do {
            // Fetch the StateOfHealthLocal object by stateOfHealthId
            let fetchRequest = NSFetchRequest<StateOfHealthLocal>(entityName: "StateOfHealthLocal")
            fetchRequest.predicate = NSPredicate(format: "stateOfHealthId == %lld", stateOfHealthId)

            if let existingStateOfHealth = try context.fetch(fetchRequest).first {
                // Update the fetched object
                existingStateOfHealth.stateOfHealth = newStateOfHealth
                // Save the context
                try context.save()

                print("State of health updated to \(newStateOfHealth) for stateOfHealthId \(stateOfHealthId).")
                completion(true)
            } else {
                // No object found with the given ID
                print("No StateOfHealthLocal object found with stateOfHealthId \(stateOfHealthId).")
                completion(false)
            }
        } catch {
            print("Error fetching or updating StateOfHealthLocal: \(error)")
            completion(false)
        }
    }

    
    func saveStateOfHealthDate(stateOfHealthId: Int64, stateOfHealthDate: Date, completion: @escaping (Bool) -> Void) {
        do {
            // Fetch the StateOfHealthLocal entity by stateOfHealthId
            let fetchRequest = NSFetchRequest<StateOfHealthLocal>(entityName: "StateOfHealthLocal")
            fetchRequest.predicate = NSPredicate(format: "stateOfHealthId == %lld", stateOfHealthId)
            
            if let stateOfHealthEntity = try context.fetch(fetchRequest).first {
                // Update the stateOfHealthDateTime attribute
                stateOfHealthEntity.stateOfHealthDateTime = stateOfHealthDate
                
                // Save the changes
                try context.save()
                print("State of health date \(stateOfHealthDate) was saved for state of health with id \(stateOfHealthId)")
                completion(true)
            } else {
                print("No state of health found with the specified ID \(stateOfHealthId).")
                completion(false)
            }
        } catch {
            print("Error saving state of health date: \(error)")
            completion(false)
        }
    }
    func syncStateOfHealth(
        onlineEntryId: Int64,
        stateOfHealth: String,
        stateOfHealthDateTime: String,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        let urlString = "http://159.89.102.239:8080/api/entry/stateOfHealth/\(onlineEntryId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the request body
        let body: [String: Any] = [
            "stateOfHealth": stateOfHealth,
            "stateOfHealthDateTime": stateOfHealthDateTime
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Check for valid response
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                let error = NSError(domain: "Server error", code: statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }

            // Parse the response data
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    completion(.success(jsonResponse ?? [:]))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No data received", code: 500, userInfo: nil)))
            }
        }

        task.resume()
    }
    func fetchEditingStateOfHealthLocal(byId stateOfHealthId: Int64) -> StateOfHealthLocal? {
        let fetchRequest: NSFetchRequest<StateOfHealthLocal> = StateOfHealthLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stateOfHealthId == %d", stateOfHealthId)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Return the first matching object if found
        } catch {
            print("Error fetching StateOfHealthLocal object: \(error)")
            return nil
        }
    }
}

