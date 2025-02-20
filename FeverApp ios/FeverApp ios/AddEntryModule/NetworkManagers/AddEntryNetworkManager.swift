//
//  AddEntryNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 20/11/2024.
//

import CoreData
import UIKit

class AddEntryNetworkManager {
    // Access the NSManagedObjectContext from the shared persistent container
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Singleton instance
    static let shared = AddEntryNetworkManager()
     let appDelegate = UIApplication.shared.delegate as? AppDelegate
 
    func createOnlineEntry(entryDate: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let profileId = appDelegate?.fetchProfileOnlineId()
        // Define the server URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/create/\(profileId!)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON body
        let requestBody: [String: Any] = [
            "entryDate": entryDate
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error)) // Return the error in case of failure
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                // Parse JSON response
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse)) // Return the parsed response
                } else {
                    let error = NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error)) // Return parsing error
            }
        }.resume()
    }
    func createLocalEntry(completion: @escaping (Bool) -> Void) {
        let newEntry = LocalEntry(context: context)
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())
        newEntry.entryDate = Date()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let profileId = appDelegate.fetchProfileId()
//        let  profileId = profileIdDataModel.shared.profileId
        do {
            // Save the object first to ensure it gets a Z_PK value
            try context.save()
            
            // Extract the Z_PK from the objectID URIRepresentation
            let objectID = newEntry.objectID
            let uriString = objectID.uriRepresentation().absoluteString
            if let primaryKeyString = uriString.split(separator: "/").last,
               let primaryKey = Int(primaryKeyString.dropFirst()) { // Remove the leading "p"
               let EntryId = Int64(primaryKey)
                newEntry.entryId = EntryId
                newEntry.profileId = profileId!
                newEntry.belongsToAFeverPhase = false
                createStateOfHealthObject(entryId: EntryId)
                createTemperatureObject(entryId: EntryId)
                createPainObject(entryId: EntryId)
                createLiquidObject(entryId: EntryId)
                createDiahreaObject(entryId: EntryId)
                createRashObject(entryId: EntryId)
                createSymptomsObject(entryId: EntryId)
                createWarningSignsObject(entryId: EntryId)
                createFeelingConfidentObject(entryId: EntryId)
                createContactWithDoctorObject(entryId: EntryId)
                createMedicationObject(entryId: EntryId)
                createMeasuresObject(entryId: EntryId)
                createNoteObject(entryId: EntryId)
                
                // Save again with the updated entryId
                try context.save()
                
                // Optionally, save the entryId elsewhere or log it
                AddEntryModel.shared.saveEntryId(entryid: newEntry.entryId)
                print("Entry created with id (Z_PK): \(newEntry.entryId)")
                completion(true)
            } else {
                print("Failed to extract Z_PK from objectID URI.")
                completion(false)
            }
        } catch {
            print("Error creating or saving the new entry: \(error)")
            completion(false)
        }
    }
    func createStateOfHealthObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new stateOfHealth local object
            let newStateOfHealth = StateOfHealthLocal(context: context)
            newStateOfHealth.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newStateOfHealth.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newStateOfHealth.stateOfHealthId = coreDataId
              stateOfHealthModel.shared.saveStateOfHealthId(stateid: newStateOfHealth.stateOfHealthId )
                stateOfHealthModel.shared.setEditingState(isEditing: false)
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating temperatureId
            try context.save()
            
            print("stateOfHealth object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated stateId: \(newStateOfHealth.stateOfHealthId)")
        } catch {
            print("Error creating state of health local object: \(error.localizedDescription)")
        }
    }
    func createTemperatureObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new TemperatureLocal object
            let newTemperature = TemperatureLocal(context: context)
            newTemperature.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID = newTemperature.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newTemperature.temperatureId = coreDataId
                temperatureModel.shared.saveTemperatureId(temperatureId: coreDataId)
                temperatureModel.shared.setEditingState(isEditing: false)
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating temperatureId
            try context.save()
            
            print("TemperatureLocal object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated TemperatureId: \(newTemperature.temperatureId)")
        } catch {
            print("Error creating TemperatureLocal object: \(error.localizedDescription)")
        }
    }
    func createPainObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new pain local object
            let newPain = PainLocal(context: context)
            newPain.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID = newPain.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newPain.painId = coreDataId
                painModel.shared.savePainId(painId: newPain.painId)
                painModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating temperatureId
            try context.save()
            
            print("painLocal object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated painId: \(newPain.painId)")
        } catch {
            print("Error creating painLocal object: \(error.localizedDescription)")
        }
    }
    func createLiquidObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new pain local object
            let newLiquid = LiquidsLocal(context: context)
            newLiquid.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newLiquid.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newLiquid.liquidId = coreDataId
                liquidModel.shared.saveLiquidId(liquidId: newLiquid.liquidId)
                liquidModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating temperatureId
            try context.save()
            
            print("liquidLocal object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated liquidId: \(newLiquid.liquidId)")
        } catch {
            print("Error creating painLocal object: \(error.localizedDescription)")
        }
    }
    func createDiahreaObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new diarrhea local object
            let newDiahrea = DiarrheaLocal(context: context)
            newDiahrea.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newDiahrea.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newDiahrea.diarrheaId = coreDataId
                diarrheaModel.shared.saveDiarheaId(diarrhea: newDiahrea.diarrheaId)
                diarrheaModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating diarrheaId
            try context.save()
            
            print("diarrheaLocal object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated diarrheaId: \(newDiahrea.diarrheaId)")
        } catch {
            print("Error creating diarrheaLocal object: \(error.localizedDescription)")
        }
    }
    func createRashObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new rash local object
            let newRash = RashLocal(context: context)
            newRash.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newRash.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newRash.rashId = coreDataId
                rashModel.shared.saveRashId(id: newRash.rashId)
                rashModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating rashId
            try context.save()
            
            print("rash local object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated rashId: \(newRash.rashId)")
        } catch {
            print("Error creating rashLocal object: \(error.localizedDescription)")
        }
    }
    func createSymptomsObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new rash local object
            let newSymptoms = SymptomsLocal(context: context)
            newSymptoms.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newSymptoms.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newSymptoms.symptomsId = coreDataId
                symptomsModel.shared.saveSymptomsId(id: newSymptoms.symptomsId)
                symptomsModel.shared.setEditingState(isEditing: false)

                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating rashId
            try context.save()
            
            print("symptoms local object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated symptomId: \(newSymptoms.symptomsId)")
        } catch {
            print("Error creating rashLocal object: \(error.localizedDescription)")
        }
    }
    func createWarningSignsObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new rash local object
            let newWarningSigns = WarningSignsLocal(context: context)
            newWarningSigns.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newWarningSigns.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newWarningSigns.warningSignsId = coreDataId
                warningSignsModel.shared.saveWarningSignsId(id: newWarningSigns.warningSignsId)
                warningSignsModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating rashId
            try context.save()
            
            print("warning signs local object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated warning signs Id: \(newWarningSigns.warningSignsId)")
        } catch {
            print("Error creating warning signs Local object: \(error.localizedDescription)")
        }
    }
    func createFeelingConfidentObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new rash local object
            let newfeeling = Confidence_levelLocal(context: context)
            newfeeling.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newfeeling.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newfeeling.confidenceLevelId = coreDataId
                feelingConfidentModel.shared.saveFeelingConfidentId(id: newfeeling.confidenceLevelId)
                feelingConfidentModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating rashId
            try context.save()
            
            print("warning signs local object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated warning signs Id: \(newfeeling.confidenceLevelId)")
        } catch {
            print("Error creating warning signs Local object: \(error.localizedDescription)")
        }
    }
    func createContactWithDoctorObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new rash local object
            let newContact = Contact_with_doctorLocal(context: context)
            newContact.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newContact.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newContact.contactWithDoctorId = coreDataId
                contactWithDoctorModel.shared.saveContactId(id: newContact.contactWithDoctorId)
                contactWithDoctorModel.shared.setEditingState(isEditing: false)
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating rashId
            try context.save()
            
            print("contact with doctor local object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated contact Id: \(newContact.contactWithDoctorId)")
        } catch {
            print("Error creating warning signs Local object: \(error.localizedDescription)")
        }
    }
    func createMedicationObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new rash local object
            let   newMedication = MedicationsLocal(context: context)
            newMedication.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =    newMedication.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newMedication.medicationEntryId = coreDataId
                medicationModel.shared.saveMedicationEntryId(id:  newMedication.medicationEntryId)
                medicationModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating rashId
            try context.save()
            
            print("contact with doctor local object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated contact Id: \(newMedication.medicationEntryId)")
        } catch {
            print("Error creating warning signs Local object: \(error.localizedDescription)")
        }
    }
    func createMeasuresObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new rash local object
            let newMeasures = MeasuresLocal(context: context)
            newMeasures.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =   newMeasures.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newMeasures.measureId = coreDataId
                measuresModel.shared.saveMeasureId(id:  newMeasures.measureId)
                measuresModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating rashId
            try context.save()
            
            print("contact with doctor local object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated contact Id: \(newMeasures.measureId)")
        } catch {
            print("Error creating warning signs Local object: \(error.localizedDescription)")
        }
    }
    func createNoteObject(entryId: Int64) {
        do {
            // Step 1: Fetch the LocalEntry object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            fetchRequest.fetchLimit = 1
            
            guard let localEntry = try context.fetch(fetchRequest).first else {
                print("Error: No LocalEntry found with entryId \(entryId)")
                return
            }
            
            // Step 2: Create a new rash local object
            let newNote = NotesLocal(context: context)
            newNote.localEntry = localEntry // Link to LocalEntry
            
            // Step 3: Save to generate Core Data object ID
            try context.save()
            
            // Step 4: Extract Core Data-generated object ID
            if let objectID =  newNote.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                newNote.noteId = coreDataId
                noteModel.shared.saveNoteId(id: newNote.noteId)
                noteModel.shared.setEditingState(isEditing: false)
                
            } else {
                print("Error: Unable to extract Core Data object ID")
            }
            
            // Save again after updating rashId
            try context.save()
            
            print("contact with doctor local object created and linked to LocalEntry with entryId: \(entryId)")
            print("Generated contact Id: \(newNote.noteId)")
        } catch {
            print("Error creating warning signs Local object: \(error.localizedDescription)")
        }
    }
    func fetchEntriesWithFeverPhases(context: NSManagedObjectContext) -> [LocalEntry]? {
        // Get the profileId from the AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileId = appDelegate.fetchProfileId()
        
        // Create a fetch request for LocalEntry objects
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        
        // Set a predicate to filter by profileId and the given conditions
        fetchRequest.predicate = NSPredicate(format: "belongsToAFeverPhase == true AND (isdeleted == false OR isdeleted == nil) AND profileId == %d", profileId!)
        
        do {
            // Fetch the LocalEntry objects that match the conditions
            let entriesWithFeverPhases = try context.fetch(fetchRequest)
            return entriesWithFeverPhases
        } catch {
            // Handle any error that occurs during fetching
            print("Failed to fetch LocalEntry objects with fever phases for profileId \(profileId): \(error.localizedDescription)")
            return nil
        }
    }


    func fetchEntriesWithoutFeverPhases(context: NSManagedObjectContext) -> [LocalEntry]? {
        // Get the profileId from the AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileId = appDelegate.fetchProfileId()
        
        // Create a fetch request for LocalEntry objects
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        
        // Set a predicate to filter by profileId and the given conditions
        fetchRequest.predicate = NSPredicate(format: "belongsToAFeverPhase == false AND (isdeleted == false OR isdeleted == nil) AND profileId == %d", profileId!)
        
        do {
            // Fetch the LocalEntry objects that match the conditions
            let entriesWithoutFeverPhases = try context.fetch(fetchRequest)
            return entriesWithoutFeverPhases
        } catch {
            // Handle any error that occurs during fetching
            print("Failed to fetch LocalEntry objects without fever phases for profileId \(profileId): \(error.localizedDescription)")
            return nil
        }
    }


    func fetchAndUpdateLocalEntry(
        with entryId: Int64,
        overallDate: Date
    ) {
        do {
            // Fetch the `LocalEntry` object with the given entryId
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)
            
            if let localEntry = try context.fetch(fetchRequest).first {
                // Update the `entryDate` of the `LocalEntry` object
                localEntry.entryDate = overallDate

                // Fetch and update related objects
                updateDate(for: localEntry.stateOfHealth, dateKey: \.stateOfHealthDateTime, with: overallDate)
                updateDate(for: localEntry.temperature, dateKey: \.temperatureDateTime, with: overallDate)
                updateDate(for: localEntry.pains, dateKey: \.painDateTime, with: overallDate)
                updateDate(for: localEntry.liquids, dateKey: \.liquidTime, with: overallDate)
                updateDate(for: localEntry.diarrhea, dateKey: \.observationTime, with: overallDate)
                updateDate(for: localEntry.rash, dateKey: \.rashTime, with: overallDate)
                updateDate(for: localEntry.symptoms, dateKey: \.symptomsTime, with: overallDate)
                updateDate(for: localEntry.warningSigns, dateKey: \.warningSignsTime, with: overallDate)
                updateDate(for: localEntry.confidenceLevel, dateKey: \.timeOfObservation, with: overallDate)
                updateDate(for: localEntry.measures, dateKey: \.measureTime, with: overallDate)
                updateDate(for: localEntry.notes, dateKey: \.notesTime, with: overallDate)
                
                // Save the context to persist changes
                try context.save()
                print("Successfully updated LocalEntry and related objects with the new date.")
            } else {
                print("No LocalEntry found with the specified entryId: \(entryId)")
            }
        } catch {
            print("Error fetching or updating LocalEntry: \(error)")
        }
    }

    // Generic function to update date properties of related objects
    private func updateDate<T: NSManagedObject>(
        for object: T?,
        dateKey: ReferenceWritableKeyPath<T, Date?>,
        with date: Date
    ) {
        object?[keyPath: dateKey] = date
    }
    
    func markEntryAsDeleted(entryId: Int64, completion: @escaping (Bool) -> Void) {
        // Get the AppDelegate and managed object context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        // Create a fetch request for LocalEntry with the specified entryId
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "entryId == %d", entryId)

        do {
            // Fetch the results
            let results = try context.fetch(fetchRequest)
            
            // Ensure at least one result is found
            if let entry = results.first {
                // Set the isdeleted property to true
                entry.isdeleted = true

                // Save the context
                try context.save()
                print("Entry with ID \(entryId) marked as deleted.")
                completion(true)
            } else {
                print("No entry found with ID \(entryId).")
                completion(false)
            }
        } catch {
            print("Error fetching or updating entry: \(error.localizedDescription)")
            completion(false)
        }
    }
}
