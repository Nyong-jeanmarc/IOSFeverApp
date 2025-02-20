//
//  AppDelegate.swift
//  FeverApp ios
//
//  Created by NEW on 15/07/2024.
//

import UIKit
import CoreData
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "coreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
 
    func endCurrentSession() {
        let context = persistentContainer.viewContext
        
        // Fetch the active session
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "status == %@", "ACTIVE") // Fetch only sessions with 'ACTIVE' status
        
        do {
            if let activeSession = try context.fetch(fetchRequest).first {
                // Update the end time to current date and time
                activeSession.end_time = Date()
                activeSession.status = "ENDED" // Update the status to 'ENDED'
                
                // Save the context with the updated session
                try context.save()
                print("Session ended successfully!")
            } else {
                print("No active session found to end.")
            }
        } catch {
            print("Failed to end session: \(error.localizedDescription)")
        }
    }
    func fetchData() -> [NSManagedObject] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        do {
            let objects = try context.fetch(request)
            return objects
        } catch {
            fatalError("Error fetching data")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
     
        // Print the app's documents directory
        if let appDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print("\n\n\nApp Directory: \(appDirectory)\n\n\n")
        }
        // Set Notification Center Delegate
               UNUserNotificationCenter.current().delegate = self
        // Override point for customization after application launch.
       
        sessionNetworkManager.shared.CreateSession { sessionID in
            sessionNetworkManager.shared.saveSessionLocally(sesionID: sessionID)
            }
        
        if let directoryLocation = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {             print("Documents Directory: \(directoryLocation)Application Support")         }
        
        //initializing translations
        AppUtils.loadSupportedLanguages()
        let userLanguageData = fetchUserLanguage()
        if let languageCode = userLanguageData.0, let currentLanguage = userLanguageData.1  {
            TranslationsViewModel.shared.loadTranslations(languageCode: languageCode)
            print("Language Code: \(languageCode), Current Language: \(currentLanguage)")
        } else {
            // Default to English if no language is saved
            TranslationsViewModel.shared.loadTranslations(languageCode: "en")
        }
        
        return true
    }
    // Handle Notifications While App is Open
      func userNotificationCenter(
          _ center: UNUserNotificationCenter,
          willPresent notification: UNNotification,
          withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
      ) {
          completionHandler([.banner, .sound, .badge])  // Show notification as banner & play sound
      }
    func applicationWillTerminate(_ application: UIApplication) {
        endCurrentSession()
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // Save userId and familyCode
    func saveUserData(userId: Int64, familyCode: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let existingUser = try context.fetch(fetchRequest).first {
                existingUser.userId = userId
                existingUser.familyCode = familyCode
            } else {
                let newUser = UserDataEntity(context: context)
                newUser.userId = userId
                newUser.familyCode = familyCode
            }
            try context.save()
            print("User data saved successfully!")
        } catch {
            print("Failed to save user data: \(error.localizedDescription)")
        }
    }

    // Fetch userId and familyCode
    func fetchUserData() -> (userId: Int64?, familyCode: String?) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                return (userData.userId, userData.familyCode)
            }
        } catch {
            print("Failed to fetch user data: \(error.localizedDescription)")
        }
        return (nil, nil)
    }

    // Clear user data (logout scenario)
    func clearUserData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                context.delete(userData)
                try context.save()
                print("User data cleared successfully.")
            }
        } catch {
            print("Failed to clear user data: \(error.localizedDescription)")
        }
    }
    // Save language code and current language
    func saveUserLanguage(languageCode: String, currentLanguage: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                userData.languageCode = languageCode
                userData.currentLanguage = currentLanguage
            } else {
                let newUser = UserDataEntity(context: context)
                newUser.languageCode = languageCode
                newUser.currentLanguage = currentLanguage
            }
            try context.save()
            print("User language saved successfully!")
        } catch {
            print("Failed to save user language: \(error.localizedDescription)")
        }
    }

    // Fetch language code and current language
    func fetchUserLanguage() -> (languageCode: String?, currentLanguage: String?) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                return (userData.languageCode, userData.currentLanguage)
            }
        } catch {
            print("Failed to fetch user language: \(error.localizedDescription)")
        }
        return (nil, nil)
    }

    //save profile name to core data
    func saveProfileName(profileName: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                userData.profileName = profileName
            } else {
                let newUser = UserDataEntity(context: context)
                newUser.profileName = profileName
            }
            try context.save()
            print("Profile name saved successfully!")
        } catch {
            print("Failed to save profile name: \(error.localizedDescription)")
        }
    }
//Fetch profile name
    func fetchProfileName() -> String? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                return userData.profileName
            }
        } catch {
            print("Failed to fetch profile name: \(error.localizedDescription)")
        }
        return nil
    }
    
    //Save profile gender
    func saveProfileGender(profileGender: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                userData.profileGender = profileGender
            } else {
                let newUser = UserDataEntity(context: context)
                newUser.profileGender = profileGender
            }
            try context.save()
            print("Profile gender saved successfully!")
        } catch {
            print("Failed to save profile gender: \(error.localizedDescription)")
        }
    }
//fetch profile gender
    func fetchProfileGender() -> String? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                return userData.profileGender
            }
        } catch {
            print("Failed to fetch profile gender: \(error.localizedDescription)")
        }
        return nil
    }
    
    //Save profile date of birth
    func saveProfileDateOfBirth(profileDateOfBirth: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                userData.profileDateOfBirth = profileDateOfBirth
            } else {
                let newUser = UserDataEntity(context: context)
                newUser.profileDateOfBirth = profileDateOfBirth
            }
            try context.save()
            print("Profile date of birth saved successfully!")
        } catch {
            print("Failed to save profile date of birth: \(error.localizedDescription)")
        }
    }
//fetch profile date of birth
    func fetchProfileDateOfBirth() -> String? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                return userData.profileDateOfBirth
            }
        } catch {
            print("Failed to fetch profile date of birth: \(error.localizedDescription)")
        }
        return nil
    }
    
    //save profileId
    func saveProfileId(profileId: Int64) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                userData.profileId = profileId
            } else {
                let newUser = UserDataEntity(context: context)
                newUser.profileId = profileId
            }
            try context.save()
            print("Profile ID saved successfully!")
        } catch {
            print("Failed to save profile ID: \(error.localizedDescription)")
        }
    }
//fetch profile id
    func fetchProfileId() -> Int64? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                return userData.profileId
            }
        } catch {
            print("Failed to fetch profile ID: \(error.localizedDescription)")
        }
        return nil
    }
    
    //Save profile online id
    func saveProfileOnlineId(profileOnlineId: Int64) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                userData.profileOnlineId = profileOnlineId
            } else {
                let newUser = UserDataEntity(context: context)
                newUser.profileOnlineId = profileOnlineId
            }
            try context.save()
            print("Profile online ID saved successfully!")
        } catch {
            print("Failed to save profile online ID: \(error.localizedDescription)")
        }
    }

    func fetchProfileOnlineId() -> Int64? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserDataEntity> = UserDataEntity.fetchRequest()

        do {
            if let userData = try context.fetch(fetchRequest).first {
                return userData.profileOnlineId
            }
        } catch {
            print("Failed to fetch profile online ID: \(error.localizedDescription)")
        }
        return nil
    }
    
    func recreateApp() {
        guard let window = UIApplication.shared.windows.first else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootViewController = storyboard.instantiateInitialViewController() {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
            
            // Optional: Add a transition animation
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}

