//
//  feelingConfidentWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class feelingConfidentWorker{
    static let shared = feelingConfidentWorker()
    
    func syncUnsyncedConfidenceLevels(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced Confidence_levelLocal objects
        let fetchRequest: NSFetchRequest<Confidence_levelLocal> = Confidence_levelLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isConfidenceLevelSynced == nil"),
            NSPredicate(format: "isConfidenceLevelSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedConfidenceLevels = try context.fetch(fetchRequest)

            guard !unsyncedConfidenceLevels.isEmpty else {
                print("No unsynced confidence level objects found.")
                completion(true)
                return
            }

            // Sync confidence levels to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for confidenceLevel in unsyncedConfidenceLevels {
                // Ensure all required attributes are available
                guard let localEntry = confidenceLevel.localEntry,
                      localEntry.onlineEntryId != 0 else {
                    print("Skipping confidence level object with missing or invalid attributes.")
                    continue
                }

                let onlineEntryId = localEntry.onlineEntryId
                let confidenceLevelValue = confidenceLevel.confidenceLevel
                let timeOfObservationString = confidenceLevel.timeOfObservation != nil
                    ? ISO8601DateFormatter().string(from: confidenceLevel.timeOfObservation!)
                    : nil

                // Enter dispatch group
                dispatchGroup.enter()

                // Call syncFeelingConfidentObject
                feelingConfidentNetworkManager.shared.syncFeelingConfidentObject(
                    onlineEntryId: onlineEntryId,
                    confidenceLevel: confidenceLevelValue,
                    timeOfObservation: timeOfObservationString
                ) { result in
                    switch result {
                    case .success(let response):
                        if let confidenceLevelResponse = response["confidenceLevel"] as? [String: Any],
                           let confidenceLevelId = confidenceLevelResponse["confidenceLevelId"] as? Int64 {
                            // Update the confidence level object in Core Data
                            confidenceLevel.onlineConfidenceLevelId = confidenceLevelId
                            confidenceLevel.isConfidenceLevelSynced = true

                            do {
                                try context.save()
                                print("Successfully synced confidence level with ID: \(confidenceLevelId)")
                            } catch {
                                print("Failed to update confidence level in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync confidence level: \(error.localizedDescription)")
                        syncErrors.append(error)
                    }

                    // Leave dispatch group
                    dispatchGroup.leave()
                }
            }

            // Notify when all syncs are completed
            dispatchGroup.notify(queue: .main) {
                if syncErrors.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } catch {
            print("Failed to fetch unsynced confidence level objects: \(error.localizedDescription)")
            completion(false)
        }
    }
}
