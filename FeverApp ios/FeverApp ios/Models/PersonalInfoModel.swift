//
//  PersonalInfoModel.swift
//  FeverApp ios
//
//  Created by user on 1/10/25.
//

import Foundation
import UIKit
import CoreData

// Saving Data to Core Data
func savePersonalInfoToCoreData(personalInfo: UserPersonalInformationEntity) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // Check if a UserPersonalInformationEntity object already exists
    let fetchRequest: NSFetchRequest<UserPersonalInformationEntity> = UserPersonalInformationEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "personalInfoId == %d", personalInfo.personalInfoId)
    
    do {
        let existingPersonalInfo = try managedContext.fetch(fetchRequest)
        
        if let existingPersonalInfoObject = existingPersonalInfo.first {
            // Update the existing object
            existingPersonalInfoObject.userFirstName = personalInfo.userFirstName
            existingPersonalInfoObject.userLastName = personalInfo.userLastName
            existingPersonalInfoObject.familyRole = personalInfo.familyRole
            existingPersonalInfoObject.userYearOfBirth = personalInfo.userYearOfBirth
            existingPersonalInfoObject.educationalLevel = personalInfo.educationalLevel
            existingPersonalInfoObject.nationality = personalInfo.nationality
            existingPersonalInfoObject.countryOfResidence = personalInfo.countryOfResidence
            existingPersonalInfoObject.postcode = personalInfo.postcode
            existingPersonalInfoObject.isSync = false
        } else {
            // Create a new object
            let newPersonalInfo = UserPersonalInformationEntity(context: managedContext)
            newPersonalInfo.personalInfoId = personalInfo.personalInfoId
            newPersonalInfo.userFirstName = personalInfo.userFirstName
            newPersonalInfo.userLastName = personalInfo.userLastName
            newPersonalInfo.familyRole = personalInfo.familyRole
            newPersonalInfo.userYearOfBirth = personalInfo.userYearOfBirth
            newPersonalInfo.educationalLevel = personalInfo.educationalLevel
            newPersonalInfo.nationality = personalInfo.nationality
            newPersonalInfo.countryOfResidence = personalInfo.countryOfResidence
            newPersonalInfo.postcode = personalInfo.postcode
            newPersonalInfo.isSync = false
        }
        
        try managedContext.save()
        print("Personal info saved successfully to core data")
    } catch {
        print("Error saving personal info to Core Data: \(error)")
    }
}

func syncPersonalInfoToServer(personalInfo: UserPersonalInformationEntity) {
    let networkManager = PersonalInfoNetworkManager()
    
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
    
    let request = PersonalInfoRequest(
        userFirstName: personalInfo.userFirstName,
        userLastName: personalInfo.userLastName,
        familyRole: familyRole,
        userYearOfBirth: personalInfo.userYearOfBirth
    )
    
    networkManager.updatePersonalInfo(userId: "\(personalInfo.personalInfoId)", request: request) { response, error in
        if let error = error {
            print("Error syncing personal info to server: \(error)")
        } else {
            print("Personal info synced successfully to server")
            
            // Update the isSync property to true
            updateIsSync(personalInfoId: personalInfo.personalInfoId)
        }
    }
}

func updateIsSync(personalInfoId: Int64) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<UserPersonalInformationEntity> = UserPersonalInformationEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "personalInfoId == %d", personalInfoId)
    
    do {
        let existingPersonalInfo = try managedContext.fetch(fetchRequest)
        
        if let existingPersonalInfoObject = existingPersonalInfo.first {
            existingPersonalInfoObject.isSync = true
            try managedContext.save()
            print("isSync property updated successfully")
        }
    } catch {
        print("Error updating isSync property: \(error)")
    }
}

func fetchUserPersonalInfo() -> [UserPersonalInformationEntity]? {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<UserPersonalInformationEntity>(entityName: "UserPersonalInformationEntity")
    
    do {
        let result = try context.fetch(fetchRequest)
        return result
    } catch {
        print("Error fetching user personal info: \(error)")
        return nil
    }
}
