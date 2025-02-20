//
//  usersMedicationWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class userMedicationWorker{
    static let shared = userMedicationWorker()
    
    func syncUnsyncedUserMedications(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch unsynced User_medications objects
        let fetchRequest: NSFetchRequest<User_medications> = User_medications.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isUserMedicationsSynced == nil"),
            NSPredicate(format: "isUserMedicationsSynced == %@", NSNumber(value: false))
        ])
        
        do {
            // Perform the fetch request
            let unsyncedMedications = try context.fetch(fetchRequest)
            
            guard !unsyncedMedications.isEmpty else {
                print("No unsynced user medications found.")
                completion(true)
                return
            }
            
            // Sync medications to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []
            
            // Get user ID from AppDelegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let (userId, _) = appDelegate.fetchUserData()
            
            for medication in unsyncedMedications {
                // Use optional binding for required attributes
                guard let medicationName = medication.medicationName else {
                    print("Skipping medication object with missing medication name.")
                    continue
                }
                
                let medicationType = medication.typeOfMedication
                let activeIngredientQuantity = medication.activeIngredientQuantity
                
                dispatchGroup.enter()
                
                // Call the syncUsersMedicationObject function
                userMedicationNetworkManager.shared.syncUsersMedicationObject(
                    userId: Int(userId!),
                    medicationName: medicationName,
                    medicationType: medicationType,
                    activeIngredientQuantity: activeIngredientQuantity
                ) { result in
                    switch result {
                    case .success(let response):
                        if let medicationResponse = response["medication"] as? [String: Any],
                           let onlineMedicationId = medicationResponse["medicationId"] as? Int64 {
                            // Update the medication object in Core Data
                            medication.onlineUserMedicationsId = onlineMedicationId
                            medication.isUserMedicationsSynced = true
                            
                            do {
                                try context.save()
                                print("Successfully synced medication with ID: \(onlineMedicationId)")
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
            print("Failed to fetch unsynced user medications: \(error.localizedDescription)")
            completion(false)
        }
    }

}
