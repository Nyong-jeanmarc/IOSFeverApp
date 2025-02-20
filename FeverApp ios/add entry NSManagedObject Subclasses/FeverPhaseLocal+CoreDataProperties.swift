//
//  FeverPhaseLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 03/12/2024.
//
//

import Foundation
import CoreData


extension FeverPhaseLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeverPhaseLocal> {
        return NSFetchRequest<FeverPhaseLocal>(entityName: "FeverPhaseLocal")
    }

    @NSManaged public var feverPhaseEndDate: Date?
    @NSManaged public var feverPhaseId: Int64
    @NSManaged public var feverPhaseStartDate: Date?
    @NSManaged public var groupDate: String?
    @NSManaged public var isFeverPhaseSynced: Bool
    @NSManaged public var onlineFeverPhaseId: Int64
    @NSManaged public var profileId: Int64
    @NSManaged public var localEntry: NSSet?

}

// MARK: Generated accessors for localEntry
extension FeverPhaseLocal {

    @objc(addLocalEntryObject:)
    @NSManaged public func addToLocalEntry(_ value: LocalEntry)

    @objc(removeLocalEntryObject:)
    @NSManaged public func removeFromLocalEntry(_ value: LocalEntry)

    @objc(addLocalEntry:)
    @NSManaged public func addToLocalEntry(_ values: NSSet)

    @objc(removeLocalEntry:)
    @NSManaged public func removeFromLocalEntry(_ values: NSSet)

}

extension FeverPhaseLocal : Identifiable {

}
