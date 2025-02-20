//
//  deleteUserPediatricianNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class deleteUserPediatricianNetworkManager{
    static let shared = deleteUserPediatricianNetworkManager()
    func deleteUserPediatrician(pediatricianId: Int, completion: @escaping (Bool) -> Void) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/user/pediatrician/\(pediatricianId)") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Send the DELETE request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Check the response status code
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Pediatrician with ID \(pediatricianId) deleted successfully.")
                    completion(true)
                } else {
                    print("Failed to delete pediatrician. Server returned status code: \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                print("Invalid server response.")
                completion(false)
            }
        }
        task.resume()
    }
    func deleteUserPediatricianFromCoreData(pediatricianId: Int64, completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create the fetch request for the User_pediatricians entity
        let fetchRequest: NSFetchRequest<User_pediatricians> = User_pediatricians.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pediatricianId == %d", pediatricianId)
        
        do {
            // Fetch the object with the given pediatricianId
            let pediatricianObjects = try context.fetch(fetchRequest)
            
            // Check if any objects were found
            if let pediatricianObject = pediatricianObjects.first {
                // Delete the object from the context
                context.delete(pediatricianObject)
                
                // Save the context to persist the changes
                try context.save()
                
                print("User pediatrician with ID \(pediatricianId) deleted successfully.")
                completion(true)
            } else {
                print("No User_pediatricians object found with ID \(pediatricianId).")
                completion(false)
            }
        } catch {
            print("Failed to fetch or delete User_pediatricians: \(error)")
            completion(false)
        }
    }

    
    
    
}
