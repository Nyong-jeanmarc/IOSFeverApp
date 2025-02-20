//
//  ChooseCountryModel.swift
//  FeverApp ios
//
//  Created by user264447 on 8/7/24.
//

import Foundation
import CoreData
import UIKit

///  ChooseCountryModel is a singleton class that manages the selected country of the user.
///   It provides functionality to save and retrieve the selected country.
class ChooseCountryModel {
    // Singleton instance
    static let shared = ChooseCountryModel()
    var defaultCountry: String?
    func saveDefaultCountry(country: String){
        self.defaultCountry = country
    }
    // Private initializer to prevent instantiation from other classes
    private init () {}
    // saves the users selected country in the session data entity
    
    /// Saves the selected country.
    ///
    ///  - Parameter country: The country selected by the user.
    func saveCountry(_ selectedcountry: String) {
        let sessionID = sessionNetworkManager.shared.sessionId
        UserDefaults.standard.set(selectedcountry, forKey: "selectedCountry")
        //save selected country to core data
        preferencesNetworkManager.shared.saveSelectedCountryToCoreData(country: selectedcountry)
        //save default country to core data
        defaultSettingsNetworkManager.shared.saveDefaultCountryToCoreData(country: self.defaultCountry ?? "N/A")
        //save selected country to remote server
        preferencesNetworkManager.shared.updatePreferenceSettings(sessionID: sessionID, selectedCountry: selectedcountry, selectedLanguage: ChooseLanguageModel.shared.selectedLanguage ?? "")
        //save default country to remote server
        defaultSettingsNetworkManager.shared.SaveDefaultSettingsRequest(sessionId: sessionID, defaultCountry: self.defaultCountry!, defaultLanguage: ChooseLanguageModel.shared.defaultLanguage ?? "null")
        
    }
}
