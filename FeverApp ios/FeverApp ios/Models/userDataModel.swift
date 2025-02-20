//
//  userDataModel.swift
//  FeverApp ios
//
//  Created by NEW on 07/10/2024.
//

import Foundation
import CoreData
import UIKit
class userDataModel {
    static let shared = userDataModel()
    var userId: Int64?
    func saveUserId(userid: Int64){
        self.userId = userid
        userNetworkManager.shared.saveUserIdToCoreData(userId: userid)
        // Access the NSManagedObjectContext from the shared persistent container
        DispatchQueue.global().async {
        
            // fetch profiles
            fetchUserDataNetworkManager.shared.fetchAndSaveProfiles(userId: Int(userid)){isSaved in
                if isSaved{
                    // fetch entries and feverPhases
                    fetchUserDataNetworkManager.shared.fetchFeverPhasesAndEntries()
                }else{
                    print("Could not fetch profile entries and feverPhases since profiles were not fetched successfully")
                }
                
            }
            // fetch user pediatricians
            fetchUserDataNetworkManager.shared.fetchAndSaveUserPediatricians(for: userid)
            // fetch user medications
            fetchUserDataNetworkManager.shared.fetchAndSaveUserMedications(userId: userid)
        }

        DispatchQueue.main.async {
           
          
        }
    }
//    
//    func saveUserId(userid: Int64) {
//        self.userId = userid
//        userNetworkManager.shared.saveUserIdToCoreData(userId: userid)
//
//        let dispatchGroup = DispatchGroup() // ✅ Track completion of fetch operations
//        var isProfileListEmpty = true // ✅ Track if profiles are empty
//        
//        DispatchQueue.global().async {
//            dispatchGroup.enter()
//            fetchUserDataNetworkManager.shared.fetchAndSaveProfiles(userId: Int(userid)) { isSaved in
//                if isSaved {
//                    isProfileListEmpty = false // ✅ Profiles were fetched successfully
//                    fetchUserDataNetworkManager.shared.fetchFeverPhasesAndEntries()
//                } else {
//                    print("Could not fetch profile entries and feverPhases since profiles were not fetched successfully")
//                }
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.enter()
//            fetchUserDataNetworkManager.shared.fetchAndSaveUserPediatricians(for: userid, dispatchGroup: dispatchGroup)
//
//            dispatchGroup.enter()
//            fetchUserDataNetworkManager.shared.fetchAndSaveUserMedications(userId: userid, dispatchGroup: dispatchGroup)
//
//            dispatchGroup.notify(queue: .main) {
//                // ✅ Navigate to Overview only if profiles were fetched
////                if !isProfileListEmpty {
////                    self.navigateToOverview()
////                }
//                completion(true)
//            }
//        }
//    }
//
//    // ✅ Function to navigate to Overview
//    func navigateToOverview() {
//        DispatchQueue.main.async {
//            if let topController = UIApplication.shared.keyWindow?.rootViewController {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                
//                // Instantiate the view controller from the storyboard
//                if let overviewVC = storyboard.instantiateViewController(withIdentifier: "overview") as? overviewViewController {
//                    
//                    // Set the modal presentation style to full-screen
//                    overviewVC.modalPresentationStyle = .fullScreen
//                    
//                    // Present the view controller
//                    topController.present(overviewVC, animated: true, completion: nil)
//                } else {
//                    print("Overview view controller not found or unable to cast.")
//                }
//            }
//        }
//    }

}
