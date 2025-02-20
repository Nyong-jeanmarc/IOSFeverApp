//
//  searchPediatricianNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 11/10/2024.
//

import Foundation
import UIKit
struct Pediatrician: Codable {
    let id: Int64
    let practiceId: String
    let doctorId: String
    let title: String
    let firstName: String
    let lastName: String
    let street: String
    let zip: String
    let city: String
    let countryCode: String
    let phone: String
    let email: String
    let visible: String
    let reference: String
}
class searchPediatricianNetworkManager{
    static let shared = searchPediatricianNetworkManager()
    func getPediatricianRequest(searchKey: String, completion: @escaping (Result<[Pediatrician], Error>) -> Void) {
        // Construct the URL for the request
        guard let url = URL(string: "http://159.89.102.239:8080/api/user/pediatrician/search?searchTerm=\(searchKey)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for a valid HTTP response
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let errorMessage = "Failed to fetch pediatricians. Please try again."
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                return
            }
            
            // Parse the JSON data
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PediatricianResponse.self, from: data)
                completion(.success(response.pediatricians))
                print(response.pediatricians)
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }
    
    // Define the Codable structures to match the JSON response
    struct PediatricianResponse: Codable {
        let message: String
        let pediatricians: [Pediatrician]
    }
    
   
}
