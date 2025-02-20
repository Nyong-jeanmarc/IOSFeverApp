//
//  UserContactInfoEntity+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by user on 1/11/25.
//
//

import Foundation
import CoreData


extension UserContactInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserContactInfoEntity> {
        return NSFetchRequest<UserContactInfoEntity>(entityName: "UserContactInfoEntity")
    }

    @NSManaged public var contactInfoId: Int64
    @NSManaged public var phonenumber: String?
    @NSManaged public var email: String?
    @NSManaged public var isSync: Bool

}

extension UserContactInfoEntity : Identifiable {

}
