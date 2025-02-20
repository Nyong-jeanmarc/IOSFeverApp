//
//  FeverCrampsModel.swift
//  FeverApp ios
//
//  Created by user on 1/30/25.
//

import Foundation
import UIKit
import CoreData


// Saving Data to Core Data
func saveFeverCrampsToCoreData(feverCramps: FeverCrampsEntity) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // Check if a FeverCrampsEntity object already exists
    let fetchRequest: NSFetchRequest<FeverCrampsEntity> = FeverCrampsEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "feverCrampsId == %d", feverCramps.feverCrampsId)
    
    do {
        let existingFeverCramps = try managedContext.fetch(fetchRequest)
        
        if let existingFeverCrampsObject = existingFeverCramps.first {
            // Update the existing object
            existingFeverCrampsObject.profileId = feverCramps.profileId
            existingFeverCrampsObject.feverCrampsDate = feverCramps.feverCrampsDate
            existingFeverCrampsObject.feverCrampsTime = feverCramps.feverCrampsTime
            existingFeverCrampsObject.feverCrampsDescription = feverCramps.feverCrampsDescription
            existingFeverCrampsObject.feverCrampsOnlineId = feverCramps.feverCrampsOnlineId
            existingFeverCrampsObject.isFeverCrampsSynced = feverCramps.isFeverCrampsSynced
        } else {
            // Create a new object
            let newFeverCramps = FeverCrampsEntity(context: managedContext)
            newFeverCramps.feverCrampsId = feverCramps.feverCrampsId
            newFeverCramps.profileId = feverCramps.profileId
            newFeverCramps.feverCrampsDate = feverCramps.feverCrampsDate
            newFeverCramps.feverCrampsTime = feverCramps.feverCrampsTime
            newFeverCramps.feverCrampsDescription = feverCramps.feverCrampsDescription
            newFeverCramps.feverCrampsOnlineId = feverCramps.feverCrampsOnlineId
            newFeverCramps.isFeverCrampsSynced = feverCramps.isFeverCrampsSynced
        }
        
        try managedContext.save()
        print("Fever cramps saved successfully to core data")
    } catch {
        print("Error saving fever cramps to Core Data: \(error)")
    }
}

//func syncFeverCrampsToServer(feverCramps: FeverCrampsEntity) {
//    let networkManager = FeverCrampsNetworkManager()
//    
//    let request = FeverCrampsRequest(
//        profileId: feverCramps.profileId,
//        feverCrampsDate: feverCramps.feverCrampsDate,
//        feverCrampsTime: feverCramps.feverCrampsTime,
//        feverCrampsDescription: feverCramps.feverCrampsDescription
//    )
//    
//    networkManager.updateFeverCramps(feverCrampsId: "\(feverCramps.feverCrampsId)", request: request) { response, error in
//        if let error = error {
//            print("Error syncing fever cramps to server: \(error)")
//        } else {
//            print("Fever cramps synced successfully to server")
//            
//            // Update the isFeverCrampsSynced property to true
//            updateIsFeverCrampsSynced(feverCrampsId: feverCramps.feverCrampsId)
//        }
//    }
//}
//
//func updateIsFeverCrampsSynced(feverCrampsId: Int64) {
//    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//    
//    let managedContext = appDelegate.persistentContainer.viewContext
//    
//    let fetchRequest: NSFetchRequest<FeverCrampsEntity> = FeverCrampsEntity.fetchRequest()
//    fetchRequest.predicate = NSPredicate(format: "feverCrampsId == %d", feverCrampsId)
//    
//    do {
//        let existingFeverCramps = try managedContext.fetch(fetchRequest)
//        
//        if let existingFeverCrampsObject = existingFeverCramps.first {
//            existingFeverCrampsObject.isFeverCrampsSynced = true
//            try managedContext.save()
//            print("isFeverCrampsSynced property updated successfully")
//        }
//    } catch {
//        print("Error updating isFeverCrampsSynced property: \(error)")
//    }
//}

func fetchFeverCramps(profileId: Int64) -> [FeverCrampsEntity]? {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<FeverCrampsEntity>(entityName: "FeverCrampsEntity")
    fetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
    
    do {
        let result = try context.fetch(fetchRequest)
        return result
    } catch {
        print("Error fetching fever cramps: \(error)")
        return nil
    }
}
