//
//  sessionNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 24/09/2024.
//

import Foundation
import UIKit
import CoreData
class sessionNetworkManager {
   static let shared = sessionNetworkManager()
    var sessionId = ""
    var sessionStartTime = ""
    func CreateSession(completion: @escaping (String) -> Void) {
            // Set up the API URL
            guard let url = URL(string: "http://159.89.102.239:8080/api/sessions") else {
                print("Invalid URL")
                return
            }


            // Create the URLRequest object
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // Create the POST request with no body
            // If your API requires a body, you can add it here
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle errors
                if let error = error {
                    print("Error in POST request: \(error)")
                    return
                }

                // Check for valid response
                guard let data = data else {
                    print("No data received")
                    return
                }
               
                // Decode the JSON response
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let sessionID = json["sessionId"] as? String
                        completion(sessionID ?? "")
                        if let sessionID = json["sessionId"] as? String {
                           
                            print("Session ID: \(sessionID)")

                            // Call the function with the sessionID
                            self.initializeSessionData(sessionID: sessionID)
                            self.sessionId = sessionID
                     
                        }
                        
                        
                    }
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let sessionStartTime = json["sessionStartTime"] as? String {
                            print("sessionStartTime: \(sessionStartTime)")

                            
                            self.sessionStartTime = sessionStartTime
                        }
                    }
                } catch let parsingError {
                    print("Error parsing JSON: \(parsingError)")
                }
      
             
            }
            task.resume()
        }
    // function to save session locally
    func saveSessionLocally(sesionID: String) {
        DispatchQueue.main.async {
            // Get the Core Data context
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            // Create a new session
            let session = Session(context: context)
            if let uuid = UUID(uuidString: sesionID) {
                // Now you can use `uuid` as a valid UUID
                // Example of passing it to your function
                session.id = uuid
            } else {
                // Handle the case where the UUID is not valid
                print("Invalid UUID format")
            }
            // Save coreDataDate to Core Data
            session.start_time = Date()
            session.last_activity_time = nil // initial last activity time same as start time
            session.status = "ACTIVE" // or any other initial status you'd like
            session.end_time = nil // Ensure end_time is initially nil
            // Specify the relationship
            let sessionData = SessionData(context: context)
            session.sessionData = sessionData
            // Save the session to Core Data
            do {
                try context.save()
                print("New session started and saved successfully!")
            } catch {
                print("Failed to save session: \(error.localizedDescription)")
            }
            
            // Create a fetch request for the SessionData entity
            let fetchRequest: NSFetchRequest<SessionData> = SessionData.fetchRequest()
            
            do {
                // Fetch the session data from Core Data
                let sessionDataList = try context.fetch(fetchRequest)
                
                if let sessionData = sessionDataList.first {
                    // If session data exists, update the values
                    sessionData.session_id = session.id
                } else {
                    // If no session data exists, create a new one
                    let newSessionData = SessionData(context: context)
                    newSessionData.session_id = session.id
                }
                
                // Save the context
                try context.save()
                print("Disclaimer and data protection acceptance saved to Core Data")
                
            } catch {
                print("Failed to save disclaimer and data protection acceptance: \(error)")
            }
        }
    }
    // Function to initialize session data
    func initializeSessionData(sessionID: String) {
        // Define the URL endpoint
        guard let url = URL(string: "http://159.89.102.239:8080/api/session-data") else {
            print("Invalid URL")
            return
        }
        
        // Create the URLRequest object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON payload
        let body: [String: Any] = [
            "sessionId": sessionID
        ]
        
        // Convert the body to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to serialize JSON body: \(error.localizedDescription)")
            return
        }
        
        // Create the URL session and the data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check if there was an error
            if let error = error {
                print("Error with data task: \(error.localizedDescription)")
                return
            }
            
            // Check if we have valid response data
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Print the response for debugging purposes
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
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
