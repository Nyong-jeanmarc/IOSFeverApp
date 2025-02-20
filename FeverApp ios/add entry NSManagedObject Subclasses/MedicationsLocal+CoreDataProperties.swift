//
//  MedicationsLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 26/11/2024.
//
//

import Foundation
import CoreData


extension MedicationsLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicationsLocal> {
        return NSFetchRequest<MedicationsLocal>(entityName: "MedicationsLocal")
    }

    @NSManaged public var hasTakenMedication: String?
    @NSManaged public var isMedicationsSynced: Bool
    @NSManaged public var isMedicationsUpdated: Bool
    @NSManaged public var medicationEntryId: Int64
    @NSManaged public var medicationList: NSObject?
    @NSManaged public var onlineMedicationsId: Int64
    @NSManaged public var localEntry: LocalEntry?
    @NSManaged public var entryMedications: NSSet?

}

// MARK: Generated accessors for entryMedications
extension MedicationsLocal {

    @objc(addEntryMedicationsObject:)
    @NSManaged public func addToEntryMedications(_ value: Entry_medications)

    @objc(removeEntryMedicationsObject:)
    @NSManaged public func removeFromEntryMedications(_ value: Entry_medications)

    @objc(addEntryMedications:)
    @NSManaged public func addToEntryMedications(_ values: NSSet)

    @objc(removeEntryMedications:)
    @NSManaged public func removeFromEntryMedications(_ values: NSSet)

}

extension MedicationsLocal : Identifiable {

}
