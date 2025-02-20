//
//  measuresModel.swift
//  FeverApp ios
//
//  Created by NEW on 28/11/2024.
//

import Foundation
import UIKit
class measuresModel{
    static let shared = measuresModel()
    var editedMeasureObject: MeasuresLocal?
    var measureId : Int64?
    var takeMeasures : String?
    var measures : [String]?
    var otherMeasures : String?
    var measuresDate : Date?
    
    private var isEditingEntry: Bool = false
      var initialMeasuresState: (takeMeasures: String?, measures: [String]?, otherMeasures: String?, date: Date?)?
    /// Set editing state
      func setEditingState(isEditing: Bool) {
          self.isEditingEntry = isEditing
          if isEditing {
              // Fetch the local measure object being edited to save initial values
              self.editedMeasureObject = measuresNetworkManager.shared.fetchEditingMeasureLocal(byId: measureId!)
              initialMeasuresState = (
                  takeMeasures: editedMeasureObject?.takeMeasures,
                  measures: editedMeasureObject?.measures as? [String],
                  otherMeasures: editedMeasureObject?.otherMeasures,
                  date: editedMeasureObject?.measureTime
              )
          } else {
              // Reset initial state
              initialMeasuresState = nil
          }
      }
    
    func saveMeasureId(id : Int64){
        self.measureId = id
    }
    func saveTakeMeasures(take: String, completion: @escaping (Bool) -> Void){
        self.takeMeasures = take
        if isEditingEntry, let initialState = initialMeasuresState, initialState.takeMeasures != take {
                  markMeasuresUpdated()
              }
        measuresNetworkManager.shared.updateTakeMeasures(for: measureId!, with: take){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveMeasures(measures: [String], completion: @escaping (Bool) -> Void){
        self.measures = measures
        if isEditingEntry, let initialState = initialMeasuresState, initialState.measures != measures {
                markMeasuresUpdated()
            }
        measuresNetworkManager.shared.saveMeasures(with: measureId!, measures: measures){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveOtherMeasures(other : String, completion: @escaping (Bool) -> Void){
        self.otherMeasures = other
        if isEditingEntry, let initialState = initialMeasuresState, initialState.otherMeasures != other {
                 markMeasuresUpdated()
             }
        measuresNetworkManager.shared.updateOtherMeasures(for: measureId!, with: other){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveMeasuresDateTime(date: Date, completion: @escaping (Bool) -> Void){
        self.measuresDate = date
        if isEditingEntry, let initialState = initialMeasuresState, initialState.date != date {
                 markMeasuresUpdated()
             }
        measuresNetworkManager.shared.updateMeasuresDate(for: measureId!, with: date){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    /// Mark measures and associated entry as updated
    private func markMeasuresUpdated() {
        updateMeasuresNetworkManager.shared.markedMeasuresUpdated(measureId: self.measureId!)
    }
}
