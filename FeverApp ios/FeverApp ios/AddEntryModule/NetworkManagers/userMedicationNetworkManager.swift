//
//  userMedicationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 27/11/2024.
//

import Foundation
import UIKit
import CoreData
class userMedicationNetworkManager{
    static let shared = userMedicationNetworkManager()
    
    func createUserMedication(
        typeOfMedication: String,
        medicationName: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.perform {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            // Fetch user data
            let (userId, familyCode) = appDelegate.fetchUserData()
            let newUserMedication = User_medications(context: context)
            newUserMedication.typeOfMedication = typeOfMedication
            newUserMedication.medicationName = medicationName
            newUserMedication.userId = userId!
            
            do {
                try context.save()
                // Step 4: Extract Core Data-generated object ID
                if let objectID = newUserMedication.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
                   let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                    newUserMedication.medicationId = coreDataId
                    newUserMedication.medicationEntryId = medicationModel.shared.medicationEntryId!
                    try context.save()
                    completion(true) // Save was successful
                }
                } catch {
                    print("Failed to save User_medications object: \(error)")
                    completion(false) // Save failed
                }
            }
        }
    
    func fetchMedications() -> [User_medications] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var medicationList: [User_medications] = []
        
        let fetchRequest: NSFetchRequest<User_medications> = User_medications.fetchRequest()
        
        do {
            let medications = try context.fetch(fetchRequest)
           medicationList = medications
        } catch {
            print("Failed to fetch User_medications: \(error)")
        }
        
        return medicationList
    }
    
    func deleteMedication(by medicationId: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User_medications> = User_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "medicationId == %d", medicationId)
        
        do {
            let medications = try context.fetch(fetchRequest)
            
            if let medicationToDelete = medications.first {
                context.delete(medicationToDelete)
                
                // Save the context to persist the deletion
                try context.save()
                print("Medication with ID \(medicationId) successfully deleted.")
            } else {
                print("No medication found with ID \(medicationId).")
            }
        } catch {
            print("Failed to delete medication: \(error.localizedDescription)")
        }
    }
    
    func syncUsersMedicationObject(
        userId: Int,
        medicationName: String?,
        medicationType: String?,
        activeIngredientQuantity: Double?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/user/medications/\(userId)") else {
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
        
        if let medicationName = medicationName {
            requestBody["medicationName"] = medicationName
        }
        if let medicationType = medicationType {
            requestBody["medicationType"] = medicationType
        }
        if let activeIngredientQuantity = activeIngredientQuantity {
            requestBody["activeIngredientQuantity"] = activeIngredientQuantity
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

