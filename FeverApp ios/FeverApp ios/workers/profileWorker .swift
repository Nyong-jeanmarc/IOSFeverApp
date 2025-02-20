//
//  profileWorker .swift
//  FeverApp ios
//
//  Created by NEW on 09/12/2024.
//

import Foundation
import UIKit
import CoreData
class profileWorker {
    static let shared = profileWorker()
    func syncUnsyncedProfiles(completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        
        // Fetch profiles where isSynced is nil or false
        fetchRequest.predicate = NSPredicate(format: "isSynced == nil OR isSynced == %@", NSNumber(value: false))
        
        do {
            let unsyncedProfiles = try context.fetch(fetchRequest)
            let (userId, _) = appDelegate.fetchUserData() 
            
            // If no unsynced profiles, complete with true
            guard !unsyncedProfiles.isEmpty else {
                completion(true)
                return
            }
            
            var syncResults = [Bool]()
            
            // Iterate over each unsynced profile and sync
            let group = DispatchGroup()
            
            for profile in unsyncedProfiles {
                group.enter()
                
                // Safely unwrap profileName
                guard let profileName = profile.profileName else {
                    print("Skipping profile with missing name")
                    syncResults.append(false)
                    group.leave()
                    continue
                }
                
                ProfileNetworkManager.shared.syncProfile(
                    userId: Int(userId!),
                    profileName: profileName,
                    profileDateOfBirth: profile.profileDateOfBirth?.toString(), // Convert Date to String if needed
                    profileGender: profile.profileGender,
                    hasChronicDisease: profile.hasChronicDisease,
                    chronicDiseases: profile.chronicDiseases,
                    profileHeight: Double(profile.profileHeight),
                    hadFeverSeizure: profile.hadFeverSeizure,
                    profileWeight: profile.profileWeight,
                    feverPhases: Int(profile.feverPhases),
                    wayOfDealingWithFeverSeizures: profile.wayOfDealingWithFeverSeizures,
                    willingnessToBeRandomized: profile.willingnessToBeRandomized,
                    doctorReferenceNumber: profile.doctorReferenceNumber,
                    profileColor: profile.profileColor,
                    profilePediatricianId: Int(profile.profilePediatricianId),
                    feverFrequency: profile.feverFrequency,
                    hasTakenAntipyretics: profile.hasTakenAntipyretics
                ) { result in
                    switch result {
                    case .success(let response):
                        if let onlineProfileId = response.profileId {
                            // Update profile with onlineProfileId and set isSynced to true
                            profile.onlineProfileId = Int64(onlineProfileId)
                            profile.isSynced = true
                            do {
                                try context.save()
                                syncResults.append(true)
                            } catch {
                                print("Failed to save context: \(error.localizedDescription)")
                                syncResults.append(false)
                            }
                        } else {
                            print("Failed to sync profile: No profileId received")
                            syncResults.append(false)
                        }
                    case .failure(let error):
                        print("Error syncing profile: \(error.localizedDescription)")
                        syncResults.append(false)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                // If all sync attempts were successful, return true
                let overallSuccess = !syncResults.contains(false)
                completion(overallSuccess)
            }
            
        } catch {
            print("Failed to fetch unsynced profiles: \(error.localizedDescription)")
            completion(false)
        }
    }
}
