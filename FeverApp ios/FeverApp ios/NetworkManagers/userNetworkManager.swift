//
//  userNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 08/10/2024.
//

import Foundation
import UIKit
class userNetworkManager{
    static let shared = userNetworkManager()
    // save user id to core data
    func saveUserIdToCoreData(userId: Int64) {
        DispatchQueue.main.async {
            // Get the managed object context
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                print("Failed to retrieve context")
                return
            }
            
            // Create a new Profile or fetch the existing one (if you want to save multiple user profiles, use a different approach)
            let profile = Profile(context: context)
            profile.userId = userId
            
            // Save the context
            do {
                try context.save()
                print("User ID saved successfully")
            } catch {
                print("Failed to save User ID: \(error)")
            }
        }
    }
    
}
