//
//  medicationWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class medicationWorker{
    
    static let shared = medicationWorker()
    
    func syncUnsyncedMedications(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch unsynced MedicationsLocal objects
        let fetchRequest: NSFetchRequest<MedicationsLocal> = MedicationsLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isMedicationsSynced == nil"),
            NSPredicate(format: "isMedicationsSynced == %@", NSNumber(value: false))
        ])
        
        do {
            // Perform the fetch request
            let unsyncedMedications = try context.fetch(fetchRequest)
            
            guard !unsyncedMedications.isEmpty else {
                print("No unsynced medication objects found.")
                completion(true)
                return
            }
            
            // Sync medications to the server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []
            
            for medication in unsyncedMedications {
                // Ensure all required attributes are available
                guard
                    let localEntry = medication.localEntry,
                    localEntry.onlineEntryId != 0 // Ensure online entry ID is valid
                else {
                    print("Skipping medication object with missing or invalid attributes.")
                    continue
                }
                
                // Retrieve the necessary properties
                let onlineEntryId = localEntry.onlineEntryId
                let hasTakenMedication = medication.hasTakenMedication
                let medicationList = medication.medicationList as? [String] ?? nil
                
                dispatchGroup.enter()
                
                // Call the syncMedicationObject function
                medicationLocalNetworkManager.shared.syncMedicationObject(
                    onlineEntryId: onlineEntryId,
                    hasTakenMedications: hasTakenMedication,
                    medicationList: medicationList
                ) { result in
                    switch result {
                    case .success(let response):
                        if
                            let createdMedication = response["createdMedication"] as? [String: Any],
                                       let medicationn = createdMedication["medication"] as? [String: Any],
                                       let medicationEntryId = medicationn["medicationEntryId"] as? Int {
                            // Update the medication object in Core Data
                            medication.onlineMedicationsId = Int64(medicationEntryId)
                            medication.isMedicationsSynced = true
                            
                            do {
                                try context.save()
                                print("Successfully synced medication with ID: \(medicationEntryId)")
                            } catch {
                                print("Failed to update medication in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync medication: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced medication objects: \(error.localizedDescription)")
            completion(false)
        }
    }

}
