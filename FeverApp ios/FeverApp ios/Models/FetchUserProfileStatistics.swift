//
//  FetchUserProfileStatistics.swift
//  FeverApp ios
//
//  Created by user on 1/8/25.
//

import Foundation
import CoreData
import UIKit


func fetchTotalFeverPhaseAndEntryCounts() -> (feverPhaseCount: String, entryCount: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return ("0", "0")
    }
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // Fetch all fever phases
    let feverPhaseFetchRequest: NSFetchRequest<FeverPhaseLocal> = FeverPhaseLocal.fetchRequest()
    
    do {
        let feverPhases = try managedContext.fetch(feverPhaseFetchRequest)
        let feverPhaseCount = String(feverPhases.count)
        
        // Fetch all entries
        let entriesFetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        
        let entries = try managedContext.fetch(entriesFetchRequest)
        let entryCount = String(entries.count)
        
        return (feverPhaseCount, entryCount)
    } catch {
        print("Error fetching total fever phase and entry counts: \(error)")
        return ("0", "0")
    }
}
