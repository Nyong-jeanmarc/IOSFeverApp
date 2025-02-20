//
//  AddProfileGenderModel.swift
//  FeverApp ios
//
//  Created by NEW on 17/09/2024.
//

import Foundation
import UIKit

///  AddProfileGenderModel is a singleton class that manages the selected profile gender of the user.
///   It provides functionality to save and retrieve the selected profile gender.
class AddProfileGenderModel {
    // Singleton instance
    static let shared = AddProfileGenderModel()
    // Variable to store the selected profile gender.
    var profileGender : String?
    
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected profile gender
    ///
    ///  - Parameter ProfileGender: The Profile Gender selected by the user.
    func saveProfilesGender(_ gender: String, completion: @escaping (_ isSavedSuccessfully : Bool?) -> Void) {
        self.profileGender =  gender
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileId = appDelegate.fetchProfileId()
        var isSavedSuccessfully : Bool?
        //        //save profile gender to remote server
        //        AddProfileGenderNetworkManager.shared.saveProfileGenderRequest(profileId: profileid, gender: gender){
        //            result in
        //            switch result{
        //            case .success(_):
        //                isSavedSuccessfully = true
        //            case .failure(_):
        //                isSavedSuccessfully = false
        //            }
        //            DispatchQueue.main.sync{
        //                completion(isSavedSuccessfully!)
        //            }
        //        }
        //save gender to local storage
        AddProfileGenderNetworkManager.shared.saveProfileGenderToCoreData(profileId: profileId!, gender: gender) { result in
            isSavedSuccessfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccessfully)
            }
        }
    }
}
