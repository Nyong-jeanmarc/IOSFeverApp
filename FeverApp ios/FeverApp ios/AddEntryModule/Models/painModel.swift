//
//  painModel.swift
//  FeverApp ios
//
//  Created by NEW on 24/11/2024.
//

import Foundation
import UIKit
class painModel {
    var editedPainObject: PainLocal?
    var painId : Int64?
    var painValues : [String]?
    var otherPainLocation: String?
    var painSeverity: String?
    var painDateTime : Date?
    private var isEditingEntry: Bool = false
    var initialPainState: (values: [String]?, otherLocation: String?, severity: String?, date: Date?)?
    static let shared = painModel()
    func savePainId(painId : Int64){
        self.painId = painId
    }
    /// Set editing state
        func setEditingState(isEditing: Bool) {
            self.isEditingEntry = isEditing
            if isEditing {
                // Fetch the local Pain object for editing
                self.editedPainObject = painNetworkManager.shared.fetchEditingPainLocal(byId: painId!)
                
                // Save initial values for comparison
                initialPainState = (
                    values: editedPainObject?.painValue as? [String],
                    otherLocation: editedPainObject?.otherPlaces,
                    severity: editedPainObject?.painSeverityScale,
                    date: editedPainObject?.painDateTime
                )
            } else {
                // Reset initial state
                initialPainState = nil
            }
        }
    
    func savePainValues(painValues : [String], completion: @escaping (Bool) -> Void){
        let entryId = AddEntryModel.shared.entryId
        self.painValues = painValues
        
        // Compare with initial value if editing
        if isEditingEntry, let initialState = initialPainState, initialState.values != painValues {
            markPainUpdated()
        }
        print("pain values set to \(painValues)")
        painNetworkManager.shared.savePainValues(with: painId!, painValues: painValues){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func saveOtherPainLocation(otherPain: String, completion: @escaping (Bool) -> Void){
        self.otherPainLocation = otherPain
        // Compare with initial value if editing
              if isEditingEntry, let initialState = initialPainState, initialState.otherLocation != otherPain {
                  markPainUpdated()
              }
        painNetworkManager.shared.updatePainLocalOtherPlaces(with: painId!, otherPlacesValue: otherPain){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func savePainSeverity(painSeverity: String, completion: @escaping (Bool) -> Void){
        self.painSeverity = painSeverity
        // Compare with initial value if editing
             if isEditingEntry, let initialState = initialPainState, initialState.severity != painSeverity {
                 markPainUpdated()
             }
        painNetworkManager.shared.updatePainSeverityScale(with: painId!, painSeverity: painSeverity){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func savePainDateTime(painDate: Date, completion: @escaping (Bool) -> Void){
        self.painDateTime = painDate
        
        // Compare with initial value if editing
        if isEditingEntry, let initialState = initialPainState, initialState.date != painDate {
            markPainUpdated()
        }
        painNetworkManager.shared.updatePainDate(with: painId!, painDate: painDate){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    /// Mark pain and associated entry as updated
      private func markPainUpdated() {
          UpdatePainNetworkManager.shared.markPainUpdated(painId: self.painId!)
      }
}
