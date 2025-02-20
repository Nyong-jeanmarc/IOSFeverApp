//
//   UpdateNoteNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/12/2024.
//

import Foundation
import UIKit
import CoreData
class  UpdateNoteNetworkManager{
    static let shared = UpdateNoteNetworkManager()
    func markNoteUpdated(noteId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch the note object based on the noteId
        if let note = noteNetworkManager.shared.fetchEditingNoteLocal(byId: noteId) {
            // Set the 'isNotesUpdated' property to true, indicating that this note has been updated
            note.isNotesUpdated = true
            
            // Also, update the 'isEntryUpdated' property of the associated 'LocalEntry' object, if exists
            if let localEntry = note.localEntry {
                localEntry.isEntryUpdated = true
            }
            
            // Save the context to persist the changes
            do {
                try context.save()
                print("Note with ID \(noteId) marked as updated.")
            } catch {
                print("Error saving updated note with ID \(noteId): \(error.localizedDescription)")
            }
        } else {
            print("Note with ID \(noteId) not found.")
        }
    }
    func updateNote(
        noteId: Int,
        notesContent: String?,
        notesOtherObservations: String?,
        notesTime: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Define the endpoint URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/update/notes/\(noteId)") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body dynamically
        var requestBody: [String: Any] = [:]
        
        if let notesContent = notesContent {
            requestBody["notesContent"] = notesContent
        }
        if let notesOtherObservations = notesOtherObservations {
            requestBody["notesOtherObservations"] = notesOtherObservations
        }
        if let notesTime = notesTime {
            requestBody["notesTime"] = notesTime
        }
        
        // Ensure the request body is not empty
        guard !requestBody.isEmpty else {
            print("Request body is empty. Nothing to send.")
            completion(false)
            return
        }
        
        // Encode the request body to JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted)
        } catch {
            print("Error encoding JSON: \(error)")
            completion(false)
            return
        }
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // Check for response and status code
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Update successful: \(httpResponse.statusCode)")
                    completion(true)
                } else {
                    print("Server error: \(httpResponse.statusCode)")
                    completion(false)
                }
            } else {
                print("No valid HTTP response received.")
                completion(false)
            }
        }
        task.resume()
    }
    
}
