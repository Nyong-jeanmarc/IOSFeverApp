//
//  liquidModel.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
class liquidModel{
    static let shared = liquidModel()
    var editedLiquidObject: LiquidsLocal?
    var liquidId : Int64?
    var dehydrationSigns : [String]?
    var liquidDateTime: Date?
    private var isEditingEntry: Bool = false
   var initialLiquidState: (dehydrationSigns: [String]?, date: Date?)?
    /// Set editing state
       func setEditingState(isEditing: Bool) {
           self.isEditingEntry = isEditing
           if isEditing {
               // Get the local liquid object being edited so we can save its initial values
               self.editedLiquidObject = liquidNetworkManager.shared.fetchEditingLiquidLocal(byId: liquidId!)
               // Save initial values to compare later
               initialLiquidState = (dehydrationSigns: editedLiquidObject?.dehydrationSigns as? [String], date: editedLiquidObject?.liquidTime)
           } else {
               // Reset initial state
               initialLiquidState = nil
           }
       }
    func saveLiquidId(liquidId: Int64){
        self.liquidId = liquidId
    }
    func saveDehydrationSigns(dehydrationSigns: [String], completion: @escaping (Bool) -> Void){
        self.dehydrationSigns = dehydrationSigns
        // Compare with initial value if editing
              if isEditingEntry, let initialState = initialLiquidState, initialState.dehydrationSigns != dehydrationSigns {
                  markLiquidUpdated()
              }
        liquidNetworkManager.shared.saveDehydrationSigns(with: liquidId!, dehydrationSigns: dehydrationSigns){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveLiquidDateTime(liquidDate: Date, completion: @escaping (Bool) -> Void){
        self.liquidDateTime = liquidDate
        // Compare with initial value if editing
              if isEditingEntry, let initialState = initialLiquidState, initialState.date != liquidDate {
                  markLiquidUpdated()
              }
        liquidNetworkManager.shared.updateLiquidDate(with: liquidId!, liquidDate: liquidDate){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    /// Mark liquid and associated entry as updated
        private func markLiquidUpdated() {
            updateLiquidNetworkManager.shared.markedLiquidUpdated(liquidId: self.liquidId!)
        }
}
