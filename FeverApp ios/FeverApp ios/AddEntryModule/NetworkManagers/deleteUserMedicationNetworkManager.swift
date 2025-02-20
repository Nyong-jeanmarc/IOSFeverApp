//
//  deleteUserMedicationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class deleteUserMedicationNetworkManager{
    static let shared = deleteUserMedicationNetworkManager()
    
    func deleteUserMedication(medicationId: Int, completion: @escaping (Bool) -> Void) {
        // Construct the URL using the medication ID
        guard let url = URL(string: "http://159.89.102.239:8080/api/medications/\(medicationId)") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        // Create the request and set its method to DELETE
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle any errors that occur during the request
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Check for successful response
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    // Successful deletion
                    print("Successfully deleted medication with ID: \(medicationId)")
                    completion(true)
                } else {
                    // Failed to delete medication
                    print("Failed to delete medication with ID: \(medicationId). Status code: \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                // No valid response
                completion(false)
            }
        }
        
        // Start the request task
        task.resume()
    }
    func deleteUserMedicationFromCoreData(medicationId: Int64, completion: @escaping (Bool) -> Void) {
        // Access the managed object context from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create a fetch request for User_medications with a predicate to match the medicationId
        let fetchRequest: NSFetchRequest<User_medications> = User_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "medicationId == %@", NSNumber(value: medicationId))
        
        do {
            // Fetch the user medication with the given medicationId
            let userMedications = try context.fetch(fetchRequest)
            
            // Check if the medication exists
            if let medicationToDelete = userMedications.first {
                // Delete the object from the context
                context.delete(medicationToDelete)
                
                // Save the context to persist the changes
                try context.save()
                print("Successfully deleted medication with ID: \(medicationId)")
                completion(true)
            } else {
                // Medication not found
                print("Medication with ID \(medicationId) not found in Core Data.")
                completion(false)
            }
        } catch {
            // Handle errors in fetching or deleting
            print("Error deleting medication: \(error.localizedDescription)")
            completion(false)
        }
    }

}
