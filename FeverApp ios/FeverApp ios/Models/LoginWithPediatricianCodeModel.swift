//
//  LoginWithPediatricianCodeModel.swift
//  FeverApp ios
//
//  Created by user on 9/7/24.
//

import Foundation

///  LoginWithPediatricianCodeModel is a singleton class that manages the entered Pediatrician Code of the user.
///   It provides functionality to save and retrieve the Pediatrician Code.
class LoginWithPediatricianCodeModel {
    // Singleton instance
    static let shared = LoginWithPediatricianCodeModel()
    
    
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    // Variable to store the Pediatrician Code
    var usersPediatricianCode : String?
    /// Saves the users Pediatrician Code.
    ///
    ///  - Parameter country: The Pediatrician Code entered by the user.
    func giveUsersPediatricianCodeToLoginWithPediatricianCodeModel(_ PediatricianCode: String, completion: @escaping (_ isRegisteredSuccesfully: Bool?) -> Void){
            self.usersPediatricianCode = PediatricianCode
        var isRegisteredSuccesfully : Bool?
        var familyCode : String?
            // send request to server to register user
        loginWithPediatricianCodeNetworkManager.shared.loginWithPediatricianCodeRequest(sessionId: sessionNetworkManager.shared.sessionId, pediatricianCode: PediatricianCode ){ result in
                switch result {
                case .success(let response):
                    print("Responser: \(response)")
                    isRegisteredSuccesfully = true
                    familyCode = response["familyCode"] as? String
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    isRegisteredSuccesfully = false
                }
            DispatchQueue.main.sync{
                completion(isRegisteredSuccesfully ?? false)
            }
            LoginWithFamilyCodeModel.shared.usersFamilyCode = familyCode
            }
       
    }
    
 
}

