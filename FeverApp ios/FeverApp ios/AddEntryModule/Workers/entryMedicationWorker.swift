//
//  entryMedicationWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class entryMedicationWorker{
    static let shared = entryMedicationWorker()
    func syncUnsyncedEntryMedications(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced Entry_medications objects
        let fetchRequest: NSFetchRequest<Entry_medications> = Entry_medications.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isEntryMedicationSynced == nil"),
            NSPredicate(format: "isEntryMedicationSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedMedications = try context.fetch(fetchRequest)

            guard !unsyncedMedications.isEmpty else {
                print("No unsynced entry medications found.")
                completion(true)
                return
            }

            // Sync medications to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for entryMedication in unsyncedMedications {
                // Ensure all required attributes are available
                guard
                    let userMedicationId = try fetchOnlineUserMedicationId(context: context, userMedicationId: entryMedication.userMedicationId),
                    let medicationEntryId = try fetchOnlineMedicationId(context: context, medicationEntryId: entryMedication.medicationEntryId)
                else {
                    print("Skipping Entry_medications object with missing or invalid related attributes.")
                    continue
                }

                // Prepare optional attributes for sync
                let medicationName = entryMedication.medicationName
                let typeOfMedication = entryMedication.typeOfMedication
                let activeIngredientQuantity = entryMedication.activeIngredientQuantity
                let amountAdministered = entryMedication.amountAdministered
                let reasonForAdministration = entryMedication.reasonForAdministration
                let basisOfDecision = entryMedication.basisOfDecision
                let dateOfAdministration = entryMedication.dateOfAdministration != nil ? ISO8601DateFormatter().string(from: entryMedication.dateOfAdministration!) : nil
                let timeOfAdministration = entryMedication.timeOfAdministration != nil ? ISO8601DateFormatter().string(from: entryMedication.timeOfAdministration!) : nil

                dispatchGroup.enter()

                // Call the syncMedicationObject function
                EntryMedicationsNetworkManager.shared.syncEntryMedicationObject(
                    medicationEntryId: medicationEntryId,
                    userMedicationId: userMedicationId,
                    medicationName: medicationName,
                    typeOfMedication: typeOfMedication,
                    activeIngredientQuantity: activeIngredientQuantity,
                    amountAdministered: amountAdministered,
                    reasonForAdministration: reasonForAdministration,
                    basisOfDecision: basisOfDecision,
                    dateOfAdministration: dateOfAdministration,
                    timeOfAdministration: timeOfAdministration
                ) { result in
                    switch result {
                    case .success(let response):
                        if let responseId = response["id"] as? Int64 {
                            // Update the Entry_medications object in Core Data
                            entryMedication.entryMedicationOnlineId = responseId
                            entryMedication.isEntryMedicationSynced = true

                            do {
                                try context.save()
                                print("Successfully synced Entry_medications with ID: \(responseId)")
                            } catch {
                                print("Failed to update Entry_medications in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync Entry_medications: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced Entry_medications: \(error.localizedDescription)")
            completion(false)
        }
    }

    // Helper functions to fetch related IDs
    private func fetchOnlineUserMedicationId(context: NSManagedObjectContext, userMedicationId: Int64) throws -> Int64? {
        let fetchRequest: NSFetchRequest<User_medications> = User_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "medicationId == %d", userMedicationId)
        return try context.fetch(fetchRequest).first?.onlineUserMedicationsId
    }

    private func fetchOnlineMedicationId(context: NSManagedObjectContext, medicationEntryId: Int64) throws -> Int64? {
        let fetchRequest: NSFetchRequest<MedicationsLocal> = MedicationsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "medicationEntryId == %d", medicationEntryId)
        return try context.fetch(fetchRequest).first?.onlineMedicationsId
    }

}
