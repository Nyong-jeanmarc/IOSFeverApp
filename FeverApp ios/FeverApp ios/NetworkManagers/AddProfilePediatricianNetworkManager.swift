//
//  AddProfilePediatricianNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 11/10/2024.
//

import Foundation
import CoreData
import UIKit
class AddProfilePediatricianNetworkManager{
    static let shared = AddProfilePediatricianNetworkManager()
    
    func saveProfilePediatricianRequest(pediatricianId: Int64, profileId: Int64, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Create the URL with the profileId in the path
        guard let url = URL(string: "http://159.89.102.239:8080/api/profile/profilePediatrician/\(profileId)") else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = [
            "userPediatricianId": pediatricianId
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create the URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if the response is an HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    // Handle successful response
                    if let data = data {
                        do {
                            // Parse JSON response
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                completion(.success(jsonResponse))
                            } else {
                                // Handle unexpected data format
                                let jsonError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
                                completion(.failure(jsonError))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    // Handle failed request
                    let statusError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code: \(httpResponse.statusCode)"])
                    completion(.failure(statusError))
                }
            }
        }
        
        // Start the task
        task.resume()
    }
    // function to save profile pediatrician id to core data
    func SaveProfilePediatricianIdToCoreData(profileId: Int64, pediatricianId: Int64) {
       
            // Get the managed object context
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                print("Failed to retrieve context")
                return
            }
            let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
            
            do {
                let profiles = try context.fetch(fetchRequest)
                
                if let profile = profiles.first {
                    profile.profilePediatricianId = pediatricianId
                    
                    // Save the changes to the context
                    try context.save()
                    print("Profile updated with pediatricianId: \(pediatricianId)")
                } else {
                    print("No profile found with the given profileId: \(profileId)")
                }
            } catch {
                print("Failed to fetch or update the profile: \(error.localizedDescription)")
            }
    }
}
