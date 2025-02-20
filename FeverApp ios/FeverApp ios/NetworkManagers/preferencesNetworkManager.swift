//
//  preferencesNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 25/09/2024.
//

import Foundation
import CoreData
import UIKit
class preferencesNetworkManager{
    static let shared = preferencesNetworkManager()
    //save selected Country to country to core data
    func saveSelectedCountryToCoreData(country: String) {
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the SessionData entity
        let fetchRequest: NSFetchRequest<SessionData> = SessionData.fetchRequest()
        // Create a predicate to filter by session ID
        let predicate = NSPredicate(format: "session_id == %@", sessionNetworkManager.shared.sessionId)
            fetchRequest.predicate = predicate
            
            // Create a sort descriptor (optional)
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            // Fetch the session data from Core Data
            let sessionDataList = try context.fetch(fetchRequest)
            
            // Assuming there's only one sessionData entity, update the first one
            if let sessionData = sessionDataList.first {
                sessionData.selected_country = country
            } else {
                // If no sessionData entity exists, create one
                let newSessionData = SessionData(context: context)
                newSessionData.selected_country = country
            }
            
            // Save the context
            try context.save()
            print("Selected country saved to Core Data")
            
        } catch {
            print("Failed to save selected country: \(error)")
        }
    }
    //save selected language to core data
    func saveSelectedLanguageToCoreData(language: String) {
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the SessionData entity
        let fetchRequest: NSFetchRequest<SessionData> = SessionData.fetchRequest()
        let predicate = NSPredicate(format: "session_id == %@", sessionNetworkManager.shared.sessionId)
            fetchRequest.predicate = predicate
            
            // Create a sort descriptor (optional)
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            // Fetch the session data from Core Data
            let sessionDataList = try context.fetch(fetchRequest)
            
            if let sessionData = sessionDataList.first {
                // If session data exists, update the selected language
                sessionData.selected_language = language
            } else {
                // If no session data exists, create a new one
                let newSessionData = SessionData(context: context)
                newSessionData.selected_language = language
            }
            
            // Save the context
            try context.save()
            print("Selected language saved to Core Data")
            
            // Call the saveSelectedLanguage function to update the language code and load translations
            saveSelectedLanguage(currentLanguage: language)
            
        } catch {
            print("Failed to save selected language: \(error)")
        }
    }
   //saving the selected language to core data and loading translations
    func saveSelectedLanguage(currentLanguage: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        // Create a fetch request for the UserData entity
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            // Fetch user data from Core Data
            let userDataList = try context.fetch(fetchRequest)
            let languageCode = AppUtils.supportedLanguages.first { $0.languageName == currentLanguage }?.languageCode ?? "en"
            if let userData = userDataList.first {
                // If user data exists, update the selected language and its code
                userData.currentLanguage = currentLanguage
                userData.languageCode = languageCode
            } else {
                // If no user data exists, create a new entry
                let newUser = UserDataEntity(context: context)
                newUser.currentLanguage = currentLanguage
                newUser.languageCode = languageCode
            }

            // Save the context
            try context.save()
            print("Selected language (\(currentLanguage)) and code (\(languageCode)) saved to Core Data")

            // Update the layout direction based on the selected language
            if let window = UIApplication.shared.windows.first {
                AppUtils.updateLayoutDirection(for: currentLanguage, in: window)
            }

            // Load translations for the selected language
            TranslationsViewModel.shared.loadTranslations(languageCode: languageCode)

        } catch {
            print("Failed to save selected language: \(error)")
        }
    }


    // Function to update preference settings in the remote server
    func updatePreferenceSettings(sessionID: String, selectedCountry: String, selectedLanguage: String) {
        // Define the URL endpoint
        guard let url = URL(string: "http://159.89.102.239:8080/api/session-data/\(sessionID)/preferences") else {
            print("Invalid URL")
            return
        }
        
        // Create the URLRequest object
        var SaveSelectedCountryandLanguageRequest = URLRequest(url: url)
        SaveSelectedCountryandLanguageRequest.httpMethod = "PUT"
        SaveSelectedCountryandLanguageRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON payload
        let body: [String: Any] = [
            "selectedCountry": selectedCountry,
            "selectedLanguage": selectedLanguage
        ]
        
        // Convert the body to JSON data
        do {
            SaveSelectedCountryandLanguageRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON body: \(error.localizedDescription)")
            return
        }
        
        // Create the URL session and the data task
        let task = URLSession.shared.dataTask(with: SaveSelectedCountryandLanguageRequest) { data, response, error in
            // Check if there was an error
            if let error = error {
                print("Error with data task: \(error.localizedDescription)")
                ChooseLanguageModel.shared.languageSavedToServerSuccesfully = false
                return
            }
            
            // Check if we have valid response data
            guard let data = data else {
                print("No data received")
                ChooseLanguageModel.shared.languageSavedToServerSuccesfully = false
                return
            }
            
            // Print the response for debugging purposes
            if let SaveSelectedCountryResponse = String(data: data, encoding: .utf8) {
                print("Response: \(SaveSelectedCountryResponse)")
            }
            
            // Optional: Parse the response if needed
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("JSON Response: \(jsonResponse)")
            } catch {
                print("Failed to parse JSON response: \(error.localizedDescription)")
            }
        }
        
        // Start the task
        task.resume()
    }
}
