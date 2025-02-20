//
//  FindYourPediatricianModel.swift
//  FeverApp ios
//
//  Created by NEW on 19/09/2024.
//

import Foundation

///  FindYourPediatricianModel is a singleton class that manages the selected pediatrician of the user.
///   It provides functionality to save and retrieve the selected pediatrician
class findYourPediatricianModel {
    // Singleton instance
    static let shared = findYourPediatricianModel()
    // Variable to store the entered profile weight.
    var profilesPediatrician = ""
    // Private initializer to prevent instantiation from other classes
    private init () {}
    
    /// Saves the selected pediatrician.
    ///
    ///  - Parameter    Pediatrician: The pediatrician selected by the user.
    func saveProfilesPediatrician(_ pediatrician: String) {
        self.profilesPediatrician = pediatrician
    }
}

