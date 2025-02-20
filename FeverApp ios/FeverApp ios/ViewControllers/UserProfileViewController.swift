//
//  UserProfileViewController.swift
//  FeverApp ios
//
//  Created by user on 8/20/24.
//



import UIKit
import SwiftUI

class UserProfileViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet var myView1: UIView!
    
    @IBOutlet var myView2: UIView!
    
    @IBOutlet var button1: UIButton!
    
    @IBOutlet var button2: UIButton!
    
    @IBOutlet var button3: UIButton!
    
    @IBOutlet weak var accountItem: UITabBarItem!
    @IBOutlet weak var userProfileTitle: UILabel!
    @IBOutlet weak var usersLabel: UILabel!
    @IBOutlet weak var feverphaseLabel: UILabel!
    @IBOutlet weak var entriesLabel: UILabel!
    @IBOutlet weak var usersValue: UILabel!
    @IBOutlet weak var feverphaseValue: UILabel!
    @IBOutlet weak var entriesValue: UILabel!
    
    @IBOutlet weak var deleteProfileLabel: UILabel!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        switch sender {
            case button1:
                navigateToViewController(withIdentifier: "MedicationNavigationController")
            case button2:
                navigateToViewController(withIdentifier: "personalInfo")
            case button3:
                navigateToViewController(withIdentifier: "contactInfoViewController")
            default:
                break
            }
    }
    private func navigateToViewController(withIdentifier identifier: String) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
    }

    
    var currentPage: String = "account"
    @IBAction func exportPdfTapped(_ sender: UIButton) {
        showExportPdfBottomSheet()
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func showExportPdfBottomSheet() {
        // Create the SwiftUI bottom sheet view
        let bottomSheet = ExportPdfBottomSheet(parentViewController: self)
        
        // Wrap it in a UIHostingController
        let hostingController = UIHostingController(rootView: bottomSheet.edgesIgnoringSafeArea(.bottom))
        hostingController.modalPresentationStyle = .pageSheet
        
        // Configure the bottom sheet presentation style
        if let sheet = hostingController.sheetPresentationController {
            // Calculate height as a percentage of the screen height
            let screenHeight = UIScreen.main.bounds.height
            let targetHeight = screenHeight * 0.35 // 40% of screen height
            
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return targetHeight
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        // Present the bottom sheet
        self.present(hostingController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        accountItem.title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.ACCOUNT",defaultText: "Account")
        
        userProfileTitle.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE",defaultText: "User Profile")
        usersLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.USERS", defaultText: "Users")
        feverphaseLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.FEVER.PHASES", defaultText: "Fever phases")
        entriesLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.ENTRIES",defaultText: "Entries")
        
        deleteProfileLabel.text = TranslationsViewModel.shared.getAdditionalTranslation( key: "USER.PROFILE.DELETE.PROFILE",defaultText: "Delete profile")
        
        //statistics vals
        usersValue.text = "1"
        let (feverPhaseCount, entryCount) = fetchTotalFeverPhaseAndEntryCounts()
        feverphaseValue.text = feverPhaseCount
        entriesValue.text = entryCount
        
        myView1.layer.cornerRadius = 10
                myView1.layer.masksToBounds = true
             
        myView2.layer.cornerRadius = 10
                myView2.layer.masksToBounds = true
        
        // Bouton 1
        var config = UIButton.Configuration.plain()
            config.background.backgroundColor = .white // ajout de la couleur blanche pour le background du bouton
            config.image = UIImage(named: "drug")
        config.image = config.image?.withTintColor(UIColor(red: 50/255, green: 99/255, blue: 187/255, alpha: 1.0))
            config.imagePadding = 10
        config.title = TranslationsViewModel.shared.getAdditionalTranslation(  key: "USER.PROFILE.DRUGS.LIST",defaultText: "Drugs list")
        config.baseForegroundColor = .black // titre noir
            config.titleAlignment = .leading
            config.imagePlacement = .leading // image à l'extrême gauche
        
        button1.configuration = config
        button1.contentHorizontalAlignment = .leading
            let chevronButton1 = UIButton()
            chevronButton1.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            chevronButton1.tintColor = .black // couleur noire pour le chevron
            button1.addSubview(chevronButton1)
            chevronButton1.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chevronButton1.trailingAnchor.constraint(equalTo: button1.trailingAnchor, constant: -10),
                chevronButton1.centerYAnchor.constraint(equalTo: button1.centerYAnchor)
            ])

        // Bouton 2
            config = UIButton.Configuration.plain()
            config.background.backgroundColor = .white
            config.image = UIImage(named: "user_id")
        config.image = config.image?.withTintColor(UIColor(red: 50/255, green: 99/255, blue: 187/255, alpha: 1.0))
            config.imagePadding = 10
        config.title = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.PERSONAL.INFO",defaultText: "Personal info")
        config.baseForegroundColor = .black // titre noir
            config.titleAlignment = .leading
        config.imagePlacement = .leading
            button2.configuration = config
        button2.contentHorizontalAlignment = .leading
            let chevronButton2 = UIButton()
            chevronButton2.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            chevronButton2.tintColor = .black
            button2.addSubview(chevronButton2)
            chevronButton2.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chevronButton2.trailingAnchor.constraint(equalTo: button2.trailingAnchor, constant: -10),
                chevronButton2.centerYAnchor.constraint(equalTo: button2.centerYAnchor)
            ])
         
        // Bouton 3
            config = UIButton.Configuration.plain()
            config.background.backgroundColor = .white
            config.image = UIImage(named: "call")
        config.image = config.image?.withTintColor(UIColor(red: 50/255, green: 99/255, blue: 187/255, alpha: 1.0))
            config.imagePadding = 10
        config.title = TranslationsViewModel.shared.getAdditionalTranslation( key: "USER.PROFILE.CONTACT.INFO",defaultText: "Contact info")
        config.baseForegroundColor = .black // titre noir
            config.titleAlignment = .leading
        config.imagePlacement = .leading
        button3.contentHorizontalAlignment = .leading
            button3.configuration = config
            let chevronButton3 = UIButton()
            chevronButton3.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            chevronButton3.tintColor = .black
            button3.addSubview(chevronButton3)
            chevronButton3.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chevronButton3.trailingAnchor.constraint(equalTo: button3.trailingAnchor, constant: -10),
                chevronButton3.centerYAnchor.constraint(equalTo: button3.centerYAnchor)
            ])
        setupCustomTabBar()
        
        }
    private func setupCustomTabBar() {
        let customTabBar = CustomTabBarView()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.parentViewController = self // Assign the parent view controller
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 88)
        ])
        
        customTabBar.updateTranslations()
        customTabBar.updateTabBarItemColors()
    }
        
        
           }
       
        
        
 

