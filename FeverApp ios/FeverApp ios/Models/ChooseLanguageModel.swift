//
//  ChooseLanguageModel.swift
//  FeverApp ios
//
//  Created by user264447 on 7/27/24.
//

import Foundation
import UIKit
import CoreData

/// ChooseLanguageModel is a singleton class that manages the selected language of the user.
///  It provides functionality to save and retrieve the selected language.

class ChooseLanguageModel {
    // Singleton instance
    static let shared = ChooseLanguageModel()
    
    // Private initializer to prevent instantiation from other classes
    private init() {}
    
    // Variable to store the selected language
    var selectedLanguage: String?
    // variable to store default language selected by the user
    var defaultLanguage: String?
    func saveDefaultLanguage(language: String){
        self.defaultLanguage = language
    }
    var languageSavedToServerSuccesfully = true
    
    /// Saves the selected language.
    ///Saves the selected languag to core data
 
    ///  - Parameter language: The language selected by the user.
    func saveLanguage(_ language: String) {
        let sessionID = sessionNetworkManager.shared.sessionId
        self.selectedLanguage = language
        // save selected language to core data
        preferencesNetworkManager.shared.saveSelectedLanguageToCoreData(language: language)
        //save default language to core data
        defaultSettingsNetworkManager.shared.savedefaultLanguageToCoreData(language: self.defaultLanguage ?? "N/A")
        //save selected language to remote server
       // preferencesNetworkManager.shared.updatePreferenceSettings(sessionID: sessionID, selectedCountry: "nulli", selectedLanguage: language)
        //save default language to remote server
        defaultSettingsNetworkManager.shared.SaveDefaultSettingsRequest(sessionId: sessionID, defaultCountry: "null", defaultLanguage: defaultLanguage!)
    }
}
