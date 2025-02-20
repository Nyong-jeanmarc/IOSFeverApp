//
//  ContactInfoModel.swift
//  FeverApp ios
//
//  Created by user on 1/11/25.
//
import Foundation
import UIKit
import CoreData

// Saving Data to Core Data
func saveContactInfoToCoreData(contactInfo: UserContactInfoEntity) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // Check if a UserContactInfoEntity object already exists
    let fetchRequest: NSFetchRequest<UserContactInfoEntity> = UserContactInfoEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "contactInfoId == %d", contactInfo.contactInfoId)
    
    do {
        let existingContactInfo = try managedContext.fetch(fetchRequest)
        
        if let existingContactInfoObject = existingContactInfo.first {
            // Update the existing object
            existingContactInfoObject.phonenumber = contactInfo.phonenumber
            existingContactInfoObject.email = contactInfo.email
            existingContactInfoObject.isSync = false
        } else {
            // Create a new object
            let newContactInfo = UserContactInfoEntity(context: managedContext)
            newContactInfo.contactInfoId = contactInfo.contactInfoId
            newContactInfo.phonenumber = contactInfo.phonenumber
            newContactInfo.email = contactInfo.email
            newContactInfo.isSync = false
        }
        
        try managedContext.save()
        print("Contact info saved successfully to Core Data")
    } catch {
        print("Error saving contact info to Core Data: \(error)")
    }
}

// Sync Contact Info to Server
func syncContactInfoToServer(contactInfo: UserContactInfoEntity) {
    let networkManager = ContactInfoNetworkManager()
    
    let request = ContactInfoRequest(
        phoneNumber: contactInfo.phonenumber,
        emailAddress: contactInfo.email
    )
    
    networkManager.updateContactInfo(userId: "\(contactInfo.contactInfoId)", request: request) { response, error in
        if let error = error {
            print("Error syncing contact info to server: \(error)")
        } else {
            print("Contact info synced successfully to server")
            
            // Update the isSync property to true
            updateIsSync(contactInfoId: contactInfo.contactInfoId)
        }
    }
}

// Update isSync Property
func updateIsSync(contactInfoId: Int64) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest: NSFetchRequest<UserContactInfoEntity> = UserContactInfoEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "contactInfoId == %d", contactInfoId)
    
    do {
        let existingContactInfo = try managedContext.fetch(fetchRequest)
        
        if let existingContactInfoObject = existingContactInfo.first {
            existingContactInfoObject.isSync = true
            try managedContext.save()
            print("isSync property updated successfully")
        }
    } catch {
        print("Error updating isSync property: \(error)")
    }
}

// Fetch Contact Info
func fetchUserContactInfo() -> [UserContactInfoEntity]? {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<UserContactInfoEntity>(entityName: "UserContactInfoEntity")
    
    do {
        let result = try context.fetch(fetchRequest)
        return result
    } catch {
        print("Error fetching user contact info: \(error)")
        return nil
    }
}
