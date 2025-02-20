//
//  userPediatricianWorker.swift
//  FeverApp ios
//
//  Created by NEW on 09/12/2024.
//

import Foundation
import UIKit
import CoreData
class userPediatricianWorker{
    static let shared = userPediatricianWorker()
    var userPediatricians: [UserPediatrician]?
//    func syncUnsyncedPediatricians(completion: @escaping (Bool) -> Void) {
//           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//               completion(false)
//               return
//           }
//
//           let context = appDelegate.persistentContainer.viewContext
//        let (userId, _) = appDelegate.fetchUserData()
//           let fetchRequest: NSFetchRequest<User_pediatricians> = User_pediatricians.fetchRequest()
//        // Fetch profiles where isSynced is nil or false
//        fetchRequest.predicate = NSPredicate(format: "isSynced == nil OR isSynced == %@", NSNumber(value: false))
//        
//
//        fetchUserDataNetworkManager.shared.fetchUserPediatricians(for: userId!) { [weak self] result in
//            switch result {
//            case .some(let pediatricians):
//                self?.userPediatricians = pediatricians
//                // Now you can use the userPediatricians array
//                print("Fetched pediatricians: \(pediatricians)")
//            case .none:
//                print("Failed to fetch pediatricians")
//            }
//        }
//
//           do {
//               // Fetch all local pediatricians
//               let pediatricians = try context.fetch(fetchRequest)
//
//               // If no pediatricians exist, complete with true
//               guard !pediatricians.isEmpty else {
//                   completion(true)
//                   return
//               }
//
//               var syncResults = [Bool]()
//               let group = DispatchGroup()
//
//               for pediatrician in pediatricians {
//                   group.enter()
//
//                   // Safely unwrap all fields
//                   let userId = appDelegate.fetchUserData().0
//                   guard let firstName = pediatrician.firstName,
//                         let lastName = pediatrician.lastName,
//                         let streetAndHouseNumber = pediatrician.streetAndHouseNumber,
//                         let city = pediatrician.city,
//                         let country = pediatrician.country,
//                         let phoneNumber = pediatrician.phoneNumber,
//                         let email = pediatrician.email else {
//                       print("Skipping pediatrician with missing data")
//                       syncResults.append(false)
//                       group.leave()
//                       continue
//                   }
//
//                   // Perform the request to add pediatrician
//                   AddUserPediatricianNetworkManager.shared.addUserPediatricianRequest(
//                    userId: userId!,
//                       firstName: firstName,
//                       lastName: lastName,
//                       streetAndHouseNumber: streetAndHouseNumber,
//                       postalCode: Int(pediatrician.postalCode),
//                       city: city,
//                       country: country,
//                       phoneNumber: phoneNumber,
//                       email: email
//                   ) { result in
//                       switch result {
//                       case .success(let pediatricianResponse):
//                           // Fetch the online profile ID
//                           if let onlineProfileId = appDelegate.fetchProfileOnlineId() {
//                               AddProfilePediatricianNetworkManager.shared.saveProfilePediatricianRequest(
//                                pediatricianId: Int64(pediatricianResponse.pediatricianId),
//                                   profileId: onlineProfileId
//                               ) { result in
//                                   switch result {
//                                   case .success(let response):
//                                       print("Successfully saved profile-pediatrician relationship: \(response)")
//                                       syncResults.append(true)
//                                   case .failure(let error):
//                                       print("Failed to save profile-pediatrician relationship: \(error.localizedDescription)")
//                                       syncResults.append(false)
//                                   }
//                                   group.leave()
//                               }
//                           } else {
//                               print("Failed to fetch online profile ID")
//                               syncResults.append(false)
//                               group.leave()
//                           }
//                       case .failure(let error):
//                           print("Failed to sync pediatrician: \(error.localizedDescription)")
//                           syncResults.append(false)
//                           group.leave()
//                       }
//                   }
//               }
//
//               group.notify(queue: .main) {
//                   // If all sync attempts were successful, return true
//                   let overallSuccess = !syncResults.contains(false)
//                   completion(overallSuccess)
//               }
//           } catch {
//               print("Failed to fetch pediatricians: \(error.localizedDescription)")
//               completion(false)
//           }
//       }
    
    func syncUnsyncedPediatricians(completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let (userId, _) = appDelegate.fetchUserData()

        fetchUserDataNetworkManager.shared.fetchUserPediatricians(for: userId!) { [weak self] result in
            switch result {
            case .some(let pediatricians):
                self?.userPediatricians = pediatricians
                // Now you can use the userPediatricians array
                print("Fetched pediatricians: \(pediatricians)")

           let context = appDelegate.persistentContainer.viewContext
                // Fetch all local pediatricians
                let fetchRequest: NSFetchRequest<User_pediatricians> = User_pediatricians.fetchRequest()
                do {
                    let localPediatricians = try context.fetch(fetchRequest)

                    // Filter out local pediatricians that already exist in userPediatricians
                    let filteredPediatricians = localPediatricians.filter { localPediatrician in
                        !(self?.userPediatricians ?? []).contains { userPediatrician in
                            userPediatrician.firstName == localPediatrician.firstName &&
                            userPediatrician.lastName == localPediatrician.lastName
                        }
                    }

                    // If no pediatricians exist, complete with true
                    guard !filteredPediatricians.isEmpty else {
                        print("No unsynced user pediatricians")
                        completion(true)
                        return
                    }

                    var syncResults = [Bool]()
                    let group = DispatchGroup()

                    for pediatrician in filteredPediatricians {
                        group.enter()

                        // Safely unwrap all fields
                        let userId = appDelegate.fetchUserData().0
                        guard let firstName = pediatrician.firstName,
                              let lastName = pediatrician.lastName,
                              let streetAndHouseNumber = pediatrician.streetAndHouseNumber,
                              let city = pediatrician.city,
                              let country = pediatrician.country,
                              let phoneNumber = pediatrician.phoneNumber,
                              let email = pediatrician.email else {
                            print("Skipping pediatrician with missing data")
                            syncResults.append(false)
                            group.leave()
                            continue
                        }

                        // Perform the request to add pediatrician
                        AddUserPediatricianNetworkManager.shared.addUserPediatricianRequest(
                            userId: userId!,
                            firstName: firstName,
                            lastName: lastName,
                            streetAndHouseNumber: streetAndHouseNumber,
                            postalCode: Int(pediatrician.postalCode),
                            city: city,
                            country: country,
                            phoneNumber: phoneNumber,
                            email: email
                        ) { result in
                            switch result {
                            case .success(let pediatricianResponse):
                                // Fetch the online profile ID
                                if let onlineProfileId = appDelegate.fetchProfileOnlineId() {
                                    AddProfilePediatricianNetworkManager.shared.saveProfilePediatricianRequest(
                                        pediatricianId: Int64(pediatricianResponse.pediatricianId),
                                        profileId: onlineProfileId
                                    ) { result in
                                        switch result {
                                        case .success(let response):
                                            print("Successfully saved profile-pediatrician relationship: \(response)")
                                            syncResults.append(true)
                                        case .failure(let error):
                                            print("Failed to save profile-pediatrician relationship: \(error.localizedDescription)")
                                            syncResults.append(false)
                                        }
                                        group.leave()
                                    }
                                } else {
                                    print("Failed to fetch online profile ID")
                                    syncResults.append(false)
                                    group.leave()
                                }
                            case .failure(let error):
                                print("Failed to sync pediatrician: \(error.localizedDescription)")
                                syncResults.append(false)
                                group.leave()
                            }
                        }
                    }

                    group.notify(queue: .main) {
                        // If all sync attempts were successful, return true
                        let overallSuccess = !syncResults.contains(false)
                        completion(overallSuccess)
                    }
                } catch {
                    print("Failed to fetch pediatricians: \(error.localizedDescription)")
                    completion(false)
                }
            case .none:
                print("Failed to fetch user pediatricians")
                completion(false)
            }
        }
    }
}
