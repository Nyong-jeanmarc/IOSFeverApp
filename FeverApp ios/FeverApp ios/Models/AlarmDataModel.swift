//
//  AlarmDataModel.swift
//  FeverApp ios
//
//  Created by NEW on 28/01/2025.
//

import Foundation
import Foundation
import UIKit
import CoreData

class AlarmDataModel {
    static let shared = AlarmDataModel()
    
    var isReminderEnabled: Bool?
    var date: Date?
    var time: Date?
    var isRepeatEnabled: Bool?
    var frequency: String?
    var notificationPeriod: Date?
    var endTime: Date?
    
    private init() {} // Private initializer to enforce singleton pattern
    
    func saveAlarmData(
        isReminderEnabled: Bool? = nil,
        date: Date? = nil,
        time: Date? = nil,
        isRepeatEnabled: Bool? = nil,
        frequency: String? = nil,
        notificationPeriod: Date? = nil,
        endTime: Date? = nil
    ) {
       self.isReminderEnabled = isReminderEnabled
       self.date = date
        self.time = time
   self.isRepeatEnabled = isRepeatEnabled
      self.frequency = frequency
   self.notificationPeriod = notificationPeriod
       self.endTime = endTime
        AlarmNetworkManager.shared.saveAlarmToLocalStorage()

    }
    func fetchLocalAlarmData() {
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
               print("Failed to get AppDelegate")
               return
           }
           
           let context = appDelegate.persistentContainer.viewContext
           let fetchRequest: NSFetchRequest<LocalAlarm> = LocalAlarm.fetchRequest()
           
           do {
               let alarms = try context.fetch(fetchRequest)
               
               if let alarm = alarms.first {
                   // Populate AlarmDataModel with retrieved values
                   self.isReminderEnabled = alarm.isReminderEnabled
                   self.date = alarm.date
                   self.time = alarm.time
                   self.isRepeatEnabled = alarm.isAutomaticRepeatEnabled
                   self.frequency = alarm.frequency
                   self.notificationPeriod = alarm.notificationPeriod
                   self.endTime = alarm.end
                   
                   print("Fetched alarm data successfully!")
               } else {
                   print("No existing alarm data found.")
               }
           } catch {
               print("Failed to fetch alarm data: \(error.localizedDescription)")
           }
       }
    func resetAlarmData() {
        isReminderEnabled = nil
        date = nil
        time = nil
        isRepeatEnabled = nil
        frequency = nil
        notificationPeriod = nil
        endTime = nil
    }
}
