//
//  warningSignsNetworkManager .swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
import CoreData
class warningSignsNetworkManager {
    static let shared = warningSignsNetworkManager()
    func fetchEditingWarningSignsLocal(byId warningSignsId: Int64) -> WarningSignsLocal? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<WarningSignsLocal> = WarningSignsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "warningSignsId == %d", warningSignsId)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Failed to fetch warning signs object with id \(warningSignsId): \(error.localizedDescription)")
            return nil
        }
    }

    func saveWarningSigns(
        with warningId: Int64,
        warningSigns : [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the liquidLocal entity
        let fetchRequest: NSFetchRequest<WarningSignsLocal> = WarningSignsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "warningSignsId == %d", warningId)
        fetchRequest.fetchLimit = 1
        
        context.perform {
            do {
                // Fetch the liquidLocal object
                if let warningLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    warningLocal.warningSigns = warningSigns as NSObject
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No warning Local object found for the given Id.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func saveWarningDate(
        with warningId: Int64,
        warningDate : Date,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the liquidLocal entity
        let fetchRequest: NSFetchRequest<WarningSignsLocal> = WarningSignsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "warningSignsId == %d", warningId)
        fetchRequest.fetchLimit = 1
        
        context.perform {
            do {
                // Fetch the liquidLocal object
                if let warningLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    warningLocal.warningSignsTime = warningDate
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No warning Local object found for the given Id.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func syncWarningSignsObject(
        onlineEntryId: Int64,
        warningSigns: [String]?,
        warningSignsTime: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        print(onlineEntryId)
        print(warningSigns)
        print(warningSignsTime)
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/warningSigns/\(onlineEntryId)") else {
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
        
        if let warningSigns = warningSigns {
            requestBody["warningSigns"] = warningSigns
        }
        if let warningSignsTime = warningSignsTime {
            requestBody["warningSignsTime"] = warningSignsTime
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
            guard let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200) || (httpResponse.statusCode == 201)  else {
                print("Unexpected server response")
                let statusError = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected server responseeee"])
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
