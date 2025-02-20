//
//  temperatureModel.swift
//  FeverApp ios
//
//  Created by NEW on 22/11/2024.
//

import Foundation
import UIKit

class temperatureModel{
    static let shared = temperatureModel()
    var editedTemperatureObject: TemperatureLocal?
    var temperatureId: Int64?
    var temperatureValue: Double?
    var temperatureComparedToForeHead : String?
    var wayOfDealingWithTemperature : String?
    var temperatureMeasurementLocation : String?
    var temperatureValueDate : Date?
    var isEditingEntry: Bool = false
    var initialTemperatureState: (value: Float?, comparison: String?, dealing: String?, location: String?, date: Date?)?
    // MARK: - Set Editing State
     func setEditingState(isEditing: Bool) {
         self.isEditingEntry = isEditing
         if isEditing {
             // Fetch the local temperature object being edited to save its initial values
             self.editedTemperatureObject = temperatureNetworkManager.shared.fetchEditingTemperatureLocal(byId: temperatureId!)
             // Save initial values to compare later
             initialTemperatureState = (
                 value: editedTemperatureObject?.temperatureValue,
                 comparison: editedTemperatureObject?.temperatureComparedToForehead,
                 dealing: editedTemperatureObject?.wayOfDealingWithTemperature,
                 location: editedTemperatureObject?.temperatureMeasurementLocation,
                 date: editedTemperatureObject?.temperatureDateTime
             )
         } else {
             // Reset initial state
             initialTemperatureState = nil
         }
     }
    func saveTemperatureId(temperatureId: Int64){
        self.temperatureId = temperatureId
    }
    func saveTemperatureComparedToForeHead(comparism: String,completion: @escaping (Bool) -> Void){
        self.temperatureComparedToForeHead = comparism
        // Compare with initial value if editing
               if isEditingEntry, let initialState = initialTemperatureState, initialState.comparison != comparism {
                   markTemperatureUpdated()
               }
        temperatureNetworkManager.shared.updateTemperatureComparedToForehead(temperatureId: temperatureId ?? 1, newComparisonValue: comparism){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveTemperatureValue(temperature: Double,completion: @escaping (Bool) -> Void){
        self.temperatureValue = temperature
        // Compare with initial value if editing
             if isEditingEntry, let initialState = initialTemperatureState, initialState.value != Float(temperature) {
                 markTemperatureUpdated()
             }
        temperatureNetworkManager.shared.updateTemperatureValue(for: temperatureId!, with: temperature){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveTemperatureValueDate(date : Date,completion: @escaping (Bool) -> Void){
        self.temperatureValueDate = date
        // Compare with initial value if editing
             if isEditingEntry, let initialState = initialTemperatureState, initialState.date != date {
                 markTemperatureUpdated()
             }
        temperatureNetworkManager.shared.saveTemperatureValueDate(temperatureId: temperatureId!, temperatureDate: date){ isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    func saveWayOfDealingWithTemperature(wayOfDealing: String,completion: @escaping (Bool) -> Void){
        self.wayOfDealingWithTemperature = wayOfDealing
        // Compare with initial value if editing
            if isEditingEntry, let initialState = initialTemperatureState, initialState.dealing != wayOfDealing {
                markTemperatureUpdated()
            }
        temperatureNetworkManager.shared.updateWayOfDealingWithFever(temperatureId: temperatureId!, newWayOfDealing: wayOfDealing){ isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func saveTemperatureMeasurementLocation(temperatureLocation: String,completion: @escaping (Bool) -> Void){
        self.temperatureMeasurementLocation = temperatureLocation
        // Compare with initial value if editing
             if isEditingEntry, let initialState = initialTemperatureState, initialState.location != temperatureLocation{
                 markTemperatureUpdated()
             }
        temperatureNetworkManager.shared.updateTemperatureLocation(temperatureId: temperatureId!, newLocation: temperatureLocation){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
        
    }
    // MARK: - Mark Updated
      private func markTemperatureUpdated() {
          UpdateTemperatureNetworkManager.shared.markedTemperatureUpdated(temperatureId: self.temperatureId!)
      }
    
    
}
