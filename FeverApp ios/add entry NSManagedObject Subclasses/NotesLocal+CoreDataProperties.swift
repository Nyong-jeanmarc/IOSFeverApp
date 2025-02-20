//
//  NotesLocal+CoreDataProperties.swift
//  FeverApp ios
//
//  Created by NEW on 28/11/2024.
//
//

import Foundation
import CoreData


extension NotesLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotesLocal> {
        return NSFetchRequest<NotesLocal>(entityName: "NotesLocal")
    }

    @NSManaged public var isNotesSynced: Bool
    @NSManaged public var isNotesUpdated: Bool
    @NSManaged public var noteId: Int64
    @NSManaged public var notesContent: String?
    @NSManaged public var notesOtherObservations: String?
    @NSManaged public var notesTime: Date?
    @NSManaged public var onlineNotesId: Int64
    @NSManaged public var localEntry: LocalEntry?

}

extension NotesLocal : Identifiable {

}
