//
//   updateContactWithDoctorNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 13/12/2024.
//

import Foundation
import UIKit
import CoreData
class  updateContactWithDoctorNetworkManager{
    static let shared =  updateContactWithDoctorNetworkManager()
    func markedContactUpdated(contactId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %d", contactId)

        do {
            // Fetch the Contact_with_doctorLocal object
            let results = try context.fetch(fetchRequest)
            if let contactLocal = results.first {
                // Update the 'isContactWithDoctorUpdated' flag to true
                contactLocal.isContactWithDoctorUpdated = true
                
                // Save the changes to Core Data
                try context.save()
                
                // Mark the associated local entry as updated (if it exists)
                if let localEntry = contactLocal.localEntry {
                    localEntry.isEntryUpdated = true
                    try context.save()
                }
            }
        } catch {
            print("Error marking contact with doctor as updated for ID \(contactId): \(error.localizedDescription)")
        }
    }

}
