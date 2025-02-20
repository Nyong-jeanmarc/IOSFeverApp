//
//  GetStartViewController.swift
//  FeverApp ios
//
//  Created by NEW on 26/07/2024.
//
import UIKit
import CoreData
var defaultLanguage = ""
/// GetStartViewController  is the initial view controller that handles the user interaction for starting the app.
///  It presents the ChoooseLanguageViewController when the user taps the "Get Start" button.
class GetStartViewController: UIViewController {
    @IBOutlet var sessionId: UILabel!
    
    @IBOutlet var sessionStatus: UILabel!
    @IBOutlet var startTime: UILabel!
    
    @IBOutlet var endTime: UILabel!
    
    
    @IBOutlet var lastActivityTime: UILabel!
    /// Outlet for the "Get Start" button.
    @IBOutlet weak var startButton: UIButton!
    /// Detects the default language of the users device.
     func detectDeviceLanguage() {
        let deviceLanguageCode = Locale.preferredLanguages.first ?? "en"
        let locale = Locale(identifier: deviceLanguageCode)
         defaultLanguage = locale.localizedString(forLanguageCode: deviceLanguageCode)?.capitalized ?? "English"
         ChooseLanguageModel.shared.saveDefaultLanguage(language: defaultLanguage)
         
    }
    func generateAndSaveSessionDataID() {
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the SessionData entity
        let fetchRequest: NSFetchRequest<SessionData> = SessionData.fetchRequest()
        
        do {
            // Fetch the session data from Core Data
            let sessionDataList = try context.fetch(fetchRequest)
            
            if let sessionData = sessionDataList.first {
                // If session data exists, check if it already has a session_id
              sessionData.id = Int64()
            } else {
                // If no session data exists, create a new one and generate a ID for session Data
                let newSessionData = SessionData(context: context)
                newSessionData.id = Int64()
            }
            
            // Save the context
            try context.save()
            print("SessionData with session_id saved to Core Data")
            
        } catch {
            print("Failed to generate or save session_id: \(error)")
        }
    }

    func saveDefaultLanguageToCoreData(language: String){
        // Get the Core Data context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the SessionData entity
        let fetchRequest: NSFetchRequest<SessionData> = SessionData.fetchRequest()
        
        do {
            // Fetch the session data from Core Data
            let sessionDataList = try context.fetch(fetchRequest)
            
            if let sessionData = sessionDataList.first {
                // If session data exists, update the selected language
                sessionData.default_language = language
            } else {
                // If no session data exists, create a new one
                let newSessionData = SessionData(context: context)
                newSessionData.default_language = language
            }
            
            // Save the context
            try context.save()
            print("Selected language saved to Core Data")
            
        } catch {
            print("Failed to save selected language: \(error)")
        }
    }
    // MARK: - View Lifecycle
    
    /// Called after the view has been loaded.  Additinal setup should be done here.
    override func viewDidLoad() {
        generateAndSaveSessionDataID()
     
        super.viewDidLoad()
        // Set the default language to the device language
        detectDeviceLanguage()
    }
    func handleNavigationToChooseLanguageScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chooseLanguageVC = storyboard.instantiateViewController(withIdentifier: "ChooseLanguageViewController") as? ChooseLanguageViewController {
            self.navigationController?.pushViewController(chooseLanguageVC, animated: true)
        }
    }
    // MARK: - Action
    
    /// Action method called when the "Get Start" button is tapped.
    /// This method instantiates ans present the ChooseLanguageViewController .
    ///
    ///  - Parameter sender: The button that triggered this action.
    @IBAction func handleGetStartedUIButtonClick(_ sender: Any) {
        handleNavigationToChooseLanguageScreen()
    }

}

