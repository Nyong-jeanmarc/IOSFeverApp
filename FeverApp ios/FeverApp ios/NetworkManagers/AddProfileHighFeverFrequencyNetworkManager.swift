//
//  AddProfileHighFeverFrequencyNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 15/10/2024.
//

import Foundation
import UIKit
import CoreData

class AddProfileHighFeverFrequencyNetworkManager{
    static let shared = AddProfileHighFeverFrequencyNetworkManager()
    // save to remote server
    func saveProfileHighFeverFrequencyRequest(profileId: Int64, feverFrequency: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Create the URL using the profileId
        guard let url = URL(string: "http://159.89.102.239:8080/api/profile/feverFrequency/\(profileId)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let body: [String: String] = ["feverFrequency": feverFrequency]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // Create a URL session data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            // Check for a successful response and process the response data
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    completion(.success(responseString))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])))
                }
            } else {
                print("Unexpected response: \(String(describing: response))")
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response"])))
            }
        }
        
        // Start the task
        task.resume()
    }
    // Save to core data
    func saveFeverFrequencyToCoreData(profileId: Int64, feverFrequency: String, completion: @escaping (Bool) -> Void) {
        // Get the managed object context from the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            print("Unable to get AppDelegate")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the Profile entity
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "profileId == %lld", profileId)
        
        do {
            // Fetch the profile with the given ID
            let profiles = try context.fetch(fetchRequest)
            if let profile = profiles.first {
                // Update the feverFrequency attribute
                profile.feverFrequency = feverFrequency
                
                // Save the changes to Core Data
                try context.save()
                print("Fever frequency updated successfully for profile ID: \(profileId)")
                completion(true)
            } else {
                print("Profile not found for the given ID")
                completion(false)
            }
        } catch {
            // Handle errors during fetch or save
            print("Error saving fever frequency: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
