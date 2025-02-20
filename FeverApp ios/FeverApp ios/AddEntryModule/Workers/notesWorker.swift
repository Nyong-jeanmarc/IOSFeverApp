//
//  notesWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class notesWorker{
    static let shared = notesWorker()
    
    func syncUnsyncedNotes(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced NotesLocal objects
        let fetchRequest: NSFetchRequest<NotesLocal> = NotesLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isNotesSynced == nil"),
            NSPredicate(format: "isNotesSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedNotes = try context.fetch(fetchRequest)

            guard !unsyncedNotes.isEmpty else {
                print("No unsynced notes found.")
                completion(true)
                return
            }

            // Sync notes to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for note in unsyncedNotes {
                // Ensure all required attributes are available
                guard let localEntry = note.localEntry,
                      localEntry.onlineEntryId != 0 // Ensure online entry ID is valid
                else {
                    print("Skipping note with missing or invalid attributes.")
                    continue
                }

                // Prepare the required attributes
                let onlineEntryId = localEntry.onlineEntryId
                let notesDateTimeString = note.notesTime != nil ? ISO8601DateFormatter().string(from: note.notesTime!) : nil

                dispatchGroup.enter()

                // Call the syncNotesObject function
                noteNetworkManager.shared.syncNotesObject(
                    onlineEntryId: onlineEntryId,
                    notesContent: note.notesContent,
                    notesOtherObservations: note.notesOtherObservations,
                    notesDateTime: notesDateTimeString
                ) { result in
                    switch result {
                    case .success(let response):
                        if let noteResponse = response["notes"] as? [String: Any],
                           let noteId = noteResponse["noteId"] as? Int64 {
                            // Update the note object in Core Data
                            note.onlineNotesId = noteId
                            note.isNotesSynced = true

                            do {
                                try context.save()
                                print("Successfully synced note with ID: \(noteId)")
                            } catch {
                                print("Failed to update note in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync note: \(error.localizedDescription)")
                        syncErrors.append(error)
                    }

                    dispatchGroup.leave()
                }
            }

            // Completion handler when all tasks are done
            dispatchGroup.notify(queue: .main) {
                if syncErrors.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } catch {
            print("Failed to fetch unsynced notes: \(error.localizedDescription)")
            completion(false)
        }
    }

}
