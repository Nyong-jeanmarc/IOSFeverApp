//
//  AddProfilePediatricianModel.swift
//  FeverApp ios
//
//  Created by NEW on 11/10/2024.
//

import Foundation
import UIKit
class AddProfilePediatricianModel{
    static let shared = AddProfilePediatricianModel()
    var profilePediatricianId : Int64?

    func saveProfilePediatricianId(id : Int64, firstName: String, lastName: String, streetAndHouseNumber: String, postalCode: Int64, city: String, country: String, phoneNumber: String, email: String, reference: String, completion: @escaping(_ isSavedSuccessfully: Bool?)-> Void){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Fetch user data
        let (userIdStored, _) = appDelegate.fetchUserData()
        self.profilePediatricianId = id
        var _ : Bool?
        var (userId,_) = appDelegate.fetchUserData()
        //save user pediatrician locally first
        AddUserPediatricianNetworkManager.shared.createUserPediatricianLocally(pediatricianId: id, userId: userId!, firstName: firstName, lastName: lastName, streetAndHouseNumber: streetAndHouseNumber, postalCode: postalCode, city: city, country: country, phoneNumber: phoneNumber, email: email, reference: reference){ isSaved in
            if isSaved{
                completion(true)
            }else{
                completion(false)
            }
        }
        let localProfileId = appDelegate.fetchProfileId()
        // save to core data
        AddProfilePediatricianNetworkManager.shared.SaveProfilePediatricianIdToCoreData(profileId: localProfileId!, pediatricianId: id)
   
    }
    func saveUserPediatricianToProfile(localProfileId: Int64, id: Int64){
        // save to core data
        AddProfilePediatricianNetworkManager.shared.SaveProfilePediatricianIdToCoreData(profileId: localProfileId, pediatricianId: id)
    }
    
}
