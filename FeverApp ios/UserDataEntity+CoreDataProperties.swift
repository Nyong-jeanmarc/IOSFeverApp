//
//  UserDataEntity+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by user on 12/1/24.
//
//

import Foundation
import CoreData


extension UserDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDataEntity> {
        return NSFetchRequest<UserDataEntity>(entityName: "UserDataEntity")
    }

    @NSManaged public var currentLanguage: String?
    @NSManaged public var familyCode: String?
    @NSManaged public var languageCode: String?
    @NSManaged public var userId: Int64
    @NSManaged public var profileId: Int64
    @NSManaged public var profileName: String?
    @NSManaged public var profileGender: String?
    @NSManaged public var profileDateOfBirth: String?
    @NSManaged public var profileOnlineId: Int64

}

extension UserDataEntity : Identifiable {

}
