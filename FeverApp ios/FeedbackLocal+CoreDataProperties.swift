//
//  FeedbackLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 07/01/2025.
//
//

import Foundation
import CoreData


extension FeedbackLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedbackLocal> {
        return NSFetchRequest<FeedbackLocal>(entityName: "FeedbackLocal")
    }

    @NSManaged public var feedbackId: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var generalSatisfaction: String?
    @NSManaged public var designSatisfaction: String?
    @NSManaged public var usabilitySatisfaction: String?
    @NSManaged public var confidenceImpact: String?
    @NSManaged public var positiveAspects: String?
    @NSManaged public var improvementSuggestions: String?

}

extension FeedbackLocal : Identifiable {

}
