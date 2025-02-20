//
//  ContactInfoWorker.swift
//  FeverApp ios
//
//  Created by NEW on 09/12/2024.
//

import Foundation
import UIKit
import CoreData

class ContactInfoWorker {
    static let shared = ContactInfoWorker()
    
    func syncUnsyncedContactInfo(completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserContactInfoEntity> = UserContactInfoEntity.fetchRequest()
        
        do {
            let existingContactInfo = try context.fetch(fetchRequest)
            
            // If no existing contact info, abort
            guard !existingContactInfo.isEmpty else {
                completion(false)
                return
            }
            
            let contactInfo = existingContactInfo.first!
            
            // Check if contact info is already synced
            guard !contactInfo.isSync else {
                print("Contact info is already synced")
                completion(false)
                return
            }
            
            // Get user ID
            let (userId, _) = appDelegate.fetchUserData()
            
            // Create ContactInfoRequest
            let request = ContactInfoRequest(
                phoneNumber: contactInfo.phonenumber ?? "",
                emailAddress: contactInfo.email ?? ""
            )
            
            // Sync contact info
            ContactInfoNetworkManager.shared.updateContactInfo(userId: String(userId!), request: request) { response, error in
                if let error = error {
                    print("Error syncing contact info: \(error)")
                    completion(false)
                } else if let response = response {
                    print("Contact info synced successfully: \(response)")
                    
                    // Update isSync status
                    contactInfo.isSync = true
                    try? context.save()
                    
                    completion(true)
                } else {
                    print("Unknown error syncing contact info")
                    completion(false)
                }
            }
        } catch {
            print("Failed to fetch existing contact info: \(error.localizedDescription)")
            completion(false)
        }
    }
}
