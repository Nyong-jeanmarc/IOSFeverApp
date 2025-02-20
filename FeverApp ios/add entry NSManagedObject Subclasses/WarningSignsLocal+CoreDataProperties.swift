//
//  WarningSignsLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//
//

import Foundation
import CoreData


extension WarningSignsLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WarningSignsLocal> {
        return NSFetchRequest<WarningSignsLocal>(entityName: "WarningSignsLocal")
    }

    @NSManaged public var isWarningSignsSynced: Bool
    @NSManaged public var isWarningSignsUpdated: Bool
    @NSManaged public var onlineWarningSignsId: Int64
    @NSManaged public var warningSigns: NSObject?
    @NSManaged public var warningSignsId: Int64
    @NSManaged public var warningSignsTime: Date?
    @NSManaged public var localEntry: LocalEntry?

}

extension WarningSignsLocal : Identifiable {

}
