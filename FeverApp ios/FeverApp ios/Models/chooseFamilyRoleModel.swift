//
//  chooseFamilyRoleModel.swift
//  FeverApp ios
//
//  Created by user on 9/6/24.
//

import Foundation
import UIKit

///  chooseFamilyRoleModel is a singleton class that manages the Family Role of the user.
///   It provides functionality to save and retrieve the selected Family Role .
class chooseFamilyRoleModel {
    // Singleton instance
    static let shared = chooseFamilyRoleModel()
    // Variable to store the selected Family Role
    var usersFamilyRole : String?
    
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected Family Role.
    ///
    ///  - Parameter FamilyRole: The Family Role selected by the user.
    func saveUsersFamilyRole(_ Role: String, completion: @escaping (_ isRegistered: Bool? )-> Void) {
        self.usersFamilyRole =  Role
       var isSavedSuccessfully: Bool?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Fetch user data
        let (userId, familyCode) = appDelegate.fetchUserData()

        AddFamilyRoleNetworkManager.shared.SaveFamilyRoleRequest(familyRole: Role, userId: userId!){
            result in
            switch result {
               case .success(let response):
                   // Handle the successful response
                   print("Family role updated successfully.")
                   if let familyRole = response["familyRole"] as? String {
                       print("Updated role: \(familyRole)")
                   }
                isSavedSuccessfully = true
                   
               case .failure(let error):
                   // Handle any errors that occurred during the request
                   print("Failed to update family role with error: \(error.localizedDescription)")
                isSavedSuccessfully = false
               }
            DispatchQueue.main.sync{
                completion(isSavedSuccessfully)
            }
        }
    }
}

