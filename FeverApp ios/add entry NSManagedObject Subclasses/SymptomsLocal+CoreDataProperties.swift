//
//  SymptomsLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 25/11/2024.
//
//

import Foundation
import CoreData


extension SymptomsLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SymptomsLocal> {
        return NSFetchRequest<SymptomsLocal>(entityName: "SymptomsLocal")
    }

    @NSManaged public var isSymptomsSynced: Bool
    @NSManaged public var isSymptomsUpdated: Bool
    @NSManaged public var onlineSymptomsId: Int64
    @NSManaged public var otherSymptoms: NSObject?
    @NSManaged public var symptoms: NSObject?
    @NSManaged public var symptomsId: Int64
    @NSManaged public var symptomsTime: Date?
    @NSManaged public var localEntry: LocalEntry?

}

extension SymptomsLocal : Identifiable {

}
