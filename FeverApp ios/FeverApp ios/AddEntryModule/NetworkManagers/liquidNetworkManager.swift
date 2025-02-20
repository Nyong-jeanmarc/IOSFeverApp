//
//  liquidNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
import CoreData
class liquidNetworkManager {
    static let shared = liquidNetworkManager()
    
    func saveDehydrationSigns(
        with liquidId: Int64,
        dehydrationSigns : [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the liquidLocal entity
        let fetchRequest: NSFetchRequest<LiquidsLocal> = LiquidsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "liquidId == %d", liquidId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the liquidLocal object
                if let liquidLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    liquidLocal.dehydrationSigns = dehydrationSigns as NSObject
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No Liquid Local object found for the given liquidId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func updateLiquidDate(
        with liquidId: Int64,
        liquidDate: Date,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the PainLocal entity
        let fetchRequest: NSFetchRequest<LiquidsLocal> = LiquidsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "liquidId == %d", liquidId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the liquid local object
                if let liquidLocal = try context.fetch(fetchRequest).first {
                    // Update the liquid time attribute
                    liquidLocal.liquidTime = liquidDate
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No liquidlocal object found for the given liquidId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func syncLiquidObject(
        dehydrationSigns: [String]?,
        liquidTime: String?,
        onlineEntryId: Int,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/liquids/\(onlineEntryId)") else {
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

        if let dehydrationSigns = dehydrationSigns {
            requestBody["dehydrationSigns"] = dehydrationSigns
        }
        if let liquidTime = liquidTime {
            requestBody["liquidTime"] = liquidTime
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
    func fetchEditingLiquidLocal(byId liquidId: Int64) -> LiquidsLocal? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LiquidsLocal> = LiquidsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "liquidId == %d", liquidId)
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.first
        } catch {
            print("Failed to fetch liquid object with id \(liquidId): \(error.localizedDescription)")
            return nil
        }
    }

}
