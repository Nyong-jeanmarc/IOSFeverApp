//
//  PainLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 24/11/2024.
//
//

import Foundation
import CoreData


extension PainLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PainLocal> {
        return NSFetchRequest<PainLocal>(entityName: "PainLocal")
    }

    @NSManaged public var isPainSynced: Bool
    @NSManaged public var isPainUpdated: Bool
    @NSManaged public var onlinePainId: Int64
    @NSManaged public var otherPlaces: String?
    @NSManaged public var painDateTime: Date?
    @NSManaged public var painId: Int64
    @NSManaged public var painSeverityScale: String?
    @NSManaged public var painValue: NSObject?
    @NSManaged public var localEntry: LocalEntry?

}

extension PainLocal : Identifiable {

}
