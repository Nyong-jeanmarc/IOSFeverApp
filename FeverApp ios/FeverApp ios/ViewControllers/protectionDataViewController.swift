//
//  protectionData.swift
//  FeverApp ios
//
//  Created by user on 8/1/24.
//

import UIKit
import CoreData
class protectionDataViewController: UIViewController {
    
    
    @IBOutlet weak var dataProtectionLabel: UILabel!
    
    var usersDataProtectionAndDisclaimerAcceptance = false
        let protectionDataButton = UIButton(type: .system)
        let protectionDataIcon = UIImageView(image: UIImage(named: "ic_data"))
        let chevron1 = UIImageView(image: UIImage(systemName: "chevron.down"))
        let subtitleLabel1 = UILabel()
        let textView1 = UITextView()
        let containerView1 = UIView()

        let disclaimerButton = UIButton(type: .system)
        let disclaimerIcon = UIImageView(image: UIImage(named: "ic_data"))
        let chevron2 = UIImageView(image: UIImage(systemName: "chevron.down"))
        let subtitleLabel2 = UILabel()
        let textView2 = UITextView()
        let containerView2 = UIView()

        var isExpanded1 = false
        var isExpanded2 = false
        var containerHeightConstraint1: NSLayoutConstraint!
        var containerHeightConstraint2: NSLayoutConstraint!
        var containerTopConstraint2: NSLayoutConstraint!
        let expandedHeight: CGFloat = 300  // Desired height when expanded
        
        
        let checkbox1 = UIButton(type: .custom)
        let checkbox2 = UIButton(type: .custom)
        let label1 = UILabel()
        let label2 = UILabel()
        let nextButton = UIButton(type: .system)
        let ContainerView = UIView()  // New gray container view

    func configureTextView(textView: UITextView, text: String, boldPhrases: [String]) {
        let attributedString = NSMutableAttributedString(string: text)
        
        for phrase in boldPhrases {
            let range = (text as NSString).range(of: phrase)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: range)
        }
        
        textView.attributedText = attributedString
    }

let selectedLanguage = ChooseLanguageModel.shared.selectedLanguage
    func getDynamicDataProtectionText() ->  NSAttributedString {
        let translations = TranslationsViewModel.shared

        // Helper function to create bold text
        func bold(_ text: String) -> NSAttributedString {
            return NSAttributedString(string: text, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        }

        // Helper function to create normal text
        func normal(_ text: String) -> NSAttributedString {
            return NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 14)])
        }

        // Create attributed strings for each section
        let heading1 = bold(translations.getTranslation(key: "PRIVACY.HEADING.1", defaultText: "Introduction to data protection:"))
        let text1 = normal(translations.getTranslation(key: "PRIVACY.TEXT.1", defaultText: "The FeverApp is an instrument of a register study on behalf of the Federal Ministry of Education and Research (BMBF) under the direction of the pediatrician Prof. Dr. med. David Martin from the University of Witten/Herdecke."))

        let heading2 = bold(translations.getTranslation(key: "PRIVACY.HEADING.2", defaultText: "Anonymity:"))
        let text2 = normal(translations.getTranslation(key: "PRIVACY.TEXT.9", defaultText: "Your family code, as well as the optionally provided mobile phone number and email, is personally identifiable. However, only the FeverApp team has access to this personal data."))

        let heading3 = bold(translations.getTranslation(key: "PRIVACY.HEADING.3", defaultText: "Voluntariness:"))
        let text3 = normal(translations.getTranslation(key: "PRIVACY.TEXT.10", defaultText: "The use of the FeverApp is voluntary at any time. If you do not answer certain questions or stop using the app, you will not experience any disadvantages."))

        let heading4 = bold(translations.getTranslation(key: "PRIVACY.HEADING.4", defaultText: "Storage duration:"))
        let text4 = normal(translations.getTranslation(key: "PRIVACY.TEXT.11", defaultText: "Your identifying data will be stored offline for a maximum of 20 years for research purposes on an external, locked, and encrypted data carrier and protected from unauthorized access."))

        let heading5 = bold(translations.getTranslation(key: "PRIVACY.HEADING.5", defaultText: "Your children's consent:"))
        let text5 = normal(translations.getTranslation(key: "PRIVACY.TEXT.12", defaultText: "If one of your children is older than 13 years, you must ask for their consent before using the app for that child."))

        let heading6 = bold(translations.getTranslation(key: "PRIVACY.HEADING.6", defaultText: "Possibility of revocation and deletion:"))
        let text6 = getAttributedString(translations.getTranslation(key: "PRIVACY.TEXT.13", defaultText: "You have the option of revoking and deleting all data yourself. Contact us by email (info@feverapp.de) or by phone (02302 926 38080)."))

        let heading7 = bold(translations.getTranslation(key: "PRIVACY.HEADING.7", defaultText: "Collection of smartphone data:"))
        let text7 = normal(translations.getTranslation(key: "PRIVACY.TEXT.14", defaultText: "Only the device manufacturer and model are recorded to identify possible errors. No motion information is stored."))

        let heading8 = bold(translations.getTranslation(key: "PRIVACY.HEADING.8", defaultText: "Summary:"))
        let text8 = getAttributedString(translations.getTranslation(key: "PRIVACY.TEXT.15", defaultText: "If you have any questions, you can contact the FeverApp support team at any time by email at info@feverapp.de or by phone at 02302 926 38080."))

        // Combine all attributed strings
        let combinedText = NSMutableAttributedString()
        combinedText.append(heading1)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(text1)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(heading2)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(text2)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(heading3)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(text3)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(heading4)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(text4)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(heading5)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(text5)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(heading6)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(text6)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(heading7)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(text7)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(heading8)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(text8)

        return combinedText
    }
    func getDynamicDisclaimerText() -> NSAttributedString {
        let translations = TranslationsViewModel.shared

        // Helper function to create bold text
        func bold(_ text: String) -> NSAttributedString {
            return NSAttributedString(string: text, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
        }

        // Helper function to create normal text
        func normal(_ text: String) -> NSAttributedString {
            return NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 14)])
        }

        // Get translated strings
        let heading1 = bold(translations.getTranslation(key: "PRIVACY.HEADING.2", defaultText: "Introduction to data protection:"))
        let warningText = getAttributedString(translations.getTranslation(key: "WARNING.TEXT", defaultText: "You are responsible for the use of the FeverApp. The FeverApp serves to support the doctor-patient relationship, the app does not give individual advice. The app and the corresponding websites only give general recommendations. These reflect the current state of science. However, medical knowledge is subject to constant change. If you have any medical questions, please contact a doctor. Especially if your child has a chronic illness or other conditions that are detrimental to the child's fever, you should consult your doctor before using this app."))

        // Combine attributed strings
        let combinedText = NSMutableAttributedString()
        combinedText.append(heading1)
        combinedText.append(NSAttributedString(string: "\n\n"))
        combinedText.append(warningText)

        return combinedText
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
         
            setupUI()
            nextButton.isEnabled = false
            navigationItem.hidesBackButton = true
                navigationItem.leftBarButtonItem = nil
                navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            // Add border radius
            nextButton.layer.cornerRadius = 10 // Set your desired radius
            nextButton.layer.masksToBounds = true // Ensure the corners are clipped


            // Create a background image for the disabled state
            let disabledBackground = UIImage(color: UIColor(hex: "B9BCC8"))// Replace with your desired color
            nextButton.setBackgroundImage(disabledBackground, for: .disabled)
//            
        }

    func setupUI() {
        dataProtectionLabel.text = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TITLE", defaultText: "Data Protection")
    
        // Configure ContainerView
        ContainerView.backgroundColor = .white // Light gray color
        ContainerView.layer.cornerRadius = 10
        ContainerView.layer.masksToBounds = true
        
        // Configure checkbox1
        checkbox1.setImage(UIImage(systemName: "square"), for: .normal)
        checkbox1.tintColor = UIColor(hex: "B9BCC8")
        checkbox1.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkbox1.addTarget(self, action: #selector(handleIConfirmThatIHaveReadAndAcceptedTheInformationOnDataProtectionUISwitchClick), for: .touchUpInside)
        
        // Configure checkbox2
        checkbox2.setImage(UIImage(systemName: "square"), for: .normal)
        checkbox2.tintColor = UIColor(hex: "B9BCC8")
        checkbox2.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkbox2.addTarget(self, action: #selector(handleIAcceptTheDisclaimerUISwitchClick), for: .touchUpInside)
        
        // Configure label1
        label1.text = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.ACCEPT", defaultText: "I confirm that I have read and accepted the information on data protection")
        label1.numberOfLines = 0
        label1.textColor = .black
        label1.lineBreakMode = .byWordWrapping  // Ensures the text wraps by word
        label1.font = UIFont.systemFont(ofSize: 14)
        
        // Configure label2
        label2.text = TranslationsViewModel.shared.getTranslation(key: "WARNING.ACCEPT",defaultText: "I accept the disclaimer")
        label2.numberOfLines = 0
        label2.textColor = .black
        label2.font = UIFont.systemFont(ofSize: 14)
        
        // Initialize the button color
        updateNextUIButtonBackgroundColorToSkyBlue()
        // Configure nextButton
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        nextButton.backgroundColor = .lightGray
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(handleNextUIButtonClick), for: .touchUpInside)
        
        
        // Create stack view for checkboxes and labels
        let checkboxStackView1 = UIStackView(arrangedSubviews: [checkbox1, label1])
        checkboxStackView1.axis = .horizontal
        checkboxStackView1.alignment = .center
        checkboxStackView1.spacing = 10
        checkboxStackView1.distribution = .fillProportionally
        
        let checkboxStackView2 = UIStackView(arrangedSubviews: [checkbox2, label2])
        checkboxStackView2.axis = .horizontal
        checkboxStackView2.alignment = .center
        checkboxStackView2.spacing = 10
        checkboxStackView2.distribution = .fillProportionally
        
        // Configure ContainerView
        ContainerView.addSubview(checkboxStackView1)
        ContainerView.addSubview(checkboxStackView2)
        ContainerView.addSubview(nextButton)
        
        // Add ContainerView to the main view
        view.addSubview(ContainerView)
        
        // Set constraints for ContainerView
        ContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            ContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            ContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            ContainerView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        // Set constraints for checkboxStackView1
        checkboxStackView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkboxStackView1.leadingAnchor.constraint(equalTo: ContainerView.leadingAnchor, constant: 16),
            checkboxStackView1.topAnchor.constraint(equalTo: ContainerView.topAnchor, constant: 16),
            checkboxStackView1.trailingAnchor.constraint(equalTo: ContainerView.trailingAnchor, constant: -16)
        ])
        
        // Set constraints for checkboxStackView2
        checkboxStackView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkboxStackView2.leadingAnchor.constraint(equalTo: ContainerView.leadingAnchor, constant: 16),
            checkboxStackView2.topAnchor.constraint(equalTo: checkboxStackView1.bottomAnchor, constant: 10),
            checkboxStackView2.trailingAnchor.constraint(equalTo: ContainerView.trailingAnchor, constant: -16)
        ])
        
        // Set constraints for nextButton
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: ContainerView.leadingAnchor, constant: 12),
            nextButton.trailingAnchor.constraint(equalTo: ContainerView.trailingAnchor, constant: -12),
            nextButton.bottomAnchor.constraint(equalTo: ContainerView.bottomAnchor, constant: -15),
            nextButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        
        
        // Configuration of containers
        configureContainer(containerView: containerView1)
        configureContainer(containerView: containerView2)
        
        // Configuration of buttons and other elements
        configureButton(button: protectionDataButton, title: TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TITLE", defaultText: "Data Protection"), action: #selector(toggleAccordion1), icon: protectionDataIcon)
        configureButton(button: disclaimerButton, title: TranslationsViewModel.shared.getTranslation(key: "WARNING.TITLE", defaultText: "Disclaimer"), action: #selector(toggleAccordion2), icon: disclaimerIcon)
        
        configureChevron(chevron: chevron1, action: #selector(toggleAccordion1))
        configureChevron(chevron: chevron2, action: #selector(toggleAccordion2))
        
//        configureSubtitleLabel(label: subtitleLabel1, text: "Introduction to data protection:")
//        configureSubtitleLabel(label: subtitleLabel2, text: "Introduction to data protection:")
        
        configureTextView(textView: textView1, text: """
            
            """, boldPhrases: ["The following sources of information are relevant for this:", "Anonymity:", "Voluntary:", "Storage duration:", "Your children's consent:", "Possibility of revocation and deletion:", "Collection of smartphone data:", "Summary:"])
        
        configureTextView(textView: textView2, text: """
""")
       
            // Add subviews
            view.addSubview(containerView1)
            containerView1.addSubview(protectionDataIcon)
            containerView1.addSubview(protectionDataButton)
            containerView1.addSubview(chevron1)
            containerView1.addSubview(subtitleLabel1)
            containerView1.addSubview(textView1)

            view.addSubview(containerView2)
            containerView2.addSubview(disclaimerIcon)
            containerView2.addSubview(disclaimerButton)
            containerView2.addSubview(chevron2)
            containerView2.addSubview(subtitleLabel2)
            containerView2.addSubview(textView2)

            // Set constraints
            setConstraints()

            // Constraints for dynamic container height
            containerHeightConstraint1 = containerView1.heightAnchor.constraint(equalToConstant: 50)
            containerHeightConstraint1.isActive = true

            containerHeightConstraint2 = containerView2.heightAnchor.constraint(equalToConstant: 50)
            containerHeightConstraint2.isActive = true

            containerTopConstraint2 = containerView2.topAnchor.constraint(equalTo: containerView1.bottomAnchor, constant: 16)
            containerTopConstraint2.isActive = true

            // Initially hide subtitles and texts
            subtitleLabel1.isHidden = true
            textView1.isHidden = true

            subtitleLabel2.isHidden = true
            textView2.isHidden = true
        }
    func updateNextUIButtonIsEnabledPropertyToTrue(){
        nextButton.isEnabled = checkbox1.isSelected && checkbox2.isSelected
    }
        func configureContainer(containerView: UIView) {
            containerView.backgroundColor = .white
            containerView.layer.cornerRadius = 10
            containerView.layer.shadowColor = UIColor.gray.cgColor
            containerView.layer.shadowOpacity = 0.3
            containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
            containerView.layer.shadowRadius = 10
            containerView.tintColor = .black
        }

        func configureButton(button: UIButton, title: String, action: Selector, icon: UIImageView) {
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.addTarget(self, action: action, for: .touchUpInside)
            button.titleLabel?.textAlignment = .center
        }

        func configureChevron(chevron: UIImageView, action: Selector) {
            let tapGesture = UITapGestureRecognizer(target: self, action: action)
            chevron.isUserInteractionEnabled = true
            chevron.addGestureRecognizer(tapGesture)
            chevron.contentMode = .scaleAspectFit
            chevron.tintColor = .gray
        }

        func configureSubtitleLabel(label: UILabel, text: String) {
            label.text = text
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 14)
            
        }

        func configureTextView(textView: UITextView, text: String) {
            textView.text = text
            textView.font = UIFont.systemFont(ofSize: 14)
            textView.isEditable = false
            textView.isScrollEnabled = true
            
        }
        
        
        func updateNextUIButtonBackgroundColorToSkyBlue() {
               if checkbox1.isSelected && checkbox2.isSelected {
                   nextButton.backgroundColor =  UIColor(hex: "A1C2FC") // Light blue color
               } else {
                   nextButton.backgroundColor =  UIColor(hex: "B9BCC8")
               }
           }
    //This function saves the user acceptance state 
    func  saveUsersDataProtectionAndDisclaimerAcceptance(){
if checkbox1.isSelected && checkbox2.isSelected {
    usersDataProtectionAndDisclaimerAcceptance = true
    DataProtectionModel.shared.saveUsersDataProtectionAndDisclaimerAcceptance(usersDataProtectionAndDisclaimerAcceptance)
} else {
    usersDataProtectionAndDisclaimerAcceptance = false
    DataProtectionModel.shared.saveUsersDataProtectionAndDisclaimerAcceptance(usersDataProtectionAndDisclaimerAcceptance)
}
    }

        

        func setConstraints() {
           
            // Enable auto-layout
            containerView1.translatesAutoresizingMaskIntoConstraints = false
            protectionDataIcon.translatesAutoresizingMaskIntoConstraints = false
            protectionDataButton.translatesAutoresizingMaskIntoConstraints = false
            chevron1.translatesAutoresizingMaskIntoConstraints = false
            subtitleLabel1.translatesAutoresizingMaskIntoConstraints = false
            textView1.translatesAutoresizingMaskIntoConstraints = false

            containerView2.translatesAutoresizingMaskIntoConstraints = false
            disclaimerIcon.translatesAutoresizingMaskIntoConstraints = false
            disclaimerButton.translatesAutoresizingMaskIntoConstraints = false
            chevron2.translatesAutoresizingMaskIntoConstraints = false
            subtitleLabel2.translatesAutoresizingMaskIntoConstraints = false
            textView2.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                // Constraints for containerView1
                containerView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                containerView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                containerView1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 215),

                protectionDataIcon.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor, constant: 16),
                protectionDataIcon.topAnchor.constraint(equalTo: containerView1.topAnchor, constant: 16),
                protectionDataIcon.widthAnchor.constraint(equalToConstant: 24),
                protectionDataIcon.heightAnchor.constraint(equalToConstant: 24),

                protectionDataButton.leadingAnchor.constraint(equalTo: protectionDataIcon.trailingAnchor, constant: 16),
                protectionDataButton.centerYAnchor.constraint(equalTo: protectionDataIcon.centerYAnchor),

                chevron1.trailingAnchor.constraint(equalTo: containerView1.trailingAnchor, constant: -16),
                chevron1.centerYAnchor.constraint(equalTo: protectionDataIcon.centerYAnchor),
                chevron1.widthAnchor.constraint(equalToConstant: 20),
                chevron1.heightAnchor.constraint(equalToConstant: 20),

                subtitleLabel1.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor, constant: 16),
                subtitleLabel1.topAnchor.constraint(equalTo: protectionDataIcon.bottomAnchor, constant: 16),
                subtitleLabel1.trailingAnchor.constraint(equalTo: containerView1.trailingAnchor, constant: -16),

                textView1.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor, constant: 16),
                textView1.trailingAnchor.constraint(equalTo: containerView1.trailingAnchor, constant: -16),
                textView1.topAnchor.constraint(equalTo: subtitleLabel1.bottomAnchor, constant: 8),
                textView1.bottomAnchor.constraint(equalTo: containerView1.bottomAnchor, constant: -16),

                // Constraints for containerView2
                containerView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                containerView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

                disclaimerIcon.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor, constant: 16),
                disclaimerIcon.topAnchor.constraint(equalTo: containerView2.topAnchor, constant: 16),
                disclaimerIcon.widthAnchor.constraint(equalToConstant: 24),
                disclaimerIcon.heightAnchor.constraint(equalToConstant: 24),

                disclaimerButton.leadingAnchor.constraint(equalTo: disclaimerIcon.trailingAnchor, constant: 16),
                disclaimerButton.centerYAnchor.constraint(equalTo: disclaimerIcon.centerYAnchor),

                chevron2.trailingAnchor.constraint(equalTo: containerView2.trailingAnchor, constant: -16),
                chevron2.centerYAnchor.constraint(equalTo: disclaimerIcon.centerYAnchor),
                chevron2.widthAnchor.constraint(equalToConstant: 20),
                chevron2.heightAnchor.constraint(equalToConstant: 20),

                subtitleLabel2.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor, constant: 16),
                subtitleLabel2.topAnchor.constraint(equalTo: disclaimerIcon.bottomAnchor, constant: 16),
                subtitleLabel2.trailingAnchor.constraint(equalTo: containerView2.trailingAnchor, constant: -16),

                textView2.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor, constant: 16),
                textView2.trailingAnchor.constraint(equalTo: containerView2.trailingAnchor, constant: -16),
                textView2.topAnchor.constraint(equalTo: subtitleLabel2.bottomAnchor, constant: 8),
                textView2.bottomAnchor.constraint(equalTo: containerView2.bottomAnchor, constant: -16),
            ])
        }

        @objc func toggleAccordion1() {
            isExpanded1.toggle()
            
            if isExpanded1 {
                textView1.attributedText = getDynamicDataProtectionText() // Fetch dynamic text
                containerHeightConstraint1.constant = expandedHeight
                chevron1.image = UIImage(systemName: "chevron.up")
                subtitleLabel1.isHidden = false
                textView1.isHidden = false

                // Hide the second container
                containerView2.isHidden = true
            } else {
                containerHeightConstraint1.constant = 50
                chevron1.image = UIImage(systemName: "chevron.down")
                subtitleLabel1.isHidden = true
                textView1.isHidden = true

                // Show the second container
                containerView2.isHidden = false
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }

    @objc func handleIConfirmThatIHaveReadAndAcceptedTheInformationOnDataProtectionUISwitchClick(_ sender: UIButton) {
           sender.isSelected.toggle()
        updateNextUIButtonIsEnabledPropertyToTrue()
        updateNextUIButtonBackgroundColorToSkyBlue()
        saveUsersDataProtectionAndDisclaimerAcceptance()
       }
        @objc func handleIAcceptTheDisclaimerUISwitchClick(_ sender: UIButton) {
               sender.isSelected.toggle()
            updateNextUIButtonIsEnabledPropertyToTrue()
            updateNextUIButtonBackgroundColorToSkyBlue()
            saveUsersDataProtectionAndDisclaimerAcceptance()
           }
    func handleNavigationToViewFeverAppWelcomeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let welcomeVC = storyboard.instantiateViewController(withIdentifier: "ViewFeverAppWelcomeViewController") as? ViewFeverAppWelcomeViewController {
                self.navigationController?.pushViewController(welcomeVC, animated: true)
            }
    }
    
           @objc func handleNextUIButtonClick() {
               // Handle the Next button action
               handleNavigationToViewFeverAppWelcomeScreen()
           }
        
        
        
        @objc func toggleAccordion2() {
            isExpanded2.toggle()
            
            if isExpanded2 {
                textView2.attributedText = getDynamicDisclaimerText() // Fetch dynamic text
                containerHeightConstraint2.constant = expandedHeight
                chevron2.image = UIImage(systemName: "chevron.up")
                subtitleLabel2.isHidden = false
                textView2.isHidden = false
            } else {
                containerHeightConstraint2.constant = 50
                chevron2.image = UIImage(systemName: "chevron.down")
                subtitleLabel2.isHidden = true
                textView2.isHidden = true
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
func getAttributedString(_ htmlString: String) -> NSAttributedString {
    guard let data = htmlString.data(using: .utf8) else {
        return NSAttributedString(string: htmlString,  attributes: [.font: UIFont.systemFont(ofSize: 14)])
    }

    do {
        let attributedString = try NSMutableAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
        // Define the font attribute with the desired size
        let font = UIFont.systemFont(ofSize: 14)

        // Apply the font size to the entire attributed string
        attributedString.addAttributes([.font: font], range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    } catch {
        print("Failed to create attributed string from HTML: \(error)")
        return NSAttributedString(string: htmlString, attributes: [.font: UIFont.systemFont(ofSize: 14)])
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
