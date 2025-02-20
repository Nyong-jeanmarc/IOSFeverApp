//
//  AddProfileHighFeversModel.swift
//  FeverApp ios
//
//  Created by NEW on 21/09/2024.
//

import Foundation
import UIKit

///  AddProfileHighFeversModel is a singleton class that manages the frequency of high fevers entered by the user.
///   It provides functionality to save and retrieve the entered number of frequency phases .
class AddProfileHighFeversModel {
    // Singleton instance
    static let shared = AddProfileHighFeversModel()
    // Variable to store the selected frequency of high fevers response.
    var profilesHighFeverResponse = ""
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected response.
    ///
    ///  - Parameter    freq: The frequency of high fevers entered by the user.
    func saveProfilesHighFeverResponse(_ freq: String, commpletion: @escaping (_ isSavedSuccessfully : Bool?)-> Void) {
        self.profilesHighFeverResponse = freq
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let profileId = appDelegate.fetchProfileId()
        var isSavedSuccesfully: Bool?
        // save to remote server
//        AddProfileHighFeverFrequencyNetworkManager.shared.saveProfileHighFeverFrequencyRequest(profileId: profileId!, feverFrequency: freq){
//            Result in
//            switch Result{
//            case .success(let response):
//                isSavedSuccesfully = true
//                print(response)
//            case .failure(let error):
//                isSavedSuccesfully = false
//                print(error)
//            }
//            DispatchQueue.main.sync{
//                commpletion(isSavedSuccesfully)
//            }
//        }
        // save to core data
        AddProfileHighFeverFrequencyNetworkManager.shared.saveFeverFrequencyToCoreData(profileId: profileId!, feverFrequency: freq) { result in
            isSavedSuccesfully = result
            DispatchQueue.main.async {
                commpletion(isSavedSuccesfully)
            }
        }
    }
}
