//
//  MeasuresLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 28/11/2024.
//
//

import Foundation
import CoreData


extension MeasuresLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeasuresLocal> {
        return NSFetchRequest<MeasuresLocal>(entityName: "MeasuresLocal")
    }

    @NSManaged public var isMeasuresSynced: Bool
    @NSManaged public var isMeasuresUpdated: Bool
    @NSManaged public var measureId: Int64
    @NSManaged public var measures: NSObject?
    @NSManaged public var measureTime: Date?
    @NSManaged public var onlineMeasuresId: Int64
    @NSManaged public var otherMeasures: String?
    @NSManaged public var takeMeasures: String?
    @NSManaged public var localEntry: LocalEntry?

}

extension MeasuresLocal : Identifiable {

}
