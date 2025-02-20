//
//  painWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class painWorker{
    static let shared = painWorker()

    func fetchAndSyncUnsyncedPains( completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PainLocal> = PainLocal.fetchRequest()
        
        // Predicate to fetch unsynced pains
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isPainSynced == nil"),
            NSPredicate(format: "isPainSynced == %@", NSNumber(value: false))
        ])
        do {
            // Fetch all unsynced PainLocal objects
            let unsyncedPains = try context.fetch(fetchRequest)
            
            // Iterate over each pain object
            let group = DispatchGroup()
            var syncErrors: [Error] = []
            
            for pain in unsyncedPains {
                guard let localEntry = pain.localEntry, localEntry.onlineEntryId != 0 else {
                    print("Skippin pain object with missing or invalid attributes.")
                    continue // Skip if associated local entry's onlineEntryId is nil or 0
                }
                
                group.enter() // Enter dispatch group
                let painDateTimeString = pain.painDateTime != nil ? ISO8601DateFormatter().string(from: pain.painDateTime!) : nil
                // Call syncPainObject for each unsynced pain
                painNetworkManager.shared.syncPainObject(
                    onlineEntryId: Int(localEntry.onlineEntryId),
                    painValue: pain.painValue as? [String],
                    otherPlaces: pain.otherPlaces,
                    painDateTime: painDateTimeString,
                    painSeverityScale: pain.painSeverityScale
                ) { result in
                    switch result {
                    case .success(let data):
                        do {
                            // Parse the response
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let pains = json["pains"] as? [String: Any],
                               let painId = pains["painId"] as? Int64 {
                                
                                // Update pain object
                                pain.onlinePainId = painId
                                pain.isPainSynced = true
                                
                                // Save changes
                                try context.save()
                            }
                        } catch {
                            syncErrors.append(error)
                        }
                    case .failure(let error):
                        syncErrors.append(error)
                    }
                    group.leave() // Leave dispatch group
                }
            }
            
            group.notify(queue: .main) {
                if syncErrors.isEmpty {
                    print("synced pain")
                    completion(true)
                } else {
                    completion(false)
                }
            }
            
        } catch {
            completion(false)
        }
    }

}
