//
//  TemperatureLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 22/11/2024.
//
//

import Foundation
import CoreData


extension TemperatureLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemperatureLocal> {
        return NSFetchRequest<TemperatureLocal>(entityName: "TemperatureLocal")
    }

    @NSManaged public var isTemperatureSynced: Bool
    @NSManaged public var isTemperatureUpdated: Bool
    @NSManaged public var onlineTemperatureId: Int64
    @NSManaged public var temperatureComparedToForehead: String?
    @NSManaged public var temperatureDateTime: Date?
    @NSManaged public var temperatureId: Int64
    @NSManaged public var temperatureMeasurementLocation: String?
    @NSManaged public var temperatureMeasurementUnit: String?
    @NSManaged public var temperatureValue: Float
    @NSManaged public var wayOfDealingWithTemperature: String?
    @NSManaged public var localEntry: LocalEntry?
    @NSManaged public var vaccination: VaccinationLocal?

}

extension TemperatureLocal : Identifiable {

}
