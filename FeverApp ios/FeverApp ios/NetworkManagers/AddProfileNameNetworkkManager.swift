//
//  AddProfileNameNetworkkManager.swift
//  FeverApp ios
//
//  Created by NEW on 10/10/2024.
//

import Foundation
import UIKit
import CoreData

class AddProfileNameNetworkkManager{
    static let shared = AddProfileNameNetworkkManager()
    func SaveProfileNameRequest(profileName: String, userId: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Create the URL with the provided userId
        guard let url = URL(string: "http://159.89.102.239:8080/api/profile") else {
            print("Invalid URL")
            return
        }
        
        // Create the request and set the method to POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let requestBody: [String: Any] = [
            "userId": userId,
            "profileName": profileName
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        // Create a URLSession data task to send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse))
                } else {
                    print("Invalid JSON format")
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
//    func saveProfileNameToCoreData(userId: Int64, newProfileName: String) {
//       
//            // Get the AppDelegate and the managed context
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            let managedContext = appDelegate.persistentContainer.viewContext
//            
//            // Create a fetch request for the Profile entity with the specified profileId
//            let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "userId == %d", userId)
//            
//            do {
//                // Fetch the results
//                let profiles = try managedContext.fetch(fetchRequest)
//                
//                // Ensure that the profile exists and update its name
//                if let profile = profiles.first {
//                    profile.profileName = newProfileName
//                    
//                    // Save the context to persist the change
//                    try managedContext.save()
//                    print("Profile name updated successfully to \(newProfileName).")
//                    // Step 2: Save profileName  in Core Data using AppDelegate
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.saveProfileName(profileName: newProfileName)
//                    print("AppDelegate saveProfileName called:\(newProfileName)")
//                    print("Profile name save successfully to core data")
//                } else {
//                    print("useer with id \(userId) not found.")
//                }
//            } catch {
//                print("Failed to update profile name: \(error.localizedDescription)")
//            }
//        
//    }
    func saveProfileNameToCoreData(userId: Int64, newProfileName: String) {
        // Get the AppDelegate and the managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a new Profile entity
        let newProfile = Profile(context: managedContext)
        
        // Set the profileName, profileId, and userId
        newProfile.profileName = newProfileName
        newProfile.userId = userId
        
        // Save the new Profile entity to Core Data
        do {
            try managedContext.save()
            print("New profile created successfully with profileName \(newProfileName).")
            
            // Refresh the object to get the correct Z_PK value
//            managedContext.refresh(newProfile, mergeChanges: false)
            
            // Extract the Z_PK from the objectID URIRepresentation
                
            let objectID = newProfile.objectID
            let uriString = objectID.uriRepresentation().absoluteString
            if let primaryKeyString = uriString.split(separator: "/").last,
               let primaryKey = Int(primaryKeyString.dropFirst()) { // Remove the leading "p"
                let profileId = Int64(primaryKey)
                newProfile.profileId = profileId
                
                // Save the changes to Core Data
                try managedContext.save()
                
                // Save the profileId to Core Data
                appDelegate.saveProfileId(profileId: profileId)
               
                print("ProfileId saved successfully to Core Data.")
                // Step 2: Save profileName  in Core Data using AppDelegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.saveProfileName(profileName: newProfileName)
                print("AppDelegate saveProfileName called:\(newProfileName)")
                print("Profile name save successfully to core data")
            } else {
                print("Failed to extract primary key from objectID")
            }
        } catch {
            print("Failed to create new profile: \(error.localizedDescription)")
        }
    }
}
