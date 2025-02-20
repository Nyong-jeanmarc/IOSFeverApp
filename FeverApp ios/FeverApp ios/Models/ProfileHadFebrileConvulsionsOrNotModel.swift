//
//  ProfileHadFebrileConvulsionsOrNotModel.swift
//  FeverApp ios
//
//  Created by NEW on 21/09/2024.
//

import Foundation

///  ProfileEverHadFeverConvulsionsOrNotModel is a singleton class that manages the response to wether the user has fever convulsions or not .
///   It provides functionality to save and retrieve the response to wether the user has fever convulsions or not .
class ProfileHadFebrileConvulsionsOrNotModel {
    // Singleton instance
    static let shared = ProfileHadFebrileConvulsionsOrNotModel()
    // Variable to store the response to wether the user has fever convulsions or not.
    var profilesFebrileConvulsionsResponse = ""
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected response.
    ///
    ///  - Parameter    convulsionsResponse: The response to wether the user has fever convulsions or not.
    func  saveProfilesFebrileConvulsionsResponse(_ convulsionsResponse: String) {
        self.profilesFebrileConvulsionsResponse = convulsionsResponse
    }
}
