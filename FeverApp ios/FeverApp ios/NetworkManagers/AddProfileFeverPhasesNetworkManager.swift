//
//  AddProfileFeverPhasesNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/10/2024.
//

import Foundation
import UIKit
import CoreData

class AddProfileFeverPhasesNetworkManager{
    static let shared = AddProfileFeverPhasesNetworkManager()

    func SaveFeverPhaseRequest(profileId: Int64, feverPhases: Int16, completion: @escaping (Result<Data, Error>) -> Void) {
        // Prepare the URL
        let urlString = "http://159.89.102.239:8080/api/profile/feverPhases/\(profileId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the JSON body
        let jsonBody: [String: Any] = ["feverPhases": feverPhases]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check the response status code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code \(statusCode)"])))
                return
            }
            
            // Return the raw data
            if let data = data {
                completion(.success(data))  // Return the raw data from the server
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
            }
        }
        
        task.resume()
    }
    // save to core data
    // Save fever phases to core data
    func saveFeverPhasesToCoreData(profileId: Int64, feverPhases: Int16, completion: @escaping (Bool) -> Void) {
        // Get the context from the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            print("Unable to get AppDelegate")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the Profile entity
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        
        // Set predicate to filter by profileId
        fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
        
        do {
            // Fetch profiles with the given profileId
            let profiles = try context.fetch(fetchRequest)
            
            if let profile = profiles.first {
                // Update the feverPhases attribute
                profile.feverPhases = feverPhases
                
                // Save the context to persist the change
                try context.save()
                print("Fever phases saved successfully!")
                completion(true)
            } else {
                print("Profile not found")
                completion(false)
            }
        } catch {
            // Handle error during fetch or save
            print("Failed to save fever phases: \(error.localizedDescription)")
            completion(false)
        }
    }


}
