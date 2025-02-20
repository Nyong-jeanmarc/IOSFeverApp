//
//  rashModel.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//

import Foundation
import UIKit
class rashModel {
    static let shared = rashModel()
    var editedRashObject: RashLocal?
    var rashId : Int64?
    var rashes: [String]?
    var rashTime: Date?
    private var isEditingEntry: Bool = false
      var initialRashState: (rashes: [String]?, date: Date?)?
    /// Set editing state
      func setEditingState(isEditing: Bool) {
          self.isEditingEntry = isEditing
          if isEditing {
              // Fetch the local Rash object being edited to save its initial values
              self.editedRashObject = rashNetworkManager.shared.fetchEditingRashLocal(byId: rashId!)
              // Save initial values to compare later
              initialRashState = (rashes: editedRashObject?.rashes as? [String], date: editedRashObject?.rashTime)
          } else {
              // Reset initial state
              initialRashState = nil
          }
      }
    func saveRashId(id : Int64){
        self.rashId = id
    }
    func saveRashes(rashes: [String],completion: @escaping (Bool) -> Void){
        self.rashes = rashes
        // Compare with initial value if editing
              if isEditingEntry, let initialRash = initialRashState, initialRash.rashes != rashes {
                  markRashUpdated()
              }
        rashNetworkManager.shared.saveRashes(with: rashId!, rashes: rashes){isSaved in
            if isSaved{
                completion(true)
            }else{
               completion(false)
            }
        }
    }
    func saveRashTime(rashTime: Date, completion: @escaping (Bool) -> Void){
        self.rashTime = rashTime
        // Compare with initial value if editing
                if isEditingEntry, let initialRash = initialRashState, initialRash.date != rashTime {
                    markRashUpdated()
                }
        rashNetworkManager.shared.updateObservationTime(for: rashId!, to: rashTime){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    /// Mark rash and associated entry as updated
      private func markRashUpdated() {
      updateRashNetworkManager.shared.markRashUpdated(rashId: self.rashId!)
      }
}
