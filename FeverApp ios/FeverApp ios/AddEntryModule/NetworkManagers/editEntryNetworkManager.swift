//
//  editEntryNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 12/12/2024.
//

import Foundation
import UIKit
import CoreData
class editEntryNetworkManager{
    static let shared = editEntryNetworkManager()
    // Access the NSManagedObjectContext from the shared persistent container
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func editEntry(entryId: Int64, completion: @escaping (Bool, [String: Int64]) -> Void) {
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            guard let localEntry = results.first else {
                print("Entry with ID \(entryId) not found.")
                completion(false, [:])
                return
            }
            AddEntryModel.shared.saveEntryId(entryid: localEntry.entryId)
            // Fetch associated object IDs
            var associatedObjectIds = [String: Int64]()
            
            if let stateOfHealth = localEntry.stateOfHealth {
                associatedObjectIds["stateOfHealthId"] = stateOfHealth.stateOfHealthId
            }
            
            if let temperature = localEntry.temperature {
                associatedObjectIds["temperatureId"] = temperature.temperatureId
            }
            
            if let pains = localEntry.pains {
                associatedObjectIds["painId"] = pains.painId
            }
            
            if let liquids = localEntry.liquids {
                associatedObjectIds["liquidsId"] = liquids.liquidId // Assuming a similar ID for LiquidsLocal
            }
            
            if let diarrhea = localEntry.diarrhea {
                associatedObjectIds["diarrheaId"] = diarrhea.diarrheaId // Assuming a similar ID for DiarrheaLocal
            }
            
            if let rash = localEntry.rash {
                associatedObjectIds["rashId"] = rash.rashId // Assuming a similar ID for RashLocal
            }
            
            if let symptoms = localEntry.symptoms {
                associatedObjectIds["symptomsId"] = symptoms.symptomsId// Assuming a similar ID for SymptomsLocal
            }
            
            if let warningSigns = localEntry.warningSigns {
                associatedObjectIds["warningSignsId"] = warningSigns.warningSignsId // Assuming a similar ID for WarningSignsLocal
            }
            
            if let confidenceLevel = localEntry.confidenceLevel {
                associatedObjectIds["confidenceLevelId"] = confidenceLevel.confidenceLevelId // Assuming a similar ID for Confidence_levelLocal
            }
            
            if let measures = localEntry.measures {
                associatedObjectIds["measuresId"] = measures.measureId // Assuming a similar ID for MeasuresLocal
            }
            
            if let notes = localEntry.notes {
                associatedObjectIds["notesId"] = notes.noteId// Assuming a similar ID for NotesLocal
            }
            
            if let contactWithDoctor = localEntry.contactWithDoctor {
                associatedObjectIds["contactWithDoctorId"] = contactWithDoctor.contactWithDoctorId // Assuming a similar ID for Contact_with_doctorLocal
            }
            
            if let medications = localEntry.medications {
                associatedObjectIds["medicationsId"] = medications.medicationEntryId // Assuming a similar ID for MedicationsLocal
            }
        
            updateModelIds(associatedObjectIds)
            // Return associated IDs to the completion handler
            completion(true, associatedObjectIds)
            
        } catch {
            print("Error fetching entry: \(error)")
            completion(false, [:])
        }
    }
    func updateModelIds(_ objectsAndId: [String: Int64]) {
        if let stateOfHealthId = objectsAndId["stateOfHealthId"] {
            stateOfHealthModel.shared.saveStateOfHealthId(stateid: stateOfHealthId)
            stateOfHealthModel.shared.setEditingState(isEditing: true)
        }
        
        if let temperatureId = objectsAndId["temperatureId"] {
            temperatureModel.shared.saveTemperatureId(temperatureId: temperatureId)
            temperatureModel.shared.setEditingState(isEditing: true)
        }
        
        if let painId = objectsAndId["painId"] {
            painModel.shared.savePainId(painId: painId)
            painModel.shared.setEditingState(isEditing: true)
        }
        
        if let liquidId = objectsAndId["liquidsId"] {
            liquidModel.shared.saveLiquidId(liquidId: liquidId)
            liquidModel.shared.setEditingState(isEditing: true)
        }
        
        if let diarrheaId = objectsAndId["diarrheaId"] {
            diarrheaModel.shared.saveDiarheaId(diarrhea: diarrheaId)
            diarrheaModel.shared.setEditingState(isEditing: true)
        }
        
        if let rashId = objectsAndId["rashId"] {
            rashModel.shared.saveRashId(id: rashId)
            rashModel.shared.setEditingState(isEditing: true)
        }
        
        if let symptomsId = objectsAndId["symptomsId"] {
            symptomsModel.shared.saveSymptomsId(id: symptomsId)
            symptomsModel.shared.setEditingState(isEditing: true)
        }
        
        if let warningSignsId = objectsAndId["warningSignsId"] {
            warningSignsModel.shared.saveWarningSignsId(id: warningSignsId)
            warningSignsModel.shared.setEditingState(isEditing: true)
        }
        
        if let confidenceLevelId = objectsAndId["confidenceLevelId"] {
            feelingConfidentModel.shared.saveFeelingConfidentId(id: confidenceLevelId)
            feelingConfidentModel.shared.setEditingState(isEditing: true)
        }
        
        if let measuresId = objectsAndId["measuresId"] {
            measuresModel.shared.saveMeasureId(id: measuresId)
            measuresModel.shared.setEditingState(isEditing: true)
        }
        
        if let notesId = objectsAndId["notesId"] {
            noteModel.shared.saveNoteId(id: notesId)
            noteModel.shared.setEditingState(isEditing: true)
        }
        
        if let contactWithDoctorId = objectsAndId["contactWithDoctorId"] {
            contactWithDoctorModel.shared.saveContactId(id: contactWithDoctorId)
            contactWithDoctorModel.shared.setEditingState(isEditing: true)
        }
        
        if let medicationsId = objectsAndId["medicationsId"] {
            medicationModel.shared.saveMedicationEntryId(id: medicationsId)
            medicationModel.shared.setEditingState(isEditing: true)
        }
    }

}
