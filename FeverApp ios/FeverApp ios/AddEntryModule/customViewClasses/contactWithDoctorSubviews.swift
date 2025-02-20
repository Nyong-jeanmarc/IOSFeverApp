//
//  contactWithDoctorSubviews.swift
//  FeverApp ios
//
//  Created by NEW on 10/11/2024.
//

import Foundation
import UIKit

extension MedicalContactStatus: CaseIterable {}
enum MedicalContactStatus: String {
    case no = "NO"
    case spokeWithOurDoctor = "SPOKE_WITH_OUR_DOCTOR"
    case spokeWithAnotherDoctor = "SPOKE_WITH_ANOTHER_DOCTOR"
    case withEmergencyServices = "WITH_EMERGENCY_SERVICES"
    
    // Get an enum case from an integer tag
        static func fromTag(_ tag: Int) -> MedicalContactStatus? {
            switch tag {
            case 0:
                return .no
            case 1:
                return .spokeWithOurDoctor
            case 2:
                return .spokeWithAnotherDoctor
            case 3:
                return .withEmergencyServices
            default:
                return nil
            }
        }
}
class ContactWithDoctorFirstView : UIView{
    let ContactWithBottomView = UIView()
    let  ContactWitskipButton = UIButton()
    let ContactWithcontainerView = UIView()
    let ContactWithImage = UIImageView()
    var ContactWithverticalStackView: UIStackView!
    func  setupContactWithBottomView() {
        // Configure painBottomView
        ContactWithBottomView.translatesAutoresizingMaskIntoConstraints = false
        ContactWithBottomView.backgroundColor = .white
        
        // Add painBottomView to the main view
        self.addSubview(ContactWithBottomView)
        // Set painBottomView constraints
        NSLayoutConstraint.activate([
            ContactWithBottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            ContactWithBottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ContactWithBottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ContactWithBottomView.heightAnchor.constraint(equalToConstant: 90),
            
            ContactWithcontainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            ContactWithcontainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ContactWithcontainerView.bottomAnchor.constraint(equalTo: ContactWithBottomView.topAnchor),
            ContactWithcontainerView.heightAnchor.constraint(equalToConstant: 190)
        ])
        
    }
    func ContactWithsetupUI() {
        
        let ContactWitskipButtonTitle = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer") + " " + TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"))
        ContactWitskipButton.addTarget(self, action: #selector(ContactWitskipButtonTouchedDown), for: .touchDown)
        ContactWitskipButton.addTarget(self, action: #selector(ContactWitskipButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        ContactWitskipButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 10))
        ContactWitskipButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
        ContactWitskipButton.setAttributedTitle(ContactWitskipButtonTitle, for: .normal)
        ContactWitskipButton.layer.borderColor = UIColor.lightGray.cgColor
        ContactWitskipButton.layer.borderWidth = 1.0
        ContactWitskipButton.layer.cornerRadius = 10
        // Configure skipButton
        ContactWitskipButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer") + " " + TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"), for: .normal)
        ContactWitskipButton.setTitleColor(.black, for: .normal)
        ContactWitskipButton.backgroundColor = .white
        ContactWitskipButton.layer.borderWidth = 1
        ContactWitskipButton.layer.borderColor = UIColor.gray.cgColor
        ContactWitskipButton.layer.cornerRadius = 10
        ContactWitskipButton.translatesAutoresizingMaskIntoConstraints = false
        // Add buttons to painBottomView
        ContactWithBottomView.addSubview(ContactWitskipButton)
        // Set constraints for the buttons
        NSLayoutConstraint.activate([
            ContactWitskipButton.leadingAnchor.constraint(equalTo: ContactWithBottomView.leadingAnchor, constant: 16),
            ContactWitskipButton.trailingAnchor.constraint(equalTo: ContactWithBottomView.trailingAnchor, constant: -16),
            ContactWitskipButton.heightAnchor.constraint(equalToConstant: 45),
            ContactWitskipButton.topAnchor.constraint(equalTo:ContactWithBottomView.topAnchor, constant: 6),
        ])
    }
    func setupContactWithView() {
        ContactWithcontainerView.translatesAutoresizingMaskIntoConstraints = false
        ContactWithcontainerView.backgroundColor = .white
        ContactWithcontainerView.layer.cornerRadius = 15
        ContactWithcontainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top corners
        self.addSubview(ContactWithcontainerView)
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        ContactWithcontainerView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: ContactWithcontainerView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: ContactWithcontainerView.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: ContactWithcontainerView.topAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: ContactWithcontainerView.bottomAnchor, constant: -16)
        ])
        
        let scrollableStackView = UIStackView()
        scrollableStackView.axis = .vertical
        scrollableStackView.spacing = 8
        scrollView.addSubview(scrollableStackView)
        
        scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollableStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollableStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollableStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollableStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollableStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        ContactWithImage.translatesAutoresizingMaskIntoConstraints = false
        ContactWithImage.image = UIImage(named: "Logo")
        ContactWithImage.contentMode = .scaleAspectFit
        self.addSubview(ContactWithImage)
        
        let ContactWithtopContainerView = customRoundedView()
        
        ContactWithtopContainerView.backgroundColor = .white
        ContactWithtopContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ContactWithtopContainerView)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        
        let ContactWithtopLabel = UILabel()
        ContactWithtopLabel.numberOfLines = 0
        ContactWithtopLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_VISIT.QUESTION", defaultText: "Have you had any medical contact regarding {{name}}?").replacingOccurrences(of: "{{name}}", with: profileName!)
        ContactWithtopLabel.font = .systemFont(ofSize: 13)
        ContactWithtopLabel.translatesAutoresizingMaskIntoConstraints = false
        ContactWithtopContainerView.addSubview(ContactWithtopLabel)
        ContactWithImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ContactWithtopContainerView.bottomAnchor.constraint(equalTo: ContactWithcontainerView.topAnchor, constant: -13),
            ContactWithtopContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            ContactWithtopContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            ContactWithtopContainerView.heightAnchor.constraint(equalToConstant: 55),
            
            ContactWithtopLabel.topAnchor.constraint(equalTo: ContactWithtopContainerView.topAnchor, constant: 10),
            ContactWithtopLabel.leadingAnchor.constraint(equalTo: ContactWithtopContainerView.leadingAnchor, constant: 10),
            ContactWithtopLabel.trailingAnchor.constraint(equalTo: ContactWithtopContainerView.trailingAnchor, constant: -10),
            ContactWithtopLabel.bottomAnchor.constraint(equalTo: ContactWithtopContainerView.bottomAnchor, constant: -10),
            
            ContactWithImage.bottomAnchor.constraint(equalTo: ContactWithtopContainerView.bottomAnchor),
            ContactWithImage.leadingAnchor.constraint(equalTo: ContactWithtopContainerView.leadingAnchor, constant: -37),
            ContactWithImage.widthAnchor.constraint(equalToConstant: 30),
            ContactWithImage.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let ContactWith = [TranslationsViewModel.shared.getTranslation(key: "PROFILE.ALERT.NO", defaultText: "No"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.2.LABEL", defaultText: "Yes, we spoke with our doctor"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.3.LABEL", defaultText: "Yes, we spoke with another doctor (substitute)"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.4.LABEL", defaultText: "Yes, with the emergency services")]
        
        for (index, ContactWith) in ContactWith.enumerated() {
            let ContactWithView = createContactWithCheckboxWithLabel(text: ContactWith, tag: index)
            scrollableStackView.addArrangedSubview(ContactWithView)
            
            let divider = UIView()
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            scrollableStackView.addArrangedSubview(divider)
        }
        
        self.ContactWithverticalStackView = scrollableStackView
    }
    func createContactWithCheckboxWithLabel(text: String, tag: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        let checkbox = UIButton(type: .custom)
        checkbox.tag = tag
        checkbox.setImage(UIImage(systemName: "square")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1), renderingMode: .alwaysOriginal), for: .selected)
        checkbox.addTarget(self, action: #selector(ContactWithtoggleCheckbox), for: .touchUpInside)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ContactWithlabelTapped(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)
        label.isUserInteractionEnabled = true
        
        stackView.addArrangedSubview(checkbox)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
    func updateViewForInitialState() {
        // Ensure there's an initial state to process
        guard let initialState = contactWithDoctorModel.shared.initialContactData else {
            return // No initial state, meaning this is a new entry
        }
        
        // Ensure the hasMedicalContact attribute exists
        guard let hasMedicalContact = initialState.hasMedicalContact else {
            return // No `hasMedicalContact` value to process
        }
        
        // Iterate through all arranged subviews in the vertical stack view
        for view in ContactWithverticalStackView.arrangedSubviews {
            if let stackView = view as? UIStackView,
               let checkbox = stackView.arrangedSubviews.first as? UIButton {
                
                // Get the tag and map it to the enum case
                if let medicalContactStatus = MedicalContactStatus.fromTag(checkbox.tag),
                   medicalContactStatus.rawValue == hasMedicalContact { // Compare with the initial state value
                    checkbox.isSelected = true // Select the checkbox
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600

        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        ContactWithsetupUI()
        setupContactWithView()
        setupContactWithBottomView()
        updateViewForInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
   
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        ContactWithsetupUI()
        setupContactWithView()
        setupContactWithBottomView()
        updateViewForInitialState()
    }
    
    @objc func ContactWithlabelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let label = gestureRecognizer.view as? UILabel else { return }
        guard let stackView = label.superview as? UIStackView else { return }
        guard let checkbox = stackView.arrangedSubviews.first as? UIButton else { return }
        ContactWithtoggleCheckbox(checkbox)
    }
    var checkBoxTap: ((_ checkType:String)->Void)?
    var displayError: (()->Void)?
    @objc func ContactWithtoggleCheckbox(_ sender: UIButton) {
        var checkType = ""
        
        // Deselect all checkboxes in the stack view
        for view in self.ContactWithverticalStackView.arrangedSubviews {
            if let stackView = view as? UIStackView, let checkbox = stackView.arrangedSubviews.first as? UIButton {
                checkbox.isSelected = false
            }
        }
        
        // Select only the tapped checkbox
        sender.isSelected = true
        
        // Retrieve the label associated with the selected checkbox
        if let stackView = sender.superview as? UIStackView,
           let label = stackView.arrangedSubviews.last as? UILabel {
            // Check the label's text to set checkType
            if label.text == "No" {
                checkType = "no"
            } else {
                checkType = "yes"
            }
        }
        // Retrieve the label associated with the selected checkbox
           if let stackView = sender.superview as? UIStackView,
              let label = stackView.arrangedSubviews.last as? UILabel,
              let labelText = label.text {

               // Use the MedicalContactStatus enum to map the label text
               if let status = MedicalContactStatus.fromTag(sender.tag) {
                   print("Selected Status: \(status.rawValue)") // Prints the enum's raw value
                   contactWithDoctorModel.shared.saveHasMedicalContact(hasMedicalContact: status.rawValue){isSaved in
                       if isSaved{
                           self.checkBoxTap?(checkType)
                       }else{
                           self.displayError?()
                       }
                   }
               } else {
                   print("Invalid Status")
               }
           }
    }

    var skipButtonTap : (()->Void)?
    @objc func ContactWitskipButtonTouchedDown() {
        ContactWitskipButton.backgroundColor = .lightGray
        skipButtonTap?()
    }
    
    @objc func ContactWitskipButtonTouchedUp() {
        ContactWitskipButton.backgroundColor = .white
    }
   
}
class DoctorDiagnosisViews: UIView, UITableViewDelegate, UITableViewDataSource{
    
    // UI Components
    
    let diagnosismessageBubbleView = UIView()
    let diagnosismessageLabel = UILabel()
    let diagnosissmileyFaceImageView = UIImageView()
    let diagnosisdropdownTextField = UITextField()
    let diagnosisdropdownButton = UIButton(type: .system)
    let diagnosisskipContainerView = UIView()
    let diagnosisskipButton = UIButton(type: .system)
    let diagnosisupArrowButton = UIButton(type: .system)
    
    // Table properties
    let diagnosisvaccinesTableView = UITableView()
    let diagnosis = [
        TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.1.LABEL", defaultText: "Allergic reaction"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.2.LABEL", defaultText: "Bronchitis"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.3.LABEL", defaultText: "Cold"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.4.LABEL", defaultText: "Red ear"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.5.LABEL", defaultText: "Swollen eyes"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.6.LABEL", defaultText: "Flu-like infection"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.7.LABEL", defaultText: "Flu-like infection after vaccination"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.8.LABEL", defaultText: "Sore throat"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.9.LABEL", defaultText: "Hand, foot and mouth disease"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.10.LABEL", defaultText: "Cough"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.11.LABEL", defaultText: "Infection"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.12.LABEL", defaultText: "Laryngitis"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.13.LABEL", defaultText: "Lungs are free"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.14.LABEL", defaultText: "Pneumonia"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.15.LABEL", defaultText: "Gastroenteritis"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.16.LABEL", defaultText: "Tonsillitis"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.17.LABEL", defaultText: "Otitis media (inflammation of the middle ear)"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.18.LABEL", defaultText: "Timpani effusion"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.19.LABEL", defaultText: "Cough that sounds like acute spasmodic laryngitis"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.20.LABEL", defaultText: "Fifth disease"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.21.LABEL", defaultText: "Scarlet fever"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.22.LABEL", defaultText: "Mucusy cough"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.23.LABEL", defaultText: "Runny or blocked nose"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.24.LABEL", defaultText: "See recent reporting"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.25.LABEL", defaultText: "Streptococci"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.26.LABEL", defaultText: "Dry cough"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.27.LABEL", defaultText: "Viral infection"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.28.LABEL", defaultText: "Teething"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2.OPTION.29.LABEL", defaultText: "Other diagnosis")
    ]
    
  var selectedDiagnosis: [String] = []
    
    // Setup Methods
    func setupRedContainerView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
    }
    
    func setupMessageBubble() {
        // Configure the bubble view
        diagnosismessageBubbleView.translatesAutoresizingMaskIntoConstraints = false
        diagnosismessageBubbleView.backgroundColor = .white
        diagnosismessageBubbleView.layer.cornerRadius = 10
        self.addSubview(diagnosismessageBubbleView)
        diagnosismessageBubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        diagnosismessageBubbleView.layer.shadowColor = UIColor.black.cgColor
        diagnosismessageBubbleView.layer.shadowOpacity = 0.2
        diagnosismessageBubbleView.layer.shadowOffset = CGSize(width: 0, height: 4)
        diagnosismessageBubbleView.layer.shadowRadius = 4
        
        // Adjust the bubble width and position to adapt to different screen sizes
        NSLayoutConstraint.activate([
            diagnosismessageBubbleView.topAnchor.constraint(equalTo:  self.topAnchor, constant: 230),
            diagnosismessageBubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            diagnosismessageBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
        
        diagnosismessageLabel.translatesAutoresizingMaskIntoConstraints = false
        diagnosismessageLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS.QUESTION", defaultText: "What was the diagnosis?")
        diagnosismessageLabel.font = UIFont.systemFont(ofSize: 16)
        diagnosismessageLabel.numberOfLines = 0
        diagnosismessageBubbleView.addSubview(diagnosismessageLabel)
        
        
        NSLayoutConstraint.activate([
            diagnosismessageLabel.topAnchor.constraint(equalTo: diagnosismessageBubbleView.topAnchor, constant: 10),
            diagnosismessageLabel.leadingAnchor.constraint(equalTo: diagnosismessageBubbleView.leadingAnchor, constant: 10),
            diagnosismessageLabel.trailingAnchor.constraint(equalTo: diagnosismessageBubbleView.trailingAnchor, constant: -10),
            diagnosismessageLabel.bottomAnchor.constraint(equalTo: diagnosismessageBubbleView.bottomAnchor, constant: -10)
        ])
        diagnosissmileyFaceImageView.translatesAutoresizingMaskIntoConstraints = false
        diagnosissmileyFaceImageView.image = UIImage(named: "Logo")
        diagnosissmileyFaceImageView.contentMode = .scaleAspectFit
        self.addSubview(diagnosissmileyFaceImageView)
        
        NSLayoutConstraint.activate([
            diagnosissmileyFaceImageView.leadingAnchor.constraint(equalTo: diagnosismessageBubbleView.leadingAnchor, constant: -35),
            diagnosissmileyFaceImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 250),
            diagnosissmileyFaceImageView.widthAnchor.constraint(equalToConstant: 30),
            diagnosissmileyFaceImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupDropdown() {
        diagnosisdropdownTextField.translatesAutoresizingMaskIntoConstraints = false
        diagnosisdropdownTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.PLEASE_SELECT", defaultText: "Please select")
        diagnosisdropdownTextField.borderStyle = .roundedRect
        self.addSubview(diagnosisdropdownTextField)
        
        NSLayoutConstraint.activate([
            diagnosisdropdownTextField.topAnchor.constraint(equalTo: diagnosismessageBubbleView.bottomAnchor, constant: 40),
            diagnosisdropdownTextField.heightAnchor.constraint(equalToConstant: 50),
            diagnosisdropdownTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 90),
            diagnosisdropdownTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            diagnosisdropdownTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        diagnosisdropdownButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        diagnosisdropdownButton.tintColor = .lightGray
        diagnosisdropdownButton.translatesAutoresizingMaskIntoConstraints = false
        diagnosisdropdownButton.addTarget(self, action: #selector(dropdownTapped), for: .touchUpInside)
        self.addSubview(diagnosisdropdownButton)
        
        NSLayoutConstraint.activate([
            diagnosisdropdownButton.centerYAnchor.constraint(equalTo: diagnosisdropdownTextField.centerYAnchor),
            diagnosisdropdownButton.trailingAnchor.constraint(equalTo: diagnosisdropdownTextField.trailingAnchor, constant: -10)
        ])
    }
    
    func setupBottomSkipContainer() {
        diagnosisskipContainerView.translatesAutoresizingMaskIntoConstraints = false
        diagnosisskipContainerView.backgroundColor = .white
        diagnosisskipContainerView.layer.cornerRadius = 10
        self.addSubview(diagnosisskipContainerView)
        
        NSLayoutConstraint.activate([
            diagnosisskipContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            diagnosisskipContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            diagnosisskipContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            diagnosisskipContainerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupSkipButton() {
        diagnosisskipButton.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedTitle.append(NSAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"), attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]))
        diagnosisskipButton.setAttributedTitle(attributedTitle, for: .normal)
        diagnosisskipButton.layer.cornerRadius = 10
        diagnosisskipButton.layer.borderWidth = 1
        diagnosisskipButton.layer.borderColor = UIColor.lightGray.cgColor
        diagnosisskipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        self.addSubview(diagnosisskipButton)
        
        NSLayoutConstraint.activate([
            diagnosisskipButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            diagnosisskipButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            diagnosisskipButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            diagnosisskipButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            diagnosisskipButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupUpArrowButton() {
        diagnosisupArrowButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        diagnosisupArrowButton.tintColor = .darkGray
        diagnosisupArrowButton.translatesAutoresizingMaskIntoConstraints = false
        diagnosisupArrowButton.addTarget(self, action: #selector(upArrowTapped), for: .touchUpInside)
        self.addSubview(diagnosisupArrowButton)
        
        NSLayoutConstraint.activate([
            diagnosisupArrowButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            diagnosisupArrowButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            diagnosisupArrowButton.widthAnchor.constraint(equalToConstant: 30),
            diagnosisupArrowButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupTableView() {
        diagnosisvaccinesTableView.translatesAutoresizingMaskIntoConstraints = false
        diagnosisvaccinesTableView.delegate = self
        diagnosisvaccinesTableView.dataSource = self
        diagnosisvaccinesTableView.isHidden = true
        diagnosisvaccinesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "vaccineCell")
        
        // Add rounded corners to the table view
        diagnosisvaccinesTableView.layer.cornerRadius = 15
        diagnosisvaccinesTableView.clipsToBounds = true
        self.addSubview(diagnosisvaccinesTableView)
        
        NSLayoutConstraint.activate([
            diagnosisvaccinesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            diagnosisvaccinesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            diagnosisvaccinesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            diagnosisvaccinesTableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
        ])
        
        // Create table view header
        let diagnosistableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 90))
        diagnosistableViewHeader.backgroundColor = .white
        
        let diagnosisgrayBar = UIView()
        diagnosisgrayBar.translatesAutoresizingMaskIntoConstraints = false
        diagnosisgrayBar.backgroundColor = UIColor.lightGray
        diagnosisgrayBar.layer.cornerRadius = 2
        diagnosistableViewHeader.addSubview(diagnosisgrayBar)
        
        NSLayoutConstraint.activate([
            diagnosisgrayBar.centerXAnchor.constraint(equalTo: diagnosistableViewHeader.centerXAnchor),
            diagnosisgrayBar.topAnchor.constraint(equalTo: diagnosistableViewHeader.topAnchor, constant: 16),
            diagnosisgrayBar.widthAnchor.constraint(equalTo: diagnosistableViewHeader.widthAnchor, multiplier: 0.12),
            diagnosisgrayBar.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        let chooseVaccinesLabel = UILabel()
        chooseVaccinesLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseVaccinesLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.DOCTOR.CONTACT.DIAGNOSIS", defaultText: "Choose Diagnosis received")
        chooseVaccinesLabel.font = UIFont.boldSystemFont(ofSize: 17)
        diagnosistableViewHeader.addSubview(chooseVaccinesLabel)
        
        NSLayoutConstraint.activate([
            chooseVaccinesLabel.leadingAnchor.constraint(equalTo: diagnosistableViewHeader.leadingAnchor, constant: 15),
            chooseVaccinesLabel.bottomAnchor.constraint(equalTo: diagnosistableViewHeader.bottomAnchor, constant: -15),
            chooseVaccinesLabel.topAnchor.constraint(equalTo:  diagnosisgrayBar.topAnchor, constant: 35)
        ])
        
        let diagnosisdoneLabel = UILabel()
        diagnosisdoneLabel.translatesAutoresizingMaskIntoConstraints = false
        diagnosisdoneLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done")
        diagnosisdoneLabel.font = UIFont.systemFont(ofSize: 17)
        diagnosisdoneLabel.textColor =  UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
        diagnosistableViewHeader.addSubview(diagnosisdoneLabel)
        
        NSLayoutConstraint.activate([
            diagnosisdoneLabel.trailingAnchor.constraint(equalTo: diagnosistableViewHeader.trailingAnchor, constant: -15),
            diagnosisdoneLabel.bottomAnchor.constraint(equalTo: diagnosistableViewHeader.bottomAnchor, constant: -15)
        ])
        
        let diagnosisdoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(doneTapped))
        diagnosisdoneLabel.isUserInteractionEnabled = true
        diagnosisdoneLabel.addGestureRecognizer(diagnosisdoneTapGesture)
        
        diagnosisvaccinesTableView.tableHeaderView = diagnosistableViewHeader
    }
    // Actions
    @objc func dropdownTapped() {
        diagnosisvaccinesTableView.isHidden.toggle()
    }
    
    @objc func skipButtonTapped() {
        print("Skip button tapped")
    }
    
    @objc func upArrowTapped() {
        print("Up arrow tapped")
    }
    var doneTap: ((_ checkType:String)->Void)?
    var handleNoAnswerTap: (()->Void)?
    var displayError: (()->Void)?
    @objc func doneTapped() {
    
        var checkType = ""
        if selectedDiagnosis.contains("Other diagnosis"){
            checkType = "other"
        }else{
            checkType = "yes"
        }
        contactWithDoctorModel.shared.saveDoctorDiagnosis(list: selectedDiagnosis){isSaved in
            if isSaved{
                print("\(self.selectedDiagnosis)")
                // Step 4: Populate the text field with the selected diagnosis strings separated by commas
                let diagnosisText = self.selectedDiagnosis.joined(separator: ", ")
                self.diagnosisdropdownTextField.text = diagnosisText
                self.doneTap?(checkType)
            }else{
                self.displayError?()
            }
            
        }
        
        diagnosisvaccinesTableView.isHidden = true
      
    }
    
    // TableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diagnosis.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaccineCell", for: indexPath)
        
        let diagnosisText = diagnosis[indexPath.row]
        cell.textLabel?.text = diagnosisText
        
        let checkmarkImageView = UIImageView()
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.contentMode = .scaleAspectFit
        // Check if the vaccineText is in the selectedVaccines array
        let isSelected = selectedDiagnosis.contains(diagnosisText)
        checkmarkImageView.image = UIImage(named: isSelected ? "Property 1=on.png" : "Property 1=off.png")
        
        cell.contentView.addSubview(checkmarkImageView)
        NSLayoutConstraint.activate([
            checkmarkImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
            checkmarkImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Diagnosis = diagnosis[indexPath.row]
        
        if let index = selectedDiagnosis.firstIndex(of: Diagnosis) {
            // Vaccine is already selected, so remove it
            selectedDiagnosis.remove(at: index)
        } else {
            // Vaccine is not selected, so add it
            selectedDiagnosis.append(Diagnosis)
        }
       
        
        tableView.reloadData()
    }
    func loadInitialDoctorDiagnosis() {
        // Step 1: Retrieve the doctorDiagnosis array from the model
        guard let initialDiagnosis = contactWithDoctorModel.shared.initialContactData?.doctorDiagnosis else {
            print("No initial diagnosis found")
            return
        }
        
        // Step 2: Update the selectedDiagnosis array with matching strings from the diagnosis array
        selectedDiagnosis = diagnosis.filter { initialDiagnosis.contains($0) }
        
        // Step 3: Reload the table view to reflect the selected checkboxes
        diagnosisvaccinesTableView.reloadData()
        
        // Step 4: Populate the text field with the selected diagnosis strings separated by commas
        let diagnosisText = selectedDiagnosis.joined(separator: ", ")
        diagnosisdropdownTextField.text = diagnosisText
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRedContainerView()
        setupMessageBubble()
        setupDropdown()
        setupBottomSkipContainer()
        setupSkipButton()
        setupUpArrowButton()
        setupTableView()
        diagnosisdropdownTextField.isEnabled = false
        loadInitialDoctorDiagnosis()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupRedContainerView()
        setupMessageBubble()
        setupDropdown()
        setupBottomSkipContainer()
        setupSkipButton()
        setupUpArrowButton()
        setupTableView()
        diagnosisdropdownTextField.isEnabled = false
        loadInitialDoctorDiagnosis()
    }
}
class OtherDiagnosisView : UIView, UITextFieldDelegate{
    
    // View Components
    private let iconImageView = UIImageView()
    private let chatBubble = UIView()
    private let questionLabel = UILabel()
    private let painTextField = UITextField()
    private let noAnswerButton = UIButton()
    private let bottomView = UIView()
    let nextButton = UIButton()  // Public to allow interaction from outside
    private let chevronButton = UIButton(type: .system)
    func checkForInitialState(){
        // Unwrap the initial state and extract the date
        guard let initialState = contactWithDoctorModel.shared.initialContactData,
              let otherDiagnosis = initialState.otherDiagnosis else {
            print("NO INITIAL STATE FOR TEMP")
            return
        }
        painTextField.text = String(otherDiagnosis)
        // Update the confirm button state
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
      
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        setupView()
        setupConstraints()
        registerKeyboardNotifications()
        checkForInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
     
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        setupView()
        setupConstraints()
        registerKeyboardNotifications()
        checkForInitialState()
    }
    
    private func setupView() {
        // Chevron Button Configuration
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let chevronImage = UIImage(systemName: "chevron.up", withConfiguration: configuration)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = .gray
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chevronButton)
        
        // Icon Image View
        iconImageView.image = UIImage(named: "Logo")
        iconImageView.tintColor = .systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Chat Bubble
        chatBubble.backgroundColor = .white
        chatBubble.layer.cornerRadius = 10
        chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chatBubble.layer.shadowColor = UIColor.lightGray.cgColor
        chatBubble.layer.shadowOpacity = 0.8
        chatBubble.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatBubble.layer.shadowRadius = 4
        chatBubble.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chatBubble)
        
        // Question Label
        questionLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS-2-OTHER.QUESTION", defaultText: "What other diagnosis has the doctor made?")
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        chatBubble.addSubview(questionLabel)
        
        // Bottom View
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 12
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomView)
        
        // Pain TextField
        painTextField.delegate = self
        painTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "TEXT_INPUT.PLACEHOLDER", defaultText: "write here ..")
        painTextField.borderStyle = .roundedRect
        painTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        painTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(painTextField)
        // Create a toolbar with a "Done" button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
       
        // No Answer Button
        let mainText = NSMutableAttributedString(
            string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"),
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular), .foregroundColor: UIColor.black]
        )
        let skipText = NSAttributedString(
            string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"),
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular), .foregroundColor: UIColor.gray]
        )
        mainText.append(skipText)
        noAnswerButton.setAttributedTitle(mainText, for: .normal)
        noAnswerButton.layer.borderColor = UIColor.lightGray.cgColor
        noAnswerButton.layer.borderWidth = 1.0
        noAnswerButton.layer.cornerRadius = 8
        noAnswerButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(noAnswerButton)
        
        // Next Button
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.4", defaultText: "Next"), for: .normal)
        nextButton.backgroundColor = UIColor(white: 0.80, alpha: 1.0)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(nextButton)
        // Add targets to buttons
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        noAnswerButton.addTarget(self, action: #selector(handleNoAnswer), for: .touchUpInside)

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chevronButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            chevronButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            chevronButton.widthAnchor.constraint(equalToConstant: 30),
            chevronButton.heightAnchor.constraint(equalToConstant: 30),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            chatBubble.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            chatBubble.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            chatBubble.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -60),
            
            questionLabel.topAnchor.constraint(equalTo: chatBubble.topAnchor, constant: 10),
            questionLabel.leadingAnchor.constraint(equalTo: chatBubble.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: chatBubble.trailingAnchor, constant: -10),
            questionLabel.bottomAnchor.constraint(equalTo: chatBubble.bottomAnchor, constant: -10),
            
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 200),
            
            painTextField.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            painTextField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30),
            painTextField.heightAnchor.constraint(equalToConstant: 48),
            painTextField.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            
            noAnswerButton.heightAnchor.constraint(equalToConstant: 44),
            noAnswerButton.topAnchor.constraint(equalTo: painTextField.bottomAnchor, constant: 40),
            noAnswerButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            noAnswerButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -20),
            
            nextButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            nextButton.widthAnchor.constraint(equalTo: noAnswerButton.widthAnchor),
            nextButton.topAnchor.constraint(equalTo: painTextField.bottomAnchor, constant: 40),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    private func registerKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        // Calculate the distance from the bottom of the screen to the top of the view
        self.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 100)
    }
       
       @objc private func keyboardWillHide(notification: NSNotification) {
           self.transform = .identity
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           painTextField.resignFirstResponder()
           return true
       }
       
       @objc private func textFieldDidChange(_ textField: UITextField) {
           let text = painTextField.text ?? ""
           nextButton.backgroundColor = text.isEmpty ? UIColor(white: 0.80, alpha: 1.0) : UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
           nextButton.isEnabled = text.isEmpty ? false : true
       }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        painTextField.layer.borderColor = UIColor.black.cgColor
        painTextField.layer.borderWidth = 2.0
        painTextField.layer.cornerRadius = 8 // Optional: Rounds the corners
    }
    var handleNextTap : (()->Void)?
    var handleNoAnswerTap : (()->Void)?
    var displayError : (()->Void)?
    // Button action handlers
    @objc func handleNext() {
        let text = painTextField.text ?? ""
        contactWithDoctorModel.shared.saveOtherDiagnosis(otherDiagnosis: text){isSaved in
            if isSaved {
                self.handleNextTap?()
            }else{
                self.displayError?()
            }
        }
    }

    @objc func handleNoAnswer() {
     handleNoAnswerTap?()
    }
    // Dismiss the keyboard when the "Done" button is tapped
    @objc private func dismissKeyboard() {
        painTextField.resignFirstResponder()
    }
}

class DoctorPrescriptionView: UIView{
    
     let WarningSignscontainerView = UIView()
     let noAnswerButton = UIButton()
     let bottomView = UIView()
     let confirmButton = UIButton()
     let WarningSignsImage = UIImageView()
     var WarningSignsverticalStackView: UIStackView!
    enum PrescriptionIssued: String {
        case no = "NO"
        case ibuprofen = "IBUPROFEN"
        case paracetamol = "PARACETAMOL"
        case antibiotic = "ANTIBIOTIC"
        case other = "OTHER"

        // Get an enum case from an integer tag
           static func fromTag(_ tag: Int) -> PrescriptionIssued? {
               switch tag {
               case 0:
                   return .no
               case 1:
                   return .ibuprofen
               case 2:
                   return .paracetamol
               case 3:
                   return .antibiotic
               case 4:
                   return .other
               default:
                   return nil
               }
           }
     
    }
     func setupWarningSignsBottomView() {
         // Add painBottomView to the main view
      
         // Set painBottomView constraints
         NSLayoutConstraint.activate([
             WarningSignscontainerView.leadingAnchor.constraint(equalTo:  self.leadingAnchor),
             WarningSignscontainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             WarningSignscontainerView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
             WarningSignscontainerView.heightAnchor.constraint(equalToConstant: 230)
         ])
     }
     
     func setupBottomView(){
         self.addSubview( bottomView)
         // Bottom View
         bottomView.backgroundColor = .white
         bottomView.layer.cornerRadius = 0
         bottomView.translatesAutoresizingMaskIntoConstraints = false
     
         // No Answer Button
         let mainText = NSMutableAttributedString(
             string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"),
             attributes: [
                 .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                 .foregroundColor: UIColor.black
             ]
         )
         let skipText = NSAttributedString(
             string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"),
             attributes: [
                 .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                 .foregroundColor: UIColor.gray
             ]
         )
         mainText.append(skipText)
         noAnswerButton.setAttributedTitle(mainText, for: .normal)
         noAnswerButton.layer.borderColor = UIColor.lightGray.cgColor
         noAnswerButton.layer.borderWidth = 1.0
         noAnswerButton.layer.cornerRadius = 8
         noAnswerButton.translatesAutoresizingMaskIntoConstraints = false
         bottomView.addSubview(noAnswerButton)
         // Next Button
         confirmButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CONFIRM", defaultText: "Confirm"), for: .normal)
         confirmButton.backgroundColor = .lightGray// or any other default color
         confirmButton.setTitleColor(.white, for: .normal)
         confirmButton.layer.cornerRadius = 8
         confirmButton.translatesAutoresizingMaskIntoConstraints = false
         bottomView.addSubview(confirmButton)
         confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
         noAnswerButton.addTarget(self, action: #selector(noAnswerButtonTapped), for: .touchUpInside)
         NSLayoutConstraint.activate([
             bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             bottomView.heightAnchor.constraint(equalToConstant: 100),
             noAnswerButton.heightAnchor.constraint(equalToConstant: 44),
             noAnswerButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15),
             noAnswerButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
             noAnswerButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -20),
             confirmButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
             confirmButton.widthAnchor.constraint(equalTo: noAnswerButton.widthAnchor),
             confirmButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15),
             confirmButton.heightAnchor.constraint(equalToConstant: 40)
         ])
         
     }
     func setupWarningSignsView() {
         WarningSignscontainerView.translatesAutoresizingMaskIntoConstraints = false
         WarningSignscontainerView.backgroundColor = .white
         WarningSignscontainerView.layer.cornerRadius = 15
         WarningSignscontainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top corners
         self.addSubview( WarningSignscontainerView)
         let scrollView = UIScrollView()
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         scrollView.showsVerticalScrollIndicator = false
         WarningSignscontainerView.addSubview(scrollView)
         NSLayoutConstraint.activate([
             scrollView.leadingAnchor.constraint(equalTo:  WarningSignscontainerView.leadingAnchor, constant: 16),
             scrollView.trailingAnchor.constraint(equalTo:  WarningSignscontainerView.trailingAnchor, constant: -16),
             scrollView.topAnchor.constraint(equalTo:  WarningSignscontainerView.topAnchor, constant: 16),
             scrollView.bottomAnchor.constraint(equalTo:  WarningSignscontainerView.bottomAnchor, constant: -16)
         ])
         let scrollableStackView = UIStackView()
         scrollableStackView.axis = .vertical
         scrollableStackView.spacing = 8
         scrollView.addSubview(scrollableStackView)
         scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             scrollableStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
             scrollableStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
             scrollableStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
             scrollableStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
             scrollableStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
         ])
         WarningSignsImage.translatesAutoresizingMaskIntoConstraints = false
         WarningSignsImage.image = UIImage(named: "Logo")
         WarningSignsImage.contentMode = .scaleAspectFit
         self.addSubview(WarningSignsImage)
         
         let  WarningSignstopContainerView = customRoundedView()
         WarningSignstopContainerView.backgroundColor = .white
         WarningSignstopContainerView.translatesAutoresizingMaskIntoConstraints = false
         self.addSubview( WarningSignstopContainerView)
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let profileName = appDelegate.fetchProfileName()
         let  WarningSignstopLabel = UILabel()
         WarningSignstopLabel.numberOfLines = 0
         WarningSignstopLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_MEDICATION.QUESTION", defaultText: "Was a prescription issued to you for {{name}}?").replacingOccurrences(of: "{{name}}", with: profileName!)
         WarningSignstopLabel.font = .systemFont(ofSize: 13)
         WarningSignstopLabel.translatesAutoresizingMaskIntoConstraints = false
         WarningSignstopContainerView.addSubview( WarningSignstopLabel)
         WarningSignsImage.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             WarningSignstopContainerView.bottomAnchor.constraint(equalTo:  WarningSignscontainerView.topAnchor, constant: -13),
             WarningSignstopContainerView.leadingAnchor.constraint(equalTo:  self.leadingAnchor, constant: 50),
             WarningSignstopContainerView.trailingAnchor.constraint(equalTo:  self.trailingAnchor, constant: -50),
             WarningSignstopContainerView.heightAnchor.constraint(equalToConstant: 40),
             
             WarningSignstopLabel.topAnchor.constraint(equalTo:  WarningSignstopContainerView.topAnchor, constant: 10),
             WarningSignstopLabel.leadingAnchor.constraint(equalTo:  WarningSignstopContainerView.leadingAnchor, constant: 10),
             WarningSignstopLabel.trailingAnchor.constraint(equalTo:  WarningSignstopContainerView.trailingAnchor, constant: -10),
             WarningSignstopLabel.bottomAnchor.constraint(equalTo:  WarningSignstopContainerView.bottomAnchor, constant: -10),
             
             WarningSignsImage.bottomAnchor.constraint(equalTo:  WarningSignstopContainerView.bottomAnchor),
             WarningSignsImage.leadingAnchor.constraint(equalTo:  WarningSignstopContainerView.leadingAnchor, constant: -37),
             WarningSignsImage.widthAnchor.constraint(equalToConstant: 30),
             WarningSignsImage.heightAnchor.constraint(equalToConstant: 30)
         ])
         
         let warningSigns = [TranslationsViewModel.shared.getTranslation(key: "PROFILE.ALERT.NO", defaultText: "No"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.2.LABEL", defaultText: "Yes, for Ibuprofen"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.3.LABEL", defaultText: "Yes, for paracetamol"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.4.LABEL", defaultText: "Yes, for antibiotic"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.5.LABEL", defaultText: "Yes, for another medicine")
         ]
         
         for (index, symptom) in warningSigns.enumerated() {
             let symptomView = createWarningSignsCheckboxWithLabel(text: symptom, tag: index)
             scrollableStackView.addArrangedSubview(symptomView)
             
             let divider = UIView()
             divider.translatesAutoresizingMaskIntoConstraints = false
             divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
             divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
             scrollableStackView.addArrangedSubview(divider)
         }
         
         self.WarningSignsverticalStackView = scrollableStackView
     }
     func createWarningSignsCheckboxWithLabel(text: String, tag: Int) -> UIStackView {
         let stackView = UIStackView()
         stackView.axis = .horizontal
         stackView.spacing = 8
         stackView.alignment = .center
         stackView.distribution = .fillProportionally
         
         let checkbox = UIButton(type: .custom)
         checkbox.tag = tag
         checkbox.setImage(UIImage(systemName: "square")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
         checkbox.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1), renderingMode: .alwaysOriginal), for: .selected)
         checkbox.addTarget(self, action: #selector( WarningSignstoggleCheckbox), for: .touchUpInside)
         checkbox.translatesAutoresizingMaskIntoConstraints = false
         checkbox.widthAnchor.constraint(equalToConstant: 24).isActive = true
         checkbox.heightAnchor.constraint(equalToConstant: 24).isActive = true
         
         let label = UILabel()
         label.text = text
         label.font = UIFont.systemFont(ofSize: 16)
         label.numberOfLines = 1
         label.setContentHuggingPriority(.defaultLow, for: .horizontal)
         let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WarningSignslabelTapped(_:)))
         label.addGestureRecognizer(tapGestureRecognizer)
         label.isUserInteractionEnabled = true
         
         stackView.addArrangedSubview(checkbox)
         stackView.addArrangedSubview(label)
         
         return stackView
     }
     
     @objc func WarningSignslabelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
         guard let label = gestureRecognizer.view as? UILabel else { return }
         guard let stackView = label.superview as? UIStackView else { return }
         guard let checkbox = stackView.arrangedSubviews.first as? UIButton else { return }
         WarningSignstoggleCheckbox(checkbox)
     }
     
     @objc func  WarningSignstoggleCheckbox(_ sender: UIButton) {
         if sender.tag == 0 {
             for view in self.WarningSignsverticalStackView.arrangedSubviews {
                 if let stackView = view as? UIStackView, stackView != sender.superview {
                     if let checkbox = stackView.arrangedSubviews.first as? UIButton {
                         checkbox.isSelected = false
                     }
                 }
             }
             sender.isSelected.toggle()
         } else {
             if let firstCheckbox = self.WarningSignsverticalStackView.arrangedSubviews[0] as? UIStackView,
                let firstCheckboxButton = firstCheckbox.arrangedSubviews.first as? UIButton {
                 firstCheckboxButton.isSelected = false
             }
             sender.isSelected.toggle()
         }
         
         // Check if any checkbox is selected
         var anyCheckboxSelected = false
         for view in self.WarningSignsverticalStackView.arrangedSubviews {
             if let stackView = view as? UIStackView {
                 if let checkbox = stackView.arrangedSubviews.first as? UIButton, checkbox.isSelected {
                     anyCheckboxSelected = true
                     break
                 }
             }
         }
         // Change confirm button background color
         if anyCheckboxSelected {
             confirmButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
             confirmButton.isEnabled = true
         } else {
             confirmButton.backgroundColor = .lightGray// or any other default color
             confirmButton.isEnabled = false
         }
     }
     
     @objc func WarningSignsskipButtonTouchedDown() {
         noAnswerButton.backgroundColor = .lightGray
     }
     
     @objc func WarningSignsskipButtonTouchedUp() {
         noAnswerButton.backgroundColor = .white
      
     }
     
     var confirmButtonTap: ((_ checkbox:String)->Void)?
     var noAnswerButtonTap: (()->Void)?
    var displayError: (()->Void)?
     @objc func noAnswerButtonTapped(){
         noAnswerButtonTap?()
     }
     @objc func confirmButtonTapped(){
         var checkedType = ""  // Initialize the checkedType string
            var selectedTags = [Int]()  // Array to hold the tags of selected checkboxes
            
            // Collect tags of selected checkboxes
            for view in self.WarningSignsverticalStackView.arrangedSubviews {
                if let stackView = view as? UIStackView, let checkbox = stackView.arrangedSubviews.first as? UIButton, checkbox.isSelected {
                    selectedTags.append(checkbox.tag)
                }
            }
            
            // Determine the checkedType based on selected tags
            if selectedTags.contains(0) && selectedTags.count == 1 {
                checkedType = "no"
            }else if selectedTags.contains(4){
                checkedType = "others"
            }else{
                checkedType = "yes"
            }
         
         var enumStrings = [String]() // Array to hold the case strings

            // Array of warning signs (matches enum descriptions)
            let warningSigns = [
                "No",
                "Yes, for ibuprofen",
                "Yes, for paracetamol",
                "Yes, for antibiotic",
                "Yes, for another medicine"
            ]

            // Collect tags of selected checkboxes
            for view in self.WarningSignsverticalStackView.arrangedSubviews {
                if let stackView = view as? UIStackView, let checkbox = stackView.arrangedSubviews.first as? UIButton, checkbox.isSelected {
                    let tag = checkbox.tag

                    // Map the selected tag to its corresponding description
                    if tag < warningSigns.count {
                        let description = warningSigns[tag]

                        // Use the enum to find the corresponding case
                        if let prescriptionIssued = PrescriptionIssued.fromTag(tag) {
                            enumStrings.append(prescriptionIssued.rawValue) // Append the case string
                        }
                    }
                }
            }

         contactWithDoctorModel.shared.saveDoctorPrescriptions(doctorPrescriptions: enumStrings){isSaved in
             if isSaved {
                 self.confirmButtonTap?(checkedType)
             }else{
                 self.displayError?()
             }
         }
            // Print the case strings
            print("Selected prescriptions (case strings): \(enumStrings)")
          
     }
    func updateViewForEditingState() {
        guard let initialState = contactWithDoctorModel.shared.initialContactData else {
            return // No initial state, meaning this is a new entry
        }
        
        guard let prescriptions = initialState.doctorPrescriptions else {
            return // No prescriptions to process
        }
        
        // Iterate through all arranged subviews in the stack view
        for view in WarningSignsverticalStackView.arrangedSubviews {
            if let stackView = view as? UIStackView,
               let checkbox = stackView.arrangedSubviews.first as? UIButton {
                
                // Get the tag and check if it corresponds to any prescription in the initial state
                if let prescription = PrescriptionIssued.fromTag(checkbox.tag),
                   prescriptions.contains(prescription.rawValue) {
                    checkbox.isSelected = true
                }
            }
        }
        
        // Update the confirm button state
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }

     // WARNING SIGNS VIEW END
     override init(frame: CGRect) {
         super.init(frame: frame)
         self.translatesAutoresizingMaskIntoConstraints = false
         self.backgroundColor = .clear
         
         let screenHeight = UIScreen.main.bounds.height
         
         let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
         
         // Set view height based on screen size
         let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
         let tableHeight: CGFloat = isSmallScreenHeight ? 170 : 250
         NSLayoutConstraint.activate([
             // Constraints for TemperaturemeasurementMainView
             self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             self.heightAnchor.constraint(equalToConstant: viewHeight),
         ])
         setupBottomView()
         setupWarningSignsView()
         setupWarningSignsBottomView()
         updateViewForEditingState()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         self.translatesAutoresizingMaskIntoConstraints = false
         self.backgroundColor = .clear
         
         let screenHeight = UIScreen.main.bounds.height
         
         let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
         
         // Set view height based on screen size
         let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
         let tableHeight: CGFloat = isSmallScreenHeight ? 170 : 250
         NSLayoutConstraint.activate([
             // Constraints for TemperaturemeasurementMainView
             self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             self.heightAnchor.constraint(equalToConstant: viewHeight),
         ])
         setupBottomView()
         setupWarningSignsView()
         setupWarningSignsBottomView()
         updateViewForEditingState()
     }
    
}
class otherReasonsForContactingDoctorTextFieldView: UIView, UITextFieldDelegate {
    
    // View Components
    private let iconImageView = UIImageView()
    private let chatBubble = UIView()
    private let questionLabel = UILabel()
    private let painTextField = UITextField()
    private let noAnswerButton = UIButton()
    private let bottomView = UIView()
    let nextButton = UIButton()  // Public to allow interaction from outside
    private let chevronButton = UIButton(type: .system)
    func checkForInitialState(){
        // Unwrap the initial state and extract the date
        guard let initialState = contactWithDoctorModel.shared.initialContactData,
              let otherContactReason = initialState.otherReasonsForContact else {
            print("NO INITIAL STATE FOR TEMP")
            return
        }
        painTextField.text = String(otherContactReason)
        // Update the confirm button state
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
        let tableHeight: CGFloat = isSmallScreenHeight ? 170 : 250
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        setupView()
        setupConstraints()
        registerKeyboardNotifications()
        checkForInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
        let tableHeight: CGFloat = isSmallScreenHeight ? 170 : 250
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        setupView()
        setupConstraints()
        registerKeyboardNotifications()
        checkForInitialState()
    }
    
    private func setupView() {
        // Chevron Button Configuration
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let chevronImage = UIImage(systemName: "chevron.up", withConfiguration: configuration)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = .gray
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chevronButton)
        
        // Icon Image View
        iconImageView.image = UIImage(named: "Logo")
        iconImageView.tintColor = .systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Chat Bubble
        chatBubble.backgroundColor = .white
        chatBubble.layer.cornerRadius = 10
        chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chatBubble.layer.shadowColor = UIColor.lightGray.cgColor
        chatBubble.layer.shadowOpacity = 0.8
        chatBubble.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatBubble.layer.shadowRadius = 4
        chatBubble.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chatBubble)
        
        // Question Label
        questionLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_REASON-OTHER.QUESTION", defaultText: "Was there another reason were you at the doctor?")
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        chatBubble.addSubview(questionLabel)
        
        // Bottom View
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 12
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomView)
        
        // Pain TextField
        painTextField.delegate = self
        painTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "TEXT_INPUT.PLACEHOLDER", defaultText: "Write here…")
        painTextField.borderStyle = .roundedRect
        painTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        painTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(painTextField)
        
        // No Answer Button
        let mainText = NSMutableAttributedString(
            string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"),
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular), .foregroundColor: UIColor.black]
        )
        let skipText = NSAttributedString(
            string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"),
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular), .foregroundColor: UIColor.gray]
        )
        mainText.append(skipText)
        noAnswerButton.setAttributedTitle(mainText, for: .normal)
        noAnswerButton.layer.borderColor = UIColor.lightGray.cgColor
        noAnswerButton.layer.borderWidth = 1.0
        noAnswerButton.layer.cornerRadius = 8
        noAnswerButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(noAnswerButton)
        
        // Next Button
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        nextButton.backgroundColor = UIColor(white: 0.80, alpha: 1.0)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(nextButton)
        // Add targets to buttons
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        noAnswerButton.addTarget(self, action: #selector(handleNoAnswer), for: .touchUpInside)

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chevronButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            chevronButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            chevronButton.widthAnchor.constraint(equalToConstant: 30),
            chevronButton.heightAnchor.constraint(equalToConstant: 30),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            chatBubble.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            chatBubble.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            chatBubble.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -60),
            
            questionLabel.topAnchor.constraint(equalTo: chatBubble.topAnchor, constant: 10),
            questionLabel.leadingAnchor.constraint(equalTo: chatBubble.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: chatBubble.trailingAnchor, constant: -10),
            questionLabel.bottomAnchor.constraint(equalTo: chatBubble.bottomAnchor, constant: -10),
            
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 200),
            
            painTextField.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            painTextField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30),
            painTextField.heightAnchor.constraint(equalToConstant: 48),
            painTextField.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            
            noAnswerButton.heightAnchor.constraint(equalToConstant: 44),
            noAnswerButton.topAnchor.constraint(equalTo: painTextField.bottomAnchor, constant: 40),
            noAnswerButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            noAnswerButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -20),
            
            nextButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            nextButton.widthAnchor.constraint(equalTo: noAnswerButton.widthAnchor),
            nextButton.topAnchor.constraint(equalTo: painTextField.bottomAnchor, constant: 40),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    private func registerKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        // Calculate the distance from the bottom of the screen to the top of the view
      
        
         
        self.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 100)
    }
       
       @objc private func keyboardWillHide(notification: NSNotification) {
           self.transform = .identity
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           painTextField.resignFirstResponder()
           return true
       }
       
       @objc private func textFieldDidChange(_ textField: UITextField) {
           let text = painTextField.text ?? ""
           nextButton.backgroundColor = text.isEmpty ? UIColor(white: 0.80, alpha: 1.0) : UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
           nextButton.isEnabled = text.isEmpty ? false : true
       }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        painTextField.layer.borderColor = UIColor.black.cgColor
        painTextField.layer.borderWidth = 2.0
        painTextField.layer.cornerRadius = 8 // Optional: Rounds the corners
    }
    var handleNextTap : (()->Void)?
    var handleNoAnswerTap : (()->Void)?
    var displayError : (()->Void)?
    // Button action handlers
    @objc func handleNext() {
        let text = painTextField.text ?? ""
        contactWithDoctorModel.shared.saveOtherReasonsForContactingDoctor(otherReason: text){isSaved in
            if isSaved{
                self.handleNextTap?()
            }else{
                self.displayError?()
            }
        }
    }
    @objc func handleNoAnswer() {
     handleNoAnswerTap?()
    }

   }
class otherMedecinePrescribedByDoctorTextFieldView: UIView, UITextFieldDelegate {
    // View Components
    private let iconImageView = UIImageView()
    private let chatBubble = UIView()
    private let questionLabel = UILabel()
    private let painTextField = UITextField()
    private let bottomView = UIView()
    let nextButton = UIButton()  // Public to allow interaction from outside
    private let chevronButton = UIButton(type: .system)
    func checkForInitialState(){
        // Unwrap the initial state and extract the date
        guard let initialState = contactWithDoctorModel.shared.initialContactData,
              let otherPrescription = initialState.otherMedecinesPrescribed else {
            print("NO INITIAL STATE FOR TEMP")
            return
        }
        painTextField.text = String(otherPrescription)
        // Update the confirm button state
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        setupView()
        setupConstraints()
        registerKeyboardNotifications()
        checkForInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        setupView()
        setupConstraints()
        registerKeyboardNotifications()
        checkForInitialState()
    }
    
    private func setupView() {
        // Chevron Button Configuration
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let chevronImage = UIImage(systemName: "chevron.up", withConfiguration: configuration)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = .gray
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chevronButton)
        
        // Icon Image View
        iconImageView.image = UIImage(named: "Logo")
        iconImageView.tintColor = .systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Chat Bubble
        chatBubble.backgroundColor = .white
        chatBubble.layer.cornerRadius = 10
        chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chatBubble.layer.shadowColor = UIColor.lightGray.cgColor
        chatBubble.layer.shadowOpacity = 0.8
        chatBubble.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatBubble.layer.shadowRadius = 4
        chatBubble.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chatBubble)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        // Question Label
        questionLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.MEDICATION.MEDICATION_2-DESCRIPTION.QUESTION", defaultText: "Which other medication did {{name}} get?").replacingOccurrences(of: "{{name}}", with: profileName!)
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        chatBubble.addSubview(questionLabel)
        
        // Bottom View
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 12
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomView)
        
        // Pain TextField
        painTextField.delegate = self
        painTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "TEXT_INPUT.PLACEHOLDER", defaultText: "Write here…")
        painTextField.borderStyle = .roundedRect
        painTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        painTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(painTextField)
        
        // Next Button
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.4", defaultText: "Next"), for: .normal)
        nextButton.backgroundColor = UIColor(white: 0.80, alpha: 1.0)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chevronButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            chevronButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            chevronButton.widthAnchor.constraint(equalToConstant: 30),
            chevronButton.heightAnchor.constraint(equalToConstant: 30),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            chatBubble.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            chatBubble.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            chatBubble.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -60),
            
            questionLabel.topAnchor.constraint(equalTo: chatBubble.topAnchor, constant: 10),
            questionLabel.leadingAnchor.constraint(equalTo: chatBubble.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: chatBubble.trailingAnchor, constant: -10),
            questionLabel.bottomAnchor.constraint(equalTo: chatBubble.bottomAnchor, constant: -10),
            
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 200),
            
            painTextField.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            painTextField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30),
            painTextField.heightAnchor.constraint(equalToConstant: 48),
            painTextField.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            
            nextButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            nextButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            nextButton.topAnchor.constraint(equalTo: painTextField.bottomAnchor, constant: 40),
            nextButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    var nextTap : (()->Void)?
    var displayError : (()->Void)?
    @objc func nextButtonTapped(){
        let text = painTextField.text ?? ""
        contactWithDoctorModel.shared.saveOtherMedecinesPrescribed(otherMedecine: text){isSaved in
            if isSaved {
                self.nextTap?()
            }else{
                self.displayError?()
            }
            
        }
    }
    private func registerKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
       self.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 100)
    }
       
       @objc private func keyboardWillHide(notification: NSNotification) {
           self.transform = .identity
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           painTextField.resignFirstResponder()
           return true
       }
       
       @objc private func textFieldDidChange(_ textField: UITextField) {
           let text = painTextField.text ?? ""
           nextButton.backgroundColor = text.isEmpty ? UIColor(white: 0.80, alpha: 1.0) : UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
           nextButton.isEnabled = text.isEmpty ? false : true
       }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        painTextField.layer.borderColor = UIColor.black.cgColor
        painTextField.layer.borderWidth = 2.0
        painTextField.layer.cornerRadius = 8 // Optional: Rounds the corners
    }
   }
class ContactWithDoctorDateTimeView: UIView, UIScrollViewDelegate{
    private let dayScrollView = UIScrollView()
    private let selectionIndicatorHeight: CGFloat = 40
    let iconImageView = UIImageView()
    let chatBubble = UIView()
    let questionLabel = UILabel()
    let chevronButton = UIButton(type: .system)
    let selectionIndicator = UIView()
    let noAnswerButton = UIButton()
    let bottomView = UIView()
    let confirmButton = UIButton()
    private var dayLabels = [UILabel]()
    private var hourLabels = [UILabel]()
    private var minuteLabels = [UILabel]()
    // Sample data arrays (reversed order for scrolling from recent to previous)
    var days = [""]
    let hours = Array((Array(0...23).map { String(format: "%02d", $0) } + ["",""]).reversed())
    let minutes = Array((Array(0...59).map { String(format: "%02d", $0) } + ["",""]).reversed())
    
    func generateDaysArray() -> [String] {
        // Fetch the user's selected language
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English

        // Initialize the days array with translated "Today" and "Yesterday"
        var days = [
            TranslationsViewModel.shared.getTranslation(key: "CALENDAR.TODAY", defaultText: "Today"),
            TranslationsViewModel.shared.getTranslation(key: "CALENDAR.YESTERDAY", defaultText: "Yesterday")
        ]

        let calendar = Calendar.current
        let dateFormatter = DateFormatter()

        // Set the formatter to the user-selected language
        dateFormatter.locale = Locale(identifier: userLanguageCode)
        dateFormatter.dateFormat = "EEE.dd.MMM" // Format: Wed.30.Oct

        for dayOffset in 2...14 { // Start from 2 days ago up to 14 days ago (2 weeks)
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) {
                let localizedDayString = dateFormatter.string(from: date)
                days.append(localizedDayString)
            }
        }

        return days
    }

    func setupBottomView(){
        // Set the SF Symbol image for a chevron down
        chevronButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        // Set the tint color to gray
        chevronButton.tintColor = .gray
        // Set other button properties
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        // Add the button to the view
        self.addSubview(chevronButton)
        // Icon Image View
        iconImageView.image = UIImage(named: "Logo")
        iconImageView.tintColor = .systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconImageView)
        // Chat Bubble View
        chatBubble.backgroundColor = .white
        chatBubble.layer.cornerRadius = 8
        chatBubble.layer.shadowColor = UIColor.lightGray.cgColor
        chatBubble.layer.shadowOpacity = 0.8
        chatBubble.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatBubble.layer.shadowRadius = 4
        chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chatBubble.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chatBubble)
        // Question Label
        questionLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_VISIT-DATE.QUESTION", defaultText: "When did you speak with the doctor?")
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        chatBubble.addSubview(questionLabel)
        // Bottom View
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 0
        bottomView.translatesAutoresizingMaskIntoConstraints = false
    
        // No Answer Button
        let mainText = NSMutableAttributedString(
            string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"),
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor.black
            ]
        )
        let skipText = NSAttributedString(
            string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"),
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                .foregroundColor: UIColor.gray
            ]
        )
        mainText.append(skipText)
        noAnswerButton.setAttributedTitle(mainText, for: .normal)
        noAnswerButton.layer.borderColor = UIColor.lightGray.cgColor
        noAnswerButton.layer.borderWidth = 1.0
        noAnswerButton.layer.cornerRadius = 8
        noAnswerButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(noAnswerButton)
        // Next Button
        confirmButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CONFIRM", defaultText: "Confirm"), for: .normal)
        confirmButton.backgroundColor = UIColor(red: 165/255.0, green: 189/255.0, blue: 242/255.0, alpha: 1.0)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(confirmButton)
        // Add targets to buttons
        noAnswerButton.addTarget(self, action: #selector(handleNoAnswer), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        NSLayoutConstraint.activate([
            chevronButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            chevronButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            chevronButton.widthAnchor.constraint(equalToConstant: 30),
            chevronButton.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(equalTo: dayScrollView.topAnchor, constant: -20),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            chatBubble.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            chatBubble.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            chatBubble.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -60),
            questionLabel.topAnchor.constraint(equalTo: chatBubble.topAnchor, constant: 10),
            questionLabel.leadingAnchor.constraint(equalTo: chatBubble.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: chatBubble.trailingAnchor, constant: -10),
            questionLabel.bottomAnchor.constraint(equalTo: chatBubble.bottomAnchor, constant: -10),
            
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            noAnswerButton.heightAnchor.constraint(equalToConstant: 44),
            noAnswerButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15),
            noAnswerButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            noAnswerButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -20),
            confirmButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            confirmButton.widthAnchor.constraint(equalTo: noAnswerButton.widthAnchor),
            confirmButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    func getSelectedDate() -> String {
        // Calculate the visible day, hour, and minute based on the bottom position of the selection indicator
        let day = getSelectedComponent(from: dayScrollView, labels: dayLabels)
      
        
        // Construct and return the selected date as a formatted string
        let selectedDate = "\(day)"
        return selectedDate
    }
    // Helper function to get the selected component based on the bottom of the selection indicator
    private func getSelectedComponent(from scrollView: UIScrollView, labels: [UILabel]) -> String {
        // Calculate the y-offset for the selection indicator's bottom position
        let selectionIndicatorBottomY = scrollView.contentOffset.y + scrollView.frame.height
        
        // Loop through labels to find the one within the selection indicator's bottom area
        for label in labels {
            // Check if the label's frame intersects with the selection indicator's bottom area
            if abs(label.frame.origin.y + label.frame.height - selectionIndicatorBottomY) < label.frame.height / 2 {
                return label.text ?? ""
            }
        }
        
        // Fallback if no label is found (shouldn't happen with proper setup)
        return ""
    }
    private func parseSelectedDate(from dateString: String) -> Date? {
        // Fetch the user's selected language
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English
        let calendar = Calendar.current
        let today = Date()
        let dateFormatter = DateFormatter()
        
        // Set the formatter to the user-selected language
        dateFormatter.locale = Locale(identifier: userLanguageCode)
        dateFormatter.timeZone = TimeZone.current

        // Handle localized "Today" and "Yesterday"
        let localizedToday = TranslationsViewModel.shared.getTranslation(key: "CALENDAR.TODAY", defaultText: "Today")
        let localizedYesterday = TranslationsViewModel.shared.getTranslation(key: "CALENDAR.YESTERDAY", defaultText: "Yesterday")

        if dateString == localizedToday {
            return calendar.startOfDay(for: today) // Sets time to 00:00 (midnight) today
        } else if dateString == localizedYesterday {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            return calendar.startOfDay(for: yesterday) // Sets time to 00:00 (midnight) yesterday
        }
        
        // Parse dates in the "EEE.dd.MMM" format
        dateFormatter.dateFormat = "EEE.dd.MMM" // Example: "Mon.18.Nov"
        guard let parsedDate = dateFormatter.date(from: dateString) else {
            print("Error: Unable to parse the date part.")
            return nil
        }
        
        // Return the parsed date (with time set to midnight)
        return calendar.startOfDay(for: parsedDate)
    }

    var confirmTapped: (()->Void)?
    var noAnswerTapped: (()->Void)?
    var displayError: (()->Void)?

    @objc func handleConfirm(){
        var contactDate : Date
         let DateString = getSelectedDate()
      
              print("Selected Date: \(DateString)")
         
          // Convert the selected date string to a Date object
              if let SelectedDate = parseSelectedDate(from: DateString) {
                  print("Selected Date (Date object): \(SelectedDate)")
                  contactDate = SelectedDate
                  contactWithDoctorModel.shared.saveContactDate(date: contactDate){isSaved in
                      if isSaved {
                          self.confirmTapped?()
                      }else{
                          self.displayError?()
                      }
                  }
              } else {
                  print("Error: Unable to parse the selected date string!")
              }
       
    }
    @objc func handleNoAnswer(){
        noAnswerTapped?()
    }
    private func setupCustomDatePicker() {
        self.addSubview(bottomView)
        // Configure the scroll views
        let scrollViews = [dayScrollView]
        scrollViews.forEach { scrollView in
            scrollView.showsVerticalScrollIndicator = false
            scrollView.delegate = self
            scrollView.backgroundColor = .white // Set white background for each scroll view
            self.addSubview(scrollView)
        }
        
        // Set constraints or frames for the scroll views
        let scrollWidth = self.frame.width
      
        dayScrollView.frame = CGRect(x: 0, y: 0, width: scrollWidth, height: 250)
       
        // Position the scroll views in the center of the view
        dayScrollView.translatesAutoresizingMaskIntoConstraints = false
      
        
        NSLayoutConstraint.activate([
            dayScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            dayScrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            dayScrollView.heightAnchor.constraint(equalToConstant: 250),
            dayScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        ])
    }
  
    func scrollToBottom(scrollView: UIScrollView, animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height)
        
        if bottomOffset.y > 0 {
            scrollView.setContentOffset(bottomOffset, animated: animated)
            updateLabelColors(for: dayScrollView)
        } else {
            // If content is smaller than the scrollView's height, set offset to (0, 0)
            scrollView.setContentOffset(.zero, animated: animated)
            updateLabelColors(for: dayScrollView)
        }
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCustomDatePicker()
        setupBottomView()
        setupSelectionIndicators()
        populateDateComponents()
        scrollToBottom(scrollView: dayScrollView)
     
      
    }
    private func setupSelectionIndicators() {
        self.addSubview(selectionIndicator)
        // Create selection indicators with blue top and bottom borders
        selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        selectionIndicator.backgroundColor = .clear
        selectionIndicator.layer.borderWidth = 1.5
        // Customize the light blue color
        let lightBlueColor = UIColor(red: 173/255.0, green: 216/255.0, blue: 230/255.0, alpha: 1.0) // Light blue
        selectionIndicator.layer.borderColor = lightBlueColor.cgColor
        NSLayoutConstraint.activate([
            selectionIndicator.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -20),
            selectionIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -10),
            selectionIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
    }
    
    private func populateDateComponents() {
        days = generateDaysArray() + ["",""]
        days.reverse()
        // Populate days
        for i in 0..<days.count {
            let label = createLabel(with: days[i])
            dayScrollView.addSubview(label)
            label.frame = CGRect(x: 0, y: CGFloat(i) * 80, width: dayScrollView.frame.width, height: 80)
            dayLabels.append(label)
        }
        dayScrollView.contentSize = CGSize(width: dayScrollView.frame.width, height: CGFloat(days.count) * 80)
        
  
        
    }
    
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray // Default gray color
        return label
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateLabelColors(for: scrollView)
    }
    
    private func updateLabelColors(for scrollView: UIScrollView) {
        // Determine the correct label array based on the scroll view
        var labels = [UILabel]()
        if scrollView == dayScrollView {
            labels = dayLabels
        }
        
        // Get the position of the selection indicator in the scroll view's coordinate space
        let selectionIndicatorFrameInScrollView = self.convert(selectionIndicator.frame, to: scrollView)
        
        // Loop through each label and check if it intersects with the selection indicator frame
        for label in labels {
            if label.frame.intersects(selectionIndicatorFrameInScrollView) {
                label.textColor = .black // Set color for labels within the selection indicator area
            } else {
                label.textColor = .gray // Set color for labels outside the selection indicator area
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600

        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
        
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
    }
}
class OtherReasonsForContactingDoctorView: UIView{
     let WarningSignscontainerView = UIView()
     let noAnswerButton = UIButton()
     let bottomView = UIView()
     let confirmButton = UIButton()
     let WarningSignsImage = UIImageView()
     var WarningSignsverticalStackView: UIStackView!
    // Add painBottomView to the main view
    enum ContactReason: String {
        case worryAndInsecurity = "WORRY_AND_INSECURITY"
        case highFever = "HIGH_FEVER"
        case warningSigns = "WARNING_SIGNS"
        case getAttestation = "GET_ATTESTATION"
        case other = "OTHER"

        // Get an enum case from an integer tag
            static func fromTag(_ tag: Int) -> ContactReason? {
                switch tag {
                case 0:
                    return .worryAndInsecurity
                case 1:
                    return .highFever
                case 2:
                    return .warningSigns
                case 3:
                    return .getAttestation
                case 4:
                    return .other
                default:
                    return nil
                }
            }
        
    }
     func setupWarningSignsBottomView() {

         // Set painBottomView constraints
         NSLayoutConstraint.activate([
             WarningSignscontainerView.leadingAnchor.constraint(equalTo:  self.leadingAnchor),
             WarningSignscontainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             WarningSignscontainerView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
             WarningSignscontainerView.heightAnchor.constraint(equalToConstant: 230)
         ])
     }
     
     func setupBottomView(){
         self.addSubview( bottomView)
         // Bottom View
         bottomView.backgroundColor = .white
         bottomView.layer.cornerRadius = 0
         bottomView.translatesAutoresizingMaskIntoConstraints = false
     
         // No Answer Button
         let mainText = NSMutableAttributedString(
             string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"),
             attributes: [
                 .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                 .foregroundColor: UIColor.black
             ]
         )
         let skipText = NSAttributedString(
             string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"),
             attributes: [
                 .font: UIFont.systemFont(ofSize: 16, weight: .regular),
                 .foregroundColor: UIColor.gray
             ]
         )
         mainText.append(skipText)
         noAnswerButton.setAttributedTitle(mainText, for: .normal)
         noAnswerButton.layer.borderColor = UIColor.lightGray.cgColor
         noAnswerButton.layer.borderWidth = 1.0
         noAnswerButton.layer.cornerRadius = 8
         noAnswerButton.translatesAutoresizingMaskIntoConstraints = false
         bottomView.addSubview(noAnswerButton)
         // Next Button
         confirmButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CONFIRM", defaultText: "Confirm"), for: .normal)
         confirmButton.backgroundColor = .lightGray// or any other default color
         confirmButton.setTitleColor(.white, for: .normal)
         confirmButton.layer.cornerRadius = 8
         confirmButton.translatesAutoresizingMaskIntoConstraints = false
         bottomView.addSubview(confirmButton)
         confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
         noAnswerButton.addTarget(self, action: #selector(noAnswerButtonTapped), for: .touchUpInside)
         NSLayoutConstraint.activate([
             bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             bottomView.heightAnchor.constraint(equalToConstant: 100),
             noAnswerButton.heightAnchor.constraint(equalToConstant: 44),
             noAnswerButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15),
             noAnswerButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
             noAnswerButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -20),
             confirmButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
             confirmButton.widthAnchor.constraint(equalTo: noAnswerButton.widthAnchor),
             confirmButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 15),
             confirmButton.heightAnchor.constraint(equalToConstant: 40)
         ])
         confirmButton.isEnabled = false
     }
    let warningSigns = [TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.1.LABEL", defaultText: "Worry and insecurity"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.2.LABEL", defaultText: "High level of fever"), TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.3.LABEL", defaultText: "Warning signs (as documented in the app)"),TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.4.LABEL", defaultText: "To get an attestation/sick note"),TranslationsViewModel.shared.getTranslation(key: "DIARY.MEDICATION.MEDICATION_KIND.OPTION.4.LABEL", defaultText: "Other")
    ]
     func setupWarningSignsView() {
         WarningSignscontainerView.translatesAutoresizingMaskIntoConstraints = false
         WarningSignscontainerView.backgroundColor = .white
         WarningSignscontainerView.layer.cornerRadius = 15
         WarningSignscontainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top corners
         self.addSubview( WarningSignscontainerView)
         let scrollView = UIScrollView()
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         scrollView.showsVerticalScrollIndicator = false
         WarningSignscontainerView.addSubview(scrollView)
         NSLayoutConstraint.activate([
             scrollView.leadingAnchor.constraint(equalTo:  WarningSignscontainerView.leadingAnchor, constant: 16),
             scrollView.trailingAnchor.constraint(equalTo:  WarningSignscontainerView.trailingAnchor, constant: -16),
             scrollView.topAnchor.constraint(equalTo:  WarningSignscontainerView.topAnchor, constant: 16),
             scrollView.bottomAnchor.constraint(equalTo:  WarningSignscontainerView.bottomAnchor, constant: -16)
         ])
         let scrollableStackView = UIStackView()
         scrollableStackView.axis = .vertical
         scrollableStackView.spacing = 8
         scrollView.addSubview(scrollableStackView)
         scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             scrollableStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
             scrollableStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
             scrollableStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
             scrollableStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
             scrollableStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
         ])
         WarningSignsImage.translatesAutoresizingMaskIntoConstraints = false
         WarningSignsImage.image = UIImage(named: "Logo")
         WarningSignsImage.contentMode = .scaleAspectFit
         self.addSubview(WarningSignsImage)
         
         let  WarningSignstopContainerView = customRoundedView()
         WarningSignstopContainerView.backgroundColor = .white
         WarningSignstopContainerView.translatesAutoresizingMaskIntoConstraints = false
         self.addSubview( WarningSignstopContainerView)
         
         let  WarningSignstopLabel = UILabel()
         WarningSignstopLabel.numberOfLines = 0
         WarningSignstopLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_REASON.QUESTION", defaultText: "Why did you contact the doctor?")
         WarningSignstopLabel.font = .systemFont(ofSize: 13)
         WarningSignstopLabel.translatesAutoresizingMaskIntoConstraints = false
         WarningSignstopContainerView.addSubview( WarningSignstopLabel)
         WarningSignsImage.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             WarningSignstopContainerView.bottomAnchor.constraint(equalTo:  WarningSignscontainerView.topAnchor, constant: -13),
             WarningSignstopContainerView.leadingAnchor.constraint(equalTo:  self.leadingAnchor, constant: 50),
             WarningSignstopContainerView.trailingAnchor.constraint(equalTo:  self.trailingAnchor, constant: -50),
             WarningSignstopContainerView.heightAnchor.constraint(equalToConstant: 40),
             
             WarningSignstopLabel.topAnchor.constraint(equalTo:  WarningSignstopContainerView.topAnchor, constant: 10),
             WarningSignstopLabel.leadingAnchor.constraint(equalTo:  WarningSignstopContainerView.leadingAnchor, constant: 10),
             WarningSignstopLabel.trailingAnchor.constraint(equalTo:  WarningSignstopContainerView.trailingAnchor, constant: -10),
             WarningSignstopLabel.bottomAnchor.constraint(equalTo:  WarningSignstopContainerView.bottomAnchor, constant: -10),
             
             WarningSignsImage.bottomAnchor.constraint(equalTo:  WarningSignstopContainerView.bottomAnchor),
             WarningSignsImage.leadingAnchor.constraint(equalTo:  WarningSignstopContainerView.leadingAnchor, constant: -37),
             WarningSignsImage.widthAnchor.constraint(equalToConstant: 30),
             WarningSignsImage.heightAnchor.constraint(equalToConstant: 30)
         ])
         
       
         
         for (index, symptom) in warningSigns.enumerated() {
             let symptomView = createWarningSignsCheckboxWithLabel(text: symptom, tag: index)
             scrollableStackView.addArrangedSubview(symptomView)
             
             let divider = UIView()
             divider.translatesAutoresizingMaskIntoConstraints = false
             divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
             divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
             scrollableStackView.addArrangedSubview(divider)
         }
         
         self.WarningSignsverticalStackView = scrollableStackView
     }
     func createWarningSignsCheckboxWithLabel(text: String, tag: Int) -> UIStackView {
         let stackView = UIStackView()
         stackView.axis = .horizontal
         stackView.spacing = 8
         stackView.alignment = .center
         stackView.distribution = .fillProportionally
         
         let checkbox = UIButton(type: .custom)
         checkbox.tag = tag
         checkbox.setImage(UIImage(systemName: "square")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
         checkbox.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1), renderingMode: .alwaysOriginal), for: .selected)
         checkbox.addTarget(self, action: #selector( WarningSignstoggleCheckbox), for: .touchUpInside)
         checkbox.translatesAutoresizingMaskIntoConstraints = false
         checkbox.widthAnchor.constraint(equalToConstant: 24).isActive = true
         checkbox.heightAnchor.constraint(equalToConstant: 24).isActive = true
         
         let label = UILabel()
         label.text = text
         label.font = UIFont.systemFont(ofSize: 16)
         label.numberOfLines = 1
         label.setContentHuggingPriority(.defaultLow, for: .horizontal)
         let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WarningSignslabelTapped(_:)))
         label.addGestureRecognizer(tapGestureRecognizer)
         label.isUserInteractionEnabled = true
         
         stackView.addArrangedSubview(checkbox)
         stackView.addArrangedSubview(label)
         
         return stackView
     }
     
     @objc func WarningSignslabelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
         guard let label = gestureRecognizer.view as? UILabel else { return }
         guard let stackView = label.superview as? UIStackView else { return }
         guard let checkbox = stackView.arrangedSubviews.first as? UIButton else { return }
         WarningSignstoggleCheckbox(checkbox)
     }
     
     @objc func  WarningSignstoggleCheckbox(_ sender: UIButton) {
         sender.isSelected.toggle()
         // Check if any checkbox is selected
         var anyCheckboxSelected = false
         for view in self.WarningSignsverticalStackView.arrangedSubviews {
             if let stackView = view as? UIStackView {
                 if let checkbox = stackView.arrangedSubviews.first as? UIButton, checkbox.isSelected {
                     anyCheckboxSelected = true
                     break
                 }
             }
         }
         // Change confirm button background color
         if anyCheckboxSelected {
             confirmButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
             confirmButton.isEnabled = true
         } else {
             confirmButton.backgroundColor = .lightGray// or any other default color
             confirmButton.isEnabled = false
         }
     }
     
     @objc func WarningSignsskipButtonTouchedDown() {
         noAnswerButton.backgroundColor = .lightGray
     }
     
     @objc func WarningSignsskipButtonTouchedUp() {
         noAnswerButton.backgroundColor = .white
      
     }
     
     var confirmButtonTap: ((_ checkbox:String)->Void)?
     var noAnswerButtonTap: (()->Void)?
    var displayError: (()->Void)?
     @objc func noAnswerButtonTapped(){
         noAnswerButtonTap?()
     }
     @objc func confirmButtonTapped(){
         var checkedType = ""  // Initialize the checkedType string
            var selectedTags = [Int]()  // Array to hold the tags of selected checkboxes
        
         var enumStrings = [String]()  // Array to hold the enum value strings (capitalized, with underscores)he enum values corresponding to selected reasons
            // Collect tags of selected checkboxes
            for view in self.WarningSignsverticalStackView.arrangedSubviews {
                if let stackView = view as? UIStackView, let checkbox = stackView.arrangedSubviews.first as? UIButton, checkbox.isSelected {
                    selectedTags.append(checkbox.tag)
                }
            }
            
            // Determine the checkedType based on selected tags
         if (selectedTags.contains(0) || selectedTags.contains(1) || selectedTags.contains(2) || selectedTags.contains(3)) && (!selectedTags.contains(4)){
                checkedType = "yes"
            } else if selectedTags.contains(4) && (selectedTags.count > 1 || selectedTags.count == 1){
                checkedType = "others"
            }
            
            for tag in selectedTags {
                if tag < warningSigns.count {
                  
                    
                    // Map the description to its corresponding enum value
                    if let enumValue = ContactReason.fromTag(tag){
                        enumStrings.append(enumValue.rawValue)  // Append the rawValue (capitalized, with underscores)
                    }
                }
            }
            
         contactWithDoctorModel.shared.saveReasonForContactingDoctor(reasons: enumStrings){isSaved in
             if isSaved {
                 self.confirmButtonTap?(checkedType)
             }else{
                 self.displayError?()
             }
             
         }
            // Print the enumStrings array
            print("Selected reasons (enum values): \(enumStrings)")
            
            
           
     }
    func updateViewForEditingState() {
        guard let initialState = contactWithDoctorModel.shared.initialContactData else {
            return // No initial state, meaning this is a new entry
        }

        guard let reasons = initialState.reasonsForContactingDoctor else {
            return // No reasons to process
        }

        // Iterate through all arranged subviews in the stack view
        for view in WarningSignsverticalStackView.arrangedSubviews {
            if let stackView = view as? UIStackView,
               let checkbox = stackView.arrangedSubviews.first as? UIButton {

                // Get the tag and check if it corresponds to any value in the initial state
                if let contactReason = ContactReason.fromTag(checkbox.tag),
                   reasons.contains(contactReason.rawValue) {
                    checkbox.isSelected = true
                }
            }
        }

        // Update the confirm button state
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }

     // WARNING SIGNS VIEW END
     override init(frame: CGRect) {
         super.init(frame: frame)
         self.translatesAutoresizingMaskIntoConstraints = false
         self.backgroundColor = .clear
         
         let screenHeight = UIScreen.main.bounds.height
         
         let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
         
         // Set view height based on screen size
         let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
      
         NSLayoutConstraint.activate([
             // Constraints for TemperaturemeasurementMainView
             self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             self.heightAnchor.constraint(equalToConstant: viewHeight),
         ])
         setupBottomView()
         setupWarningSignsView()
         setupWarningSignsBottomView()
         updateViewForEditingState()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         self.translatesAutoresizingMaskIntoConstraints = false
         self.backgroundColor = .clear
         
         let screenHeight = UIScreen.main.bounds.height
         
         let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
         
         // Set view height based on screen size
         let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
  
         NSLayoutConstraint.activate([
             // Constraints for TemperaturemeasurementMainView
             self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             self.heightAnchor.constraint(equalToConstant: viewHeight),
         ])
         setupBottomView()
         setupWarningSignsView()
         setupWarningSignsBottomView()
         updateViewForEditingState()
     }
}
class OtherMeasuresTakenByDoctorView: UIView, UITextFieldDelegate{
    // View Components
    private let iconImageView = UIImageView()
    private let chatBubble = UIView()
    private let questionLabel = UILabel()
    private let painTextField = UITextField()
    private let noAnswerButton = UIButton()
    private let bottomView = UIView()
    let nextButton = UIButton()  // Public to allow interaction from outside
    private let chevronButton = UIButton(type: .system)
    func checkForInitialState(){
        // Unwrap the initial state and extract the date
        guard let initialState = contactWithDoctorModel.shared.initialContactData,
              let otherMeasures = initialState.otherMeasuresTakenBydoctor else {
            print("NO INITIAL STATE FOR TEMP")
            return
        }
        painTextField.text = String(otherMeasures)
        // Update the confirm button state
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
    
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        setupView()
        setupConstraints()
        registerKeyboardNotifications()
        checkForInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
      
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
        setupView()
        setupConstraints()
        registerKeyboardNotifications()
        checkForInitialState()
    }
    
    private func setupView() {
        // Chevron Button Configuration
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let chevronImage = UIImage(systemName: "chevron.up", withConfiguration: configuration)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = .gray
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chevronButton)
        
        // Icon Image View
        iconImageView.image = UIImage(named: "Logo")
        iconImageView.tintColor = .systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Chat Bubble
        chatBubble.backgroundColor = .white
        chatBubble.layer.cornerRadius = 10
        chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chatBubble.layer.shadowColor = UIColor.lightGray.cgColor
        chatBubble.layer.shadowOpacity = 0.8
        chatBubble.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatBubble.layer.shadowRadius = 4
        chatBubble.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chatBubble)
        
        // Question Label
        questionLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.ENTRY.DOCTOR.MEASURES", defaultText: "What other measures was taken by the doctor?")
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.systemFont(ofSize: 16)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        chatBubble.addSubview(questionLabel)
        
        // Bottom View
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 12
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomView)
        
        // Pain TextField
        painTextField.delegate = self
        painTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "TEXT_INPUT.PLACEHOLDER", defaultText: "Write here..")
        painTextField.borderStyle = .roundedRect
    
        painTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        painTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(painTextField)
        // Create a toolbar with a "Done" button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
        let doneButton = UIBarButtonItem(title: TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.DONE", defaultText: "Done"), style: .done, target: self, action: #selector(dismissKeyboard))
           toolbar.setItems([doneButton], animated: false)
        // Set the toolbar as the inputAccessoryView for the painTextField
           painTextField.inputAccessoryView = toolbar
        // No Answer Button
        let mainText = NSMutableAttributedString(
            string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"),
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular), .foregroundColor: UIColor.black]
        )
        let skipText = NSAttributedString(
            string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"),
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular), .foregroundColor: UIColor.gray]
        )
        mainText.append(skipText)
        noAnswerButton.setAttributedTitle(mainText, for: .normal)
        noAnswerButton.layer.borderColor = UIColor.lightGray.cgColor
        noAnswerButton.layer.borderWidth = 1.0
        noAnswerButton.layer.cornerRadius = 8
        noAnswerButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(noAnswerButton)
        
        // Next Button
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.4", defaultText: "Next"), for: .normal)
        nextButton.backgroundColor = UIColor(white: 0.80, alpha: 1.0)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(nextButton)
        // Add targets to buttons
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        noAnswerButton.addTarget(self, action: #selector(handleNoAnswer), for: .touchUpInside)

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chevronButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            chevronButton.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            chevronButton.widthAnchor.constraint(equalToConstant: 30),
            chevronButton.heightAnchor.constraint(equalToConstant: 30),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            chatBubble.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            chatBubble.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            chatBubble.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -60),
            
            questionLabel.topAnchor.constraint(equalTo: chatBubble.topAnchor, constant: 10),
            questionLabel.leadingAnchor.constraint(equalTo: chatBubble.leadingAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: chatBubble.trailingAnchor, constant: -10),
            questionLabel.bottomAnchor.constraint(equalTo: chatBubble.bottomAnchor, constant: -10),
            
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 200),
            
            painTextField.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            painTextField.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30),
            painTextField.heightAnchor.constraint(equalToConstant: 48),
            painTextField.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            
            noAnswerButton.heightAnchor.constraint(equalToConstant: 44),
            noAnswerButton.topAnchor.constraint(equalTo: painTextField.bottomAnchor, constant: 40),
            noAnswerButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10),
            noAnswerButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -20),
            
            nextButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10),
            nextButton.widthAnchor.constraint(equalTo: noAnswerButton.widthAnchor),
            nextButton.topAnchor.constraint(equalTo: painTextField.bottomAnchor, constant: 40),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    private func registerKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
    
        // Calculate the distance from the bottom of the screen to the top of the view
      
        
         
        self.transform = CGAffineTransform(translationX: 0, y: -keyboardFrame.height + 100)
    }
       
       @objc private func keyboardWillHide(notification: NSNotification) {
           self.transform = .identity
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           painTextField.resignFirstResponder()
           return true
       }
       
       @objc private func textFieldDidChange(_ textField: UITextField) {
           let text = painTextField.text ?? ""
           nextButton.backgroundColor = text.isEmpty ? UIColor(white: 0.80, alpha: 1.0) : UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
           nextButton.isEnabled = text.isEmpty ? false : true
       }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        painTextField.layer.borderColor = UIColor.black.cgColor
        painTextField.layer.borderWidth = 2.0
        painTextField.layer.cornerRadius = 8 // Optional: Rounds the corners
    }
    var handleNextTap : (()->Void)?
    var handleNoAnswerTap : (()->Void)?
    var displayError : (()->Void)?
    // Button action handlers
    @objc func handleNext() {
        let text = painTextField.text ?? ""
        contactWithDoctorModel.shared.saveOtherMeasuresTakenByDoctor(otherMeasures: text){isSaved in
            if isSaved{
                self.handleNextTap?()
            }else{
                self.displayError?()
            }
        }
    }

    @objc func handleNoAnswer() {
     handleNoAnswerTap?()
    }
    // Dismiss the keyboard when the "Done" button is tapped
    @objc private func dismissKeyboard() {
        painTextField.resignFirstResponder()
    }
}
