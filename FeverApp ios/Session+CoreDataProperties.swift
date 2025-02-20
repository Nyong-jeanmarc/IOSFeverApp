//
//  Session+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 14/09/2024.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var end_time: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var last_activity_time: Date?
    @NSManaged public var start_time: Date?
    @NSManaged public var status: String?
    @NSManaged public var sessionData: SessionData?

}

extension Session : Identifiable {

}
