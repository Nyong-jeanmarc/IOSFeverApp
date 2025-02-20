//
//  dataprotectionNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 26/09/2024.
//

import Foundation

class dataprotectionNetworkManager{
 static let shared = dataprotectionNetworkManager()
    func ReadAndAcceptDataProtectionRequest(sessionId: String, dataProtectionAccepted: Bool, disclaimerAccepted: Bool) {
        // Prepare the URL
        let urlString = "http://159.89.102.239:8080/api/session-data/\(sessionId)/agreements"
        
        // Ensure URL is valid
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Define the request body (data protection and disclaimer acceptance)
        let body: [String: Any] = [
            "dataProtectionAccepted": dataProtectionAccepted,
            "disclaimerAccepted": disclaimerAccepted
        ]
        
        // Convert the body to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            return
        }
        
        // Add the necessary headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                print("Error:", error)
                return
            }
            
            // Handle response
                        if let httpResponse = response as? HTTPURLResponse {
                            if (200...299).contains(httpResponse.statusCode) {
                                //success
                           
                            } else {
                                // Failure: non-2xx response
                         
                            }
                        }
                    }
                    
        // Start the data task
        task.resume()
    }
}
