//
//  updateSymptomsWorker.swift
//  FeverApp ios
//
//  Created by NEW on 16/12/2024.
//

import Foundation
import UIKit
import CoreData
class updateSymptomsWorker{
    static let shared = updateSymptomsWorker()
    func syncUpdatedSymptomsObjects(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Fetch all local SymptomsLocal objects where isSymptomsUpdated is true
        let fetchRequest: NSFetchRequest<SymptomsLocal> = SymptomsLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isSymptomsUpdated == %@", NSNumber(value: true))
        
        do {
            let updatedSymptomsObjects = try context.fetch(fetchRequest)
            
            // If there are no objects to sync, return success
            if updatedSymptomsObjects.isEmpty {
                print("No updated Symptoms objects to sync.")
                completion(true)
                return
            }
            
            // Track success for all sync operations
            var syncSuccess = true
            let dispatchGroup = DispatchGroup()
            
            // Process each updated Symptoms object
            for symptomsObject in updatedSymptomsObjects {
                // Prepare the request parameters
                let symptoms = symptomsObject.symptoms as? [String]
                let otherSymptoms = symptomsObject.otherSymptoms as? [String]
                let symptomsTimeString = symptomsObject.symptomsTime != nil
                    ? ISO8601DateFormatter().string(from: symptomsObject.symptomsTime!)
                    : nil
                
                let onlineSymptomsId = Int(symptomsObject.onlineSymptomsId)
                
                // Use DispatchGroup to track completion of each network call
                dispatchGroup.enter()
                
                updateSymptomsNetworkManager.shared.updateSymptoms(
                    symptomsId: onlineSymptomsId,
                    symptoms: symptoms,
                    otherSymptoms: otherSymptoms,
                    symptomsTime: symptomsTimeString
                ) { success in
                    DispatchQueue.main.async {
                        if success {
                            // Update the isSymptomsUpdated flag to false
                            symptomsObject.isSymptomsUpdated = false
                            print("Successfully synced symptomsId: \(onlineSymptomsId)")
                        } else {
                            // Keep the isSymptomsUpdated flag as true and mark failure
                            symptomsObject.isSymptomsUpdated = true
                            print("Failed to sync symptomsId: \(onlineSymptomsId)")
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
            print("Failed to fetch updated Symptoms objects: \(error)")
            completion(false)
        }
    }

}
