//
//  warningSignsModel.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
class warningSignsModel {
    static let shared = warningSignsModel()
    var editedWarningSignsObject: WarningSignsLocal?
    var warningSignsId: Int64?
    var warningSigns: [String]?
    var warningSignsDate: Date?
    private var isEditingEntry: Bool = false
    var initialWarningSigns: (signs: [String]?, date: Date?)?
    /// Set editing state
       func setEditingState(isEditing: Bool) {
           self.isEditingEntry = isEditing
           if isEditing {
               // Fetch the local warning signs object being edited
               self.editedWarningSignsObject = warningSignsNetworkManager.shared.fetchEditingWarningSignsLocal(byId: warningSignsId!)
               // Save initial values for comparison
               initialWarningSigns = (signs: editedWarningSignsObject?.warningSigns as? [String],
                                      date: editedWarningSignsObject?.warningSignsTime)
           } else {
               // Reset initial values
               initialWarningSigns = nil
           }
       }
    func saveWarningSignsId(id: Int64){
        self.warningSignsId = id
        
    }
    func saveWarningSigns(warningSigns: [String], completion: @escaping (Bool) -> Void){
        self.warningSigns = warningSigns
        // Compare with initial values if editing
            if isEditingEntry, let initialSigns = initialWarningSigns, initialSigns.signs != warningSigns {
                markWarningSignsUpdated()
            }
        warningSignsNetworkManager.shared.saveWarningSigns(with: warningSignsId!, warningSigns: warningSigns){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveWarningDate(date: Date, completion: @escaping (Bool) -> Void){
        self.warningSignsDate = date
        // Compare with initial values if editing
              if isEditingEntry, let initialSigns = initialWarningSigns, initialSigns.date != date {
                  markWarningSignsUpdated()
              }
        warningSignsNetworkManager.shared.saveWarningDate(with: warningSignsId!, warningDate: date){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    /// Mark warning signs and associated entry as updated
    private func markWarningSignsUpdated() {
        updateWarningSignsNetworkManager.shared.markedWarningSignsUpdated(warningSignsId: self.warningSignsId!)
    }
}
