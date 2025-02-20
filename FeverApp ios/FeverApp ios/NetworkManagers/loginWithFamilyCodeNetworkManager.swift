//
//  loginWithFamilyCodeNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 08/10/2024.
//

import Foundation
import UIKit
class loginWithFamilyCodeNetworkManager {
   static let shared = loginWithFamilyCodeNetworkManager()
    // send request to server for user registration
    func loginWithFamilyCodeRequest(sessionId: String, familyCode: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Define the URL for the endpoint
        guard let url = URL(string: "http://159.89.102.239:8080/api/users/login/with/family/code") else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Define the request body
        let body: [String: Any] = [
            "sessionId": sessionId,
            "familyCode": familyCode
        ]
        
        // Convert the body to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON: \(error)")
            return
        }
        
        // Create a data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure there is a response and data
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data or response received"])))
                print("Server error or no data received")
                return
            }
        
            // Parse the JSON response
            do {
                if let loginWithFamilyCodeResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
//                     let userIdNum = loginWithFamilyCodeResponse["userId"] as? Int
//                    let userId = Int64(userIdNum!)
//                    userDataModel.shared.saveUserId(userid: userId)
                        
                    
                    if let userIdNum = loginWithFamilyCodeResponse["userId"] as? Int,
                       let familyCode = loginWithFamilyCodeResponse["familyCode"] as? String {
                        
                        // Convert userId to Int64
                        let userId = Int64(userIdNum)

                        // Step 1: Save userId using userDataModel
                        userDataModel.shared.saveUserId(userid: userId)
                        print("userDataModel saveUserId called with userId: \(userId)")

                        // Step 2: Save userId and familyCode in Core Data using AppDelegate
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.saveUserData(userId: userId, familyCode: familyCode)
                        print("AppDelegate saveUserData called with userId: \(userId), familyCode: \(familyCode)")
                        print("User ID and family code saved successfully.")
                        
                        //Next get existing personal info if exist
                        self.fetchAndSyncPersonalInfo(userId: String(userId)) { success in
                            if success {
                                print("Personal info fetched and synced successfully.")
                            } else {
                                print("Failed to fetch and sync personal info.")
                            }
                        }

                        //Next get existing contact info if exist
                        self.fetchAndSyncContactInfo(userId: String(userId)) { success in
                            if success {
                                print("Contact info fetched and synced successfully.")
                            } else {
                                print("Failed to fetch and sync contact info.")
                            }
                            completion(.success(loginWithFamilyCodeResponse))
                        }
                    } else {
                        print("Invalid response data: Unable to parse userId or familyCode.")
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])))
                    }
                    
                    
                    
                } else {
                    print("Invalid JSON structure")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])))
                
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the network request
        task.resume()
    }
    
    func fetchAndSyncPersonalInfo(userId: String, completion: @escaping (Bool) -> Void) {
        PersonalInfoNetworkManager.shared.getPersonalInfo(userId: userId) { response, error in
            if let error = error {
                print("Error fetching personal info: \(error)")
                completion(false)
            } else if let response = response {
                print("Personal info fetched and synced successfully: \(response)")
                completion(true)
            } else {
                print("Unknown error fetching personal info")
                completion(false)
            }
        }
    }

    func fetchAndSyncContactInfo(userId: String, completion: @escaping (Bool) -> Void) {
        ContactInfoNetworkManager.shared.getContactInfo(userId: userId) { response, error in
            if let error = error {
                print("Error fetching contact info: \(error)")
                completion(false)
            } else if let response = response {
                print("Contact info fetched and synced successfully: \(response)")
                completion(true)
            } else {
                print("Unknown error fetching contact info")
                completion(false)
            }
        }
    }
    
}
