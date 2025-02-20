//
//  AddProfileHeightModel.swift
//  FeverApp ios
//
//  Created by NEW on 18/09/2024.
//

import Foundation
import UIKit

///  AddProfileDateOfBirthModel is a singleton class that manages the entered profile height of the user.
///   It provides functionality to save and retrieve the entered profile height
class AddProfileHeightModel {
    // Singleton instance
    static let shared = AddProfileHeightModel()
    // Variable to store the entered profile height.
    var profilesHeight : Float?
    
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the entered profile height.
    ///
    ///  - Parameter ProfileDateOfBirth: The Profile date of birth selected by the user.
    func saveProfilesHeight(_ height: Float, completion: @escaping (_ isSavedSuccessfully: Bool?)-> Void) {
        self.profilesHeight =  height
        var isSavedSuccessfully: Bool?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let profileId = appDelegate.fetchProfileId()
        //save profile height to remote server
        //        AddProfileHeightNetworkManager.shared.SaveProfileHeightRequest(profileId: profileId!, profileHeight: height){
        //            Result in
        //            switch Result{
        //                
        //            case .success(let response):
        //                isSavedSuccessfully = true
        //                print(response)
        //            case .failure(let error):
        //                isSavedSuccessfully = false
        //                print(error)
        //            }
        //            DispatchQueue.main.sync{
        //                completion(isSavedSuccessfully ?? false)
        //            }
        //        }
        // save profile height to core data
        AddProfileHeightNetworkManager.shared.saveProfileHeightToCoreData(profileId: profileId!, profileHeight: height) { result in
            isSavedSuccessfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccessfully)
            }
        }
    }
}

