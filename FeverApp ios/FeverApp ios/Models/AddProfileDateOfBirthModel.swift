//
//  AddProfileDateOfBirthModel.swift
//  FeverApp ios
//
//  Created by NEW on 17/09/2024.
//

import Foundation
import UIKit

///  AddProfileDateOfBirthModel is a singleton class that manages the selected profile date of birth of the user.
///   It provides functionality to save and retrieve the selected profile date of birth.
class AddProfileDateOfBirthModel {
    // Singleton instance
    static let shared = AddProfileDateOfBirthModel()
    // Variable to store the selected profile date of birth.
    var ProfileDateOfBirth : String?
    
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected profile date of birth
    ///
    ///  - Parameter ProfileDateOfBirth: The Profile date of birth selected by the user.
    func saveProfileDateOfBirth(_ dob: String , completion : @escaping (_ isSavedSuccessfully: Bool?) -> Void) {
        self.ProfileDateOfBirth =  dob
        var isSavedSuccessfully : Bool?
        // save profile date of birth to remote server
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Fetch user data
        let (userId, _) = appDelegate.fetchUserData()
        let profileId = appDelegate.fetchProfileId()
        // save profile name to core data
        //        if userId == nil || userId == 0 {
        //
        //            profileDateOfBirthNetworkManager.shared.SaveProfileDateOfBirthRequest(userId: userDataModel.shared.userId!, profileName: AddProfileNameModel.shared.userProfileName!, profileDateOfBirth: AddProfileDateOfBirthModel.shared.ProfileDateOfBirth!){ result in
        //            switch result {
        //            case .success(let SaveProfileDateOfBirthResponse):
        //                print("Success: \(SaveProfileDateOfBirthResponse)")
        //                isSavedSuccessfully = true
        //            case .failure(let error):
        //                print("Error: \(error.localizedDescription)")
        //                isSavedSuccessfully = false
        //            }
        //            DispatchQueue.main.sync{
        //                completion(isSavedSuccessfully)
        //            }
        //        }
        //        } else {
        //            profileDateOfBirthNetworkManager.shared.SaveProfileDateOfBirthRequest(userId: userId!, profileName: AddProfileNameModel.shared.userProfileName!, profileDateOfBirth: AddProfileDateOfBirthModel.shared.ProfileDateOfBirth!) {result in
        //            switch result {
        //            case .success(let SaveProfileDateOfBirthResponse):
        //                print("Success: \(SaveProfileDateOfBirthResponse)")
        //                isSavedSuccessfully = true
        //            case .failure(let error):
        //                print("Error: \(error.localizedDescription)")
        //                isSavedSuccessfully = false
        //            }
        //            DispatchQueue.main.sync{
        //                completion(isSavedSuccessfully)
        //            }
        //        }
        //        }
        //save profile date of birth to core data
        profileDateOfBirthNetworkManager.shared.saveProfileDateOfBirthToCoreData(profileId: profileId!, dateOfBirthString: dob) { result in
            isSavedSuccessfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccessfully)
            }
        }
        }
    }

