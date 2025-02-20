//
//  userNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 07/10/2024.
//

import Foundation
import UIKit
class loginWithPediatricianCodeNetworkManager {
    static let shared = loginWithPediatricianCodeNetworkManager()
    // send request to server for user registration
    func loginWithPediatricianCodeRequest(sessionId: String, pediatricianCode: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Define the URL for the endpoint
        guard let url = URL(string: "http://159.89.102.239:8080/api/users/register/with/pediatrician/code") else {
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
            "pediatricianCode": pediatricianCode
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
                print("Server error or no data received")
                return
            }
            
            // Parse the JSON response
            do {
                if let loginWithPediatricianCodeResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(loginWithPediatricianCodeResponse))
//                    let userIdString = loginWithPediatricianCodeResponse["userId"] as? String
//                    let userId = Int64(userIdString!)
//                    userDataModel.shared.saveUserId(userid: userId!)
                    
                    if let userIdString = loginWithPediatricianCodeResponse["userId"] as? String,
                       let familyCode = loginWithPediatricianCodeResponse["familyCode"] as? String,
                       let userId = Int64(userIdString) {

                        // Step 1: Save userId using userDataModel
//                        userDataModel.shared.saveUserId(userid: userId)
//                        print("userDataModel saveUserId called with userId: \(userId)")

                        // Step 2: Save userId and familyCode in Core Data using AppDelegate
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.saveUserData(userId: userId, familyCode: familyCode)
                        print("AppDelegate saveUserData called with userId: \(userId), familyCode: \(familyCode)")
                        print("User ID and family code saved successfully.")
                    } else {
                        print("Invalid response data: Unable to parse userId or familyCode.")
                    }

                } else {
                    print("Invalid JSON structure")
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the network request
        task.resume()
    }
}
