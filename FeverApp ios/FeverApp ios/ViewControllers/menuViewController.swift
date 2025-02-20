//
//  menuViewController.swift
//  FeverApp ios
//
//  Created by user on 8/23/24.
//

import UIKit
import SwiftUI

class MenuViewController: UIViewController,  UIDocumentInteractionControllerDelegate{
    
    @IBOutlet var views: [UIView]!
    
    @IBOutlet var button: UIView!
    
    private var exportBottomSheetVC: UIViewController!
    private var exportButton: UIButton!
    
    //The menu cards
    @IBOutlet weak var settingCard: UIView!
    @IBOutlet weak var emergencyContactCard: UIView!
    @IBOutlet weak var dataProtectionCard: UIView!
    @IBOutlet weak var disclaimerCard: UIView!
    @IBOutlet weak var aboutFeverAppCard: UIView!
    @IBOutlet weak var contactAndWedsiteCard: UIView!
    @IBOutlet weak var giveFeedbackCard: UIView!
    @IBOutlet weak var documentFeverCrampsCard: UIView!
    @IBOutlet weak var tourCard: UIView!
    
    //The menu texts
    @IBOutlet weak var emergencyContactLabel: UILabel!
    @IBOutlet weak var moreTitle: UILabel!
    @IBOutlet weak var dataProtectionLabel: UILabel!
    @IBOutlet weak var disclaimerOfLiabilityLabel: UILabel!
    @IBOutlet weak var aboutFeverAppLabel: UILabel!
    @IBOutlet weak var contactAndWebsiteLabel: UILabel!
    @IBOutlet weak var giveFeedbackLabel: UILabel!
    @IBOutlet weak var documentFeverCrampsLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var tourLabel: UILabel!
    
    
    
    
    
    @IBAction func exportPdfButton(_ sender: Any) {
        showExportPdfBottomSheet()
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func addShadowToViews(){
        for aview in views{
            aview.layer.shadowColor = UIColor.lightGray.cgColor
            aview.layer.shadowOpacity = 0.8
            aview.layer.shadowRadius = 5
            aview.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
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
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.8
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        addShadowToViews()
        // Add tap gestures to each card using tags
        addTapGesture(to: settingCard, tag: 8)
        addTapGesture(to: emergencyContactCard, tag: 1)
        addTapGesture(to: dataProtectionCard, tag: 2)
        addTapGesture(to: disclaimerCard, tag: 3)
        addTapGesture(to: aboutFeverAppCard, tag: 4)
        addTapGesture(to: contactAndWedsiteCard, tag: 5)
        addTapGesture(to: giveFeedbackCard, tag: 6)
        addTapGesture(to: documentFeverCrampsCard, tag: 7)
        addTapGesture(to: tourCard, tag: 9)
        
        //Label translations
        emergencyContactLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.EMERGENCY", defaultText: "Emergency contact information")
        
        moreTitle.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.MORE", defaultText: "More")
        
        dataProtectionLabel.text = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TITLE", defaultText: "Data protection")
        
        disclaimerOfLiabilityLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.DISCLAIMER", defaultText: "Disclaimer of liability")
        
        aboutFeverAppLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.ABOUT", defaultText: "About FeverApp")
        
        contactAndWebsiteLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.CONTACT", defaultText: "Contact & Website")
        
        giveFeedbackLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.FEEDBACK", defaultText: "Give feedback")
        
        documentFeverCrampsLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.FEVER_SEIZURE", defaultText: "Document fever cramps")
        settingsLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "SETTINGS.SETTING", defaultText: "Settings")
        
        tourLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.TUTORIAL", defaultText: "Tour")
        
        
        
        
        
        
        
        
        
        setupCustomTabBar()
    }

    let customTabBar = CustomTabBarView()
    private func setupCustomTabBar() {
        
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
    // Helper function to add a tap gesture recognizer
    private func addTapGesture(to view: UIView, tag: Int) {
        view.tag = tag
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc func handleCardTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        switch tappedView.tag {
        case 1:
            navigateToViewController(withIdentifier: "emergencyContact")
        case 8:
            navigateToViewController(withIdentifier: "settingViewController")
        case 2:
            navigateToViewController(withIdentifier: "moreDataProtectionViewController")
        case 3:
            navigateToViewController(withIdentifier: "DisclaimerOfLiaViewController")
        case 4:
            navigateToViewController(withIdentifier: "aboutFeverAppViewController")
        case 5:
            navigateToViewController(withIdentifier: "contactUsViewController")
        case 6:
            navigateToViewController(withIdentifier: "giveFeedbackViewController")
        case 7:
            navigateToViewController(withIdentifier: "documentFeverCrampsViewController")
        case 9:
            navigateToViewController(withIdentifier: "overview")
            
            
        default:
            break
        }
    }
    
    
    // Helper function to navigate to a view controller
    private func navigateToViewController(withIdentifier identifier: String) {
        // Reset shouldShowTour to false after showing the tour
        UserDefaults.standard.set(true, forKey: "shouldShowTour")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        // Check if the instantiated view controller is of the type that has a callback
            if let viewController = viewController as? giveFeedbackViewController {
                // Assign the callback
                viewController.moveToOverView = {
                    self.customTabBar.navigateToViewController(from: self, withIdentifier: "overview")
                       }
                }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }

}

// Export Bottom Sheet SwiftUI View
struct ExportPdfBottomSheet: View {
    @Environment(\.dismiss) var dismiss
    let parentViewController: UIViewController
    
    @StateObject private var exportPDFViewModel = ExportPDFViewModel()
    @State private var isChecked = false
    @State private var showDialog = false
    @State private var selectedFeverPhases: [String] = []
    
   @State private var feverPhaseList: [(key: String, displayText: String)] = [] // Dynamically updated
    
    @State private var filteredFeverPhases: [FeverPhaseGraph] = []
    @State private var isLoading = false

    let profileId: Int64 = 1
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text(TranslationsViewModel.shared.getTranslation(key: "DIARY.PDF_EXPORT.HEADER", defaultText: "Export fever phases as PDF"))
                    .font(.headline)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Message
            if !feverPhaseList.isEmpty {
                Text(TranslationsViewModel.shared.getTranslation(key: "DIARY.PDF_EXPORT.MESSAGE", defaultText: "Please choose the fever phases that you would like to export"))
                    .font(.subheadline)
                    .padding(.horizontal)
            }
            
            // Conditional Display: Show list or message if empty
            if feverPhaseList.isEmpty {
                // Display message when list is empty
                Text(TranslationsViewModel.shared.getAdditionalTranslation(key: "SETTINGS.EXPORT.FEVERPHASE.TEXT2", defaultText: "No fever phases to export.\nPlease create an entry to export by clicking on the '+' icon on the profile card on the overview screen."))
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical)
            } else {
                // Display fever phase list
                List(feverPhaseList, id: \.key) { phase in
                    HStack {
                        Button(action: {
                            toggleSelection(phaseKey: phase.key)
                        }) {
                            Image(systemName: selectedFeverPhases.contains(phase.key) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(selectedFeverPhases.contains(phase.key) ? Color(red: 0.631, green: 0.761, blue: 0.988) : .gray)
                                .imageScale(.small) // Reduce icon size
                        }
                        Text(phase.displayText)
                            .font(.system(size: 14)) // Set smaller text size
                    }
                }
                .listStyle(PlainListStyle())
            }

            // Action Buttons
            HStack(spacing: 8) {
                // Cancel Button
                Button(action: {
                    dismiss()
                }) {
                    Text(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CANCEL", defaultText: "Cancel"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .font(.system(size: 14, weight: .regular))
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                .frame(height: 36)
                
                // Export Button
                Button(action: {
                    if !selectedFeverPhases.isEmpty {
                        let appDelegate = UIApplication.shared.delegate as? AppDelegate
                        let profileName = appDelegate!.fetchProfileName()
                        let profileGender = appDelegate!.fetchProfileGender()
                        let profileDob = appDelegate!.fetchProfileDateOfBirth()
                        let (_, familyCode) = appDelegate!.fetchUserData()

                        let profile = ProfilePdfData(profileName: profileName!, profileGender: profileGender!, profileDateOfBirth: profileDob!, familyCode: familyCode!)

                        // Fetch filtered fever phases and generate the PDF after completion
                        fetchFilteredFeverPhases { success in
                            if success {
                                exportPDFViewModel.generateAndSavePdf(profile: profile, feverPhases: filteredFeverPhases, context: parentViewController) {
                                    dismiss()
                                }
                            } else {
                                print("Failed to fetch filtered fever phases.")
                            }
                        }
                    }
                }) {
                    Text(TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.EXPORT", defaultText: "Eport"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .font(.system(size: 14, weight: .regular))
                        .background(selectedFeverPhases.isEmpty ? Color.gray : Color(red: 0.631, green: 0.761, blue: 0.988))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .frame(height: 36)
                .disabled(selectedFeverPhases.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
        .background(Color.white)
        .sheet(isPresented: $showDialog) {
            ExportConfirmationDialog()
        }        .onAppear {
            fetchFeverPhases()
        }
    }
    
    // Fetch Fever Phases
       private func fetchFeverPhases() {
           isLoading = true
           
           DispatchQueue.global(qos: .background).async {
               let repository = FeverPhaseRepository.shared
               var isLoadingFlag = false
               let appDelegate = UIApplication.shared.delegate as? AppDelegate
               let profileID = appDelegate?.fetchProfileId()
               let feverPhases = repository.getAllProfileFeverPhases(profileId: profileID!, isLoading: &isLoadingFlag)
               
               // Map fever phases to tuples with key and display text
               let feverPhaseTuples = feverPhases.map { phase in
                   (
                       key: phase.key,
                       displayText: phase.key == "0" ?
                           TranslationsViewModel.shared.getAdditionalTranslation(key: "OVERVIEW.FEVERPHASE", defaultText: "Ongoing fever phase") :
                           "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARY-CHART.TEXT.1", defaultText: "Fever phase")) \(phase.feverPhaseStartDate) - \(phase.feverPhaseEndDate)"
                   )
               }
               
               DispatchQueue.main.async {
                   self.feverPhaseList = feverPhaseTuples
                   self.isLoading = false
               }
           }
       }
    
    // Fetch Filtered Fever Phases
    private func fetchFilteredFeverPhases(completion: @escaping (Bool) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        let profileID = appDelegate.fetchProfileId() ?? 0
        let selectedPhaseIDs = selectedFeverPhases.compactMap { Int64($0) }
        
        isLoading = true
        FeverPhaseRepository.shared.getFilteredFeverPhases(profileId: profileID, selectedFeverPhaseIds: selectedPhaseIDs) { filteredPhases, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    print("Error fetching filtered fever phases: \(error.localizedDescription)")
                    completion(false)
                } else if let phases = filteredPhases {
                    self.filteredFeverPhases = phases
                    print("\n\n\nFiltered fever phases: \(phases)")
                    print("\n\n\nFiltered fever phases variable: \(filteredFeverPhases)")
                    completion(true)
                }
            }
        }
    }

       
       // Toggle selection
       private func toggleSelection(phaseKey: String) {
           if selectedFeverPhases.contains(phaseKey) {
               selectedFeverPhases.removeAll { $0 == phaseKey }
           } else {
               selectedFeverPhases.append(phaseKey)
           }
           print("Selected fever phase IDs: \(selectedFeverPhases)")
       }
}

// Confirmation Dialog View
struct ExportConfirmationDialog: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Exporting PDF...")
                .font(.headline)
                .padding()
            Button("Close") {
                dismiss()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}
