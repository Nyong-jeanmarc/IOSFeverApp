//
//  SessionData+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 13/09/2024.
//
//

import Foundation
import CoreData


extension SessionData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessionData> {
        return NSFetchRequest<SessionData>(entityName: "SessionData")
    }

    @NSManaged public var id: Int64
    @NSManaged public var data_protection_agreement_accepted: Bool
    @NSManaged public var default_country: String?
    @NSManaged public var disclaimer_accepted: Bool
    @NSManaged public var intro_video_statistics: String?
    @NSManaged public var selected_country: String?
    @NSManaged public var selected_language: String?
    @NSManaged public var default_language: String?
    @NSManaged public var session_id: UUID?
    @NSManaged public var session: Session?

}

extension SessionData : Identifiable {

}
