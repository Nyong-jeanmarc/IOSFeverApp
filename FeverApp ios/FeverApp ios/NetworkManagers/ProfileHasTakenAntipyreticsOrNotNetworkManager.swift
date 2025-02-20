//
//  ProfileHasTakenAntipyreticsOrNotNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 15/10/2024.
//

import Foundation
import UIKit
import CoreData

class ProfileHasTakenAntipyreticsOrNotNetworkManager{
    static let shared = ProfileHasTakenAntipyreticsOrNotNetworkManager()
    
    func saveHasTakenAntyrepticsOrNotRequest(profileId: Int64, hasTakenAntipyretics: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Create the URL for the PATCH request
        guard let url = URL(string: "http://159.89.102.239:8080/api/profile/hasTakenAntipyretics/\(profileId)") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON body with the hasTakenAntipyretics parameter
        let body: [String: Any] = ["hasTakenAntipyretics": hasTakenAntipyretics]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let errorMessage = "Server returned status code: \(statusCode)"
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                return
            }
            
            do {
                // Attempt to parse the JSON response
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }
    // saves to core data
    // Save has taken antipyretics to core data
    func saveHasTakenAntipyreticsToCoreData(profileId: Int64, hasTakenAntipyretics: String, completion: @escaping (Bool) -> Void) {
        // Get the managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the Profile entity
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
        
        do {
            // Fetch the profile with the given profileId
            let profiles = try managedContext.fetch(fetchRequest)
            
            // Assuming profileId is unique, we take the first result
            if let profile = profiles.first {
                // Set the hasTakenAntipyretics value
                profile.hasTakenAntipyretics = hasTakenAntipyretics
                
                // Save the context
                try managedContext.save()
                print("hasTakenAntipyretics saved successfully!")
                completion(true)
            } else {
                print("Profile with profileId \(profileId) not found.")
                completion(false)
            }
        } catch let error as NSError {
            print("Could not fetch or save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
}
