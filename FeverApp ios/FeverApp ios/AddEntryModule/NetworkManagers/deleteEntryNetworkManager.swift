//
//  deleteEntryNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 11/12/2024.
//

import Foundation
import UIKit
class deleteEntryNetworkManager{
    static let shared = deleteEntryNetworkManager()
    
    func deleteEntry(entryId: Int64, completion: @escaping (Bool) -> Void) {
        // Construct the URL
        let urlString = "http://159.89.102.239:8080/api/entry/\(entryId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(false)
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        // Create the URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error during DELETE request: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Check the response code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Entry deleted successfully")
                completion(true)
            } else {
                print("Failed to delete entry. Response: \(String(describing: response))")
                completion(false)
            }
        }

        // Start the task
        task.resume()
    }
}
