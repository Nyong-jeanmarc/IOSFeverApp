////
////  FeverCrampsWorker.swift
////  FeverApp ios
////
////  Created by user on 1/30/25.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//class FeverCrampsWorker {
//    static let shared = FeverCrampsWorker()
//    
//    func syncUnsyncedFeverCramps(completion: @escaping (Bool) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            completion(false)
//            return
//        }
//        
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<FeverCrampsEntity> = FeverCrampsEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "isFeverCrampsSynced == %d", 0) // Fetch only unsynced records
//        
//        do {
//            let unsyncedFeverCramps = try context.fetch(fetchRequest)
//            
//            guard !unsyncedFeverCramps.isEmpty else {
//                completion(false)
//                return
//            }
//            
//            let feverCramp = unsyncedFeverCramps.first!
//            
//            // Get profile ID
//            guard let profileId = appDelegate.fetchProfileId() else {
//                completion(false)
//                return
//            }
//            
//            // Create the request body
//            let request = FeverCrampsRequest(
//                feverCrampsDate: feverCramp.feverCrampsDate ?? Date(),
//                feverCrampsTime: feverCramp.feverCrampsTime ?? "",
//                feverCrampsDescription: feverCramp.feverCrampsDescription ?? ""
//            )
//            
//            // Sync fever cramps data
//            FeverCrampsNetworkManager.shared.documentFeverCramps(profileId: profileId, request: request) { response, error in
//                if let error = error {
//                    print("Error syncing fever cramps: \(error)")
//                    completion(false)
//                } else if let response = response {
//                    print("Fever cramps synced successfully: \(response)")
//                    
//                    // Update entity with server data
//                    feverCramp.feverCrampsOnlineId = Int64(response.feverCrampsId ?? 0)
//                    feverCramp.isFeverCrampsSynced = 1
//                    
//                    try? context.save()
//                    
//                    completion(true)
//                } else {
//                    print("Unknown error syncing fever cramps")
//                    completion(false)
//                }
//            }
//        } catch {
//            print("Failed to fetch unsynced fever cramps: \(error.localizedDescription)")
//            completion(false)
//        }
//    }
//}


//
//  FeverCrampsWorker.swift
//  FeverApp ios
//
//  Created by user on 1/30/25.
//

import Foundation
import UIKit
import CoreData

class FeverCrampsWorker {
    static let shared = FeverCrampsWorker()
    
    func syncUnsyncedFeverCramps(completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FeverCrampsEntity> = FeverCrampsEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFeverCrampsSynced == %d", 0) // Fetch only unsynced records
        
        do {
            let unsyncedFeverCramps = try context.fetch(fetchRequest)
            
            guard !unsyncedFeverCramps.isEmpty else {
                completion(false)
                return
            }
            
            for feverCramp in unsyncedFeverCramps {
                // Fetch the profile associated with this fever cramp
                let profileFetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
                profileFetchRequest.predicate = NSPredicate(format: "profileId == %d", feverCramp.profileId)
                
                guard let profile = try? context.fetch(profileFetchRequest).first else {
                    print("No profile found for profileId: \(feverCramp.profileId)")
                    continue // Skip this fever cramp
                }
                
                let onlineProfileId = profile.onlineProfileId
                
                // Skip syncing if the profile does not have an online profile ID
                if onlineProfileId == 0 {
                    print("Skipping sync for fever cramp with profileId \(feverCramp.profileId) as onlineProfileId is 0")
                    continue
                }
                
                // Create the request body
                let request = FeverCrampsRequest(
                    feverCrampsDate: feverCramp.feverCrampsDate ?? Date(),
                    feverCrampsTime: feverCramp.feverCrampsTime ?? "00:00:00",  // Ensure valid time format
                    feverCrampsDescription: feverCramp.feverCrampsDescription ?? ""
                )

                // Sync fever cramps data
                FeverCrampsNetworkManager.shared.documentFeverCramps(profileId: onlineProfileId, request: request) { response, error in
                    if let error = error {
                        print("Error syncing fever cramps: \(error)")
                    } else if let response = response {
                        print("Fever cramps synced successfully: \(response)")
                        
                        // Update entity with server data
                        feverCramp.feverCrampsOnlineId = Int64(response.feverCrampsId ?? 0)
                        feverCramp.isFeverCrampsSynced = 1
                        
                        try? context.save()
                    } else {
                        print("Unknown error syncing fever cramps")
                    }
                }
            }
            
            completion(true)
        } catch {
            print("Failed to fetch unsynced fever cramps: \(error.localizedDescription)")
            completion(false)
        }
    }
}
