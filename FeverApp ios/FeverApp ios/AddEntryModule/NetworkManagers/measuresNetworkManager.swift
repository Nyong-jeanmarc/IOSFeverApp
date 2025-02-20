//
//  measuresNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 28/11/2024.
//

import Foundation
import CoreData
import UIKit
class measuresNetworkManager{
    static let shared = measuresNetworkManager()
    func fetchEditingMeasureLocal(byId measureId: Int64) -> MeasuresLocal? {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MeasuresLocal> = MeasuresLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "measureId == %d", measureId)

        do {
            // Execute fetch request
            let results = try context.fetch(fetchRequest)
            // Return the first result if found
            return results.first
        } catch {
            print("Error fetching MeasuresLocal with ID \(measureId): \(error.localizedDescription)")
            return nil
        }
    }


    func updateTakeMeasures(for id: Int64, with newValue: String, completion: @escaping (Bool) -> Void) {
        // Get the Core Data context
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            print("Failed to get the context")
            completion(false)
            return
        }
        
        // Create a fetch request for the MeasuresLocal entity
        let fetchRequest: NSFetchRequest<MeasuresLocal> = MeasuresLocal.fetchRequest()
        
        // Set a predicate to fetch the specific measure with the given id
        fetchRequest.predicate = NSPredicate(format: "measureId == %d", id)
        
        do {
            // Fetch the object with the specified id
            let measures = try context.fetch(fetchRequest)
            
            // Update the takeMeasures attribute for the matching object, if found
            if let measure = measures.first {
                measure.takeMeasures = newValue
                
                // Save the context to persist changes
                try context.save()
                print("Updated takeMeasures for id \(id) to: \(newValue)")
                completion(true)
            } else {
                print("No MeasuresLocal object found with id: \(id)")
                completion(false)
            }
        } catch {
            print("Failed to fetch or update MeasuresLocal: \(error)")
            completion(false)
        }
    }
    func saveMeasures(
        with measureId: Int64,
        measures: [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the PainLocal entity
        let fetchRequest: NSFetchRequest<MeasuresLocal> = MeasuresLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "measureId == %d", measureId)
        fetchRequest.fetchLimit = 1

        context.perform {
            do {
                // Fetch the PainLocal object
                if let measureLocal = try context.fetch(fetchRequest).first {
                    // Update the otherPlaces attribute
                    measureLocal.measures = measures as NSObject
                    
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
    func updateOtherMeasures(for id: Int64, with newValue: String, completion: @escaping (Bool) -> Void) {
        // Get the Core Data context
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            print("Failed to get the context")
            completion(false)
            return
        }
        
        // Create a fetch request for the MeasuresLocal entity
        let fetchRequest: NSFetchRequest<MeasuresLocal> = MeasuresLocal.fetchRequest()
        
        // Set a predicate to fetch the specific measure with the given id
        fetchRequest.predicate = NSPredicate(format: "measureId == %d", id)
        
        do {
            // Fetch the object with the specified id
            let measures = try context.fetch(fetchRequest)
            
            // Update the takeMeasures attribute for the matching object, if found
            if let measure = measures.first {
                measure.otherMeasures = newValue
                
                // Save the context to persist changes
                try context.save()
                print("Updated takeMeasures for id \(id) to: \(newValue)")
                completion(true)
            } else {
                print("No MeasuresLocal object found with id: \(id)")
                completion(false)
            }
        } catch {
            print("Failed to fetch or update MeasuresLocal: \(error)")
            completion(false)
        }
    }
    func updateMeasuresDate(for id: Int64, with newValue: Date, completion: @escaping (Bool) -> Void) {
        // Get the Core Data context
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            print("Failed to get the context")
            completion(false)
            return
        }
        
        // Create a fetch request for the MeasuresLocal entity
        let fetchRequest: NSFetchRequest<MeasuresLocal> = MeasuresLocal.fetchRequest()
        
        // Set a predicate to fetch the specific measure with the given id
        fetchRequest.predicate = NSPredicate(format: "measureId == %d", id)
        
        do {
            // Fetch the object with the specified id
            let measures = try context.fetch(fetchRequest)
            
            // Update the takeMeasures attribute for the matching object, if found
            if let measure = measures.first {
                measure.measureTime = newValue
                
                // Save the context to persist changes
                try context.save()
                print("Updated takeMeasures for id \(id) to: \(newValue)")
                completion(true)
            } else {
                print("No MeasuresLocal object found with id: \(id)")
                completion(false)
            }
        } catch {
            print("Failed to fetch or update MeasuresLocal: \(error)")
            completion(false)
        }
    }
    func syncMeasuresObject(
        onlineEntryId: Int64,
        takeMeasures: String?,
        measures: [String]?,
        otherMeasures: String?,
        measureTime: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/measures/\(onlineEntryId)") else {
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
        
        if let takeMeasures = takeMeasures {
            requestBody["takeMeasures"] = takeMeasures
        }
        if let measures = measures {
            requestBody["measures"] = measures
        }
        if let otherMeasures = otherMeasures {
            requestBody["otherMeasures"] = otherMeasures
        }
        if let measureTime = measureTime {
            requestBody["measureTime"] = measureTime
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
