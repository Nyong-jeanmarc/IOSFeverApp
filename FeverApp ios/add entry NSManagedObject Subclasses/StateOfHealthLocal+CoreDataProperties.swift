//
//  StateOfHealthLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 20/11/2024.
//
//

import Foundation
import CoreData


extension StateOfHealthLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StateOfHealthLocal> {
        return NSFetchRequest<StateOfHealthLocal>(entityName: "StateOfHealthLocal")
    }

    @NSManaged public var isStateOfHealthSynced: Bool
    @NSManaged public var isStateOfHealthUpdated: Bool
    @NSManaged public var onlineStateOfHealthId: Int64
    @NSManaged public var stateOfHealth: String?
    @NSManaged public var stateOfHealthDateTime: Date?
    @NSManaged public var stateOfHealthId: Int64
    @NSManaged public var localEntry: LocalEntry?

}

extension StateOfHealthLocal : Identifiable {

}
