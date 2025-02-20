//
//  profileDateOfBirthNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 10/10/2024.
//

import Foundation
import UIKit
import CoreData

class profileDateOfBirthNetworkManager{
    
    static let shared = profileDateOfBirthNetworkManager()

    func SaveProfileDateOfBirthRequest(userId: Int64, profileName: String, profileDateOfBirth: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Define the server URL (adjust the URL as needed)
        let urlString = "http://159.89.102.239:8080/api/profile/profileDateOfBirth/\(userId)"
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON body
        let requestBody: [String: Any] = [
            "userId": userId,
            "profileName": profileName,
            "profileDateOfBirth": profileDateOfBirth
        ]
        
        // Convert the body to JSON data
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
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
            
            // Handle response
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // Check for response data
                    if let data = data, let saveProfileDateOfBirthResponse = String(data: data, encoding: .utf8) {
                        completion(.success(saveProfileDateOfBirthResponse))
                    } else {
                        completion(.failure(NSError(domain: "No response data", code: 204, userInfo: nil)))
                    }
                } else {
                    let error = NSError(domain: "Request failed with status code \(httpResponse.statusCode)", code: httpResponse.statusCode, userInfo: nil)
                    completion(.failure(error))
                }
            }
        }
        
        // Start the task
        task.resume()
    }
    func saveProfileDateOfBirthToCoreData(profileId: Int64, dateOfBirthString: String, completion: @escaping (Bool) -> Void) {
        // Get the AppDelegate instance
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Unable to retrieve AppDelegate")
            completion(false)
            return
        }
        
        // Create a DateFormatter to convert the string into a Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Expecting format like "2023-10-10"

        // Convert the dateOfBirthString to a Date object
        guard let dateOfBirth = dateFormatter.date(from: dateOfBirthString) else {
            print("Invalid date format. Expected 'yyyy-MM-dd'.")
            completion(false)
            return
        }
        
        // Get the managed object context from the AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext

        // Create a fetch request to retrieve the Profile entity with the given profileId
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)

        do {
            // Perform the fetch request
            let profiles = try managedContext.fetch(fetchRequest)
            
            // Check if a profile with the given ID exists
            if let profile = profiles.first {
                // Update the profile's date of birth
                profile.profileDateOfBirth = dateOfBirth
                
                // Save the changes to Core Data
                try managedContext.save()
                print("Profile date of birth updated successfully.")
                
                // Step 2: Save profileDOB  in Core Data using AppDelegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.saveProfileDateOfBirth(profileDateOfBirth: dateOfBirthString)
                print("AppDelegate saveProfileDOB called:\(dateOfBirthString)")
                print("Profile date of birth save successfully to core data")
                
                completion(true)
            } else {
                print("Profile with ID \(profileId) not found.")
                completion(false)
            }
        } catch let error as NSError {
            print("Could not fetch or save data. \(error), \(error.userInfo)")
            completion(false)
        }
    }
    
    
}
