//
//  diahreaModel.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
class diarrheaModel{
    static let shared = diarrheaModel()
    var editedDiarrheaObject: DiarrheaLocal?
    var diarrheaId : Int64?
    var diarrheaResponse : String?
    var observationTime: Date?
    private var isEditingEntry: Bool = false
      var initialDiarrheaState: (response: String?, date: Date?)?
    /// Set editing state
       func setEditingState(isEditing: Bool) {
           self.isEditingEntry = isEditing
           if isEditing {
               // Fetch the local diarrhea object being edited so we can save its initial values
               self.editedDiarrheaObject = diarrheaNetworkManager.shared.fetchEditingDiarrheaLocal(byId: diarrheaId!)
               // Save initial values to compare later
               initialDiarrheaState = (response: editedDiarrheaObject?.diarrheaAndOrVomiting, date: editedDiarrheaObject?.observationTime)
           } else {
               // Reset initial state
               initialDiarrheaState = nil
           }
       }
       
    func saveDiarheaId(diarrhea: Int64){
        self.diarrheaId = diarrhea
    }
    func saveDiarrheaAndOrVomiting(diarrheaResponse: String, completion: @escaping (Bool) -> Void){
        self.diarrheaResponse = diarrheaResponse
        // Compare with initial value if editing
            if isEditingEntry, let initialState = initialDiarrheaState, initialState.response != diarrheaResponse {
                markDiarrheaUpdated()
            }
        diarrheaNetworkManager.shared.updateDiarrheaAndOrVomiting(withId: diarrheaId!, newValue: diarrheaResponse){ isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveDiarrheaDateTime(date : Date, completion: @escaping (Bool) -> Void){
        self.observationTime = date
        // Compare with initial value if editing
            if isEditingEntry, let initialState = initialDiarrheaState, initialState.date != date {
                markDiarrheaUpdated()
            }
        diarrheaNetworkManager.shared.updateObservationTime(for: diarrheaId!, to: date){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    /// Mark diarrhea and associated entry as updated
       private func markDiarrheaUpdated() {
           updateDiarrheaNetworkManager.shared.markDiarrheaUpdated(diarrheaId: self.diarrheaId!)
       }
}
