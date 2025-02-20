//
//  User_medications+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 27/11/2024.
//
//

import Foundation
import CoreData


extension User_medications {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User_medications> {
        return NSFetchRequest<User_medications>(entityName: "User_medications")
    }

    @NSManaged public var activeIngredientQuantity: Double
    @NSManaged public var amountAdministered: Double
    @NSManaged public var basisOfDecision: String?
    @NSManaged public var dateOfAdministration: Date?
    @NSManaged public var isupdated: Bool
    @NSManaged public var isUserMedicationsSynced: Bool
    @NSManaged public var medicationEntryId: Int64
    @NSManaged public var medicationId: Int64
    @NSManaged public var medicationName: String?
    @NSManaged public var onlineUserMedicationsId: Int64
    @NSManaged public var reasonForAdministration: String?
    @NSManaged public var timeOfAdministration: Date?
    @NSManaged public var typeOfMedication: String?
    @NSManaged public var userId: Int64

}

extension User_medications : Identifiable {

}
