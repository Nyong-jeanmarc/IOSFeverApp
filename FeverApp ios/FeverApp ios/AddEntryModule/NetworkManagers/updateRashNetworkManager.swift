//
//  updateRashNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateRashNetworkManager{
    static let shared = updateRashNetworkManager()
    func markRashUpdated(rashId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<RashLocal> = RashLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "rashId == %d", rashId)

        do {
            // Fetch the RashLocal object
            let results = try context.fetch(fetchRequest)
            if let rash = results.first {
                // Update the isRashUpdated property
                rash.isRashUpdated = true

                // Update the isEntryUpdated property of the associated local entry, if it exists
                if let localEntry = rash.localEntry {
                    localEntry.isEntryUpdated = true
                }

                // Save changes to the context
                try context.save()
                print("Rash with ID \(rashId) marked as updated.")
            } else {
                print("No RashLocal object found with ID \(rashId).")
            }
        } catch {
            print("Error fetching or updating RashLocal object with ID \(rashId): \(error.localizedDescription)")
        }
    }
    func updateRash(
        rashId: Int,
        rashes: [String]?,
        rashDateTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/rash/\(rashId)") else {
            print("Invalid URL")
            completion(false)
            return
        }

        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the request body dynamically
        var requestBody: [String: Any] = [:]
        if let rashes = rashes {
            requestBody["rashes"] = rashes
        }
        if let rashDateTime = rashDateTime {
            requestBody["rashDateTime"] = rashDateTime
        }

        // Ensure the request body is not empty
        guard !requestBody.isEmpty else {
            print("Request body is empty. Nothing to send.")
            completion(false)
            return
        }

        // Encode the request body to JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        } catch {
            print("Error encoding JSON: \(error)")
            completion(false)
            return
        }

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false)
                return
            }

            // Check for response and status code
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Update successful: \(httpResponse.statusCode)")
                    completion(true)
                } else {
                    print("Server error: \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        task.resume()
    }

}
