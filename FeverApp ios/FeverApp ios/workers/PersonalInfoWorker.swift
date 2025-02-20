//
//  PersonalInfoWorker.swift
//  FeverApp ios
//
//  Created by NEW on 09/12/2024.
//

import Foundation
import UIKit
import CoreData

enum FamilyRole: String {
    case MOM
    case DAD
    case GRANDMA
    case GRANDPA
    case OTHER
    case NOT_SPECIFIED
}

class PersonalInfoWorker {
    static let shared = PersonalInfoWorker()
    
    func syncUnsyncedPersonalInfo(completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserPersonalInformationEntity> = UserPersonalInformationEntity.fetchRequest()
        
        do {
            let existingPersonalInfo = try context.fetch(fetchRequest)
            
            // If no existing personal info, abort
            guard !existingPersonalInfo.isEmpty else {
                completion(false)
                return
            }
            
            let personalInfo = existingPersonalInfo.first!
            
            // Check if personal info is already synced
            guard !personalInfo.isSync else {
                print("Personal info is already synced")
                completion(false)
                return
            }
            
            // Get user ID
            let (userId, _) = appDelegate.fetchUserData()
            
            // Convert family role to enum
            let familyRole: FamilyRole = {
                switch personalInfo.familyRole {
                case "Mom":
                    return .MOM
                case "Dad":
                    return .DAD
                case "Grandma":
                    return .GRANDMA
                case "Grandpa":
                    return .GRANDPA
                case "Other":
                    return .OTHER
                case "Not specified":
                    return .NOT_SPECIFIED
                default:
                    return .NOT_SPECIFIED
                }
            }()
            
            // Extract year from date of birth
            let dateOfBirth = personalInfo.userYearOfBirth
            let yearOfBirth: String
            if let dateOfBirth = dateOfBirth, dateOfBirth.contains(",") {
                yearOfBirth = String(dateOfBirth.components(separatedBy: " ")[2] ?? "")
            } else {
                yearOfBirth = dateOfBirth ?? ""
            }
            
            // Create PersonalInfoRequest
            let request = PersonalInfoRequest(
                userFirstName: personalInfo.userFirstName ?? "",
                userLastName: personalInfo.userLastName ?? "",
                familyRole: familyRole,
                userYearOfBirth: yearOfBirth
            )
            
            // Sync personal info
            PersonalInfoNetworkManager.shared.updatePersonalInfo(userId: String(userId!), request: request) { response, error in
                if let error = error {
                    print("Error syncing personal info: \(error)")
                    completion(false)
                } else if let response = response {
                    print("Personal info synced successfully: \(response)")
                    
                    // Update isSync status
                    personalInfo.isSync = true
                    try? context.save()
                    
                    completion(true)
                } else {
                    print("Unknown error syncing personal info")
                    completion(false)
                }
            }
        } catch {
            print("Failed to fetch existing personal info: \(error.localizedDescription)")
            completion(false)
        }
    }
}
