//
//  AddProfileFeverSeizuresOrNotNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/10/2024.
//

import Foundation
import UIKit
import CoreData
class AddProfileFeverSeizuresOrNotNetworkManager{
    static let shared = AddProfileFeverSeizuresOrNotNetworkManager()
    
    func SaveHasFeverSeizureRequest(profileId: Int64, hadFeverSeizure: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Server URL (replace with your actual server URL)
        let urlString = "http://159.89.102.239:8080/api/profile/hadFeverSeizure/\(profileId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create JSON body
        let requestBody: [String: Any] = ["hadFeverSeizure": hadFeverSeizure]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        // Create URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "Invalid response from server", code: 0, userInfo: nil)))
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(NSError(domain: "Invalid data", code: 0, userInfo: nil)))
            }
        }
        
        // Start the task
        task.resume()
    }
    // Save had fever seizure or not to core data
    func saveHadFeverSeizureOrNotToCoreData(profileId: Int64, hadFeverSeizure: String, completion: @escaping (Bool) -> Void) {
        // Get the context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Fetch the profile object based on the profileId
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
        
        do {
            let profiles = try managedContext.fetch(fetchRequest)
            
            if let profile = profiles.first {
                // Update the 'hadFeverSeizure' attribute
                profile.hadFeverSeizure = hadFeverSeizure
                
                // Save the changes
                try managedContext.save()
                print("HadFeverSeizure response saved successfully for profileId: \(profileId)")
                completion(true)
            } else {
                print("No profile found with profileId: \(profileId)")
                completion(false)
            }
        } catch let error as NSError {
            print("Could not fetch or save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
}
