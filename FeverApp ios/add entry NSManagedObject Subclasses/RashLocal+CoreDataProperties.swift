//
//  RashLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//
//

import Foundation
import CoreData


extension RashLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RashLocal> {
        return NSFetchRequest<RashLocal>(entityName: "RashLocal")
    }

    @NSManaged public var isRashSynced: Bool
    @NSManaged public var isRashUpdated: Bool
    @NSManaged public var onlineRashId: Int64
    @NSManaged public var rashes: NSObject?
    @NSManaged public var rashId: Int64
    @NSManaged public var rashTime: Date?
    @NSManaged public var localEntry: LocalEntry?

}

extension RashLocal : Identifiable {

}
