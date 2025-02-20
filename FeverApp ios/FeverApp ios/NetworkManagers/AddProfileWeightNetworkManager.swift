//
//  AddProfileWeightNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/10/2024.
//

import Foundation
import UIKit
import CoreData
class AddProfileWeightNetworkManager{
    static let shared = AddProfileWeightNetworkManager()
    func SaveProfileWeightRequest(profileId: Int64, profileWeight: Double, completion: @escaping (Result<Data?, Error>) -> Void) {
        // Define the URL string, using the profile ID as a path parameter
        let urlString = "http://159.89.102.239:8080/api/profile/profileWeight/\(profileId)"
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create a URLRequest object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Define the request headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON body
        let body: [String: Any] = [
            "profileWeight": profileWeight
        ]
        
        // Try to serialize the body to JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(.failure(error)) // Call completion with error
            return
        }
        
        // Create a data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle error if any
            if let error = error {
                print("Error during the request: \(error.localizedDescription)")
                completion(.failure(error)) // Call completion with error
                return
            }
            
            // Check for a valid HTTP response
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("Request successful with status code: \(httpResponse.statusCode)")
                completion(.success(data)) // Call completion with the response data
            } else {
                // Handle unexpected response
                let serverError = NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])
                completion(.failure(serverError)) // Call completion with error
            }
        }
        
        // Start the data task
        task.resume()
    }
    // Save to core data
    func saveProfileWeightToCoreData(profileId: Int64, profileWeight: Double, completion: @escaping (Bool) -> Void) {
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

            // If the profile exists, update the weight
            if let profile = profiles.first {
                profile.profileWeight = profileWeight

                // Save the changes
                try managedContext.save()
                print("Profile weight updated successfully!")
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
