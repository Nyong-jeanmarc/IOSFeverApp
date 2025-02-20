//
//  AddProfileChronicDiseaseModel .swift
//  FeverApp ios
//
//  Created by NEW on 20/09/2024.
//

import Foundation
import UIKit

///  ProfileHasChronicDiseaseOrNotModel is a singleton class that manages the entered chronic disease of the user.
///   It provides functionality to save and retrieve the entered chronic disease of the user.
class AddProfileChronicDiseaseModel  {
    // Singleton instance
    static let shared = AddProfileChronicDiseaseModel ()
    // Variable to store the entered chronic disease.
    var profilesChronicDisease: [String]?
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the entered chronic disease of the user.
    ///
    ///  - Parameter    disease: The chronic disease entered by the user.
    func saveProfileChronicDisease(_ disease: [String], completion: @escaping (_ isSavedSuccessfully: Bool?)-> Void) {
        self.profilesChronicDisease = disease
        var isSavedSuccesfully : Bool?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let profileId = appDelegate.fetchProfileId()
        //        //save profile chronic diseases to remote server
        //        AddProfileChronicDiseasesNetworkManager.shared.SaveChronicDiseaseRequest(profileId: profileId!, chronicDiseases: disease){
        //            result in
        //            switch result{
        //
        //            case .success(let response):
        //                print(response)
        //                isSavedSuccesfully = true
        //            case .failure(let error):
        //                print(error)
        //                isSavedSuccesfully = false
        //
        //            }
        //            DispatchQueue.main.sync{
        //                completion(isSavedSuccesfully)
        //            }
        //        }
        // save profile chronic diseases to core data
        AddProfileChronicDiseasesNetworkManager.shared.saveChronicDiseasesToCoreData(profileId: profileId!, chronicDiseases: disease) { result in
            isSavedSuccesfully = result
            DispatchQueue.main.async {
                completion(isSavedSuccesfully)
            }
        }
    }
}
