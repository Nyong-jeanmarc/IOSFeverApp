//
//  VaccinationLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 23/11/2024.
//
//

import Foundation
import CoreData


extension VaccinationLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VaccinationLocal> {
        return NSFetchRequest<VaccinationLocal>(entityName: "VaccinationLocal")
    }

    @NSManaged public var isVaccinationSynced: Bool
    @NSManaged public var isVaccinationUpdated: Bool
    @NSManaged public var onlineVaccinationId: Int64
    @NSManaged public var vaccinatedLast2WeeksOrNot: String?
    @NSManaged public var vaccinationDateTime: Date?
    @NSManaged public var vaccinationId: Int64
    @NSManaged public var vaccineReceived: NSObject?
    @NSManaged public var temperature: TemperatureLocal?

}

extension VaccinationLocal : Identifiable {

}
