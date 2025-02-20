//
//  ProfileEverHadFeverSeizureOrNotModel.swift
//  FeverApp ios
//
//  Created by NEW on 21/09/2024.
//

import Foundation
import UIKit

///  ProfileEverHadFeverSeizureOrNotModel is a singleton class that manages the response to wether the user has fever seizures or not .
///   It provides functionality to save and retrieve the response to wether the user has fever seizures or not .
class ProfileEverHadFeverSeizureOrNotModel {
    // Singleton instance
    static let shared = ProfileEverHadFeverSeizureOrNotModel()
    // Variable to store the response to wether the user has fever seizures or not.
    var profilesFeverSeizureResponse = ""
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected response.
    ///
    ///  - Parameter    seizureResponse: The response to wether the user has fever seizures or not.
    func  saveProfilesFeverSeizureResponse(_ seizureResponse: String, completion: @escaping (_ isSavedSucccessfully: Bool?)-> Void) {
        self.profilesFeverSeizureResponse  = seizureResponse
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let profileId = appDelegate.fetchProfileId()
        var isSavedSuccessfully : Bool?
        // save to remote server
        //        AddProfileFeverSeizuresOrNotNetworkManager.shared.SaveHasFeverSeizureRequest(profileId: profileId!, hadFeverSeizure: seizureResponse){
        //            Result in
        //            switch Result{
        //            case .success(let response):
        //                print(response)
        //                isSavedSuccessfully = true
        //            case .failure(let error):
        //                print(error)
        //                isSavedSuccessfully = false
        //            }
        //            DispatchQueue.main.sync{
        //                completion(isSavedSuccessfully)
        //            }
        //        }
        // save to core data
        AddProfileFeverSeizuresOrNotNetworkManager.shared.saveHadFeverSeizureOrNotToCoreData(profileId: profileId!, hadFeverSeizure: seizureResponse) { result in
            isSavedSuccessfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccessfully)
            }
        }
    }
}
