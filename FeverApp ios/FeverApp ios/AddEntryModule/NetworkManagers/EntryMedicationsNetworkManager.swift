//
//  EntryMedicationsNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 28/11/2024.
//

import Foundation
import UIKit
import CoreData
class EntryMedicationsNetworkManager{
    static let shared = EntryMedicationsNetworkManager()
    func fetchEditingEntryMedicationLocal(byId entryMedicationId: Int64) -> Entry_medications? {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Entry_medications> = Entry_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", entryMedicationId)

        do {
            // Execute fetch request
            let results = try context.fetch(fetchRequest)
            // Return the first result if found
            return results.first
        } catch {
            print("Error fetching Entry_medications with ID \(entryMedicationId): \(error.localizedDescription)")
            return nil
        }
    }

    func checkAssociatedEntryMedication(for userMedicationId: Int64) -> (exists: Bool, entryMedicationId: Int64?) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch the Entry_medications object with the matching userMedicationId
        let fetchRequest: NSFetchRequest<Entry_medications> = Entry_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userMedicationId == %d", userMedicationId)

        do {
            // Execute fetch request
            if let entryMedication = try context.fetch(fetchRequest).first {
                // If an associated Entry_medications object exists, return true and the id
                return (true, entryMedication.id)
            } else {
                // No associated Entry_medications object found
                return (false, nil)
            }
        } catch {
            print("Error fetching Entry_medications for User_medications ID \(userMedicationId): \(error.localizedDescription)")
            return (false, nil)
        }
    }
    func createAndUpdateEntryMedication(
        with userMedicationId: Int64,
        medicationName: String,
        typeOfMedication: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a new Entry_medications object
        let newEntryMedication = Entry_medications(context: context)
        
        // Set the userMedicationId attribute
        newEntryMedication.userMedicationId = userMedicationId
        
        // Set other required default values (if any)
        newEntryMedication.medicationName = medicationName
        newEntryMedication.typeOfMedication = typeOfMedication
        do {
            // Save the context to persist the new object
            try context.save()
            // Step 4: Extract Core Data-generated object ID
            if let objectID = newEntryMedication.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newEntryMedication.id = coreDataId
                newEntryMedication.medicationEntryId = medicationModel.shared.medicationEntryId!
                EntryMedicationsModel.shared.saveMedicationEntryId(medId:newEntryMedication.medicationEntryId)
            }
            try context.save()
            print("Entry_medications object successfully created with userMedicationId: \(userMedicationId)")
            completion(true) // Notify success
        } catch {
            print("Failed to save Entry_medications object: \(error.localizedDescription)")
            completion(false) // Notify failure
        }
    }
    func updateEntryMedication(
        with id: Int64,
        amountAdministered: Double,
        basisOfDecision: String,
        reasonForAdministration: String,
        dateOfAdministration: Date,
        timeOfAdministration: Date,
        completion: @escaping (Bool) -> Void
    ) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Entry_medications entity
        let fetchRequest: NSFetchRequest<Entry_medications> = Entry_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "medicationEntryId == %d", id)
        
        do {
            // Fetch the matching Entry_medications object
            let results = try context.fetch(fetchRequest)
            
            if let entryMedication = results.first {
                // Update the attributes with the provided values
                entryMedication.amountAdministered = amountAdministered
                entryMedication.basisOfDecision = basisOfDecision
                entryMedication.reasonForAdministration = reasonForAdministration
                entryMedication.dateOfAdministration = dateOfAdministration
                entryMedication.timeOfAdministration = timeOfAdministration
                // update its user medication too
                updateUserMedication(userMedicationId: entryMedication.userMedicationId, basisOfDecision: basisOfDecision, timeOfAdministration: timeOfAdministration, dateOfAdministration: dateOfAdministration, reasonForAdministration: reasonForAdministration, amountAdministered: amountAdministered)
                // Save the context to persist the changes
                try context.save()
                print("Successfully updated Entry_medications with ID \(id).")
                completion(true) // Notify success
            } else {
                print("No Entry_medications object found with ID \(id).")
                completion(false) // Notify failure due to missing object
            }
        } catch {
            print("Failed to fetch or update Entry_medications: \(error.localizedDescription)")
            completion(false) // Notify failure due to an error
        }
    }
    func updateUserMedication(
        userMedicationId: Int64,
        basisOfDecision: String,
        timeOfAdministration: Date,
        dateOfAdministration: Date,
        reasonForAdministration: String,
        amountAdministered: Double
    ) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for User_medications
        let fetchRequest: NSFetchRequest<User_medications> = User_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "medicationId == %d", userMedicationId)
        
        do {
            // Fetch the results
            let medications = try context.fetch(fetchRequest)
            
            if let medication = medications.first {
                // Update the attributes
                medication.basisOfDecision = basisOfDecision
                medication.timeOfAdministration = timeOfAdministration
                medication.dateOfAdministration = dateOfAdministration
                medication.reasonForAdministration = reasonForAdministration
                medication.amountAdministered = amountAdministered
                
                // Save the context
                try context.save()
                print("Medication updated successfully.")
            } else {
                print("No medication found with the given ID.")
            }
        } catch {
            print("Failed to fetch or update medication: \(error.localizedDescription)")
        }
    }
    func syncEntryMedicationObject(
        medicationEntryId: Int64?,
        userMedicationId: Int64?,
        medicationName: String?,
        typeOfMedication: String?,
        activeIngredientQuantity: Double?,
        amountAdministered: Double?,
        reasonForAdministration: String?,
        basisOfDecision: String?,
        dateOfAdministration: String?,
        timeOfAdministration: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/medications/sync") else {
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
        
        if let medicationEntryId = medicationEntryId {
            requestBody["medicationEntryId"] = medicationEntryId
        }
        if let userMedicationId = userMedicationId {
            requestBody["userMedicationId"] = userMedicationId
        }
        if let medicationName = medicationName {
            requestBody["medicationName"] = medicationName
        }
        if let typeOfMedication = typeOfMedication {
            requestBody["typeOfMedication"] = typeOfMedication
        }
        if let activeIngredientQuantity = activeIngredientQuantity {
            requestBody["activeIngredientQuantity"] = activeIngredientQuantity
        }
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
