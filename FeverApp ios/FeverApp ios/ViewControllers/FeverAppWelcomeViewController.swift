//
//  FeverAppWelcomeViewController.swift
//  FeverApp ios
//
//  Created by user264447 on 8/8/2024


import UIKit
import CoreData

/// A view controller that manages the welcome screen of the FeverApp.
class ViewFeverAppWelcomeViewController: UIViewController {
    
    /// The UIButton that navigates to the next screen.
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var sessionID: UILabel!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    func setWelcomeText() -> NSAttributedString {
        // Get the full translation text
        let fullText = TranslationsViewModel.shared.getTranslation(key: "WELCOME.HEADING", defaultText: "Welcome to FeverApp!")

        // Split the text by "FeverApp"
        let splitText = fullText.components(separatedBy: "FeverApp")

        // Create the attributed string
        let attributedText = NSMutableAttributedString(string: splitText[0], attributes: [
            .font: UIFont.systemFont(ofSize: 25, weight: .regular),
            .foregroundColor: UIColor.white
        ])

        // Add "FeverApp" with bold style
        let boldText = NSAttributedString(string: "\nFeverApp", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 30),
            .foregroundColor: UIColor.white
        ])
        attributedText.append(boldText)

        // Append the remaining text if available
        if splitText.count > 1 {
            let remainingText = NSAttributedString(string: splitText[1], attributes: [
                .font: UIFont.systemFont(ofSize: 30, weight: .regular),
                .foregroundColor: UIColor.white
            ])
            attributedText.append(remainingText)
        }

        // Assign the attributed text to the UILabel
     return attributedText
    }
    
   // MARK: - View Lifecycle
    /// Called after the view has been loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure welcomeLabel
        welcomeLabel.numberOfLines = 0 // Allow multiple lines
        welcomeLabel.lineBreakMode = .byWordWrapping
        welcomeLabel.attributedText = setWelcomeText()

//        // Update constraints if necessary
//        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
//        ])
        navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = nil
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // configure the next button
        configureNextButton()
    }
    /// Configure the next button's appearance and action.
    private func configureNextButton() {
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
    }
    
    // MARK: - Action
    /// Handles the click event for the next UIButton.
    ///
    ///  - Parameter sender: The UIButton that was clicked.
    
    @IBAction func handleNextUIButtonClickEvent(_ sender: Any) {
        handleNavigationToChooseCountryScreen()
    }
    func fetchSessions() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()

        // Sort sessions by 'start_time' in descending order
        let sortDescriptor = NSSortDescriptor(key: "start_time", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let sessions = try context.fetch(fetchRequest)
            if let firstSession = sessions.first {
                // If a session is found, update the labels with the latest session data
                sessionID.text = "Session ID: \(firstSession.id!)"
                
            } else {
                // No sessions found, set labels to "No Data"
                sessionID.text = "No Data"
            }
        } catch {
            print("Failed to fetch sessions: \(error.localizedDescription)")
        }
    }
    /// Handles the navigation to the Choose Country Screen.
    private func handleNavigationToChooseCountryScreen() {
        // Initialize the ChooseCountryViewController from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chooseCountryVC = storyboard.instantiateViewController(withIdentifier: "ChooseCountryViewController") as? ChooseCountryViewController {
            // Navigate to the ChooseCountryViewController
            self.navigationController?.pushViewController(chooseCountryVC, animated: true)
        }
    }
}
