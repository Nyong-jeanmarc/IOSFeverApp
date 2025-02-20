//
//  DiarrheaLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//
//

import Foundation
import CoreData


extension DiarrheaLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiarrheaLocal> {
        return NSFetchRequest<DiarrheaLocal>(entityName: "DiarrheaLocal")
    }

    @NSManaged public var diarrheaAndOrVomiting: String?
    @NSManaged public var diarrheaId: Int64
    @NSManaged public var isDiarrheaSynced: Bool
    @NSManaged public var isDiarrheaUpdated: Bool
    @NSManaged public var observationTime: Date?
    @NSManaged public var onlineDiarrheaId: Int64
    @NSManaged public var localEntry: LocalEntry?

}

extension DiarrheaLocal : Identifiable {

}
