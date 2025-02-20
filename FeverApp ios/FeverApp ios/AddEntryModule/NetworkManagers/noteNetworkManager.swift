//
//  noteNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 28/11/2024.
//

import Foundation
import UIKit
import CoreData
class noteNetworkManager {
    static let shared = noteNetworkManager()
    func fetchEditingNoteLocal(byId noteId: Int64) -> NotesLocal? {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NotesLocal> = NotesLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "noteId == %d", noteId)

        do {
            // Execute fetch request
            let results = try context.fetch(fetchRequest)
            // Return the first result if found
            return results.first
        } catch {
            print("Error fetching NotesLocal with ID \(noteId): \(error.localizedDescription)")
            return nil
        }
    }

    func updateNoteContent(
        withId id: Int64,
        newContent: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create a fetch request for the NoteLocal entity
        let fetchRequest: NSFetchRequest<NotesLocal> = NotesLocal.fetchRequest()

        // Add a predicate to filter by the given id
        fetchRequest.predicate = NSPredicate(format: "noteId == %d", id)

        do {
            // Fetch the results
            let results = try context.fetch(fetchRequest)

            // Check if a note with the given id exists
            if let note = results.first {
                // Update the noteContent attribute
                note.notesContent = newContent

                // Save the context to persist changes
                try context.save()

                // Call completion handler with success
                completion(true)
            } else {
                // No matching note found
                completion(false)
            }
        } catch {
            // Handle errors (e.g., fetch or save failed)
            print("Error updating note: \(error)")
            completion(false)
        }
    }
    func updateOtherNoteContent(
        withId id: Int64,
        newContent: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create a fetch request for the NoteLocal entity
        let fetchRequest: NSFetchRequest<NotesLocal> = NotesLocal.fetchRequest()

        // Add a predicate to filter by the given id
        fetchRequest.predicate = NSPredicate(format: "noteId == %d", id)

        do {
            // Fetch the results
            let results = try context.fetch(fetchRequest)

            // Check if a note with the given id exists
            if let note = results.first {
                // Update the noteContent attribute
                note.notesOtherObservations = newContent

                // Save the context to persist changes
                try context.save()

                // Call completion handler with success
                completion(true)
            } else {
                // No matching note found
                completion(false)
            }
        } catch {
            // Handle errors (e.g., fetch or save failed)
            print("Error updating note: \(error)")
            completion(false)
        }
    }
    func updateNoteDate(
        withId id: Int64,
        newDate: Date,
        completion: @escaping (Bool) -> Void
    ) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create a fetch request for the NoteLocal entity
        let fetchRequest: NSFetchRequest<NotesLocal> = NotesLocal.fetchRequest()

        // Add a predicate to filter by the given id
        fetchRequest.predicate = NSPredicate(format: "noteId == %d", id)

        do {
            // Fetch the results
            let results = try context.fetch(fetchRequest)

            // Check if a note with the given id exists
            if let note = results.first {
                // Update the noteContent attribute
                note.notesTime = newDate

                // Save the context to persist changes
                try context.save()

                // Call completion handler with success
                completion(true)
            } else {
                // No matching note found
                completion(false)
            }
        } catch {
            // Handle errors (e.g., fetch or save failed)
            print("Error updating note: \(error)")
            completion(false)
        }
    }
    
    func syncNotesObject(
        onlineEntryId: Int64,
        notesContent: String?,
        notesOtherObservations: String?,
        notesDateTime: String?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/entry/notes/\(onlineEntryId)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Construct the request body, dynamically excluding nil values
        var requestBody: [String: Any] = [:]

        if let notesContent = notesContent {
            requestBody["notesContent"] = notesContent
        }
        if let notesOtherObservations = notesOtherObservations {
            requestBody["notesOtherObservations"] = notesOtherObservations
        }
        if let notesDateTime = notesDateTime {
            requestBody["notesDateTime"] = notesDateTime
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }

        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Unexpected server response")
                let statusError = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])
                completion(.failure(statusError))
                return
            }

            guard let data = data else {
                print("No data received")
                let dataError = NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(dataError))
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    completion(.success(jsonResponse))
                } else {
                    print("Invalid JSON structure")
                    let jsonError = NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])
                    completion(.failure(jsonError))
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }

        task.resume()
    }

}
