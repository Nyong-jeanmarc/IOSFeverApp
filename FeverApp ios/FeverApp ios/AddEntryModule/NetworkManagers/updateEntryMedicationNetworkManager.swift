//
//  updateEntryMedicationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateEntryMedicationNetworkManager{
    static let shared = updateEntryMedicationNetworkManager()
    func markEntryMedicationUpdated(entryId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch the entry medication object by ID
        let fetchRequest: NSFetchRequest<Entry_medications> = Entry_medications.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", entryId)

        do {
            if let entryMedication = try context.fetch(fetchRequest).first {
                // Mark the entry medication as updated
                entryMedication.isEntryMedicationUpdated = true

                // Fetch the associated user medication object using userMedicationId
                if let userMedicationId = entryMedication.userMedicationId as Int64? {
                    let userMedFetchRequest: NSFetchRequest<User_medications> = User_medications.fetchRequest()
                    userMedFetchRequest.predicate = NSPredicate(format: "medicationId == %d", userMedicationId)

                    if let userMedication = try context.fetch(userMedFetchRequest).first {
                        // Mark the associated user medication as updated
                        userMedication.isupdated = true
                    }
                }

                // Save changes to the context
                try context.save()
                print("Entry medication and associated user medication marked as updated successfully.")
            } else {
                print("No entry medication found with ID \(entryId).")
            }
        } catch {
            print("Error marking entry medication updated: \(error.localizedDescription)")
        }
    }
}
