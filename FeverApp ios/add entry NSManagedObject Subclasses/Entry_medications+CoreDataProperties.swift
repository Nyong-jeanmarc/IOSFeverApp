//
//  Entry_medications+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 02/12/2024.
//
//

import Foundation
import CoreData


extension Entry_medications {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry_medications> {
        return NSFetchRequest<Entry_medications>(entityName: "Entry_medications")
    }

    @NSManaged public var activeIngredientQuantity: Double
    @NSManaged public var amountAdministered: Double
    @NSManaged public var basisOfDecision: String?
    @NSManaged public var dateOfAdministration: Date?
    @NSManaged public var entryMedicationOnlineId: Int64
    @NSManaged public var id: Int64
    @NSManaged public var isEntryMedicationSynced: Bool
    @NSManaged public var isEntryMedicationUpdated: Bool
    @NSManaged public var medicationEntryId: Int64
    @NSManaged public var medicationName: String?
    @NSManaged public var reasonForAdministration: String?
    @NSManaged public var timeOfAdministration: Date?
    @NSManaged public var typeOfMedication: String?
    @NSManaged public var userMedicationId: Int64
    @NSManaged public var medicationLocal: MedicationsLocal?

}

extension Entry_medications : Identifiable {

}
