//
//  updateUserMedicationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateUserMedicationNetworkManager{
    static let shared = updateUserMedicationNetworkManager()
    func updateUserMedication(
        medicationId: Int,
        amountAdministered: Double?,
        reasonForAdministration: String?,
        basisOfDecision: String?,
        dateOfAdministration: String?,
        timeOfAdministration: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/medications/\(medicationId)") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body dynamically
        var requestBody: [String: Any] = [:]
        if let amountAdministered = amountAdministered {
            requestBody["amountAdministered"] = amountAdministered
        }
        if let reasonForAdministration = reasonForAdministration {
            requestBody["reasonForAdministration"] = reasonForAdministration
        }
        if let basisOfDecision = basisOfDecision {
            requestBody["basisOfDecision"] = basisOfDecision
        }
        if let dateOfAdministration = dateOfAdministration {
            requestBody["dateOfAdministration"] = dateOfAdministration
        }
        if let timeOfAdministration = timeOfAdministration {
            requestBody["timeOfAdministration"] = timeOfAdministration
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
