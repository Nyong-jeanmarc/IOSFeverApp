//
//  contactWithDoctorWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class contactWithDoctorWorker{
    static let shared = contactWithDoctorWorker()
    func syncUnsyncedContactsWithDoctor(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced Contact_with_doctorLocal objects
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isContactWithDoctorSynced == nil"),
            NSPredicate(format: "isContactWithDoctorSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedContacts = try context.fetch(fetchRequest)

            guard !unsyncedContacts.isEmpty else {
                print("No unsynced contact with doctor objects found.")
                completion(true)
                return
            }

            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for contact in unsyncedContacts {
                // Ensure the associated local entry has a valid online entry ID
                guard
                    let localEntry = contact.localEntry,
                    localEntry.onlineEntryId != 0
                else {
                    print("Skipping contact with doctor object with missing or invalid attributes.")
                    continue
                }

                // Extract optional properties
                let onlineEntryId = localEntry.onlineEntryId
                let hasHadMedicalContact = contact.hasHadMedicalContact
                let dateOfContact = contact.dateOfContact != nil ? ISO8601DateFormatter().string(from: contact.dateOfContact!) : nil
                let reasonForContact = contact.reasonForContact as? [String]
                let otherReasonForContact = contact.otherReasonForContact
                let doctorsDiagnoses = contact.doctorDiagnoses as? [String]
                let otherDiagnosis = contact.otherDiagnosis
                let doctorsPrescriptionsIssued = contact.doctorsPrescriptionsIssued as? [String]
                let otherPrescriptionsIssued = contact.otherPrescriptionsIssued
                let doctorsRecommendationMeasures = contact.doctorsRecommendationMeasures

                dispatchGroup.enter()

                // Call the syncContactWithDoctorObject function
                contactWithDoctorNetworkManager.shared.syncContactWithDoctorObject(
                    onlineEntryId: onlineEntryId,
                    hasHadMedicalContact: hasHadMedicalContact,
                    dateOfContact: dateOfContact,
                    reasonForContact: reasonForContact,
                    otherReasonForContact: otherReasonForContact,
                    doctorsDiagnoses: doctorsDiagnoses,
                    otherDiagnosis: otherDiagnosis,
                    doctorsPrescriptionsIssued: doctorsPrescriptionsIssued,
                    otherPrescriptionsIssued: otherPrescriptionsIssued,
                    doctorsRecommendationMeasures: doctorsRecommendationMeasures
                ) { result in
                    switch result {
                    case .success(let response):
                        if let contactResponse = response["contactWithDoctor"] as? [String: Any],
                           let contactId = contactResponse["contactWithDoctorId"] as? Int64 {
                            // Update the contact with doctor object in Core Data
                            contact.onlineContactWithDoctorId = contactId
                            contact.isContactWithDoctorSynced = true

                            do {
                                try context.save()
                                print("Successfully synced contact with doctor ID: \(contactId)")
                            } catch {
                                print("Failed to update contact with doctor in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync contact with doctor: \(error.localizedDescription)")
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
            print("Failed to fetch unsynced contact with doctor objects: \(error.localizedDescription)")
            completion(false)
        }
    }

}
