//
//  AlarmNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 31/01/2025.
//

import Foundation
import UIKit
import CoreData
import UserNotifications
class AlarmNetworkManager{
static let shared = AlarmNetworkManager()
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted.")
                completion(true)
            } else {
                print("❌ Notification permission denied: \(error?.localizedDescription ?? "No error info")")
                completion(false)
            }
        }
    }

    func showPrePermissionAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "FeverApp Would Like to\n Send You Notfifications",
                                      message: "Stay updated with important reminders and alerts.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Allow", style: .default) { _ in
            self.requestNotificationPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel) { _ in
            completion(false) // User declined at the pre-alert stage
        })
        
        if let topVC = UIApplication.shared.windows.first?.rootViewController {
            topVC.present(alert, animated: true, completion: nil)
        }
    }

    func saveAlarmToLocalStorage() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Failed to get AppDelegate")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LocalAlarm> = LocalAlarm.fetchRequest()
        
        do {
            let alarms = try context.fetch(fetchRequest)
            let alarm: LocalAlarm
            
            if let existingAlarm = alarms.first {
                // Update existing alarm
                alarm = existingAlarm
            } else {
                // Create a new alarm
                alarm = LocalAlarm(context: context)
            }
            
            let sharedData = AlarmDataModel.shared
            
            alarm.isReminderEnabled = sharedData.isReminderEnabled ?? false
            alarm.date = sharedData.date
            alarm.time = sharedData.time
            alarm.isAutomaticRepeatEnabled = sharedData.isRepeatEnabled ?? false
            alarm.frequency = sharedData.frequency
            alarm.notificationPeriod = sharedData.notificationPeriod
            alarm.end = sharedData.endTime
            // Save changes
            try context.save()
            LocalNotificationManager.shared.scheduleNotification(for: alarm)
            print("Alarm saved successfully!")
          
            
        } catch {
            print("Failed to fetch or save alarm: \(error.localizedDescription)")
        }
    }
}
class LocalNotificationManager {
    
    static let shared = LocalNotificationManager()
    
    private init() {}

    func scheduleNotification(for alarm: LocalAlarm) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        guard alarm.isReminderEnabled, let date = alarm.date, let time = alarm.time else {
            return
        }

        let calendar = Calendar.current
        let notificationDate = calendar.date(bySettingHour: calendar.component(.hour, from: time),
                                             minute: calendar.component(.minute, from: time),
                                             second: 0, of: date) ?? date

        if alarm.isAutomaticRepeatEnabled {
      print("scheduled repeat notification for: \(formattedDate(notificationDate))")
            scheduleRepeatedNotifications(from: notificationDate, alarm: alarm)
        } else {
            print("scheduled single notification for: \(formattedDate(notificationDate))")
            scheduleSingleNotification(at: notificationDate)
            print("Date: \(formattedDate(notificationDate))")
        }
    }
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    private func scheduleSingleNotification(at date: Date) {
        // Clear all previous notification requests
           UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = createNotificationContent()
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    private func scheduleRepeatedNotifications(from startDate: Date, alarm: LocalAlarm) {
        // Clear all previous notification requests
           UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        guard let frequency = alarm.frequency,
              let periodEnd = alarm.end else { return }
        
        let interval = getFrequencyInterval(frequency) // In seconds
        let calendar = Calendar.current
        let notificationPeriodStart = alarm.notificationPeriod ?? startDate
        
        // Adjust the first notification time to align with the notificationPeriodStart
        var nextNotificationTime = startDate
        if nextNotificationTime < notificationPeriodStart {
            nextNotificationTime = calendar.date(
                bySettingHour: calendar.component(.hour, from: notificationPeriodStart),
                minute: calendar.component(.minute, from: notificationPeriodStart),
                second: 0,
                of: nextNotificationTime
            ) ?? startDate
        }
        
        // Align the next notification time to the specified frequency
        while nextNotificationTime < notificationPeriodStart ||
              nextNotificationTime.timeIntervalSince(notificationPeriodStart).truncatingRemainder(dividingBy: interval) != 0 {
            nextNotificationTime = nextNotificationTime.addingTimeInterval(interval)
        }

        // Schedule notifications until the periodEnd
        let content = createNotificationContent()
        
        // Trigger for the next notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        
        // Create and add the notification request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            }
        }
    }
    private func createNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.1", defaultText: "Reminder")
        content.body = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.NOTIFICATION.TEXT", defaultText: "Alarm clock: Check your child's fever!")
        content.sound = .default
        return content
    }

    private func getFrequencyInterval(_ frequency: String) -> TimeInterval {
        let intervalMapping: [String: TimeInterval] = [
            "Every minute": 60, // 60 seconds
            "Hourly": 3600,     // 1 hour = 3600 seconds
            "every 2 hours": 7200,
            "every 3 hours": 10800,
            "every 4 hours": 14400,
            "every 5 hours": 18000,
            "every 6 hours": 21600,
            "every 7 hours": 25200,
            "every 8 hours": 28800,
            "every 9 hours": 32400,
            "every 10 hours": 36000,
            "every 11 hours": 39600,
            "every 12 hours": 43200,
            "every 24 hours": 86400,
            "every 48 hours": 172800
        ]
        return intervalMapping[frequency] ?? 3600 // Default to hourly (3600 seconds)
    }
    
    /// Schedule notifications at 28 hours and 48 hours intervals
       func scheduleReminderNotifications(startingFrom date: Date) {
           let notificationCenter = UNUserNotificationCenter.current()
           
           // Cancel existing notifications to avoid duplication
           cancelNotifications()
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let profileName = appDelegate.fetchProfileName()!
           // Notification 1: 28 hours
           let content28 = createNotificationContent(
            title: TranslationsViewModel.shared.getTranslation(key: "LOOP.REMINDER.CHILD_RECOVERED.TITLE", defaultText: "Healthy again?"),
            body: TranslationsViewModel.shared.getTranslation(key: "LOOP.REMINDER.CHILD_RECOVERED.TEXT", defaultText: "You haven't reported for a while? Is {{name}} fit again?").replacingOccurrences(of: "{{name}}", with: profileName)
           )
           let trigger28 = UNTimeIntervalNotificationTrigger(timeInterval: 24 * 60 * 60, repeats: false)
           let request28 = UNNotificationRequest(identifier: "Notification28Hours", content: content28, trigger: trigger28)
           
           // Notification 2: 48 hours
           let content48 = createNotificationContent(
               title: TranslationsViewModel.shared.getTranslation(key: "LOOP.REMINDER.CHILD_RECOVERED.TITLE", defaultText: "Healthy again?"),
               body: TranslationsViewModel.shared.getTranslation(key: "LOOP.REMINDER.CHILD_RECOVERED.TEXT", defaultText: "You haven't reported for a while? Is {{name}} fit again?").replacingOccurrences(of: "{{name}}", with: profileName)
           )
           let trigger48 = UNTimeIntervalNotificationTrigger(timeInterval: 48 * 60 * 60, repeats: false)
           let request48 = UNNotificationRequest(identifier: "Notification48Hours", content: content48, trigger: trigger48)
           
           // Add requests
           notificationCenter.add(request28) { error in
               if let error = error {
                   print("Failed to schedule 28-hour notification: \(error.localizedDescription)")
               }
           }
           notificationCenter.add(request48) { error in
               if let error = error {
                   print("Failed to schedule 48-hour notification: \(error.localizedDescription)")
               }
           }
       }
       
       /// Cancel all scheduled notifications
       func cancelNotifications() {
           let notificationCenter = UNUserNotificationCenter.current()
           notificationCenter.removePendingNotificationRequests(withIdentifiers: ["Notification28Hours", "Notification48Hours"])
       }
       
       /// Reset the waiting time by rescheduling the notifications
       func resetNotificationSchedule() {
           scheduleReminderNotifications(startingFrom: Date())
       }
       
       /// Create notification content
       private func createNotificationContent(title: String, body: String) -> UNNotificationContent {
           let content = UNMutableNotificationContent()
           content.title = title
           content.body = body
           content.sound = .default
           return content
       }
    func checkAndScheduleNotificationsForUnlinkedEntries() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate not available")
            return
        }
        
        let profileId = appDelegate.fetchProfileId() // Fetch the current profile ID
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "belongsToAFeverPhase == nil OR belongsToAFeverPhase == false"),
            NSPredicate(format: "profileId == %d", profileId!)
        ])
        
        do {
            let unlinkedEntries = try context.fetch(fetchRequest)
            
            if !unlinkedEntries.isEmpty {
                // Schedule notifications if there is at least one unlinked entry
                LocalNotificationManager.shared.scheduleReminderNotifications(startingFrom: Date())
                print("Scheduled notifications for unlinked entries.")
            } else {
                print("No unlinked entries found.")
            }
        } catch {
            print("Failed to fetch unlinked entries: \(error.localizedDescription)")
        }
    }
}
