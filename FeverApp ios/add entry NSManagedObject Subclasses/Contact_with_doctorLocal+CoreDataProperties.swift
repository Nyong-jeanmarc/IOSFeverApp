//
//  Contact_with_doctorLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 26/11/2024.
//
//

import Foundation
import CoreData


extension Contact_with_doctorLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact_with_doctorLocal> {
        return NSFetchRequest<Contact_with_doctorLocal>(entityName: "Contact_with_doctorLocal")
    }

    @NSManaged public var contactWithDoctorId: Int64
    @NSManaged public var dateOfContact: Date?
    @NSManaged public var doctorDiagnoses: NSObject?
    @NSManaged public var doctorsPrescriptionsIssued: NSObject?
    @NSManaged public var doctorsRecommendationMeasures: String?
    @NSManaged public var hasHadMedicalContact: String?
    @NSManaged public var isContactWithDoctorSynced: Bool
    @NSManaged public var isContactWithDoctorUpdated: Bool
    @NSManaged public var onlineContactWithDoctorId: Int64
    @NSManaged public var otherDiagnosis: String?
    @NSManaged public var otherPrescriptionsIssued: String?
    @NSManaged public var otherReasonForContact: String?
    @NSManaged public var reasonForContact: NSObject?
    @NSManaged public var localEntry: LocalEntry?

}

extension Contact_with_doctorLocal : Identifiable {

}
