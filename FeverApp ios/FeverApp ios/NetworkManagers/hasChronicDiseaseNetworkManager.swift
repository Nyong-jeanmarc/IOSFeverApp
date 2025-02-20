//
//  ChronicDiseaseNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 11/10/2024.
//

import Foundation
import UIKit
import CoreData
class hasChronicDiseaseNetworkManager{
    static let shared = hasChronicDiseaseNetworkManager()
    
    func SaveHasChronicDiseaseRequest(profileId: Int64, hasChronicDisease: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Construct the URL for the request
        guard let url = URL(string: "http://159.89.102.239:8080/api/profile/hasChronicDisease/\(profileId)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let body: [String: Any] = ["hasChronicDisease": hasChronicDisease]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for a valid HTTP response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(.success("Chronic disease status updated successfully."))
            } else {
                let errorMessage = "Failed to update chronic disease status. Please try again."
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        }
        
        // Start the task
        task.resume()
    }
    // Save has chronic disease response to core data
    func saveProfileHasChronicDiseaseToCoreData(profileId: Int64, hasChronicDisease: String, completion: @escaping (Bool) -> Void) {
        // Get the AppDelegate and the managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the Profile entity with the specified profileId
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
        
        do {
            // Fetch the results
            let profiles = try managedContext.fetch(fetchRequest)
            
            // Ensure that the profile exists and update its name
            if let profile = profiles.first {
                profile.hasChronicDisease = hasChronicDisease
                
                // Save the context to persist the change
                try managedContext.save()
                print("Profile hasChronicDisease updated successfully to \(hasChronicDisease).")
                completion(true)
            } else {
                print("Profile with id \(profileId) not found.")
                completion(false)
            }
        } catch {
            print("Failed to update profile hasChronicDisease: \(error.localizedDescription)")
            completion(false)
        }
    }
    }
    
