//
//  AddProfileNameModel.swift
//  FeverApp ios
//
//  Created by NEW on 16/09/2024.
//

import Foundation
import UIKit

///  AddProfileNameModel is a singleton class that manages the profile name of the user.
///   It provides functionality to save and retrieve the entered profile name .
class AddProfileNameModel {
    // Singleton instance
    static let shared = AddProfileNameModel()
    // Variable to store the selected Family Role
    var userProfileName : String?
    
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the entered profile name
    ///
    ///  - Parameter ProfileName: The Profile name selected by the user.
    func saveUserProfileName(_ name: String, completion: @escaping (_ isSavedSuccessfully: Bool?) -> Void) {
        var isSavedSuccessfully: Bool?
        // save profile name to model
        self.userProfileName =  name
//        let userId = userDataModel.shared.userId!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Fetch user data
        let (userId, _) = appDelegate.fetchUserData()
        // save profile name to server
        AddProfileNameNetworkkManager.shared.SaveProfileNameRequest(profileName: name, userId: Int(userId!)) { result in
            switch result {
            case .success(let saveProfileNameResponse):
                print("Profile created successfully: \(saveProfileNameResponse)")
                profileIdDataModel.shared.giveprofileIdToProfileDataModel(profileId: saveProfileNameResponse["profileId"] as! Int64)
              isSavedSuccessfully = true
            case .failure(let error):
                isSavedSuccessfully = false
                print("Failed to create profile: \(error.localizedDescription)")
            }
            DispatchQueue.main.sync{
                completion(isSavedSuccessfully)
            }
        }

        // save profile name to core data
        if userId == nil || userId == 0 {
            AddProfileNameNetworkkManager.shared.saveProfileNameToCoreData(userId: userDataModel.shared.userId!, newProfileName: name)
        } else {
            AddProfileNameNetworkkManager.shared.saveProfileNameToCoreData(userId:userId!, newProfileName: name)
        }
    }
}
