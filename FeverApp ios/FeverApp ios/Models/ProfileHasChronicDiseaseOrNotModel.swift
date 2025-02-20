//
//  ProfileHasChronicDiseaseOrNotModel.swift
//  FeverApp ios
//
//  Created by NEW on 20/09/2024.
//

import Foundation
import UIKit

///  ProfileHasChronicDiseaseOrNotModel is a singleton class that manages the response of the user.
///   It provides functionality to save and retrieve the selected chronic disease response.
class ProfileHasChronicDiseaseOrNotModel {
    // Singleton instance
    static let shared = ProfileHasChronicDiseaseOrNotModel()
    // Variable to store the selected chronic disease response.
   var profilesChronicDiseaseResponse = ""
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected response.
    ///
    ///  - Parameter    Pediatrician: The pediatrician selected by the user.
    func saveProfilesChronicDiseaseResponse(_ response: String , completion: @escaping (_ isSavedSuccessfully: Bool?)-> Void) {
        self.profilesChronicDiseaseResponse = response
        var isSavedSuccessfully : Bool?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let profileId = appDelegate.fetchProfileId()
//        //save to remote server
//        hasChronicDiseaseNetworkManager.shared.SaveHasChronicDiseaseRequest(profileId: profileId!, hasChronicDisease: response){
//            result in
//            switch result{
//                
//            case .success(let response):
//                print("response:\(response)")
//                isSavedSuccessfully = true
//                
//            case .failure(_):
//                print("server error")
//                isSavedSuccessfully = false
//            }
//            DispatchQueue.main.sync{
//                completion(isSavedSuccessfully)
//            }
//        }
        //save to core data
        hasChronicDiseaseNetworkManager.shared.saveProfileHasChronicDiseaseToCoreData(profileId: profileId!, hasChronicDisease: response) { result in
            isSavedSuccessfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccessfully)
            }
        }
    }
}
