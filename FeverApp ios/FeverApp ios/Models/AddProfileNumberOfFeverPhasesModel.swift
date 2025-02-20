//
//  AddProfileNumberOfFeverPhasesModel.swift
//  FeverApp ios
//
//  Created by NEW on 20/09/2024.
//

import Foundation
import UIKit

///  AddProfileNumberOfFeverPhasesModel is a singleton class that manages the entered number of fever phases of the user.
///   It provides functionality to save and retrieve the entered number of fever phases .
class AddProfileNumberOfFeverPhasesModel {
    // Singleton instance
    static let shared = AddProfileNumberOfFeverPhasesModel()
    // Variable to store the selected chronic disease response.
    var profilesNumberOfFeverPhases: Int16?
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected response.
    ///
    ///  - Parameter    numPhases: The Number of fever phases entered by the user.
    func saveProfileNumberOfFeverPhases(_ numPhases: Int16, completion: @escaping (_ isSavedSuccessfully: Bool?)->Void) {
        self.profilesNumberOfFeverPhases = numPhases
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let profileId = appDelegate.fetchProfileId()
        var isSavedSuccessfully : Bool?
        // save to remote server
//        AddProfileFeverPhasesNetworkManager.shared.SaveFeverPhaseRequest(profileId: profileId, feverPhases: numPhases){
//            result in
//            switch result{
//            case .success(let response):
//                isSavedSuccessfully = true
//                print(response)
//            case .failure(let error):
//                isSavedSuccessfully = false
//                print(error)
//            }
//            DispatchQueue.main.sync{
//                completion(isSavedSuccessfully)
//            }
//        }
        // save to core data
        AddProfileFeverPhasesNetworkManager.shared.saveFeverPhasesToCoreData(profileId: profileId!, feverPhases: numPhases) { result in
            isSavedSuccessfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccessfully)
            }
        }
    }
}
