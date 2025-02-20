//
//  UserPersonalInformationEntity+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by user on 1/10/25.
//
//

import Foundation
import CoreData


extension UserPersonalInformationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserPersonalInformationEntity> {
        return NSFetchRequest<UserPersonalInformationEntity>(entityName: "UserPersonalInformationEntity")
    }

    @NSManaged public var personalInfoId: Int64
    @NSManaged public var userFirstName: String?
    @NSManaged public var userLastName: String?
    @NSManaged public var familyRole: String?
    @NSManaged public var userYearOfBirth: String?
    @NSManaged public var educationalLevel: String?
    @NSManaged public var nationality: String?
    @NSManaged public var countryOfResidence: String?
    @NSManaged public var postcode: String?
    @NSManaged public var isSync: Bool

}

extension UserPersonalInformationEntity : Identifiable {

}
