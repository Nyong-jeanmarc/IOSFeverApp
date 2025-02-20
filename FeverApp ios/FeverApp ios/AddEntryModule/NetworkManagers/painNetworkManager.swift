//
//  painNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 24/11/2024.
//

import Foundation
import CoreData
import UIKit
class painNetworkManager{
    static let shared = painNetworkManager()
    
    func savePainValues(
        with painId: Int64,
        painValues: [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the PainLocal entity
        let fetchRequest: NSFetchRequest<PainLocal> = PainLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "painId == %d", painId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the PainLocal object
                if let painLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    painLocal.painValue = painValues as NSObject
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No PainLocal object found for the given painId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func updatePainLocalOtherPlaces(
        with painId: Int64,
        otherPlacesValue: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the PainLocal entity
        let fetchRequest: NSFetchRequest<PainLocal> = PainLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "painId == %d", painId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the PainLocal object
                if let painLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    painLocal.otherPlaces = otherPlacesValue
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No PainLocal object found for the given painId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func updatePainSeverityScale(
        with painId: Int64,
        painSeverity: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the PainLocal entity
        let fetchRequest: NSFetchRequest<PainLocal> = PainLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "painId == %d", painId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the PainLocal object
                if let painLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    painLocal.painSeverityScale = painSeverity
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No PainLocal object found for the given painId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func updatePainDate(
        with painId: Int64,
        painDate: Date,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the PainLocal entity
        let fetchRequest: NSFetchRequest<PainLocal> = PainLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "painId == %d", painId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the PainLocal object
                if let painLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    painLocal.painDateTime = painDate
                    
                    // Save the context
                    try context.save()
                    completion(true) // Success
                } else {
                    print("No PainLocal object found for the given painId.")
                    completion(false) // Failure
                }
            } catch {
                print("Error fetching or saving data: \(error.localizedDescription)")
                completion(false) // Failure
            }
        }
    }
    func syncPainObject(
        onlineEntryId: Int,
        painValue: [String]?,
        otherPlaces: String?,
        painDateTime: String?,
        painSeverityScale: String?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        // Server URL
        let urlString = "http://159.89.102.239:8080/api/entry/pain/\(onlineEntryId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the body with only non-nil parameters
        var body: [String: Any] = [:]
        if let painValue = painValue {
            body["painValue"] = painValue
        }
        if let otherPlaces = otherPlaces {
            body["otherPlaces"] = otherPlaces
        }
        if let painDateTime = painDateTime {
            body["painDateTime"] = painDateTime
        }
        if let painSeverityScale = painSeverityScale {
            body["painSeverityScale"] = painSeverityScale
        }
        
        // Serialize the body
        do {
            let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = bodyData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected response status code"])
                completion(.failure(statusError))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
            }
        }
        task.resume()
    }
    func fetchEditingPainLocal(byId painId: Int64) -> PainLocal? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PainLocal> = PainLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "painId == %d", painId)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Return the first matching PainLocal object
        } catch {
            print("Failed to fetch PainLocal with ID \(painId): \(error.localizedDescription)")
            return nil
        }
    }

}
