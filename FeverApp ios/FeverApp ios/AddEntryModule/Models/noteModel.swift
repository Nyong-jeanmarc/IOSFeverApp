//
//  noteModel.swift
//  FeverApp ios
//
//  Created by NEW on 28/11/2024.
//

import Foundation
import UIKit
import CoreData
class noteModel{
    static let shared = noteModel()
    var editedNoteObject: NotesLocal?
    var noteId : Int64?
    var noteContent : String?
    var otherNotes : String?
    var noteDate : Date?
    private var isEditingEntry: Bool = false
     var initialNote: (content: String?, otherNotes: String?, date: Date?)?
    /// Set editing state
       func setEditingState(isEditing: Bool) {
           self.isEditingEntry = isEditing
           if isEditing {
               // Fetch the local note object being edited to save its initial values
               self.editedNoteObject = noteNetworkManager.shared.fetchEditingNoteLocal(byId: noteId!)
               // Save initial values for comparison later
               initialNote = (
                   content: editedNoteObject?.notesContent,
                   otherNotes: editedNoteObject?.notesOtherObservations,
                   date: editedNoteObject?.notesTime
               )
           } else {
               // Reset initial state
               initialNote = nil
           }
       }
    func saveNoteId(id : Int64){
        self.noteId = id
    }
    func saveNoteContent(note: String,completion: @escaping (Bool) -> Void){
        self.noteContent = note
        // Compare with initial value if editing
               if isEditingEntry, let initial = initialNote, initial.content != note {
                   markNoteUpdated()
               }
        noteNetworkManager.shared.updateNoteContent(withId: noteId!, newContent: note){ isSaved in
            if isSaved{
                completion(true)
            }else{
               completion(false)
            }
            
        }
    }
    func saveOtherNotes(other : String ,completion: @escaping (Bool) -> Void){
        self.otherNotes = other
        // Compare with initial value if editing
             if isEditingEntry, let initial = initialNote, initial.otherNotes != other {
                 markNoteUpdated()
             }
        noteNetworkManager.shared.updateOtherNoteContent(withId: noteId!, newContent: other){isSaved in
            if isSaved {
                completion(true)
            }else{
             completion(false)
            }
        }
    }
    func saveNoteDate(date: Date,completion: @escaping (Bool) -> Void){
        self.noteDate = date
        // Compare with initial value if editing
             if isEditingEntry, let initial = initialNote, initial.date != date {
                 markNoteUpdated()
             }
        noteNetworkManager.shared.updateNoteDate(withId: noteId!, newDate: date){isSaved in
            if isSaved {
                completion(true)
            }else{
              completion(false)
            }
        }
    }
    /// Mark note and associated entry as updated
     private func markNoteUpdated() {
         UpdateNoteNetworkManager.shared.markNoteUpdated(noteId: self.noteId!)
     }
}
