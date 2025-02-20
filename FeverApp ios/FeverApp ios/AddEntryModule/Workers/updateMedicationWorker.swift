//
//  updateMedicationWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateMedicationWorker{
    static let shared = updateMedicationWorker()
    
    func syncUpdatedMedications(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all MedicationsLocal objects where isMedicationsUpdated == true
        let fetchRequest: NSFetchRequest<MedicationsLocal> = MedicationsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isMedicationsUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedMedications = try context.fetch(fetchRequest)
            
            // If there are no updated objects, return success
            if updatedMedications.isEmpty {
                print("No updated Medications objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated medication object
            for medicationObject in updatedMedications {
                let medicationEntryId = Int(medicationObject.onlineMedicationsId)
                let hasTakenMedications = medicationObject.hasTakenMedication
                let medicationList = medicationObject.medicationList as? [String]
                
                // Enter the dispatch group
                dispatchGroup.enter()
                
                updateMedicationNetworkManager.shared.updateMedicationEntry(
                    medicationEntryId: medicationEntryId,
                    hasTakenMedications: hasTakenMedications,
                    medicationList: medicationList
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isMedicationsUpdated flag to false
                            medicationObject.isMedicationsUpdated = false
                            print("Successfully synced medicationId: \(medicationObject.onlineMedicationsId)")
                        } else {
                            // Keep the isMedicationsUpdated flag as true
                            medicationObject.isMedicationsUpdated = true
                            print("Failed to sync medicationId: \(medicationObject.onlineMedicationsId)")
                            syncSuccess = false
                        }
                        
                        // Save changes to Core Data
                        do {
                            try context.save()
                            print("Changes saved to Core Data.")
                        } catch {
                            print("Error saving Core Data: \(error)")
                            syncSuccess = false
                        }
                        
                        // Leave the group after processing
                        dispatchGroup.leave()
                    }
                }
            }
            
            // Notify when all network calls are complete
            dispatchGroup.notify(queue: .main) {
                print("All sync operations completed.")
                completion(syncSuccess)
            }
            
        } catch {
            print("Failed to fetch updated Medications objects: \(error)")
            completion(false)
        }
    }

}
