//
//  fetchUserDataModel.swift
//  FeverApp ios
//
//  Created by NEW on 14/01/2025.
//

import Foundation
import UIKit
import CoreData
class fetchUserDataNetworkManager{
  
    static let shared = fetchUserDataNetworkManager()
    // Function to fetch and save profiles
    func fetchAndSaveProfiles(userId: Int, completion: @escaping (Bool) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Define the server endpoint
        let urlString = "http://159.89.102.239:8080/api/profile/allUserProfiles/\(userId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(false) // Indicate failure
            return
        }

        // Create a URL session to fetch the data
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Error fetching profiles: \(error!.localizedDescription)")
                completion(false) // Indicate failure if profiles are missing
                return
            }
            
            guard let data = data else {
                print("No data returned")
                completion(false) // Indicate failure if profiles are missing
                return
            }
            
            do {
                // Decode the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let userProfiles = json["userProfiles"] as? [[String: Any]] {
                    
                    // Save each profile to Core Data
                    for profileDict in userProfiles {
                        let profile = Profile(context: context)
                        
                        // Map response fields to Core Data fields
                        profile.onlineProfileId = profileDict["profileId"] as? Int64 ?? 0
                        profile.userId = profileDict["userId"] as? Int64 ?? 0
                        profile.profileName = profileDict["profileName"] as? String
                        profile.profileDateOfBirth = {
                            if let dobString = profileDict["profileDateOfBirth"] as? String {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                return formatter.date(from: dobString)
                            }
                            return nil
                        }()
                        profile.profileGender = profileDict["profileGender"] as? String
                        profile.hasChronicDisease = profileDict["hasChronicDisease"] as? String
                        profile.chronicDiseases = profileDict["chronicDiseases"] as? [String]
                        profile.profileHeight = profileDict["profileHeight"] as? Float ?? 0.0
                        profile.hadFeverSeizure = profileDict["hadFeverSeizure"] as? String
                        profile.profileWeight = profileDict["profileWeight"] as? Double ?? 0.0
                        profile.feverPhases = profileDict["feverPhases"] as? Int16 ?? 0
                        profile.wayOfDealingWithFeverSeizures = profileDict["wayOfDealingWithFeverSeizures"] as? String
                        profile.doctorReferenceNumber = profileDict["doctorReferenceNumber"] as? String
                        profile.willingnessToBeRandomized = profileDict["willingnessToBeRandomized"] as? String
                        profile.profileColor = profileDict["profileColor"] as? String
                        profile.profilePediatricianId = profileDict["profilePediatricianId"] as? Int64 ?? 0
                        profile.feverFrequency = profileDict["feverFrequency"] as? String
                        profile.hasTakenAntipyretics = profileDict["hasTakenAntipyretics"] as? String
                        // Set isSynced to true
                        profile.isSynced = true
                        try context.save()
                        
                        // Fetch and sync fever cramps for the profile
//                        let profileId = profile.onlineProfileId
                        
                        // Extract the Z_PK from the objectID URIRepresentation
                        let objectID = profile.objectID
                        let uriString = objectID.uriRepresentation().absoluteString
                        if let primaryKeyString = uriString.split(separator: "/").last,
                           let primaryKey = Int(primaryKeyString.dropFirst()) { // Remove the leading "p"
                            let profileId = Int64(primaryKey)
                            profile.profileId = profileId
                            
                            self.fetchAndSyncFeverCramps(profileId: profileDict["profileId"] as? Int64 ?? 0, localProfileId: profileId) { success in
                                if success {
                                    print("Fever cramps fetched and synced successfully for profile \(profileDict["profileId"] ).")
                                } else {
                                    print("Failed to fetch and sync fever cramps for profile \(profileDict["profileId"] ).")
                                }
                            }
                            
                        }
                    }
                    
                    // Save the context
                    do {
                        try context.save()
                        completion(true) // Indicate success
                        print("Profiles saved successfully")
                    } catch {
                        print("Error saving profiles to Core Data: \(error.localizedDescription)")
                        completion(false) // Indicate failure
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(false) // Indicate failure
            }
        }
        
        // Start the task
        task.resume()
    }
   

    func fetchAndSaveUserPediatricians(for userId: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Define the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/user/pediatrician/\(userId)") else {
            print("Invalid URL")
            return
        }
        
        // Create the URL session
        let session = URLSession.shared
        
        // Create the task
        let task = session.dataTask(with: url) { data, response, error in
            // Handle errors
            if let error = error {
                print("Error fetching pediatricians: \(error.localizedDescription)")
                return
            }
            
            // Check response and data
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Fetch all local pediatricians
            let fetchRequest: NSFetchRequest<User_pediatricians> = User_pediatricians.fetchRequest()
            
            // Parse the JSON response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let pediatricians = json["pediatricians"] as? [[String: Any]] {
                    
                    let localPediatricians = try context.fetch(fetchRequest)
                    
                    // Filter out online pediatricians that already exist in local Pediatricians
                    let filteredPediatricians = pediatricians.filter { onlinePediatrician in
                        !localPediatricians.contains { localPediatrician in
                            onlinePediatrician["firstName"] as? String == localPediatrician.firstName &&
                            onlinePediatrician["lastName"] as? String == localPediatrician.lastName
                        }
                        
                    }

                    // If no pediatricians exist, complete with true
                    guard !filteredPediatricians.isEmpty else {
                        print("No new User pediatriciaN TO insert")
//                        completion(true)
                        return
                    }
                    
                    // Save pediatricians to Core Data
                    context.performAndWait {
                        for pediatrician in filteredPediatricians {
                            let entity = User_pediatricians(context: context)
                            entity.pediatricianId = pediatrician["pediatricianId"] as? Int64 ?? 0
                            entity.userId = pediatrician["userId"] as? Int64 ?? 0
                            entity.firstName = pediatrician["firstName"] as? String
                            entity.lastName = pediatrician["lastName"] as? String
                            entity.streetAndHouseNumber = pediatrician["streetAndHouseNumber"] as? String
                            entity.postalCode = pediatrician["postalCode"] as? Int64 ?? 0
                            entity.city = pediatrician["city"] as? String
                            entity.country = pediatrician["country"] as? String
                            entity.phoneNumber = pediatrician["phoneNumber"] as? String
                            entity.email = pediatrician["email"] as? String
                            entity.reference = pediatrician["reference"] as? String
                        }
                        
                        // Save the context
                        do {
                            try context.save()
                            print("Pediatricians saved successfully")
                        } catch {
                            print("Error saving pediatricians: \(error.localizedDescription)")
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        // Start the task
        task.resume()
    }
    
    
    func fetchUserPediatricians(for userId: Int64, completion: @escaping ([UserPediatrician]?) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Define the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/user/pediatrician/\(userId)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        // Create the URL session
        let session = URLSession.shared
        
        // Create the task
        let task = session.dataTask(with: url) { data, response, error in
            // Handle errors
            if let error = error {
                print("Error fetching pediatricians: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check response and data
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            // Parse the JSON response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let pediatricians = json["pediatricians"] as? [[String: Any]] {
                    
                    var userPediatricians: [UserPediatrician] = []
                    
                    for pediatrician in pediatricians {
                        let userPediatrician = UserPediatrician(
                            pediatricianId: Int(pediatrician["pediatricianId"] as? Int64 ?? 0),
                            userId: Int(pediatrician["userId"] as? Int64 ?? 0),
                            firstName: pediatrician["firstName"] as? String ?? "",
                            lastName: pediatrician["lastName"] as? String ?? "",
                            streetAndHouseNumber: pediatrician["streetAndHouseNumber"] as? String ?? "",
                            postalCode: Int(pediatrician["postalCode"] as? Int64 ?? 0),
                            city: pediatrician["city"] as? String ?? "",
                            country: pediatrician["country"] as? String ?? "",
                            phoneNumber: pediatrician["phoneNumber"] as? String ?? "",
                            email: pediatrician["email"] as? String ?? "",
                            reference: pediatrician["reference"] as? String
                        )
                        
                        userPediatricians.append(userPediatrician)
                    }
                    
                    completion(userPediatricians)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        // Start the task
        task.resume()
    }
    
    
    func fetchAndSaveUserMedications(userId: Int64) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Define the URL with the user ID
        guard let url = URL(string: "http://159.89.102.239:8080/api/user/medications/\(userId)") else {
            
            return
        }
        
        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors
            if let error = error {
              
                return
            }
            
            // Ensure data is not nil
            guard let data = data else {
               
                return
            }
            
            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let medications = json["medication"] as? [[String: Any]] {
                    
                    // Save medications to Core Data
                    context.perform {
                        for medication in medications {
                            let userMedication = User_medications(context: context)
                            userMedication.medicationId = medication["medicationId"] as? Int64 ?? 0
                            userMedication.medicationEntryId = medication["medicationEntryId"] as? Int64 ?? 0
                            userMedication.userId = medication["userId"] as? Int64 ?? 0
                            userMedication.medicationName = medication["medicationName"] as? String
                            userMedication.typeOfMedication = medication["typeOfMedication"] as? String
                            userMedication.activeIngredientQuantity = medication["activeIngredientQuantity"] as? Double ?? 0.0
                            userMedication.amountAdministered = medication["amountAdministered"] as? Double ?? 0.0
                            userMedication.reasonForAdministration = medication["reasonForAdministration"] as? String
                            userMedication.basisOfDecision = medication["basisOfDecision"] as? String
                            
                            if let dateStr = medication["dateOfAdministration"] as? String {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                userMedication.dateOfAdministration = dateFormatter.date(from: dateStr)
                            }
                            
                            if let timeStr = medication["timeOfAdministration"] as? String {
                                let timeFormatter = DateFormatter()
                                timeFormatter.dateFormat = "HH:mm:ss"
                                userMedication.timeOfAdministration = timeFormatter.date(from: timeStr)
                            }
                            
                            userMedication.isupdated = false
                            userMedication.isUserMedicationsSynced = false
                        }
                        
                        do {
                            // Save the context
                            try context.save()
                          
                        } catch {
                        print("error")
                        }
                    }
                } else {
                  print("Invalid response structure")
                }
            } catch {
               print("Invalid response structure")
            }
        }
        
        // Start the task
        task.resume()
    }
  
    func fetchFeverPhasesAndEntries() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.persistentContainer

        persistentContainer.performBackgroundTask { context in
            // Fetch local profiles
            let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
            do {
                let localProfiles = try context.fetch(fetchRequest)

                for profile in localProfiles {
                    guard let onlineProfileId = profile.onlineProfileId as? Int64 else { continue }
                    guard let profileId = profile.profileId as? Int64 else { continue }
                    let url = URL(string: "http://159.89.102.239:8080/api/profile/dashboard/listView/\(onlineProfileId)")!

                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"

                    URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data, error == nil else {
                            print("Error fetching data for profile ID \(onlineProfileId): \(error?.localizedDescription ?? "Unknown error")")
                            return
                        }

                        context.perform {
                            do {
                                // Parse response
                                let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                guard let results = responseJSON?["results"] as? [[String: Any]] else { return }

                                for result in results {
                                    // Save fever phases
                                    if let feverPhases = result["feverPhases"] as? [[String: Any]] {
                                        for feverPhase in feverPhases {
                                            let feverPhaseEntity = FeverPhaseLocal(context: context)
                                            feverPhaseEntity.onlineFeverPhaseId = feverPhase["feverPhaseId"] as? Int64 ?? 0
                                            feverPhaseEntity.profileId = profileId
                                            feverPhaseEntity.feverPhaseStartDate = self.parseDate(feverPhase["feverPhaseStartDate"] as? String)
                                            feverPhaseEntity.isFeverPhaseSynced = true

                                            feverPhaseEntity.feverPhaseEndDate = self.parseDate(feverPhase["feverPhaseEndDate"] as? String)
                                            feverPhaseEntity.groupDate = result["groupDate"] as? String

                                            try context.save()

                                            // Map Core Data ID to feverPhaseId
                                            if let objectID = feverPhaseEntity.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
                                               let coreDataId = Int64(objectID.dropFirst()) {
                                                feverPhaseEntity.feverPhaseId = coreDataId
                                            } else {
                                                print("Error: Unable to extract Core Data object ID for FeverPhase")
                                            }

                                            if let feverPhaseEntries = feverPhase["feverPhaseEntries"] as? [[String: Any]] {
                                                for entry in feverPhaseEntries {
                                                    let entryEntity = LocalEntry(context: context)
                                                    entryEntity.onlineEntryId = entry["entryId"] as? Int64 ?? 0
                                                    entryEntity.profileId = profileId
                                                    entryEntity.entryDate = self.parseDate(entry["entryDate"] as? String)
                                                    entryEntity.belongsToAFeverPhase = entry["belongsToAFeverPhase"] as? Bool ?? false
                                                    entryEntity.feverPhaseId = feverPhaseEntity.feverPhaseId
                                                    entryEntity.feverPhase = feverPhaseEntity

                                                    try context.save()

                                                    // Map Core Data ID to entryId
                                                    if let objectID = entryEntity.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
                                                       let coreDataId = Int64(objectID.dropFirst()) {
                                                        entryEntity.entryId = coreDataId
                                                    } else {
                                                        print("Error: Unable to extract Core Data object ID for LocalEntry")
                                                    }

                                                    // Map additional relationships
                                                    entryEntity.stateOfHealth = self.parseStateOfHealth(entry["stateOfHealth"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.temperature = self.parseTemperature(entry["temperature"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.pains = self.parsePain(entry["pains"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.liquids = self.parseLiquids(entry["liquids"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.diarrhea = self.parseDiarrhea(entry["diarrhea"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.symptoms = self.parseSymptoms(entry["symptoms"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.rash = self.parseRash(entry["rash"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.warningSigns = self.parseWarningSigns(entry["warningSigns"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.measures = self.parseMeasures(entry["measures"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.contactWithDoctor = self.parseContactWithDoctor(entry["contactWithDoctor"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.notes = self.parseNotes(entry["notes"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.confidenceLevel = self.parseConfidenceLevel(entry["confidenceLevel"] as? [String: Any] ?? [:], context: context)
                                                    entryEntity.medications = self.parseMedications(entry["medications"] as? [String: Any] ?? [:], context: context)

                                                    feverPhaseEntity.addToLocalEntry(entryEntity)
                                                }
                                            }
                                        }
                                    }

                                    // Save entries not belonging to fever phases
                                    if let entries = result["entriesNotBelongingToAFeverPhase"] as? [[String: Any]] {
                                        for entry in entries {
                                            let entryEntity = LocalEntry(context: context)
                                            entryEntity.onlineEntryId = entry["entryId"] as? Int64 ?? 0
                                            entryEntity.profileId = profileId
                                            entryEntity.entryDate = self.parseDate(entry["entryDate"] as? String)
                               
                                            entryEntity.belongsToAFeverPhase = false

                                            try context.save()

                                            // Map Core Data ID to entryId
                                            if let objectID = entryEntity.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
                                               let coreDataId = Int64(objectID.dropFirst()) {
                                                entryEntity.entryId = coreDataId
                                            } else {
                                                print("Error: Unable to extract Core Data object ID for LocalEntry")
                                            }

                                            entryEntity.stateOfHealth = self.parseStateOfHealth(entry["stateOfHealth"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.temperature = self.parseTemperature(entry["temperature"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.pains = self.parsePain(entry["pains"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.liquids = self.parseLiquids(entry["liquids"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.diarrhea = self.parseDiarrhea(entry["diarrhea"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.symptoms = self.parseSymptoms(entry["symptoms"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.rash = self.parseRash(entry["rash"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.warningSigns = self.parseWarningSigns(entry["warningSigns"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.measures = self.parseMeasures(entry["measures"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.contactWithDoctor = self.parseContactWithDoctor(entry["contactWithDoctor"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.notes = self.parseNotes(entry["notes"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.confidenceLevel = self.parseConfidenceLevel(entry["confidenceLevel"] as? [String: Any] ?? [:], context: context)
                                            entryEntity.medications = self.parseMedications(entry["medications"] as? [String: Any] ?? [:], context: context)
                                        }
                                    }
                                }

                                try context.save()
                            } catch {
                                print("Error parsing or saving data for profile ID \(profileId): \(error.localizedDescription)")
                            }
                        }
                    }.resume()
                }
            } catch {
                print("Error fetching local profiles: \(error.localizedDescription)")
            }
        }
    }
    //fever cramps documentation
    func fetchAndSyncFeverCramps(profileId: Int64, localProfileId: Int64, completion: @escaping (Bool) -> Void) {
        FeverCrampsNetworkManager.shared.getFeverCramps(profileId: profileId, localProfileId: localProfileId) { response, error in
            if let error = error {
                print("Error fetching fever cramps: \(error)")
                completion(false)
            } else if let response = response {
                print("Fever cramps fetched and synced successfully: \(response)")
                completion(true)
            } else {
                print("Unknown error fetching fever cramps")
                completion(false)
            }
        }
    }


    // MARK: - Parsing Helpers

    func parseStateOfHealth(_ response: [String: Any], context : NSManagedObjectContext ) -> StateOfHealthLocal {
       
        let stateOfHealth = StateOfHealthLocal(context: context)
        stateOfHealth.onlineStateOfHealthId = response["stateOfHealthId"] as? Int64 ?? 0
        stateOfHealth.stateOfHealth = response["stateOfHealth"] as? String
        stateOfHealth.stateOfHealthDateTime = parseDate(response["stateOfHealthDateTime"] as? String)
        stateOfHealth.isStateOfHealthSynced = false
        stateOfHealth.isStateOfHealthUpdated = false
        saveContextAndSetCoreDataId(entity: stateOfHealth, context: context) { id in
            stateOfHealth.stateOfHealthId = id
         }
        
        return stateOfHealth
    }

    func parseTemperature(_ response: [String: Any], context : NSManagedObjectContext) -> TemperatureLocal {
     
        let temperature = TemperatureLocal(context: context)
        temperature.onlineTemperatureId = response["temperatureId"] as? Int64 ?? 0
        temperature.temperatureValue = response["temperatureValue"] as? Float ?? 0.0
        temperature.temperatureMeasurementUnit = response["temperatureMeasurementUnit"] as? String
        temperature.temperatureMeasurementLocation = response["temperatureMeasurementLocation"] as? String
        temperature.wayOfDealingWithTemperature = response["wayOfDealingWithTemperature"] as? String
        temperature.temperatureComparedToForehead = response["temperatureComparedToForehead"] as? String
        temperature.temperatureDateTime = parseDate(response["temperatureDateTime"] as? String)
        temperature.isTemperatureSynced = false
        temperature.isTemperatureUpdated = false
        saveContextAndSetCoreDataId(entity: temperature, context: context) { id in
            temperature.temperatureId = id
         }
     
        if let vaccinationData = response["vaccination"] as? [String: Any] {
            temperature.vaccination = parseVaccination(vaccinationData, context: context)
        } else {
            temperature.vaccination = nil
            print("Warning: 'vaccination' data is missing or invalid")
        }

        return temperature
    }

    func parseVaccination(_ response: [String: Any], context : NSManagedObjectContext) -> VaccinationLocal {
      
        let vaccination = VaccinationLocal(context: context)
        vaccination.onlineVaccinationId = response["vaccinationId"] as? Int64 ?? 0
        vaccination.vaccinatedLast2WeeksOrNot = response["vaccinatedLast2WeeksOrNot"] as? String
        vaccination.vaccinationDateTime = parseDate(response["vaccinationDateTime"] as? String)
        vaccination.isVaccinationSynced = false
        vaccination.isVaccinationUpdated = false
        saveContextAndSetCoreDataId(entity: vaccination, context: context) { id in
            vaccination.vaccinationId = id
         }
        return vaccination
    }

    func parsePain(_ response: [String: Any], context : NSManagedObjectContext) -> PainLocal {
      
        let pain = PainLocal(context: context)
        pain.onlinePainId = response["painId"] as? Int64 ?? 0
        pain.painValue = response["painValue"] as? NSObject
        pain.painSeverityScale = response["severityScale"] as? String
        pain.otherPlaces = response["otherPlaces"] as? String
        pain.painDateTime = parseDate(response["painDateTime"] as? String)
        pain.isPainSynced = false
        pain.isPainUpdated = false
        saveContextAndSetCoreDataId(entity: pain, context: context) { id in
            pain.painId = id
         }
        return pain
    }

    func parseLiquids(_ response: [String: Any], context : NSManagedObjectContext) -> LiquidsLocal {
      
        let liquids = LiquidsLocal(context: context)
        liquids.onlineLiquidId = response["liquidId"] as? Int64 ?? 0
        liquids.dehydrationSigns = response["dehydrationSigns"] as? NSObject
        liquids.liquidTime = parseDate(response["liquidTime"] as? String)
        liquids.isLiquidSynced = false
        liquids.isLiquidUpdated = false
        saveContextAndSetCoreDataId(entity: liquids, context: context) { id in
            liquids.liquidId = id
         }
        return liquids
    }

    func parseDiarrhea(_ response: [String: Any], context : NSManagedObjectContext) -> DiarrheaLocal {
      
        let diarrhea = DiarrheaLocal(context: context)
        diarrhea.onlineDiarrheaId = response["diarrheaId"] as? Int64 ?? 0
        diarrhea.diarrheaAndOrVomiting = response["diarrheaAndOrVomiting"] as? String
        diarrhea.observationTime = parseDate(response["observationTime"] as? String)
        diarrhea.isDiarrheaSynced = false
        diarrhea.isDiarrheaUpdated = false
        saveContextAndSetCoreDataId(entity: diarrhea, context: context) { id in
             diarrhea.diarrheaId = id
         }
        return diarrhea
    }

    func parseRash(_ response: [String: Any], context : NSManagedObjectContext) -> RashLocal {
      
        let rash = RashLocal(context: context)
        rash.onlineRashId = response["rashId"] as? Int64 ?? 0
        rash.rashes = response["rashes"] as? NSObject
        rash.rashTime = parseDate(response["rashTime"] as? String)
        rash.isRashSynced = false
        rash.isRashUpdated = false
        saveContextAndSetCoreDataId(entity: rash, context: context) { id in
            rash.rashId = id
         }
        return rash
    }

    func parseSymptoms(_ response: [String: Any], context : NSManagedObjectContext) -> SymptomsLocal {
       
        let symptoms = SymptomsLocal(context: context)
        symptoms.onlineSymptomsId = response["symptomsId"] as? Int64 ?? 0
        symptoms.symptoms = response["symptoms"] as? NSObject
        symptoms.otherSymptoms = response["otherSymptoms"] as? NSObject
        symptoms.symptomsTime = parseDate(response["symptomsTime"] as? String)
        symptoms.isSymptomsSynced = false
        symptoms.isSymptomsUpdated = false
        saveContextAndSetCoreDataId(entity: symptoms, context: context) { id in
            symptoms.symptomsId = id
         }
        return symptoms
    }

    func parseWarningSigns(_ response: [String: Any], context : NSManagedObjectContext) -> WarningSignsLocal {
       
        let warningSigns = WarningSignsLocal(context: context)
        warningSigns.onlineWarningSignsId = response["warningSignsId"] as? Int64 ?? 0
        warningSigns.warningSigns = response["warningSigns"] as? NSObject
        warningSigns.warningSignsTime = parseDate(response["warningSignsTime"] as? String)
        warningSigns.isWarningSignsSynced = false
        warningSigns.isWarningSignsUpdated = false
        saveContextAndSetCoreDataId(entity: warningSigns, context: context) { id in
            warningSigns.warningSignsId = id
         }
        return warningSigns
    }

    func parseConfidenceLevel(_ response: [String: Any], context : NSManagedObjectContext) -> Confidence_levelLocal {
   
        let confidenceLevel = Confidence_levelLocal(context: context)
        confidenceLevel.onlineConfidenceLevelId = response["confidenceLevelId"] as? Int64 ?? 0
        confidenceLevel.confidenceLevel = response["confidenceLevel"] as? String
        confidenceLevel.timeOfObservation = parseDate(response["timeOfObservation"] as? String)
        confidenceLevel.isConfidenceLevelSynced = false
        confidenceLevel.isConfidenceLevelUpdated = false
        saveContextAndSetCoreDataId(entity: confidenceLevel, context: context) { id in
            confidenceLevel.confidenceLevelId = id
         }
        return confidenceLevel
    }

    func parseContactWithDoctor(_ response: [String: Any], context : NSManagedObjectContext) -> Contact_with_doctorLocal {
   
        let contactWithDoctor = Contact_with_doctorLocal(context: context)
        contactWithDoctor.onlineContactWithDoctorId = response["contactWithDoctorId"] as? Int64 ?? 0
        contactWithDoctor.hasHadMedicalContact = response["hasHadMedicalContact"] as? String
        contactWithDoctor.dateOfContact = parseDate(response["dateOfContact"] as? String)
        contactWithDoctor.reasonForContact = response["reasonForContact"] as? NSObject
        contactWithDoctor.otherReasonForContact = response["otherReasonForContact"] as? String
        contactWithDoctor.doctorDiagnoses = response["doctorDiagnoses"] as? NSObject
        contactWithDoctor.otherDiagnosis = response["otherDiagnosis"] as? String
        contactWithDoctor.doctorsPrescriptionsIssued = response["doctorsPrescriptionsIssued"] as? NSObject
        contactWithDoctor.otherPrescriptionsIssued = response["otherPrescriptionsIssued"] as? String
        contactWithDoctor.doctorsRecommendationMeasures = response["doctorsRecommendationMeasures"] as? String
        contactWithDoctor.isContactWithDoctorSynced = false
        contactWithDoctor.isContactWithDoctorUpdated = false
        saveContextAndSetCoreDataId(entity: contactWithDoctor, context: context) { id in
            contactWithDoctor.contactWithDoctorId = id
         }
        return contactWithDoctor
    }

    func parseMedications(_ response: [String: Any], context : NSManagedObjectContext) -> MedicationsLocal {

        let medications = MedicationsLocal(context: context)
        medications.onlineMedicationsId = response["medicationEntryId"] as? Int64 ?? 0
        medications.hasTakenMedication = response["hasTakenMedication"] as? String
        medications.medicationList = response["entryMedications"] as? NSObject
        medications.isMedicationsSynced = false
        medications.isMedicationsUpdated = false
        saveContextAndSetCoreDataId(entity: medications, context: context) { id in
            medications.medicationEntryId = id
         }
        return medications
    }

    func parseMeasures(_ response: [String: Any], context : NSManagedObjectContext) -> MeasuresLocal {
     
        let measures = MeasuresLocal(context: context)
        measures.onlineMeasuresId = response["measureId"] as? Int64 ?? 0
        measures.measures = response["measures"] as? NSObject
        measures.measureTime = parseDate(response["measureTime"] as? String)
        measures.otherMeasures = response["otherMeasures"] as? String
        measures.takeMeasures = response["takeMeasures"] as? String
        measures.isMeasuresSynced = false
        measures.isMeasuresUpdated = false
        saveContextAndSetCoreDataId(entity: measures, context: context) { id in
            measures.measureId = id
         }
        return measures
    }

    func parseNotes(_ response: [String: Any], context : NSManagedObjectContext) -> NotesLocal {
    
        let notes = NotesLocal(context: context)
        notes.onlineNotesId = response["noteId"] as? Int64 ?? 0
        notes.notesContent = response["notesContent"] as? String
        notes.notesOtherObservations = response["notesOtherObservations"] as? String
        notes.notesTime = parseDate(response["notesTime"] as? String)
        notes.isNotesSynced = false
        notes.isNotesUpdated = false
        saveContextAndSetCoreDataId(entity: notes, context: context) { id in
            notes.noteId = id
         }
        return notes
    }

    // MARK: - Helper Function for Saving and Setting Core Data ID

    private func saveContextAndSetCoreDataId<T: NSManagedObject>(entity: T, context: NSManagedObjectContext, completion: (Int64) -> Void) {
        do {
            try context.save()
            if let objectID = entity.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
               let coreDataId = Int64(objectID.dropFirst()) {
                completion(coreDataId)
            } else {
                print("Error: Unable to extract Core Data object ID for \(T.self)")
            }
        } catch {
            print("Error saving context: \(error)")
        }
    }
    // MARK: - Helper for Date Parsing
    func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: dateString)
    }



}
