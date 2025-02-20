//
//  deleteEntryWorker.swift
//  FeverApp ios
//
//  Created by NEW on 11/12/2024.
//

import Foundation
import CoreData
import UIKit
class deleteEntryWorker{
    static let shared = deleteEntryWorker()
    func syncEntryDeletions() {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Step 1: Fetch entries with isdeleted == true
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isdeleted == true")

        do {
            let deletedEntries = try context.fetch(fetchRequest)
            
            // Step 2: If there are no deleted entries, log and return
            if deletedEntries.isEmpty {
                print("No deleted entries to process.")
                return
            }

            // Step 3: Process each entry to send DELETE request to the server
            for entry in deletedEntries {
                deleteEntryNetworkManager.shared.deleteEntry(entryId: entry.entryId) { success in
                    if success {
                        // Step 4: If deletion is successful on the server, remove from local DB
                        self.deleteEntryAndAssociatedObjects(entry: entry, context: context)
                    } else {
                        print("Failed to delete entry with ID \(entry.entryId). Will retry in 2 minutes.")
                    }
                }
            }
        } catch {
            print("Failed to fetch deleted LocalEntry objects: \(error.localizedDescription)")
        }
    }


    // Helper function to delete the entry and its associated objects from the local database
    private func deleteEntryAndAssociatedObjects(entry: LocalEntry, context: NSManagedObjectContext) {
        // Delete associated objects first
        if let stateOfHealth = entry.stateOfHealth {
            context.delete(stateOfHealth)
        }
        if let temperature = entry.temperature {
            context.delete(temperature)
        }
        if let pains = entry.pains {
            context.delete(pains)
        }
        if let liquids = entry.liquids {
            context.delete(liquids)
        }
        if let diarrhea = entry.diarrhea {
            context.delete(diarrhea)
        }
        if let symptoms = entry.symptoms {
            context.delete(symptoms)
        }
        if let rash = entry.rash {
            context.delete(rash)
        }
        if let warningSigns = entry.warningSigns {
            context.delete(warningSigns)
        }
        if let confidenceLevel = entry.confidenceLevel {
            context.delete(confidenceLevel)
        }
        if let measures = entry.measures {
            context.delete(measures)
        }
        if let notes = entry.notes {
            context.delete(notes)
        }
        if let contactWithDoctor = entry.contactWithDoctor {
            context.delete(contactWithDoctor)
        }
        if let medications = entry.medications {
            context.delete(medications)
        }
        if let feverPhase = entry.feverPhase {
            context.delete(feverPhase)
        }

        // Finally, delete the entry itself
        context.delete(entry)

        // Save changes to the context
        do {
            try context.save()
            print("Entry with ID \(entry.entryId) and associated objects deleted from local database.")
        } catch {
            print("Failed to delete entry and associated objects from local database: \(error.localizedDescription)")
        }
    }
    
}
