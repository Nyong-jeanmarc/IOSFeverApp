//
//  Profile+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 07/10/2024.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var profileId: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var profileName: String?
    @NSManaged public var profileDateOfBirth: Date?
    @NSManaged public var profileGender: String?
    @NSManaged public var hasChronicDisease: String?
    @NSManaged public var chronicDiseases: [String]?
    @NSManaged public var profileHeight: Float
    @NSManaged public var hadFeverSeizure: String?
    @NSManaged public var profileWeight: Double
    @NSManaged public var feverPhases: Int16
    @NSManaged public var wayOfDealingWithFeverSeizures: String?
    @NSManaged public var doctorReferenceNumber: String?
    @NSManaged public var willingnessToBeRandomized: String?
    @NSManaged public var profileColor: String?
    @NSManaged public var profilePediatricianId: Int64
    @NSManaged public var feverFrequency: String?
    @NSManaged public var hasTakenAntipyretics: String?
    @NSManaged public var onlineProfileId: Int64
    @NSManaged public var isSynced: Bool

}

extension Profile : Identifiable {

}
