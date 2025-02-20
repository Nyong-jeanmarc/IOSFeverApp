//
//  AddProfileHeightNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/10/2024.
//

import Foundation
import UIKit
import CoreData
class AddProfileHeightNetworkManager{
    static let shared = AddProfileHeightNetworkManager()
    
    func SaveProfileHeightRequest(profileId: Int64, profileHeight: Float, completion: @escaping (Result<String, Error>) -> Void) {
        // Create the URL for the API endpoint
        let urlString = "http://159.89.102.239:8080/api/profile/profileHeight/\(profileId)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL."])
            completion(.failure(error))
            return
        }
        
        // Prepare the data to send in the body of the request
        let parameters: [String: Any] = [
            "profileHeight": profileHeight
        ]
        
        // Convert parameters to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON."])
            completion(.failure(error))
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add the JSON data to the request body
        request.httpBody = jsonData
        
        // Create a URLSession data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle any errors in the request
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if the response is valid
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Handle the data (if any)
                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                    completion(.success(responseBody)) // Return the response body on success
                } else {
                    let error = NSError(domain: "", code: 204, userInfo: [NSLocalizedDescriptionKey: "No response body received."])
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update profile height. Invalid response."])
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }
    // Save height to core data
    func saveProfileHeightToCoreData(profileId: Int64, profileHeight: Float, completion: @escaping (Bool) -> Void) {
        // Reference to the AppDelegate for Core Data stack
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }

        // Get the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // Create a fetch request for the Profile entity
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        
        // Add a predicate to fetch the profile with the specific profileId
        fetchRequest.predicate = NSPredicate(format: "profileId == %lld", profileId)

        do {
            // Fetch the profile matching the profileId
            let profiles = try managedContext.fetch(fetchRequest)

            // If the profile exists, update the height
            if let profile = profiles.first {
                profile.profileHeight = profileHeight
                
                // Save the changes
                try managedContext.save()
                print("Profile height updated successfully!")
                completion(true)
            } else {
                print("No profile found with ID \(profileId)")
                completion(false)
            }
        } catch let error as NSError {
            print("Could not fetch or update profile. \(error), \(error.userInfo)")
            completion(false)
        }
    }
}
