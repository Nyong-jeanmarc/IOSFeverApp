//
//  FeverCrampsEntity+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by user on 1/30/25.
//
//

import Foundation
import CoreData


extension FeverCrampsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeverCrampsEntity> {
        return NSFetchRequest<FeverCrampsEntity>(entityName: "FeverCrampsEntity")
    }

    @NSManaged public var feverCrampsId: Int64
    @NSManaged public var profileId: Int64
    @NSManaged public var feverCrampsDate: Date?
    @NSManaged public var feverCrampsTime: String?
    @NSManaged public var feverCrampsDescription: String?
    @NSManaged public var feverCrampsOnlineId: Int64
    @NSManaged public var isFeverCrampsSynced: Int64

}

extension FeverCrampsEntity : Identifiable {

}
