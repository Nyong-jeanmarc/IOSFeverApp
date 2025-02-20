//
//  vaccinationWorker.swift
//  FeverApp ios
//
//  Created by NEW on 01/12/2024.
//

import Foundation
import UIKit
import CoreData
class vaccinationWorker{
    static let shared = vaccinationWorker()
    func syncUnsyncedVaccinations(completion: @escaping (Bool) -> Void) {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch unsynced VaccinationLocal objects
        let fetchRequest: NSFetchRequest<VaccinationLocal> = VaccinationLocal.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "isVaccinationSynced == nil"),
            NSPredicate(format: "isVaccinationSynced == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let unsyncedVaccinations = try context.fetch(fetchRequest)

            guard !unsyncedVaccinations.isEmpty else {
                print("No unsynced vaccination objects found.")
                completion(true)
                return
            }

            // Sync vaccinations to server
            let dispatchGroup = DispatchGroup()
            var syncErrors: [Error] = []

            for vaccination in unsyncedVaccinations {
                // Ensure associated temperature's online ID is valid
                guard let associatedTemperature = vaccination.temperature,
                      associatedTemperature.onlineTemperatureId != 0 else {
                    print("Skipping vaccination object with missing or invalid associated temperature online ID.")
                    continue
                }

                // Prepare the parameters
                let vaccinatedLast2WeeksOrNot = vaccination.vaccinatedLast2WeeksOrNot
                let vaccineReceived = vaccination.vaccineReceived as? [String]
                let vaccinationDateTimeString = vaccination.vaccinationDateTime != nil
                    ? ISO8601DateFormatter().string(from: vaccination.vaccinationDateTime!)
                    : nil
                let onlineTemperatureId = associatedTemperature.onlineTemperatureId

                dispatchGroup.enter()

                // Call the syncVaccinationObject function
                vaccinationNetworkManager.shared.syncVaccinationObject(
                    onlineTemperatureId: onlineTemperatureId,
                    vaccinatedLast2WeeksOrNot: vaccinatedLast2WeeksOrNot,
                    vaccineReceived: vaccineReceived,
                    vaccinationDateTime: vaccinationDateTimeString
                ) { result in
                    switch result {
                    case .success(let response):
                        if let vaccinationResponse = response["vaccination"] as? [String: Any],
                           let onlineVaccinationId = vaccinationResponse["vaccinationId"] as? Int64 {
                            // Update the vaccination object in Core Data
                            vaccination.onlineVaccinationId = onlineVaccinationId
                            vaccination.isVaccinationSynced = true

                            do {
                                try context.save()
                                print("Successfully synced vaccination with ID: \(onlineVaccinationId)")
                            } catch {
                                print("Failed to update vaccination in Core Data: \(error.localizedDescription)")
                                syncErrors.append(error)
                            }
                        } else {
                            print("Invalid response structure: \(response)")
                            syncErrors.append(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"]))
                        }
                    case .failure(let error):
                        print("Failed to sync vaccination: \(error.localizedDescription)")
                        syncErrors.append(error)
                    }
                    dispatchGroup.leave()
                }
            }

            // Completion handler when all tasks are done
            dispatchGroup.notify(queue: .main) {
                if syncErrors.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } catch {
            print("Failed to fetch unsynced vaccination objects: \(error.localizedDescription)")
            completion(false)
        }
    }

}
