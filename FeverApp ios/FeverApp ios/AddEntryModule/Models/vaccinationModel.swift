//
//  vaccinationModel.swift
//  FeverApp ios
//
//  Created by NEW on 23/11/2024.
//

import Foundation
import UIKit
class vaccinationModel{
    static let shared = vaccinationModel()
    var editedVaccinationObject: VaccinationLocal?
    var vaccineId : Int64?
    var vaccinatedOrNot : String?
    var vaccinationsRecieved : [String]?
    var vaccineDate : Date?
    private var isEditingEntry: Bool = false
    private var initialVaccinationState: (vaccinated: String?, vaccinations: [String]?, date: Date?)?
    func saveVaccinationId(Id: Int64){
        self.vaccineId = Id
        self.setEditingState(isEditing: temperatureModel.shared.isEditingEntry)
    }
    /// Set editing state
       func setEditingState(isEditing: Bool) {
           self.isEditingEntry = isEditing
           if isEditing {
               // Get the local vaccination object being edited to save its initial values
               self.editedVaccinationObject = vaccinationNetworkManager.shared.fetchEditingVaccinationLocal(byId: vaccineId!)
               // Save initial values to compare later
               initialVaccinationState = (
                   vaccinated: editedVaccinationObject?.vaccinatedLast2WeeksOrNot,
                   vaccinations: editedVaccinationObject?.vaccineReceived as? [String],
                   date: editedVaccinationObject?.vaccinationDateTime
               )
           } else {
               // Reset initial state
               initialVaccinationState = nil
           }
       }
    func saveVaccinatedOrNot(vaccinatedOrNot: String,completion: @escaping (Bool) -> Void){
        let tempId = temperatureModel.shared.temperatureId
        self.vaccinatedOrNot = vaccinatedOrNot
        // Compare with initial value if editing
              if isEditingEntry, let initialState = initialVaccinationState, initialState.vaccinated != vaccinatedOrNot {
                  markVaccinationUpdated()
              }
        vaccinationNetworkManager.shared.createVaccinationObject(temperatureId: tempId!, vaccinatedLast2WeeksOrNot: vaccinatedOrNot){isSaved in
            if isSaved {
                completion(true)
            }else{
               completion(false)
            }
        }
    }
    func saveVaccinationsRecieved(vaccinationsRecieved: [String],completion: @escaping (Bool) -> Void){
        self.vaccinationsRecieved = vaccinationsRecieved
        // Compare with initial value if editing
               if isEditingEntry, let initialState = initialVaccinationState, initialState.vaccinations != vaccinationsRecieved {
                   markVaccinationUpdated()
               }
        vaccinationNetworkManager.shared.updateVaccinationReceived(vaccinationId: vaccineId!, Vaccines: vaccinationsRecieved){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveVaccinationDate(vaccineDate : Date,completion: @escaping (Bool) -> Void){
        self.vaccineDate = vaccineDate
        // Compare with initial value if editing
              if isEditingEntry, let initialState = initialVaccinationState, initialState.date != vaccineDate {
                  markVaccinationUpdated()
              }
        vaccinationNetworkManager.shared.updateVaccinationDateTime(vaccinationId: vaccineId!, vaccineDate: vaccineDate){isSaved in
            if isSaved{
                completion(true)
            }else{
              completion(false)
            }
            
        }
    }
    /// Mark vaccination and associated entry as updated
      private func markVaccinationUpdated() {
          UpdateVaccinationNetworkManager.shared.markVaccinationUpdated(vaccinationId: self.vaccineId!)
      }
}
