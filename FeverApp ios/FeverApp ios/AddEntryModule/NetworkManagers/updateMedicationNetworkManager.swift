//
//  updateMedicationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateMedicationNetworkManager{
    static let shared = updateMedicationNetworkManager()
    func markedMedicationUpdated(medicationId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MedicationsLocal> = MedicationsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "medicationEntryId == %d", medicationId)

        do {
            // Fetch the specific medication entry
            if let medicationLocal = try context.fetch(fetchRequest).first {
                // Mark the medication as updated
                medicationLocal.isMedicationsUpdated = true

                // Update the associated local entry's isEntryUpdated property
                if let associatedLocalEntry = medicationLocal.localEntry {
                    associatedLocalEntry.isEntryUpdated = true
                }

                // Save changes to the context
                try context.save()
                print("Medication with ID \(medicationId) and its associated entry marked as updated.")
            } else {
                print("No medication found with ID \(medicationId).")
            }
        } catch {
            print("Error marking medication as updated with ID \(medicationId): \(error.localizedDescription)")
        }
    }
    func updateMedicationEntry(
        medicationEntryId: Int,
        hasTakenMedications: String?,
        medicationList: [String]?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/medications/\(medicationEntryId)") else {
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
        if let hasTakenMedications = hasTakenMedications {
            requestBody["hasTakenMedications"] = hasTakenMedications
        }
        if let medicationList = medicationList, !medicationList.isEmpty {
            requestBody["medicationList"] = medicationList
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
