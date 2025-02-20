//
//  User_pediatricians+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 09/12/2024.
//
//

import Foundation
import CoreData


extension User_pediatricians {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User_pediatricians> {
        return NSFetchRequest<User_pediatricians>(entityName: "User_pediatricians")
    }

    @NSManaged public var pediatricianId: Int64
    @NSManaged public var userId: Int64
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var streetAndHouseNumber: String?
    @NSManaged public var postalCode: Int64
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var email: String?
    @NSManaged public var reference: String?

}

extension User_pediatricians : Identifiable {

}
