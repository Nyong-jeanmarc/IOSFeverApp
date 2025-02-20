//
//  contactWithDoctorNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 26/11/2024.
//

import Foundation
import UIKit
import CoreData
class contactWithDoctorNetworkManager{
    static let shared = contactWithDoctorNetworkManager()
    func updateHasMedicalContact(
        withId id: Int64,
        newMedicalContact: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the `Contact_with_doctorLocal` entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %d", id)

        do {
            // Fetch the object
            let results = try context.fetch(fetchRequest)

            if let contact = results.first {
                // Update the `hasHadMedicalContact` attribute
                contact.hasHadMedicalContact = newMedicalContact
                
                // Save the context
                do {
                    try context.save()
                    // Call the completion handler with success
                    completion(true)
                } catch {
                    // Handle save failure
                    completion(false)
                }
            } else {
                // No object found with the given ID
                completion(false)
            }
        } catch {
            // Handle fetch failure
            completion(false)
        }
    }
    func updateMedicalContactDate(
        withId id: Int64,
        medicalContactDate: Date,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the `Contact_with_doctorLocal` entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %d", id)

        do {
            // Fetch the object
            let results = try context.fetch(fetchRequest)

            if let contact = results.first {
                // Update the `hasHadMedicalContact` attribute
                contact.dateOfContact = medicalContactDate
                
                // Save the context
                do {
                    try context.save()
                    // Call the completion handler with success
                    completion(true)
                } catch {
                    // Handle save failure
                    completion(false)
                }
            } else {
                // No object found with the given ID
                completion(false)
            }
        } catch {
            // Handle fetch failure
            completion(false)
        }
    }
    func updateReasonForContact(
        withId id: Int64,
        newReasons: [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Contact_with_doctorLocal entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %lld", id)
        
        do {
            // Fetch the object with the given ID
            let results = try context.fetch(fetchRequest)
            
            if let contact = results.first {
                // Update the reasonForContact property
                contact.reasonForContact = newReasons as NSObject
                
                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("No contact found with the given ID")
                completion(false)
            }
        } catch {
            print("Failed to fetch contact: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateOtherReasonForContact(
        withId id: Int64,
        otherReasons: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Contact_with_doctorLocal entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %lld", id)
        
        do {
            // Fetch the object with the given ID
            let results = try context.fetch(fetchRequest)
            
            if let contact = results.first {
                // Update the reasonForContact property
                contact.otherReasonForContact = otherReasons
                
                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("No contact found with the given ID")
                completion(false)
            }
        } catch {
            print("Failed to fetch contact: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateDoctorDiagnosis(
        withId id: Int64,
        diagnosis: [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Contact_with_doctorLocal entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %lld", id)
        
        do {
            // Fetch the object with the given ID
            let results = try context.fetch(fetchRequest)
            
            if let contact = results.first {
                // Update the reasonForContact property
                contact.doctorDiagnoses = diagnosis as NSObject
                
                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("No contact found with the given ID")
                completion(false)
            }
        } catch {
            print("Failed to fetch contact: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateOtherDoctorDiagnosis(
        withId id: Int64,
        otherDiagnosis: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Contact_with_doctorLocal entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %lld", id)
        
        do {
            // Fetch the object with the given ID
            let results = try context.fetch(fetchRequest)
            
            if let contact = results.first {
                // Update the reasonForContact property
                contact.otherDiagnosis = otherDiagnosis
                
                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("No contact found with the given ID")
                completion(false)
            }
        } catch {
            print("Failed to fetch contact: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateDoctorPrescriptions(
        withId id: Int64,
        prescriptions: [String],
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Contact_with_doctorLocal entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %lld", id)
        
        do {
            // Fetch the object with the given ID
            let results = try context.fetch(fetchRequest)
            
            if let contact = results.first {
                // Update the reasonForContact property
                contact.doctorsPrescriptionsIssued = prescriptions as NSObject
                
                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("No contact found with the given ID")
                completion(false)
            }
        } catch {
            print("Failed to fetch contact: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateOtherMedecinesPrescribed(
        withId id: Int64,
        otherMedecine: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Contact_with_doctorLocal entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %lld", id)
        
        do {
            // Fetch the object with the given ID
            let results = try context.fetch(fetchRequest)
            
            if let contact = results.first {
                // Update the reasonForContact property
                contact.otherPrescriptionsIssued = otherMedecine
                
                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("No contact found with the given ID")
                completion(false)
            }
        } catch {
            print("Failed to fetch contact: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateOtherMeasuresTakenByDoctor(
        withId id: Int64,
        otherMeasures: String,
        completion: @escaping (Bool) -> Void
    ) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Contact_with_doctorLocal entity
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %lld", id)
        
        do {
            // Fetch the object with the given ID
            let results = try context.fetch(fetchRequest)
            
            if let contact = results.first {
                // Update the reasonForContact property
                contact.doctorsRecommendationMeasures = otherMeasures
                
                // Save the context
                do {
                    try context.save()
                    completion(true)
                } catch {
                    print("Failed to save context: \(error.localizedDescription)")
                    completion(false)
                }
            } else {
                print("No contact found with the given ID")
                completion(false)
            }
        } catch {
            print("Failed to fetch contact: \(error.localizedDescription)")
            completion(false)
        }
    }
    func syncContactWithDoctorObject(
        onlineEntryId: Int64,
        hasHadMedicalContact: String?,
        dateOfContact: String?,
        reasonForContact: [String]?,
        otherReasonForContact: String?,
        doctorsDiagnoses: [String]?,
        otherDiagnosis: String?,
        doctorsPrescriptionsIssued: [String]?,
        otherPrescriptionsIssued: String?,
        doctorsRecommendationMeasures: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/contactWithDoctor/create/\(onlineEntryId)") else {
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

        if let hasHadMedicalContact = hasHadMedicalContact {
            requestBody["hasHadMedicalContact"] = hasHadMedicalContact
        }
        if let dateOfContact = dateOfContact {
            requestBody["dateOfContact"] = dateOfContact
        }
        if let reasonForContact = reasonForContact {
            requestBody["reasonForContact"] = reasonForContact
        }
        if let otherReasonForContact = otherReasonForContact {
            requestBody["otherReasonForContact"] = otherReasonForContact
        }
        if let doctorsDiagnoses = doctorsDiagnoses {
            requestBody["doctorsDiagnoses"] = doctorsDiagnoses
        }
        if let otherDiagnosis = otherDiagnosis {
            requestBody["otherDiagnosis"] = otherDiagnosis
        }
        if let doctorsPrescriptionsIssued = doctorsPrescriptionsIssued {
            requestBody["doctorsPrescriptionsIssued"] = doctorsPrescriptionsIssued
        }
        if let otherPrescriptionsIssued = otherPrescriptionsIssued {
            requestBody["otherPrescriptionsIssued"] = otherPrescriptionsIssued
        }
        if let doctorsRecommendationMeasures = doctorsRecommendationMeasures {
            requestBody["doctorsRecommendationMeasures"] = doctorsRecommendationMeasures
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

            guard let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200) || (httpResponse.statusCode == 201)  else {
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
    
  func fetchEditingContactLocal(byId contactId: Int64) -> (
        hasMedicalContact: String?,
        contactDate: Date?,
        reasonsForContactingDoctor: [String]?,
        otherReasonsForContact: String?,
        doctorDiagnosis: [String]?,
        otherDiagnosis: String?,
        doctorPrescriptions: [String]?,
        otherMedecinesPrescribed: String?,
        otherMeasuresTakenBydoctor: String?
    )? {
        // Fetch the Contact_with_doctorLocal object from Core Data and return its details
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Contact_with_doctorLocal> = Contact_with_doctorLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactWithDoctorId == %d", contactId)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let contactLocal = results.first {
                return (
                    hasMedicalContact: contactLocal.hasHadMedicalContact,
                    contactDate: contactLocal.dateOfContact,
                    reasonsForContactingDoctor: contactLocal.reasonForContact as? [String],
                    otherReasonsForContact: contactLocal.otherReasonForContact,
                    doctorDiagnosis: contactLocal.doctorDiagnoses as? [String],
                    otherDiagnosis: contactLocal.otherDiagnosis,
                    doctorPrescriptions: contactLocal.doctorsPrescriptionsIssued as? [String],
                    otherMedecinesPrescribed: contactLocal.otherPrescriptionsIssued,
                    otherMeasuresTakenBydoctor: contactLocal.doctorsRecommendationMeasures
                )
            }
        } catch {
            print("Error fetching Contact_with_doctorLocal with ID \(contactId): \(error.localizedDescription)")
        }
        
        return nil
    }
}
