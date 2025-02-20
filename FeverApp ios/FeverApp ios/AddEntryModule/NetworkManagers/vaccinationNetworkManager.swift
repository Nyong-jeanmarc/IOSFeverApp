//
//  vaccinationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 23/11/2024.
//

import Foundation
import UIKit
import CoreData
class vaccinationNetworkManager{
    static let shared = vaccinationNetworkManager()
    func fetchEditingVaccinationLocal(byId vaccinationId: Int64) -> VaccinationLocal? {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<VaccinationLocal> = VaccinationLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vaccinationId == %d", vaccinationId)

        do {
            // Execute fetch request
            let results = try context.fetch(fetchRequest)
            // Return the first result if found
            return results.first
        } catch {
            print("Error fetching VaccinationLocal with ID \(vaccinationId): \(error.localizedDescription)")
            return nil
        }
    }

    func createVaccinationObject(temperatureId: Int64,
                                 vaccinatedLast2WeeksOrNot: String,
                                 completion: @escaping (Bool) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
          
            // 1. Fetch the TemperatureLocal object using the given temperatureId
            let fetchRequest: NSFetchRequest<TemperatureLocal> = TemperatureLocal.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "temperatureId == %d", temperatureId)
            
            if let temperatureObject = try context.fetch(fetchRequest).first {
                // 2. Create a new VaccinationLocal object
                let vaccination = VaccinationLocal(context: context)
                
                // 3. Set the relationship with TemperatureLocal
                vaccination.temperature = temperatureObject
                try context.save()
                // Extract the Z_PK from the objectID URIRepresentation
                let objectID = vaccination.objectID
                let uriString = objectID.uriRepresentation().absoluteString
                if let primaryKeyString = uriString.split(separator: "/").last,
                   let primaryKey = Int(primaryKeyString.dropFirst()) { // Remove the leading "p"
                    let EntryId = Int64(primaryKey)
                    vaccination.vaccinationId = EntryId
                    vaccinationModel.shared.saveVaccinationId(Id: EntryId)
                    print("vaccination object created with id \(vaccination.vaccinationId)")
                }else{
                        print("error getting vaccination id")
                    }
                
                // 4. Set the vaccinatedLast2WeeksOrNot attribute
                vaccination.vaccinatedLast2WeeksOrNot = vaccinatedLast2WeeksOrNot
                
                // 5. Save the context
                do {
                    try context.save()
                    print("Vaccination object created and linked to TemperatureLocal with ID \(temperatureId).")
                    completion(true)
                } catch {
                    print("Error saving Vaccination object: \(error)")
                    completion(false)
                }
            } else {
                print("TemperatureLocal object with ID \(temperatureId) not found.")
                completion(false)
            }
        } catch {
            print("Error creating Vaccination object: \(error)")
            completion(false)
        }
    }
    func updateVaccinationReceived(vaccinationId: Int64, Vaccines: [String], completion: @escaping (Bool) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch request for VaccinationLocal by vaccinationId
        let fetchRequest: NSFetchRequest<VaccinationLocal> = VaccinationLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vaccinationId == %d", vaccinationId)

        do {
            // Fetch the VaccinationLocal object
            if let vaccination = try context.fetch(fetchRequest).first {
                // Update the vaccineReceived attribute
                vaccination.vaccineReceived = Vaccines as NSObject
                
                // Save the context
                do {
                    try context.save()
                    print("Updated vaccineReceived for vaccinationId \(vaccinationId) with \(Vaccines).")
                    completion(true)
                } catch {
                    print("Error saving updated VaccinationLocal object: \(error)")
                    completion(false)
                }
            } else {
                print("No VaccinationLocal object found with vaccinationId \(vaccinationId).")
                completion(false)
            }
        } catch {
            print("Error fetching VaccinationLocal object: \(error)")
            completion(false)
        }
    }
    func updateVaccinationDateTime(vaccinationId: Int64, vaccineDate: Date, completion: @escaping (Bool) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch request for VaccinationLocal by vaccinationId
        let fetchRequest: NSFetchRequest<VaccinationLocal> = VaccinationLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vaccinationId == %d", vaccinationId)

        do {
            // Fetch the VaccinationLocal object
            if let vaccination = try context.fetch(fetchRequest).first {
                // Update the vaccineReceived attribute
                vaccination.vaccinationDateTime = vaccineDate
                
                // Save the context
                do {
                    try context.save()
                    print("Updated vaccinedate for vaccinationId \(vaccinationId) with \(vaccineDate).")
                    completion(true)
                } catch {
                    print("Error saving updated VaccinationLocal object: \(error)")
                    completion(false)
                }
            } else {
                print("No VaccinationLocal object found with vaccinationId \(vaccinationId).")
                completion(false)
            }
        } catch {
            print("Error fetching VaccinationLocal object: \(error)")
            completion(false)
        }
    }
    func syncVaccinationObject(
        onlineTemperatureId: Int64,
        vaccinatedLast2WeeksOrNot: String?,
        vaccineReceived: [String]?,
        vaccinationDateTime: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/temperature/vaccination/\(onlineTemperatureId)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the request body, dynamically excluding nil values
        var requestBody: [String: Any] = [:]
        
        if let vaccinatedLast2WeeksOrNot = vaccinatedLast2WeeksOrNot {
            requestBody["vaccinatedLast2WeeksOrNot"] = vaccinatedLast2WeeksOrNot
        }
        if let vaccineReceived = vaccineReceived {
            requestBody["vaccineReceived"] = vaccineReceived
        }
        if let vaccinationDateTime = vaccinationDateTime {
            requestBody["vaccinationDateTime"] = vaccinationDateTime
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Unexpected server response")
                let statusError = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])
                completion(.failure(statusError))
                return
            }
            
            guard let data = data else {
                print("No data received")
                let dataError = NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(dataError))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    completion(.success(jsonResponse))
                } else {
                    print("Invalid JSON structure")
                    let jsonError = NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                    completion(.failure(jsonError))
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func checkIfProfileIsVaccinated() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return false
          }
        // Fetch the profileId using your appDelegate function
        guard let profileId = appDelegate.fetchProfileId() else {
            print("Profile ID could not be fetched")
            return false
        }
        
        // Get the Core Data context
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for LocalEntry
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
        
        do {
            // Fetch all LocalEntry objects with the matching profileId
            let entries = try context.fetch(fetchRequest)
            
            // Iterate through the fetched LocalEntry objects
            for entry in entries {
                // Check if the entry has an associated TemperatureLocal object
                if let temperature = entry.temperature {
                    // Check if the TemperatureLocal object has an associated VaccinationLocal object
                    if temperature.vaccination != nil {
                        return true // Found a vaccination, return true
                    }
                }
            }
            
        } catch {
            print("Failed to fetch LocalEntry objects: \(error.localizedDescription)")
        }
        
        // No entries with a vaccination found, return false
        return false
    }
}
