//
//  profileIdNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 10/10/2024.
//

import Foundation
import CoreData
import UIKit
class profileIdNetworkManager{
    static let shared = profileIdNetworkManager()
    func saveProfileIdToCoreData(userId: Int64, profileId: Int64) {
        DispatchQueue.main.sync{
            // Get the Core Data context
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            appDelegate.saveProfileOnlineId(profileOnlineId: profileId)
            // Create a fetch request for the Profile entity
            //            let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
            //            fetchRequest.predicate = NSPredicate(format: "userId == %d", userId)
            //
            //            do {
            //                // Fetch the existing Profile object with the specified userId
            //                let profiles = try context.fetch(fetchRequest)
            //
            //                if let profile = profiles.first {
            //                    // Update the profileId of the existing Profile object
            //                    profile.profileId = profileId
            //
            //                    // Save the changes to Core Data
            //                    try context.save()
            //                    print("Profile ID updated successfully for userId \(userId).")
            //                } else {
            //                    print("No Profile found for userId \(userId).")
            //                }
            //            } catch {
            //                print("Failed to update Profile ID: \(error.localizedDescription)")
            //            }
            //        }
        }
    }
}
