//
//  contactWithDoctorModel.swift
//  FeverApp ios
//
//  Created by NEW on 26/11/2024.
//

import Foundation
import UIKit
class contactWithDoctorModel{
    static let shared = contactWithDoctorModel()
    var contactId : Int64?
    var hasMedicalContact: String?
    var contactDate: Date?
    var reasonsForContactingDoctor: [String]?
    var otherReasonsForContact: String?
    var doctorDiagnosis: [String]?
    var otherDiagnosis: String?
    var doctorPrescriptions: [String]?
    var otherMedecinesPrescribed: String?
    var otherMeasuresTakenBydoctor: String?
    private var isEditingEntry: Bool = false
     var initialContactData: (
         hasMedicalContact: String?,
         contactDate: Date?,
         reasonsForContactingDoctor: [String]?,
         otherReasonsForContact: String?,
         doctorDiagnosis: [String]?,
         otherDiagnosis: String?,
         doctorPrescriptions: [String]?,
         otherMedecinesPrescribed: String?,
         otherMeasuresTakenBydoctor: String?
     )?
    func setEditingState(isEditing: Bool) {
            self.isEditingEntry = isEditing
            if isEditing, let contactId = self.contactId {
                // Get the local Contact_with_doctorLocal object being edited so we can save its initial values
                self.initialContactData = contactWithDoctorNetworkManager.shared.fetchEditingContactLocal(byId: contactId)
            } else {
                // Reset initial state when not editing
                initialContactData = nil
            }
        }
    func saveContactId(id: Int64){
        self.contactId = id
    }
    func saveHasMedicalContact(hasMedicalContact: String, completion: @escaping (Bool) -> Void){
        self.hasMedicalContact = hasMedicalContact
        if isEditingEntry, let initialData = initialContactData, initialData.hasMedicalContact != hasMedicalContact {
                 markContactUpdated()
             }
        contactWithDoctorNetworkManager.shared.updateHasMedicalContact(withId: contactId!, newMedicalContact: hasMedicalContact){isSaved  in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func saveContactDate(date: Date, completion: @escaping (Bool) -> Void){
        self.contactDate = date
        if isEditingEntry, let initialData = initialContactData, initialData.contactDate != contactDate {
                  markContactUpdated()
              }
        contactWithDoctorNetworkManager.shared.updateMedicalContactDate(withId: contactId!, medicalContactDate: date){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func saveReasonForContactingDoctor(reasons:[String], completion: @escaping (Bool) -> Void){
        self.reasonsForContactingDoctor = reasons
        if isEditingEntry, let initialData = initialContactData, initialData.reasonsForContactingDoctor != reasons {
                  markContactUpdated()
              }
        contactWithDoctorNetworkManager.shared.updateReasonForContact(withId: contactId!, newReasons: reasons){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveOtherReasonsForContactingDoctor(otherReason : String, completion: @escaping (Bool) -> Void){
        self.otherReasonsForContact = otherReason
        if isEditingEntry, let initialData = initialContactData, initialData.otherReasonsForContact != otherReason {
                   markContactUpdated()
               }
        contactWithDoctorNetworkManager.shared.updateOtherReasonForContact(withId: contactId!, otherReasons: otherReason){ isSaved in
            if isSaved{
                completion(true)
            }else{
               completion(false)
            }
        }
    }
    func saveDoctorDiagnosis(list: [String], completion: @escaping (Bool) -> Void){
        self.doctorDiagnosis = list
        if isEditingEntry, let initialData = initialContactData, initialData.doctorDiagnosis != list {
                  markContactUpdated()
              }
        contactWithDoctorNetworkManager.shared.updateDoctorDiagnosis(withId: contactId!, diagnosis: list){ isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveOtherDiagnosis(otherDiagnosis : String, completion: @escaping (Bool) -> Void){
        self.otherDiagnosis = otherDiagnosis
        if isEditingEntry, let initialData = initialContactData, initialData.otherDiagnosis != otherDiagnosis {
                  markContactUpdated()
              }
        contactWithDoctorNetworkManager.shared.updateOtherDoctorDiagnosis(withId: contactId!, otherDiagnosis: otherDiagnosis){ isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    func saveDoctorPrescriptions(doctorPrescriptions : [String], completion: @escaping (Bool) -> Void){
        self.doctorPrescriptions = doctorPrescriptions
        if isEditingEntry, let initialData = initialContactData, initialData.doctorPrescriptions != doctorPrescriptions {
                  markContactUpdated()
              }
        contactWithDoctorNetworkManager.shared.updateDoctorPrescriptions(withId: contactId!, prescriptions: doctorPrescriptions){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func saveOtherMedecinesPrescribed(otherMedecine: String, completion: @escaping (Bool) -> Void){
        self.otherMedecinesPrescribed = otherMedecine
        if isEditingEntry, let initialData = initialContactData, initialData.otherMedecinesPrescribed != otherMedecine {
                  markContactUpdated()
              }
        contactWithDoctorNetworkManager.shared.updateOtherMedecinesPrescribed(withId: contactId!, otherMedecine: otherMedecine){isSaved in
            if isSaved {
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    func saveOtherMeasuresTakenByDoctor(otherMeasures: String, completion: @escaping (Bool) -> Void){
        self.otherMeasuresTakenBydoctor = otherMeasures
        if isEditingEntry, let initialData = initialContactData, initialData.otherMeasuresTakenBydoctor != otherMeasures {
                  markContactUpdated()
              }
        contactWithDoctorNetworkManager.shared.updateOtherMeasuresTakenByDoctor(withId: contactId!, otherMeasures: otherMeasures){isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    private func markContactUpdated() {
          // Mark the contact as updated and also the associated local entry
          updateContactWithDoctorNetworkManager.shared.markedContactUpdated(contactId: self.contactId!)
      }
    
    
}
