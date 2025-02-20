//
//  AddFamilyRoleNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 09/10/2024.
//

import Foundation
class AddFamilyRoleNetworkManager{
    static let shared = AddFamilyRoleNetworkManager()
    func SaveFamilyRoleRequest(familyRole: String, userId: Int64, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Define the URL using the userId in the path
        guard let url = URL(string: "http://159.89.102.239:8080/api/users/familyRole/\(userId)") else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Define the request body with the family role
        let body: [String: Any] = [
            "familyRole": familyRole
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
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Server error or no data received"])
                completion(.failure(error))
                return
            }
            
            // Parse the JSON response
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse))
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the network request
        task.resume()
    }
    
}
