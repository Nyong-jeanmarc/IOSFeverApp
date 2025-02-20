//
//  feelingConfidentModel.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
class feelingConfidentModel{
    static let shared = feelingConfidentModel()
    var editedFeelingConfidentObject: Confidence_levelLocal?
    var feelingConfidentId : Int64?
    var confidenceLevel: String?
    var feelingDate : Date?
    private var isEditingEntry: Bool = false
    var initialFeelingConfident: (confidenceLevel: String?, date: Date?)?
    /// Set editing state
      func setEditingState(isEditing: Bool) {
          self.isEditingEntry = isEditing
          if isEditing {
              // Get the local feeling confident object being edited so we can save its initial values
              self.editedFeelingConfidentObject = feelingConfidentNetworkManager.shared.fetchEditingFeelingConfidentLocal(byId: feelingConfidentId!)
              // Save initial values to compare later
              initialFeelingConfident = (confidenceLevel: editedFeelingConfidentObject?.confidenceLevel, date: editedFeelingConfidentObject?.timeOfObservation)
          } else {
              // Reset initial state
              initialFeelingConfident = nil
          }
      }
    func saveFeelingConfidentId(id: Int64){
        self.feelingConfidentId = id
    }
    func saveConfidenceLevel(confidenceLevel: String, completion: @escaping (Bool) -> Void){
        self.confidenceLevel = confidenceLevel
        // Compare with initial value if editing
              if isEditingEntry, let initialState = initialFeelingConfident, initialState.confidenceLevel != confidenceLevel {
                  markFeelingConfidentUpdated()
              }
        feelingConfidentNetworkManager.shared.updateConfidenceLevel(for: feelingConfidentId!, to: confidenceLevel){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveFeelingDate(date: Date, completion: @escaping (Bool) -> Void){
        self.feelingDate = date
        // Compare with initial value if editing
               if isEditingEntry, let initialState = initialFeelingConfident, initialState.date != feelingDate {
                   markFeelingConfidentUpdated()
               }
        feelingConfidentNetworkManager.shared.updateFeelingDate(for: feelingConfidentId!, to: date){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    /// Mark feeling confident and associated entry as updated
     private func markFeelingConfidentUpdated() {
         updateFeelingConfidentNetworkManager.shared.markedFeelingConfidentUpdated(feelingConfidentId: self.feelingConfidentId!)
     }
}
