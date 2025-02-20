//
//  profileIdDataModel.swift
//  FeverApp ios
//
//  Created by NEW on 10/10/2024.
//

import Foundation
import CoreData
import UIKit

class profileIdDataModel{
   static let shared = profileIdDataModel()
    var profileId : Int64?
    func giveprofileIdToProfileDataModel(profileId: Int64){
        self.profileId = profileId
        
        //save profile id locally
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Fetch user data
        let (userId, _) = appDelegate.fetchUserData()
        // save profile name to core data
        if userId == nil || userId == 0 {
            profileIdNetworkManager.shared.saveProfileIdToCoreData(userId: userDataModel.shared.userId!, profileId: profileId)
        } else {
            profileIdNetworkManager.shared.saveProfileIdToCoreData(userId:userId!, profileId: profileId)
        }
    }
    // func fetchProfileAndSaveId() -> Int64? {
    //     // Access the NSManagedObjectContext from the shared persistent container
    //  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //     // Create a fetch request for the Profile entity
    //     let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()

    //     do {
    //         // Fetch all profiles (assuming there's only one profile)
    //         let profiles = try context.fetch(fetchRequest)
            
    //         // Get the first profile's profileId
    //         if let profile = profiles.first {
    //             let profileId = profile.profileId
    //             print("Fetched Profile ID: \(profileId)")
    //             return profileId // Save or use the profileId
    //         } else {
    //             print("No profiles found in Core Data.")
    //             return nil
    //         }
    //     } catch {
    //         print("Failed to fetch Profile: \(error)")
    //         return nil
    //     }
    // }
    func fetchProfileAndSaveId() -> Int64? {
        // Access the NSManagedObjectContext from the shared persistent container
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Create a fetch request for the Profile entity
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()

        do {
            // Fetch all profiles (assuming there's only one profile)
            let profiles = try context.fetch(fetchRequest)
            
            // Get the first profile's profileId
            if let profile = profiles.first {
                let profileId = profile.profileId
                print("Fetched Profile ID: \(profileId)")
                return profileId // Save or use the profileId
            } else {
                print("No profiles found in Core Data.")
                return nil
            }
        } catch {
            print("Failed to fetch Profile: \(error)")
            return nil
        }
    }
}
