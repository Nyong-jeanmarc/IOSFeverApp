//
//  updateUserMedicationWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateUserMedicationWorker{
    static let shared = updateUserMedicationWorker()
    func syncUpdatedUserMedications(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all User_medications objects where isupdated is true
        let fetchRequest: NSFetchRequest<User_medications> = User_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isupdated == %@", NSNumber(value: true))
        
        do {
            let updatedMedications = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedMedications.isEmpty {
                print("No updated UserMedications objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated medication object
            for medicationObject in updatedMedications {
                let onlineId = Int(medicationObject.onlineUserMedicationsId)
                let amountAdministered = medicationObject.amountAdministered
                let reasonForAdministration = medicationObject.reasonForAdministration
                let basisOfDecision = medicationObject.basisOfDecision
                let dateOfAdministration = medicationObject.dateOfAdministration != nil
                    ? ISO8601DateFormatter().string(from: medicationObject.dateOfAdministration!)
                    : nil
                let timeOfAdministration = medicationObject.timeOfAdministration != nil
                    ? ISO8601DateFormatter().string(from: medicationObject.timeOfAdministration!)
                    : nil
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                updateUserMedicationNetworkManager.shared.updateUserMedication(
                    medicationId: onlineId,
                    amountAdministered: amountAdministered,
                    reasonForAdministration: reasonForAdministration,
                    basisOfDecision: basisOfDecision,
                    dateOfAdministration: dateOfAdministration,
                    timeOfAdministration: timeOfAdministration
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isupdated flag to false
                            medicationObject.isupdated = false
                            print("Successfully synced medicationId: \(onlineId)")
                        } else {
                            // Keep the isupdated flag as true and mark failure
                            medicationObject.isupdated = true
                            print("Failed to sync medicationId: \(onlineId)")
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
            print("Failed to fetch updated UserMedications objects: \(error)")
            completion(false)
        }
    }

}
