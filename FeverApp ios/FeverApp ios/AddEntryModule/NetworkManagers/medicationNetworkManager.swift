//
//  medicationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 27/11/2024.
//

import Foundation
import UIKit
import CoreData
class medicationLocalNetworkManager{
    static let shared = medicationLocalNetworkManager()
    func fetchEditingMedicationLocal(byId medicationEntryId: Int64) -> MedicationsLocal? {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MedicationsLocal> = MedicationsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "medicationEntryId == %d", medicationEntryId)

        do {
            // Execute fetch request
            let results = try context.fetch(fetchRequest)
            // Return the first result if found
            return results.first
        } catch {
            print("Error fetching MedicationsLocal with ID \(medicationEntryId): \(error.localizedDescription)")
            return nil
        }
    }

    func updateHasTakenMedication(
        withId id: Int64,
        toValue value: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create a fetch request for the MedicationsLocal entity
        let fetchRequest: NSFetchRequest<MedicationsLocal> = MedicationsLocal.fetchRequest()
        
        // Add a predicate to filter by the given ID
        fetchRequest.predicate = NSPredicate(format: "medicationEntryId == %d", id)
        
        do {
            // Perform the fetch request
            let results = try context.fetch(fetchRequest)
            
            if let medication = results.first {
                // Update the hasTakenMedication property
                medication.hasTakenMedication = value
                
                // Save the context to persist changes
                try context.save()
                
                // Call completion handler with success
                print("Successfully updated medication with ID: \(id) to value: \(value)")
                completion(true)
            } else {
                // No matching entity found
                print("No medication found with ID: \(id)")
                completion(false)
            }
        } catch {
            // Handle errors (e.g., fetch or save failed)
            print("Error updating medication: \(error)")
            completion(false)
        }
    }
    func syncMedicationObject(
        onlineEntryId: Int64,
        hasTakenMedications: String?,
        medicationList: [String]?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/medications/\(onlineEntryId)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the request body, dynamically excluding nil values
        var requestBody: [String: Any] = [:]
        
        if let hasTakenMedications = hasTakenMedications {
            requestBody["hasTakenMedications"] = hasTakenMedications
        }
        if let medicationList = medicationList, !medicationList.isEmpty {
            requestBody["medicationList"] = medicationList
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Unexpected server response")
                let statusError = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])
                completion(.failure(statusError))
                return
            }
            
            guard let data = data else {
                print("No data received")
                let dataError = NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(dataError))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    completion(.success(jsonResponse))
                } else {
                    print("Invalid JSON structure")
                    let jsonError = NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                    completion(.failure(jsonError))
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
