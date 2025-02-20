//
//  defaultSettingsNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 30/09/2024.
//

import Foundation
import UIKit
import CoreData
class defaultSettingsNetworkManager{
    static let shared = defaultSettingsNetworkManager()
    //save default country to core data
    func saveDefaultCountryToCoreData(country: String) {
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
            
            // Assuming there's only one sessionData entity, update the first one
            if let sessionData = sessionDataList.first {
                sessionData.default_country = country
            } else {
                // If no sessionData entity exists, create one
                let newSessionData = SessionData(context: context)
                newSessionData.default_country = country
            }
            
            // Save the context
            try context.save()
            print("Selected country saved to Core Data")
            
        } catch {
            print("Failed to save selected country: \(error)")
        }
    }
    //save default language to core data
    func savedefaultLanguageToCoreData(language: String) {
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
                sessionData.default_language = language
            } else {
                // If no session data exists, create a new one
                let newSessionData = SessionData(context: context)
                newSessionData.default_language = language
            }
            
            // Save the context
            try context.save()
            print("Selected language saved to Core Data")
            
        } catch {
            print("Failed to save selected language: \(error)")
        }
    }
    func SaveDefaultSettingsRequest(sessionId: String, defaultCountry: String, defaultLanguage: String) {
        
        // 1. Define the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/session-data/\(sessionId)/defaults") else {
            print("Invalid URL")
            return
        }
        
        // 2. Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // 3. Set headers if needed
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 4. Create the body
        let body: [String: String] = [
            "defaultCountry": defaultCountry,
            "defaultLanguage": defaultLanguage
        ]
        
        // 5. Convert the body to JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
          
            return
        }
        
        // 6. Attach the JSON body to the request
        request.httpBody = httpBody
        
        // 7. Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle error
            if error != nil {
               print("error")
                return
            }
            
            // Handle response
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                  print("default language updated successfully")
                } else {
                  print("failed")
                }
            }
        }
        
        // 8. Start the task
        task.resume()
    }
}
