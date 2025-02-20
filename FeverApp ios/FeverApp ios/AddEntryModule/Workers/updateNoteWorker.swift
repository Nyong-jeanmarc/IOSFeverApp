//
//  updateNoteWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateNoteWorker{
    static let shared = updateNoteWorker()
    func syncUpdatedNoteObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all local Note objects where isNotesUpdated is true
        let fetchRequest: NSFetchRequest<NotesLocal> = NotesLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isNotesUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedNoteObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedNoteObjects.isEmpty {
                print("No updated Note objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated object
            for noteObject in updatedNoteObjects {
                // Set values, allowing them to be nil if they don't exist
                let notesContent = noteObject.notesContent
                let notesOtherObservations = noteObject.notesOtherObservations
                let notesTimeString = noteObject.notesTime != nil
                    ? ISO8601DateFormatter().string(from: noteObject.notesTime!)
                    : nil
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                // Call the function to update the note on the server
                UpdateNoteNetworkManager.shared.updateNote(
                    noteId: Int(noteObject.onlineNotesId),
                    notesContent: notesContent,
                    notesOtherObservations: notesOtherObservations,
                    notesTime: notesTimeString
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isNotesUpdated flag to false
                            noteObject.isNotesUpdated = false
                            print("Successfully synced noteId: \(noteObject.onlineNotesId)")
                        } else {
                            // Keep the isNotesUpdated flag as true and mark failure
                            noteObject.isNotesUpdated = true
                            print("Failed to sync noteId: \(noteObject.onlineNotesId)")
                            syncSuccess = false
                        }
                        
                        // Save changes to Core Data
                        do {
                            try context.save()
                            print("Changes saved to Core Data.")
                        } catch {
                            print("Error saving Core Data: \(error)")
                            syncSuccess = false
                        }
                        
                        // Leave the group after processing
                        dispatchGroup.leave()
                    }
                }
            }
            
            // Notify when all network calls are complete
            dispatchGroup.notify(queue: .main) {
                print("All sync operations completed.")
                completion(syncSuccess)
            }
            
        } catch {
            print("Failed to fetch updated Note objects: \(error)")
            completion(false)
        }
    }

}
