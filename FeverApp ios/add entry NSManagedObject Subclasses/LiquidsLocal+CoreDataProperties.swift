//
//  LiquidsLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//
//

import Foundation
import CoreData


extension LiquidsLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LiquidsLocal> {
        return NSFetchRequest<LiquidsLocal>(entityName: "LiquidsLocal")
    }

    @NSManaged public var dehydrationSigns: NSObject?
    @NSManaged public var isLiquidSynced: Bool
    @NSManaged public var isLiquidUpdated: Bool
    @NSManaged public var liquidId: Int64
    @NSManaged public var liquidTime: Date?
    @NSManaged public var onlineLiquidId: Int64
    @NSManaged public var localEntry: LocalEntry?

}

extension LiquidsLocal : Identifiable {

}
