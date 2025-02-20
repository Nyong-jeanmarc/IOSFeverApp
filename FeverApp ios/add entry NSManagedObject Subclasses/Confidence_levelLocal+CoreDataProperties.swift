//
//  Confidence_levelLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//
//

import Foundation
import CoreData


extension Confidence_levelLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Confidence_levelLocal> {
        return NSFetchRequest<Confidence_levelLocal>(entityName: "Confidence_levelLocal")
    }

    @NSManaged public var confidenceLevel: String?
    @NSManaged public var confidenceLevelId: Int64
    @NSManaged public var isConfidenceLevelSynced: Bool
    @NSManaged public var isConfidenceLevelUpdated: Bool
    @NSManaged public var onlineConfidenceLevelId: Int64
    @NSManaged public var timeOfObservation: Date?
    @NSManaged public var localEntry: LocalEntry?

}

extension Confidence_levelLocal : Identifiable {

}
