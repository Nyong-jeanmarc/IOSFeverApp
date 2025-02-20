//
//  ProfileHasTakenAntipyreticsOrNotModel.swift
//  FeverApp ios
//
//  Created by NEW on 21/09/2024.
//

import Foundation
import UIKit

///  ProfileHasTakenAntipyreticsOrNotModel is a singleton class that manages the response to wether the user has taken antyreptics or not .
///   It provides functionality to save and retrieve the response to wether the user has taken antyreptics or not .
class ProfileHasTakenAntipyreticsOrNotModel {
    // Singleton instance
    static let shared = ProfileHasTakenAntipyreticsOrNotModel()
    // Variable to store the response to wether the user has taken antyreptics or not.
    var profilesAntipyreticsIntakeResponse = ""
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected response.
    ///
    ///  - Parameter    antyrepticsResponse: Thenresponse to wether the user has taken antyreptics or not.
    func saveProfilesAntipyreticsIntakeResponse(_ antyrepticsResponse: String, completion: @escaping (_ isSavedSuccessfully: Bool?)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let profileId = appDelegate.fetchProfileId()
        var isSavedSuccessfully: Bool?
        self.profilesAntipyreticsIntakeResponse = antyrepticsResponse
        //save to remote server
//        ProfileHasTakenAntipyreticsOrNotNetworkManager.shared.saveHasTakenAntyrepticsOrNotRequest(profileId: profileId!, hasTakenAntipyretics: antyrepticsResponse){
//            Result in
//            switch Result{
//            case .success(let response):
//                print(response)
//                isSavedSuccessfully = true
//            case .failure(let error):
//                print(error)
//                isSavedSuccessfully = true
//            }
//            DispatchQueue.main.sync{
//                completion(isSavedSuccessfully)
//            }
//        }
        // save to core data
        ProfileHasTakenAntipyreticsOrNotNetworkManager.shared.saveHasTakenAntipyreticsToCoreData(profileId: profileId!, hasTakenAntipyretics: antyrepticsResponse) { result in
            isSavedSuccessfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccessfully)
            }
        }
    }
}
