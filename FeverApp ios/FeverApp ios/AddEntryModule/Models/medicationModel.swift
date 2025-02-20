//
//  medicationModel.swift
//  FeverApp ios
//
//  Created by NEW on 26/11/2024.
//

import Foundation
import UIKit
class medicationModel{
    static let shared = medicationModel()
    var editedMedicationObject: MedicationsLocal?
    var medicationEntryId : Int64?
    var hasTakenMedication : String?
    private var isEditingEntry: Bool = false
     var initialMedicationState: (String?)?
    /// Set editing state
      func setEditingState(isEditing: Bool) {
          self.isEditingEntry = isEditing
          if isEditing {
              // Fetch the local medication object being edited and save its initial state
              self.editedMedicationObject = medicationLocalNetworkManager.shared.fetchEditingMedicationLocal(byId: medicationEntryId!)
              initialMedicationState = (editedMedicationObject?.hasTakenMedication)
          } else {
              // Reset initial state
              initialMedicationState = nil
          }
      }
    func saveMedicationEntryId(id : Int64){
        self.medicationEntryId = id
    }
    func saveHasTakenMedication(hasTaken: String,completion: @escaping (Bool) -> Void){
        self.hasTakenMedication = hasTaken
        // Compare with initial value if editing
             if isEditingEntry, let initialState = initialMedicationState, initialState != hasTaken {
                 markMedicationUpdated()
             }
        print("has medication saved ")
        medicationLocalNetworkManager.shared.updateHasTakenMedication(withId: medicationEntryId!, toValue: hasTaken){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    /// Mark medication and associated entry as updated
      private func markMedicationUpdated() {
          updateMedicationNetworkManager.shared.markedMedicationUpdated(medicationId: self.medicationEntryId!)
      }
}
