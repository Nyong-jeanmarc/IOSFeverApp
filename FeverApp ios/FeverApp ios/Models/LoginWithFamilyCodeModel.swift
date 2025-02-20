//
//  LoginWithFamilyCodeModel.swift
//  FeverApp ios
//
//  Created by user on 9/5/24.
//

import Foundation

///  LoginWithFamilyCodeModel is a singleton class that manages the entered FamilyCode of the user.
///   It provides functionality to save and retrieve the FamilyCode.
class LoginWithFamilyCodeModel {
    // Singleton instance
    static let shared = LoginWithFamilyCodeModel()
    
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    // Variable to store the acceptance state
    var usersFamilyCode : String?
    func validateFamilyCode(_ familyCode: String) -> Bool{
        var status = false
        let familyCodeRegex = "^[a-zA-Z0-9]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", familyCodeRegex)
        status = predicate.evaluate(with: familyCode)
        return status
    }
    /// Saves the users Family Code.
    ///
    ///  - Parameter country: The Family Code entered by the user.
    func giveUsersFamilyCodeToLoginWithFamilyCodeModel(_ FamilyCode: String, completion: @escaping (_ isRegistered: Bool? , _ hasProfiles: Bool)-> Void){
        self.usersFamilyCode =  FamilyCode
        var isRegisteredSuccesfully: Bool?
        var hasProfiles = false
        loginWithFamilyCodeNetworkManager.shared.loginWithFamilyCodeRequest(sessionId: sessionNetworkManager.shared.sessionId, familyCode: FamilyCode){result in
            
                    switch result {
                    case .success(let response):
                            print("ResponseF: \(response)")
                            isRegisteredSuccesfully = true
                        // Extract hasProfiles from the response
                        if let hasProfilesValue = response["hasProfiles"] as? Int, hasProfilesValue == 1 {
                            hasProfiles = true
                        }
                      
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                        isRegisteredSuccesfully = false
       
                    }
            DispatchQueue.main.async {
                completion(isRegisteredSuccesfully, hasProfiles)
            }
        }
     
        
    }
}
                           
