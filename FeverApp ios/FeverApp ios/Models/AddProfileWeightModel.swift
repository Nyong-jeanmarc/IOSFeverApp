//
//  AddProfileWeightModel.swift
//  FeverApp ios
//
//  Created by NEW on 18/09/2024.
//

import Foundation
import UIKit

///  AddProfileWeightModel is a singleton class that manages the entered profile weight of the user.
///   It provides functionality to save and retrieve the entered profile weight
class AddProfileWeightModel {
    // Singleton instance
    static let shared = AddProfileWeightModel()
    // Variable to store the entered profile weight.
    var profilesWeight : Double?
    
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the entered profile Weight.
    ///
    ///  - Parameter    ProfileWeight: The Profile date of birth selected by the user.
    func saveProfilesWeight(_ weight: Double, completion: @escaping (_ isSavedSuccessfully : Bool?)-> Void) {
        self.profilesWeight = weight
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let profileId = appDelegate.fetchProfileId()
        var isSavedSuccessfully : Bool?
        // save to remote server
        //        AddProfileWeightNetworkManager.shared.SaveProfileWeightRequest(profileId: profileId!, profileWeight: weight){
        //            result in
        //            switch result{
        //
        //            case .success(let response):
        //                print(response ?? "")
        //                isSavedSuccessfully = true
        //            case .failure(let error):
        //                print(error)
        //                isSavedSuccessfully = false
        //            }
        //            DispatchQueue.main.sync{
        //                completion(isSavedSuccessfully)
        //            }
        //        }
        //save to core data
        AddProfileWeightNetworkManager.shared.saveProfileWeightToCoreData(profileId: profileId!, profileWeight: weight) { result in
            isSavedSuccessfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccessfully)
            }
        }
    }
}

