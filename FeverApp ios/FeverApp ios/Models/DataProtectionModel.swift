//
//  DataProtectionModel.swift
//  FeverApp ios
//
//  Created by user on 9/4/24.
//

import Foundation
import UIKit
import CoreData

/// DataProtectionModel is a singleton class that manages the acceptance status of the user.

class DataProtectionModel {
    // Singleton instance
    static let shared = DataProtectionModel()
    
    // Private initializer to prevent instantiation from other classes
    private init() {}
    
    // Variable to store the acceptance state
    var dataProtectionAccepted: Bool?
    var disclaimerAccepted: Bool?

    
    // function to store the acceptance state in core data
    func saveDisclaimerAndDataProtectionAcceptance(dataProtectionAccepted: Bool, disclaimerAccepted: Bool) {
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the SessionData entity
        let fetchRequest: NSFetchRequest<SessionData> = SessionData.fetchRequest()
        
        do {
            // Fetch the session data from Core Data
            let sessionDataList = try context.fetch(fetchRequest)
            
            if let sessionData = sessionDataList.first {
                // If session data exists, update the values
                sessionData.disclaimer_accepted = disclaimerAccepted
                sessionData.data_protection_agreement_accepted = dataProtectionAccepted
            } else {
                // If no session data exists, create a new one
                let newSessionData = SessionData(context: context)
                newSessionData.disclaimer_accepted = disclaimerAccepted
                newSessionData.data_protection_agreement_accepted = dataProtectionAccepted
            }
            
            // Save the context
            try context.save()
            print("Disclaimer and data protection acceptance saved to Core Data")
            
        } catch {
            print("Failed to save disclaimer and data protection acceptance: \(error)")
        }
    }

    /// Saves the acceptance state
    ///
    ///  - Parameter acceptance: The acceptance selected by the user.
    func saveUsersDataProtectionAndDisclaimerAcceptance(_ acceptance: Bool) {
        self.disclaimerAccepted = acceptance
        self.dataProtectionAccepted = acceptance
        // Additional code to save the acceptance to persistent storage can be added here
        saveDisclaimerAndDataProtectionAcceptance(dataProtectionAccepted: acceptance, disclaimerAccepted: acceptance)
        //Send reauest to save acceptance to remote server
        dataprotectionNetworkManager.shared.ReadAndAcceptDataProtectionRequest(sessionId: sessionNetworkManager.shared.sessionId, dataProtectionAccepted: dataProtectionAccepted!, disclaimerAccepted: disclaimerAccepted!)
    }
}

