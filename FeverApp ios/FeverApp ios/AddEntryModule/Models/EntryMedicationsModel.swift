//
//  EntryMedicationsModel.swift
//  FeverApp ios
//
//  Created by NEW on 28/11/2024.
//

import Foundation
import UIKit
class EntryMedicationsModel{
    static let shared = EntryMedicationsModel()
    var editedEntryMedicationObject: Entry_medications?
    var medicationEntryId : Int64?
    var amountAdministered: Double?
     var basisOfDecision: String?
     var reasonForAdministration: String?
     var dateOfAdministration: Date?
     var timeOfAdministration: Date?
    // Tracking Initial Values
      private var isEditingEntry: Bool = false
      private var initialEntryMedication: (
          amountAdministered: Double?,
          basisOfDecision: String?,
          reasonForAdministration: String?,
          dateOfAdministration: Date?,
          timeOfAdministration: Date?
      )?
    /// Set editing state
      func setEditingState(isEditing: Bool) {
          self.isEditingEntry = isEditing
          if isEditing {
              // Fetch the local Entry_medications object being edited
              self.editedEntryMedicationObject = EntryMedicationsNetworkManager.shared.fetchEditingEntryMedicationLocal(byId: medicationEntryId!)
              
              // Save initial values for comparison
              initialEntryMedication = (
                  amountAdministered: editedEntryMedicationObject?.amountAdministered,
                  basisOfDecision: editedEntryMedicationObject?.basisOfDecision,
                  reasonForAdministration: editedEntryMedicationObject?.reasonForAdministration,
                  dateOfAdministration: editedEntryMedicationObject?.dateOfAdministration,
                  timeOfAdministration: editedEntryMedicationObject?.timeOfAdministration
              )
          } else {
              // Reset initial state
              initialEntryMedication = nil
          }
      }
    func saveMedicationEntryId(medId : Int64){
        self.medicationEntryId = medId
    }
    func checkAssociatedEntryMedication(userId: Int64) -> Bool {
        let entryMedication = EntryMedicationsNetworkManager.shared.checkAssociatedEntryMedication(for: userId)
        if entryMedication.exists {
            saveMedicationEntryId(medId: entryMedication.entryMedicationId!)
            return true
        } else {
           return false
        }
    }

    func createAndUpdateEntryMedication(
        with userMedicationId: Int64,
        medicationName: String,
        typeOfMedication: String,
        completion: @escaping (Bool) -> Void
    ) {
        EntryMedicationsNetworkManager.shared.createAndUpdateEntryMedication(with: userMedicationId, medicationName: medicationName, typeOfMedication: typeOfMedication){isCreated in
            if isCreated{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func updateEntryMedication(
        with id: Int64,
        amountAdministered: Double,
        basisOfDecision: String,
        reasonForAdministration: String,
        dateOfAdministration: Date,
        timeOfAdministration: Date,
        completion: @escaping (Bool) -> Void
    ) {
        if isEditingEntry {
            var isUpdatedNeeded = false

                   if let initial = initialEntryMedication {
                       if initial.amountAdministered != amountAdministered {
                           isUpdatedNeeded = true
                       }
                       if initial.basisOfDecision != basisOfDecision {
                           isUpdatedNeeded = true
                       }
                       if initial.reasonForAdministration != reasonForAdministration {
                           isUpdatedNeeded = true
                       }
                       if initial.dateOfAdministration != dateOfAdministration {
                           isUpdatedNeeded = true
                       }
                       if initial.timeOfAdministration != timeOfAdministration {
                           isUpdatedNeeded = true
                       }
                   }
            
            if isUpdatedNeeded {
                       EntryMedicationsNetworkManager.shared.updateEntryMedication(
                           with: id,
                           amountAdministered: amountAdministered,
                           basisOfDecision: basisOfDecision,
                           reasonForAdministration: reasonForAdministration,
                           dateOfAdministration: dateOfAdministration,
                           timeOfAdministration: timeOfAdministration
                       ) { isUpdated in
                           if isUpdated {
                               updateEntryMedicationNetworkManager.shared.markEntryMedicationUpdated(entryId: id)
                           }
                           completion(isUpdated)
                       }
                   } else {
                       completion(true) // No update needed
                   }
        }else{
            EntryMedicationsNetworkManager.shared.updateEntryMedication(
                with: id,
                amountAdministered: amountAdministered,
                basisOfDecision: basisOfDecision,
                reasonForAdministration: reasonForAdministration,
                dateOfAdministration: dateOfAdministration,
                timeOfAdministration: timeOfAdministration
            ) { isUpdated in
                completion(isUpdated)
            }
        }
       
    }
}
