//
//  LocalEntry+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 20/11/2024.
//
//

import Foundation
import CoreData


extension LocalEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalEntry> {
        return NSFetchRequest<LocalEntry>(entityName: "LocalEntry")
    }

    @NSManaged public var belongsToAFeverPhase: Bool
    @NSManaged public var entryDate: Date?
    @NSManaged public var entryId: Int64
    @NSManaged public var feverPhaseId: Int64
    @NSManaged public var feverPhaseIdOnline: Int64
    @NSManaged public var isdeleted: Bool
    @NSManaged public var isEntrySynced: Bool
    @NSManaged public var isEntryUpdated: Bool
    @NSManaged public var onlineEntryId: Int64
    @NSManaged public var profileId: Int64
    @NSManaged public var stateOfHealth: StateOfHealthLocal?
    @NSManaged public var temperature: TemperatureLocal?
    @NSManaged public var pains: PainLocal?
    @NSManaged public var liquids: LiquidsLocal?
    @NSManaged public var diarrhea: DiarrheaLocal?
    @NSManaged public var symptoms: SymptomsLocal?
    @NSManaged public var rash: RashLocal?
    @NSManaged public var warningSigns: WarningSignsLocal?
    @NSManaged public var confidenceLevel: Confidence_levelLocal?
    @NSManaged public var measures: MeasuresLocal?
    @NSManaged public var notes: NotesLocal?
    @NSManaged public var contactWithDoctor: Contact_with_doctorLocal?
    @NSManaged public var medications: MedicationsLocal?
    @NSManaged public var feverPhase: FeverPhaseLocal?
}

extension LocalEntry : Identifiable {

}
