//
//  UpdateVaccinationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 14/12/2024.
//

import Foundation
import UIKit
import CoreData
class UpdateVaccinationNetworkManager{
    static let shared = UpdateVaccinationNetworkManager()
    func markVaccinationUpdated(vaccinationId: Int64) {
        // Get the Core Data context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Fetch the vaccination object with the specified ID
        let fetchRequest: NSFetchRequest<VaccinationLocal> = VaccinationLocal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vaccinationId == %d", vaccinationId)

        do {
            if let vaccination = try context.fetch(fetchRequest).first {
                // Update the isVaccinationUpdated property
                vaccination.isVaccinationUpdated = true

                // Update the isEntryUpdated property of the associated Temperature object (if any)
                if let temperature = vaccination.temperature {
                    temperature.isTemperatureUpdated = true
                }

                // Save the context
                try context.save()
                print("Vaccination and associated entry marked as updated for ID \(vaccinationId).")
            } else {
                print("No VaccinationLocal object found with ID \(vaccinationId).")
            }
        } catch {
            print("Error updating VaccinationLocal with ID \(vaccinationId): \(error.localizedDescription)")
        }
    }

}
