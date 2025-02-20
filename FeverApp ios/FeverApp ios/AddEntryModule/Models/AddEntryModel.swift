//
//  AddEntryModel.swift
//  FeverApp ios
//
//  Created by NEW on 20/11/2024.
//

import Foundation
import UIKit
class AddEntryModel  {
    static let shared = AddEntryModel()
    var entryId: Int64?
    
    func saveEntryId(entryid: Int64){
        self.entryId = entryid
        print("entry id is: \(entryid)")
    }
}
