//
//  measureWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class measureWorker{
    static let shared = measureWorker()
    
    func syncUnsyncedMeasures(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch unsynced MeasuresLocal objects
        let fetchRequest: NSFetchRequest<MeasuresLocal> = MeasuresLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isMeasuresSynced == nil"),
            NSPredicate(format: "isMeasuresSynced == %@", NSNumber(value: false))
        ])
        
        do {
            // Perform the fetch request
            let unsyncedMeasures = try context.fetch(fetchRequest)
            
            guard !unsyncedMeasures.isEmpty else {
                print("No unsynced measure objects found.")
                completion(true)
                return
            }
            
            // Sync measures to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []
            
            for measure in unsyncedMeasures {
                // Ensure all required attributes are available
                guard
                    let localEntry = measure.localEntry,
                    localEntry.onlineEntryId != 0 // Ensure online entry ID is valid
                else {
                    print("Skipping measure object with missing or invalid attributes.")
                    continue
                }
                
                let onlineEntryId = localEntry.onlineEntryId
                let measureTimeString = measure.measureTime != nil ? ISO8601DateFormatter().string(from: measure.measureTime!) : nil
                
                dispatchGroup.enter()
                
                // Call the syncMeasuresObject function
                measuresNetworkManager.shared.syncMeasuresObject(
                    onlineEntryId: onlineEntryId,
                    takeMeasures: measure.takeMeasures,
                    measures: measure.measures as? [String],
                    otherMeasures: measure.otherMeasures,
                    measureTime: measureTimeString
                ) { result in
                    switch result {
                    case .success(let response):
                        if let measureResponse = response["measures"] as? [String: Any],
                           let measureId = measureResponse["measureId"] as? Int64 {
                            // Update the measure object in Core Data
                            measure.onlineMeasuresId = measureId
                            measure.isMeasuresSynced = true
                            
                            do {
                                try context.save()
                                print("Successfully synced measure with ID: \(measureId)")
                            } catch {
                                print("Failed to update measure in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync measure: \(error.localizedDescription)")
                        syncErrors.append(error)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            // Completion handler when all tasks are done
            dispatchGroup.notify(queue: .main) {
                if syncErrors.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } catch {
            print("Failed to fetch unsynced measure objects: \(error.localizedDescription)")
            completion(false)
        }
    }

}
