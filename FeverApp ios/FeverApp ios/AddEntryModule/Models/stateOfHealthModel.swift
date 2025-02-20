//
//  stateOfHealthModel.swift
//  FeverApp ios
//
//  Created by NEW on 20/11/2024.
//

import Foundation
import UIKit
class stateOfHealthModel  {
    static let shared = stateOfHealthModel()
    var editedStateOfHealthObject: StateOfHealthLocal?
    var selectedStateOfHealth : String?
    var stateOfHealthId: Int64?
    var stateOfhealthDate: Date?
    private var isEditingEntry: Bool = false
       var initialStateOfHealth: (state: String?, date: Date?)?
    /// Set editing state
      func setEditingState(isEditing: Bool) {
          self.isEditingEntry = isEditing
          if isEditing {
              // get the local state of health object being edited so we can save its initial values
              self.editedStateOfHealthObject = stateOfHealthNetworkManager.shared.fetchEditingStateOfHealthLocal(byId: stateOfHealthId!)
              // Save initial values to compare later
              initialStateOfHealth = (state: editedStateOfHealthObject?.stateOfHealth, date: editedStateOfHealthObject?.stateOfHealthDateTime)
          } else {
              // Reset initial state
              initialStateOfHealth = nil
          }
      }
    
    func saveStateOfHealth(stateOfHealth: String,completion: @escaping (Bool) -> Void){
     let currentEntryId = AddEntryModel.shared.entryId
        self.selectedStateOfHealth = stateOfHealth
        // Compare with initial value if editing
              if isEditingEntry, let initialState = initialStateOfHealth, initialState.state != stateOfHealth {
                  markStateOfHealthUpdated()
              }
        stateOfHealthNetworkManager.shared.fetchAndUpdateStateOfHealth(for: stateOfHealthId!, newStateOfHealth: stateOfHealth){ isSavedSuccessfull in
            if isSavedSuccessfull{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveStateOfHealthDate(stateDate: Date,completion: @escaping (Bool) -> Void){
        self.stateOfhealthDate = stateDate
        // Compare with initial value if editing
             if isEditingEntry, let initialState = initialStateOfHealth, initialState.date != stateDate {
                 markStateOfHealthUpdated()
             }
        stateOfHealthNetworkManager.shared.saveStateOfHealthDate(stateOfHealthId: self.stateOfHealthId!, stateOfHealthDate: stateDate){ isSaved in
            if isSaved{
               completion(true)
            }else{
                completion(false)
           }
        }
    }
    func saveStateOfHealthId(stateid: Int64){
        self.stateOfHealthId = stateid
        print("state of health id is: \(stateid)")
    }
    /// Mark state of health and associated entry as updated
       private func markStateOfHealthUpdated() {
           updateStateOfHealthNetworkManager.shared.markedStateOfHealthUpdated(stateId: self.stateOfHealthId!)
       }
}
