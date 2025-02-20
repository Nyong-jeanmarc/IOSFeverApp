//
//  liquidWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class liquidWorker{
    static let shared = liquidWorker()
    func fetchAndSyncUnsyncedLiquids(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Step 1: Fetch unsynced liquids
        let fetchRequest: NSFetchRequest<LiquidsLocal> = LiquidsLocal.fetchRequest()
        // Predicate to fetch unsynced pains
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isLiquidSynced == nil"),
            NSPredicate(format: "isLiquidSynced == %@", NSNumber(value: false))
        ])
        
        do {
            
            let unsyncedLiquids = try context.fetch(fetchRequest)
            print("Found \(unsyncedLiquids.count) unsynced liquids.")
            
            guard !unsyncedLiquids.isEmpty else {
                print("No unsynced liquids objects found.")
                completion(true)
                return
            }
            for liquid in unsyncedLiquids {
                guard let localEntry = liquid.localEntry,
                      localEntry.onlineEntryId != 0 else {
                    print("Skipping liquid with no associated online entry ID.")
                    continue
                }
                let liquidDateTimeString = liquid.liquidTime != nil ? ISO8601DateFormatter().string(from: liquid.liquidTime!) : nil
                // Step 2: Call syncLiquidObject for each unsynced liquid
                liquidNetworkManager.shared.syncLiquidObject(
                    dehydrationSigns: liquid.dehydrationSigns as? [String],
                    liquidTime: liquidDateTimeString,
                    onlineEntryId: Int(localEntry.onlineEntryId)
                ) { result in
                    switch result {
                    case .success(let response):
                        // Parse response and update the local object
                        if let liquidsData = response["liquids"] as? [String: Any],
                           let liquidId = liquidsData["liquidId"] as? Int64 {
                            
                            // Update the liquid object
                            liquid.onlineLiquidId = liquidId
                            liquid.isLiquidSynced = true
                            
                            // Save changes to the context
                            do {
                                try context.save()
                                completion(true)
                                print("Successfully synced liquid with ID \(liquid.liquidId).")
                            } catch {
                                completion(false)
                                print("Failed to save context after syncing liquid: \(error)")
                            }
                        } else {
                            completion(false)
                            print("Invalid response format for liquid sync.")
                        }
                        
                    case .failure(let errorMessage):
                        completion(false)
                        print("Failed to sync liquid with ID \(liquid.liquidId): \(errorMessage)")
                    }
                }
            }
            
        } catch {
            completion(false)
            print("Failed to fetch unsynced liquids: \(error)")
        }
    }
}
