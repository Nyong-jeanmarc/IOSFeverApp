//
//  LocalAlarm+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 30/01/2025.
//
//

import Foundation
import CoreData


extension LocalAlarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalAlarm> {
        return NSFetchRequest<LocalAlarm>(entityName: "LocalAlarm")
    }

    @NSManaged public var isReminderEnabled: Bool
    @NSManaged public var date: Date?
    @NSManaged public var time: Date?
    @NSManaged public var isAutomaticRepeatEnabled: Bool
    @NSManaged public var frequency: String?
    @NSManaged public var notificationPeriod: Date?
    @NSManaged public var end: Date?

}

extension LocalAlarm : Identifiable {

}
