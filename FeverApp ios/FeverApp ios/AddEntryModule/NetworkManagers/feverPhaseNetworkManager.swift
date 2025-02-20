//
//  feverPhaseNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 03/12/2024.
//

import Foundation
import UIKit
import CoreData
class feverPhaseNetworkManager{
    static let shared = feverPhaseNetworkManager()
    
    func createNewFeverPhaseAndAssignEntries(profileId: Int64) {
        // Access the NSManagedObjectContext
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Step 1: Fetch all LocalEntry objects that do not belong to a fever phase for that given Profile
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
          fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
              NSCompoundPredicate(orPredicateWithSubpredicates: [
                  NSPredicate(format: "belongsToAFeverPhase == nil"),
                  NSPredicate(format: "belongsToAFeverPhase == %@", NSNumber(value: false))
              ]),
              NSPredicate(format: "profileId == %d", profileId)
          ])

        do {
            let entriesWithoutFeverPhase = try context.fetch(fetchRequest)

            guard !entriesWithoutFeverPhase.isEmpty else {
                print("No entries found that do not belong to a fever phase.")
                return
            }

            // Step 2: Determine the oldest and most recent entry dates
            let sortedEntries = entriesWithoutFeverPhase.sorted { ($0.entryDate ?? Date.distantPast) < ($1.entryDate ?? Date.distantPast) }
            let oldestEntryDate = sortedEntries.first?.entryDate ?? Date()
            let mostRecentEntryDate = sortedEntries.last?.entryDate ?? Date()

            // Step 3: Create a new FeverPhaseLocal object
            let newFeverPhase = FeverPhaseLocal(context: context)
            newFeverPhase.feverPhaseStartDate = oldestEntryDate
            newFeverPhase.feverPhaseEndDate = mostRecentEntryDate
            newFeverPhase.isFeverPhaseSynced = false
            newFeverPhase.profileId = profileId

            // Save the context to generate the Z_PK
            try context.save()

            // Extract the Z_PK (Core Data primary key) and assign it to feverPhaseId
            let objectID = newFeverPhase.objectID
            let uriString = objectID.uriRepresentation().absoluteString
            if let primaryKeyString = uriString.split(separator: "/").last,
               let primaryKey = Int(primaryKeyString.dropFirst()) { // Remove the leading "p"
                newFeverPhase.feverPhaseId = Int64(primaryKey)
            }

            // Step 4: Update each LocalEntry to associate with the new fever phase
            for entry in entriesWithoutFeverPhase {
                entry.feverPhaseId = newFeverPhase.feverPhaseId
                entry.feverPhase = newFeverPhase
                entry.belongsToAFeverPhase = true

                // Add the entry to the FeverPhaseLocal's relationship
                newFeverPhase.addToLocalEntry(entry)
            }

            // Save the updated entries and fever phase
            try context.save()
            print("Successfully created a new fever phase and associated \(entriesWithoutFeverPhase.count) entries.")
        } catch {
            print("Failed to create fever phase or update entries: \(error.localizedDescription)")
        }
    }
    
    func syncFeverPhaseObject(
        profileId: Int64?,
        feverPhaseStartDate: String?,
        feverPhaseEndDate: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/feverPhase/sync") else {
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
        
        if let profileId = profileId {
            requestBody["profileId"] = profileId
        }
        if let feverPhaseStartDate = feverPhaseStartDate {
            requestBody["feverPhaseStartDate"] = feverPhaseStartDate
        }
        if let feverPhaseEndDate = feverPhaseEndDate {
            requestBody["feverPhaseEndDate"] = feverPhaseEndDate
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
    func fetchAllFeverPhases(context: NSManagedObjectContext) -> [FeverPhaseLocal]? {
        // Get the profileId from the AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileId = appDelegate.fetchProfileId()
        
        // Create a fetch request for FeverPhaseLocal objects
        let fetchRequest: NSFetchRequest<FeverPhaseLocal> = FeverPhaseLocal.fetchRequest()
        
        // Set a predicate to filter by profileId
        fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId!)
        
        do {
            // Fetch the FeverPhaseLocal objects that match the profileId
            let feverPhases = try context.fetch(fetchRequest)
            return feverPhases
        } catch {
            // Handle any error that occurs during fetching
            print("Failed to fetch FeverPhaseLocal objects for profileId \(profileId): \(error.localizedDescription)")
            return nil
        }
    }


}
