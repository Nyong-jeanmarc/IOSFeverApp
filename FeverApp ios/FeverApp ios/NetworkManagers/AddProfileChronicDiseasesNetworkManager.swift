//
//  AddProfileChronicDiseasesNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/10/2024.
//

import Foundation
import UIKit
import CoreData
class AddProfileChronicDiseasesNetworkManager{
    static let shared = AddProfileChronicDiseasesNetworkManager()
    // save profile chronic diseases to server
    func SaveChronicDiseaseRequest(profileId: Int64, chronicDiseases: [String], completion: @escaping (Result<String, Error>) -> Void) {
        // Convert the array of chronic diseases into a single comma-separated string
        let diseasesString = chronicDiseases.joined(separator: ", ")
        
        // Create the URL using the profileId
        guard let url = URL(string: "http://159.89.102.239:8080/api/profile/chronicDisease/\(profileId)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let body: [String: String] = ["chronicDiseases": diseasesString]
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
    // Save chronic diseases to core data
    func saveChronicDiseasesToCoreData(profileId: Int64, chronicDiseases: [String], completion: @escaping (Bool) -> Void) {
        
        // Get the Core Data context from the AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the Profile entity
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
        
        do {
            // Fetch the profile with the given profileId
            let profiles = try context.fetch(fetchRequest)
            
            if let profile = profiles.first {
                // Update the chronicDiseases attribute
                profile.chronicDiseases = chronicDiseases
                
                // Save the changes to Core Data
                try context.save()
                print("Chronic diseases saved successfully for profileId \(profileId).")
                completion(true)
            } else {
                print("Profile with profileId \(profileId) not found.")
                completion(false)
            }
        } catch let error as NSError {
            print("Could not save chronic diseases. Error: \(error), \(error.userInfo)")
            completion(false)
        }
    }
}
