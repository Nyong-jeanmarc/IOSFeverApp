//
//  symptomsModel.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
class symptomsModel {
    static let shared = symptomsModel()
    var editedSymptomsObject: SymptomsLocal?
    var symptomsId : Int64?
    var symptoms : [String]?
    var otherSymptoms : [String]?
    var symptomsDate : Date?
    
    private var isEditingEntry: Bool = false
    
    var initialSymptomsState: (symptoms: [String]?, otherSymptoms: [String]?, date: Date?)?
    /// Set editing state
      func setEditingState(isEditing: Bool) {
          self.isEditingEntry = isEditing
          if isEditing {
              // Get the local symptoms object being edited to save its initial values
              self.editedSymptomsObject = symptomsNetworkManager.shared.fetchEditingSymptomsLocal(byId: symptomsId!)
              // Save initial values to compare later
              initialSymptomsState = (
                  symptoms: editedSymptomsObject?.symptoms as? [String],
                  otherSymptoms: editedSymptomsObject?.otherSymptoms as? [String],
                  date: editedSymptomsObject?.symptomsTime
              )
          } else {
              // Reset initial state
              initialSymptomsState = nil
          }
      }
    func saveSymptomsId(id: Int64){
        self.symptomsId = id
    }
    func saveSymptoms(symptoms: [String], completion: @escaping (Bool) -> Void){
        self.symptoms = symptoms
        // Compare with initial value if editing
               if isEditingEntry, let initialState = initialSymptomsState, initialState.symptoms != symptoms {
                   markSymptomsUpdated()
               }
        symptomsNetworkManager.shared.saveSymptoms(with: symptomsId!, symptoms: symptoms){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveOtherSymptoms(otherSymptoms: [String], completion: @escaping (Bool) -> Void){
        self.otherSymptoms = otherSymptoms
        // Compare with initial value if editing
               if isEditingEntry, let initialState = initialSymptomsState, initialState.otherSymptoms != otherSymptoms {
                   markSymptomsUpdated()
               }
        symptomsNetworkManager.shared.saveOtherSymptoms(with: symptomsId!, symptoms: otherSymptoms){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func saveSymtomsDate(date: Date, completion: @escaping (Bool) -> Void){
        self.symptomsDate = date
        // Compare with initial value if editing
              if isEditingEntry, let initialState = initialSymptomsState, initialState.date != date {
                  markSymptomsUpdated()
              }
        symptomsNetworkManager.shared.saveSymptomsDate(with: symptomsId!, symptomDate: date){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    /// Mark symptoms and associated entry as updated
      private func markSymptomsUpdated() {
          updateSymptomsNetworkManager.shared.markSymptomsUpdated(symptomsId: self.symptomsId!)
      }
}
