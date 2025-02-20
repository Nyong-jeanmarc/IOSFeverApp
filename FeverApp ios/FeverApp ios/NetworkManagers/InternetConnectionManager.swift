//
//  InternetConnectionManager.swift
//  FeverApp ios
//
//  Created by NEW on 04/10/2024.
//
import Foundation
import UIKit

import Network

class InternetConnectionManager : ObservableObject {
    static let shared = InternetConnectionManager()
    private var syncTimer: Timer?
    private let monitorQueue = DispatchQueue(label: "network-monitor")
    let monitor = NWPathMonitor()
    let syncMonitor = NWPathMonitor()
    private var isInternetAvailable: Bool = false

    func startMonitoring() {
        monitor.start(queue: DispatchQueue(label: "network-monitor"))
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("connected")
                self?.dismissInternetAlert()
            } else {
                print("disconnected")
                self?.showNoInternetAlert()
            }
        }
    }
    func startMonitoringForSync() {
          // Start monitoring internet status continuously
        syncMonitor.start(queue: monitorQueue)
        syncMonitor.pathUpdateHandler = { [weak self] path in
              self?.isInternetAvailable = (path.status == .satisfied)
              if self?.isInternetAvailable == true {
                  print("Internet available")
              } else {
                  print("Internet unavailable")
              }
          }
          
          // Start the periodic sync timer
          startPeriodicSync()
      }

    func stopMonitoring() {
        // Stop both the periodic sync timer and the network monitor
               stopPeriodicSync()
           monitor.cancel()
           print("Internet monitoring stopped")
       }
    private func startPeriodicSync() {
          stopPeriodicSync() // Ensure any existing timer is canceled
          syncTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true) { [weak self] _ in
              self?.checkInternetAndSync()
          }
          print("Started periodic sync")
      }
    private func checkInternetAndSync() {
           if isInternetAvailable {
               DispatchQueue.global(qos: .background).async {
                   self.performBackgroundSync()
               }
           } else {
               print("No internet connection. Sync skipped.")
           }
       }
    private func stopPeriodicSync() {
            syncTimer?.invalidate()
            syncTimer = nil
            print("Stopped periodic sync")
        }
    private func performBackgroundSync() {
        // sync profiles
        profileWorker.shared.syncUnsyncedProfiles(){isSynced in
            if isSynced{
                print("synced profiles ")
            }else{
                print("failed to sync profiles")
            }
            
        }
        
        //syn personal info
        PersonalInfoWorker.shared.syncUnsyncedPersonalInfo(){ isSynced in
            if isSynced{
                print("synced personal info")
            }else{
                print("failed to sync personal info")
            }
        }
        
        
        //syn contact info
        ContactInfoWorker.shared.syncUnsyncedContactInfo (){ isSynced in
            if isSynced{
                print("Contact info synced successfully")
            } else {
                print("Failed to sync contact info")
            }
        }

        //syn fever cramps documentation
        FeverCrampsWorker.shared.syncUnsyncedFeverCramps (){ isSynced in
            if isSynced{
                print("Fever cramps  synced successfully")
            } else {
                print("Failed to sync ")
            }
        }
        
        DispatchQueue.main.async {
            // sync user pediatricians
            userPediatricianWorker.shared.syncUnsyncedPediatricians(){isSynced in
                if isSynced{
                    print("synced user pediatricians")
                }else{
                    print("failed to sync userPediatricians")
                }
            }
        }
      
        // sync entry objects
        AddEntryWorker.shared.syncUnsyncedEntries(){isSynced in
            if isSynced{
                print("synced entries")
            }else{
                print("failed to sync entries")
            }
        }
        // sync deleted entry objects
        deleteEntryWorker.shared.syncEntryDeletions()
        // sync state of health objects
        stateOfHealthWorker.shared.syncUnsyncedStateOfHealthObjects(){isSynced in
            if isSynced{
                print("synced stateOf health")
            }else{
                print("failed to sync state of health")
            }
            
        }
        // sync temperature objects
        temperatureWorker.shared.syncUnsyncedTemperatures(){ isSynced in
            if isSynced{
                print("synced temperature")
            }else{
                print("failed to sync temperature")
            }
        }
        // sync vaccination
        vaccinationWorker.shared.syncUnsyncedVaccinations(){isSynced in
            if isSynced{
                print("synced vaccination")
            }else{
                print("failed to sync vaccination")
            }
        }
        // sync pain
        painWorker.shared.fetchAndSyncUnsyncedPains(){ isSynced in
            if isSynced{
                print("synced pain")
            }else{
                print("failed to sync pain")
            }
            
        }
        //sync liquid
        liquidWorker.shared.fetchAndSyncUnsyncedLiquids(){isSynced in
            if isSynced {
                print("synced liquids")
            }else{
                print("failed to sync liquids")
            }
        }
        // sync Diarrhea
        diarrheaWorker.shared.syncUnsyncedDiarrheaObjects(){isSynced in
            if isSynced{
                print("synced diarrhea")
            }else{
                print("failed to sync diarrhea")
            }
        }
        // sync rash
        rashWorker.shared.syncUnsyncedRashes(){isSynced in
            if isSynced {
                print("synced rash")
            }else{
                print("synced rash")
            }
        }
        // sync symptoms
        symptomsWorker.shared.syncUnsyncedSymptoms(){isSynced in
            if isSynced{
                print("synced symptoms")
            }else{
                print("failed to sync symptoms")
            }
        }
        // sync warning signs
        warningSignsWorker.shared.syncUnsyncedWarningSigns(){isSynced in
            if isSynced{
                print("synced warning signs")
            }else{
                print("failed to sync warning signs")
            }
        }
        // sync feeling confident
        feelingConfidentWorker.shared.syncUnsyncedConfidenceLevels(){isSaved in
            if isSaved {
                print("synced confidence level")
            }else{
                print("failed to sync confidence level")
            }
        }
        // sync contact with doctor
        contactWithDoctorWorker.shared.syncUnsyncedContactsWithDoctor(){isSynced in
            if isSynced{
                print("synced contact with doctor")
            }else{
                print("failed to sync contact with doctor")
            }
        } 
        // sync medication
        medicationWorker.shared.syncUnsyncedMedications(){isSynced in
            if isSynced {
                print("synced medications")
            }else{
                print("failed to sync medications")
            }
        }
        // sync user medication
        userMedicationWorker.shared.syncUnsyncedUserMedications(){isSaved in
            if isSaved{
                print("synced user medications")
            }else{
                print("failed to sync user medications")
            }
        }
        // sync entry medications
        entryMedicationWorker.shared.syncUnsyncedEntryMedications(){isSaved in
                if isSaved{
                    print("synced user medications")
                }else{
                    print("failed to sync user medications")
                }
        }
        //sync measures
        measureWorker.shared.syncUnsyncedMeasures(){isSynced in
            if isSynced{
                print("synced measures")
            }else{
                print("failed to sync measures")
            }
        }
        // sync notes
        notesWorker.shared.syncUnsyncedNotes(){isSynced in
            if isSynced{
                print("synced notes")
            }else{
                print("failed to sync notes")
            }
        }
        
        // sync feverPhases
        feverPhaseWorker.shared.syncUnsyncedFeverPhases(){isSynced in
            if isSynced{
                print("synced feverPhase")
            }else{
                print("failed to sync feverPhase")
            }
            
        }
        
        // sync state of health updates
        updateStateOfHealthWorker.shared.syncUpdatedStateOfHealthObjects(){ isSynced in
            if isSynced{
                print("synced state of health update")
            }else{
                print("failed to sync state of health update ")
            }
            
        }
        // sync temperature updates
        updateTemperatureWorker.shared.syncUpdatedTemperatureObjects(){isSynced in
            if isSynced{
                print("synced temperature update")
            }else{
                print("failed synced temperature update")
            }
            
        }
        // sync pain Updates
        updatePainWorker.shared.syncUpdatedPainObjects(){ isSynced in
            if isSynced{
                print("synced pain update")
            }else{
                print("failed synced pain update")
            }
            
        }
        // sync liquid update
        updateLiquidWorker.shared.syncUpdatedLiquidObjects(){ isSynced in
            if isSynced{
                print("synced liquid update")
            }else{
                print("failed sync liquid update")
            }
            
        }
        // sync warning signs update
        updateWarningSignsWorker.shared.syncUpdatedWarningSignsObjects(){ isSynced in
            if isSynced{
                print("synced warning signs update")
            }else{
                print("failed sync warning signs update")
            }
            
        }
        // sync diarrhea updates
        updateDiarrheaWorker.shared.syncUpdatedDiarrheaObjects(){ isSynced in
            if isSynced{
                print("synced diarrhea update")
            }else{
                print("failed sync diarrhea update")
            }
            
        }
        // sync rash updates
        updateRashWorker.shared.syncUpdatedRashObjects(){ isSynced in
            if isSynced{
                print("synced rash update")
            }else{
                print("failed sync rash update")
            }
            
        }
        //sync measure object
        updateMeasureWorker.shared.syncUpdatedMeasureObjects(){ isSynced in
            if isSynced{
                print("synced measure update")
            }else{
                print("failed sync measure update")
            }
        }
        // sync symptoms object
        updateSymptomsWorker.shared.syncUpdatedSymptomsObjects(){ isSynced in
            if isSynced{
                print("synced symptoms update")
            }else{
                print("failed sync symptoms update")
            }
        }
        // sync feeling confident update
        updateFeelingConfidentWorker.shared.syncUpdatedConfidenceLevelObjects(){ isSynced in
            if isSynced{
                print("synced symptoms update")
            }else{
                print("failed sync symptoms update")
            }
        }
        //sync note update
        updateNoteWorker.shared.syncUpdatedNoteObjects(){ isSynced in
            if isSynced{
                print("synced symptoms update")
            }else{
                print("failed sync symptoms update")
            }
        }
        //sync user Medication updates
        updateUserMedicationWorker.shared.syncUpdatedUserMedications(){ isSynced in
            if isSynced{
                print("synced userMedication update")
            }else{
                print("failed to sync userMedication update")
            }
        }
        // sync medication local objects
        updateMedicationWorker.shared.syncUpdatedMedications(){ isSynced in
            if isSynced{
                print("synced userMedication update")
            }else{
                print("failed to sync userMedication update")
            }
        }
        
        
        // sync state of health objects
         print("Performing background sync...")
         // Add your background sync logic here (e.g., API requests or data syncing)
     }
   
    func getCurrentViewController() -> UIViewController? {
        
        let scene = UIApplication.shared.connectedScenes.first
        if let scene = scene as? UIWindowScene {
            let window = scene.windows.first
            if let navigationController = window?.rootViewController as? UINavigationController {
                return navigationController.topViewController
            } else {
                return window?.rootViewController
            }

        }
        return nil
    }
    func dismissInternetAlert(){
        DispatchQueue.main.async { [self] in
            // Get the current view controller
            if let viewController = self.getCurrentViewController() {
                // Dismiss any presented view controllers (including alerts)
                viewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    func showNoInternetAlert() {
        DispatchQueue.main.async { [self] in
            let alertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .default) { _ in
                alertController.dismiss(animated: true)
                   self.startMonitoring()
               }
          

            // Get the current view controller and present the alert
            if let topVC = getCurrentViewController() {
                topVC.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
