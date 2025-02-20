//
//  ContactInfoNetworkManager.swift
//  FeverApp ios
//
//  Created by user on 1/11/25.
//

import Foundation
import UIKit
import CoreData

class ContactInfoNetworkManager {
    static let shared = ContactInfoNetworkManager()
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    // Fetch Contact Info
    func getContactInfo(userId: String, completion: @escaping (ContactInfoResponse?, Error?) -> Void) {
        apiService.makeRequest(
            endpoint: "/api/contactInfo/retrieve/\(userId)",
            method: .get,
            parameters: nil
        ) { (response: Decodable?, error: Error?) in
            if let response = response as? ContactInfoResponse {
                // Insert or update Core Data
                self.insertOrUpdateContactInfo(response: response) { success, coreDataError in
                    if success {
                        completion(response, nil)
                    } else {
                        print("Error saving to Core Data: \(String(describing: coreDataError?.localizedDescription))")
                        completion(nil, coreDataError)
                    }
                }
            } else {
                completion(nil, error)
            }
        }
    }

    // Update Contact Info
    func updateContactInfo(userId: String, request: ContactInfoRequest, completion: @escaping (ContactInfoResponse?, Error?) -> Void) {
        apiService.makeRequest(endpoint: "/api/contactInfo/update/\(userId)", method: .put, parameters: request) { response, error in
            if let response = response as? ContactInfoResponse {
                completion(response, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    private func insertOrUpdateContactInfo(response: ContactInfoResponse, completion: @escaping (Bool, Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false, NSError(domain: "CoreDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "AppDelegate not found"]))
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserContactInfoEntity> = UserContactInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "contactInfoId == %d", response.contactInfoId ?? 0)

        do {
            let results = try context.fetch(fetchRequest)

            let contactInfo: UserContactInfoEntity
            if let existingEntity = results.first {
                // Update the existing entity
                contactInfo = existingEntity
            } else {
                // Create a new entity
                let entity = NSEntityDescription.entity(forEntityName: "UserContactInfoEntity", in: context)!
                contactInfo = UserContactInfoEntity(entity: entity, insertInto: context)
            }

            // Update the properties
            contactInfo.contactInfoId = Int64(response.contactInfoId ?? 0)
            contactInfo.phonenumber = response.phoneNumber
            contactInfo.email = response.emailAddress
            contactInfo.isSync = true // Assuming the data fetched from the server is synced

            // Save the context
            try context.save()
            completion(true, nil)
        } catch {
            print("Core Data fetch or save error: \(error.localizedDescription)")
            completion(false, error)
        }
    }
}



struct ContactInfoRequest: Encodable {
    let phoneNumber: String?
    let emailAddress: String?
}

struct ContactInfoResponse: Decodable {
    let contactInfoId: Int?
    let phoneNumber: String?
    let emailAddress: String?
    let userId: Int?
}
