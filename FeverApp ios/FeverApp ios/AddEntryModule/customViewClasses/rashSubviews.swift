//
//  rashSubviews.swift
//  FeverApp ios
//
//  Created by NEW on 11/11/2024.
//

import Foundation
import UIKit

class RashFirstSubview : UIView{
    
     let WarningSignscontainerView = UIView()
     let noAnswerButton = UIButton()
     let bottomView = UIView()
     let confirmButton = UIButton()
     let WarningSignsImage = UIImageView()
     var WarningSignsverticalStackView: UIStackView!
  
    
    enum RashResponse: String {
        case no = "NO"
        case rednessCanBePushedAway = "YES_REDNESS_CAN_BE_PUSHED_AWAY"
        case rednessCannotBePushedAway = "YES_REDNESS_CANNOT_BE_PUSHED_AWAY"

        // Convert raw values to user-friendly descriptions
        var userFriendlyDescription: String {
            switch self {
            case .no:
                return "No"
            case .rednessCanBePushedAway:
                return "Yes, the redness can be pushed away"
            case .rednessCannotBePushedAway:
                return "Yes, the redness cannot be pushed away"
            }
        }

        // Get an enum case from its tag
        static func fromTag(_ tag: Int) -> RashResponse? {
            switch tag {
            case 0:
                return .no
            case 1:
                return .rednessCanBePushedAway
            case 2:
                return .rednessCannotBePushedAway
            default:
                return nil
            }
        }
    }

    func updateViewForEditingState() {
        guard let initialState = rashModel.shared.initialRashState else {
            return // No initial state, meaning this is a new entry
        }
        
        guard let rashes = initialState.rashes else {
            return // No rashes to process
        }
        
        // Iterate through all arranged subviews in the stack view
        for view in WarningSignsverticalStackView.arrangedSubviews {
            if let stackView = view as? UIStackView,
               let checkbox = stackView.arrangedSubviews.first as? UIButton {
                
                // Get the tag and check if it corresponds to any value in the initial state
                if let rashResponse = RashFirstSubview.RashResponse.fromTag(checkbox.tag),
                   rashes.contains(rashResponse.rawValue) {
                    checkbox.isSelected = true
                }
            }
        }
        
        // Update the confirm button state
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
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
         confirmButton.isEnabled = false
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
         WarningSignstopLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.RASH.RASH.QUESTION", defaultText: "Does {{name}} have a rash?").replacingOccurrences(of: "{{name}}", with: profileName!)
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

         let warningSigns = [TranslationsViewModel.shared.getTranslation(key: "DIARY.RASH.RASH.OPTION.1.DISPLAYLABEL", defaultText: "No rash"), TranslationsViewModel.shared.getTranslation(key: "DIARY.RASH.RASH.OPTION.2.LABEL", defaultText: "Yes, the redness can be pushed away"), TranslationsViewModel.shared.getTranslation(key: "DIARY.RASH.RASH.OPTION.3.LABEL", defaultText: "Yes, the redness cannot be pushed away")
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
         label.numberOfLines = 0
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
            } else{
                checkedType = "yes"
            }
       
         var rashEnumValues: [String] = []

         for rashTag in selectedTags {
             if let enumCase = RashResponse.fromTag(rashTag) {
                 rashEnumValues.append(enumCase.rawValue)
             } else {
               
             }
         }

         rashModel.shared.saveRashes(rashes:  rashEnumValues){isSaved in
             if isSaved {
                 print("rash values saved are \(rashEnumValues)")
                 // Call the closure with the determined checkedType
                 self.confirmButtonTap?(checkedType)
             }else{
                 self.displayError?()
                 
             }
         }
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
class RashDateTimeView: UIView, UIScrollViewDelegate{
    private let dayScrollView = UIScrollView()
    private let hourScrollView = UIScrollView()
    private let minuteScrollView = UIScrollView()
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
    
    func generateDaysArray() -> [String]{
        // Fetch the user's selected language
           let appDelegate = UIApplication.shared.delegate as? AppDelegate
           let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English
           
           var days = [
               TranslationsViewModel.shared.getTranslation(key: "CALENDAR.TODAY", defaultText: "Today"),
               TranslationsViewModel.shared.getTranslation(key: "CALENDAR.YESTERDAY", defaultText: "Yesterday")
           ]
           
           let calendar = Calendar.current
           let dateFormatter = DateFormatter()
           
           // Set the formatter to the user-selected language
           dateFormatter.locale = Locale(identifier: userLanguageCode) // Use the fetched language
           dateFormatter.dateFormat = "EEE.dd.MMM" // Example format: Wed.30.Oct
           
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
        questionLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARRHEA.MEASUREMENTS_DATE-DIARRHEA.QUESTION", defaultText: "At what time are you making this observations?")
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
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        noAnswerButton.addTarget(self, action: #selector(noAnswerButtonTapped), for: .touchUpInside)
    }
    var confirmButtonTap: ((_ selectedDate: Date)->Void)?
    var noAnswerButtonTap: (()->Void)?
    @objc func noAnswerButtonTapped(){
        noAnswerButtonTap?()
    }
    private func parseSelectedDate(from dateString: String) -> Date? {
        // Fetch the user's selected language
           let appDelegate = UIApplication.shared.delegate as? AppDelegate
           let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English
        let calendar = Calendar.current
        let today = Date()
        let dateFormatter = DateFormatter()
        print("language code is : \(userLanguageCode)")
        // Set the formatter to the user-selected language
        dateFormatter.locale = Locale(identifier: userLanguageCode) // Use the fetched language
        dateFormatter.timeZone = TimeZone.current
        
        // Split the input string into date and time parts
        let components = dateString.components(separatedBy: ", ")
        guard components.count == 2 else {
            print("failed to seperate date and time part")
            return nil }
        
        let datePart = components[0]
        let timePart = components[1]
        
        // Parse the time part (e.g., "13:58")
        let timeComponents = timePart.split(separator: ":")
        guard timeComponents.count == 2,
              let hour = Int(timeComponents[0]),
              let minute = Int(timeComponents[1]) else {
            print("failed to parse time part")
            return nil }
        
        // Handle "Today" and "Yesterday"
        let localizedToday = TranslationsViewModel.shared.getTranslation(key: "CALENDAR.TODAY", defaultText: "Today")
        let localizedYesterday = TranslationsViewModel.shared.getTranslation(key: "CALENDAR.YESTERDAY", defaultText: "Yesterday")
        
        if datePart == localizedToday {
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: today)
        } else if datePart == localizedYesterday {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: yesterday)
        }
        
        // Parse standard date formats
        let sanitizedDatePart = datePart
        print("sanitizedDatePart: \(sanitizedDatePart)")
        dateFormatter.dateFormat = "EEE.dd.MMM" // Day, Date, and Month
        guard let parsedDate = dateFormatter.date(from: sanitizedDatePart) else {
            print("failed to parse date part")
            return nil }
        
        // Combine the parsed date and time
        var dateComponents = calendar.dateComponents([.day, .month], from: parsedDate)
        dateComponents.year = calendar.component(.year, from: today)
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents)
    }

    func getSelectedDate() -> String {
        // Calculate the visible day, hour, and minute based on the bottom position of the selection indicator
        let day = getSelectedComponent(from: dayScrollView, labels: dayLabels)
        let hour = getSelectedComponent(from: hourScrollView, labels: hourLabels)
        let minute = getSelectedComponent(from: minuteScrollView, labels: minuteLabels)
        
        // Construct and return the selected date as a formatted string
        let selectedDate = "\(day), \(hour):\(minute)"
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
    var displayError: (()->Void)?
    @objc func confirmButtonTapped(){
        let selectedDateString = getSelectedDate()
            print("Selected Date: \(selectedDateString)")
        var selectedDate : Date? = Date()
        // Convert the selected date string to a Date object
            if let SelectedDate = parseSelectedDate(from: selectedDateString) {
                print("Selected Date (Date object): \(SelectedDate)")
                selectedDate = SelectedDate
            } else {
                print("Error: Unable to parse the selected date string!")
            }
        rashModel.shared.saveRashTime(rashTime: selectedDate!){isSaved in
            if isSaved{
                // Call the closure with the determined checkedType
                self.confirmButtonTap?(selectedDate ?? Date())
                let entryId = AddEntryModel.shared.entryId
                AddEntryNetworkManager.shared.fetchAndUpdateLocalEntry(with: entryId!, overallDate: selectedDate ?? Date())
            }else{
                self.displayError?()
            }
            
        }
         
    }

    private func setupCustomDatePicker() {
        self.addSubview(bottomView)
        // Configure the scroll views
        let scrollViews = [dayScrollView, hourScrollView, minuteScrollView]
        scrollViews.forEach { scrollView in
            scrollView.showsVerticalScrollIndicator = false
            scrollView.delegate = self
            scrollView.backgroundColor = .white // Set white background for each scroll view
            self.addSubview(scrollView)
        }
        
        // Set constraints or frames for the scroll views
        let scrollWidth = self.frame.width / 3
      
        dayScrollView.frame = CGRect(x: 0, y: 0, width: scrollWidth, height: 250)
        hourScrollView.frame = CGRect(x: scrollWidth, y: 0, width: scrollWidth, height: 250)
        minuteScrollView.frame = CGRect(x: 2 * scrollWidth, y: 0, width: scrollWidth, height: 250)
        // Position the scroll views in the center of the view
        dayScrollView.translatesAutoresizingMaskIntoConstraints = false
        hourScrollView.translatesAutoresizingMaskIntoConstraints = false
        minuteScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            dayScrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            dayScrollView.heightAnchor.constraint(equalToConstant: 250),
            dayScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            hourScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            hourScrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            hourScrollView.heightAnchor.constraint(equalToConstant: 250),
            hourScrollView.leadingAnchor.constraint(equalTo: dayScrollView.trailingAnchor),
            
            minuteScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            minuteScrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            minuteScrollView.heightAnchor.constraint(equalToConstant: 250),
            minuteScrollView.leadingAnchor.constraint(equalTo: hourScrollView.trailingAnchor)
        ])
    }
    private func scrollToCurrentTime() {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())
        let currentMinute = calendar.component(.minute, from: Date())
        
        if let hourIndex = hours.firstIndex(of: String(format: "%02d", currentHour)) {
            let hourOffset = CGFloat(hourIndex) * 80 // Assuming each label is 80 points in height
            hourScrollView.setContentOffset(CGPoint(x: 0, y: hourOffset), animated: false)
        }
        
        if let minuteIndex = minutes.firstIndex(of: String(format: "%02d", currentMinute)) {
            let minuteOffset = CGFloat(minuteIndex) * 80 // Assuming each label is 80 points in height
            minuteScrollView.setContentOffset(CGPoint(x: 0, y: minuteOffset), animated: false)
        }
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
    func scrollToInitialState() {
        // Unwrap the initial state and extract the date
        guard let initialState = rashModel.shared.initialRashState,
              let date = initialState.date else {
            return
        }
        
        // Extract calendar components from the date
        let calendar = Calendar.current
        let dayString = formattedDayString(for: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        // Scroll day scroll view
        if let dayIndex = days.firstIndex(of: dayString) {
            let dayOffset = CGFloat(dayIndex) * 80 - dayScrollView.bounds.height + 80 // 80 is assumed row height
            dayScrollView.setContentOffset(CGPoint(x: 0, y: max(0, dayOffset)), animated: true)
        }
        
        // Scroll hour scroll view
        if let hourIndex = hours.firstIndex(of: String(format: "%02d", hour)) {
            let hourOffset = CGFloat(hourIndex) * 80 - hourScrollView.bounds.height + 80
            hourScrollView.setContentOffset(CGPoint(x: 0, y: max(0, hourOffset)), animated: true)
        }
        
        // Scroll minute scroll view
        if let minuteIndex = minutes.firstIndex(of: String(format: "%02d", minute)) {
            let minuteOffset = CGFloat(minuteIndex) * 80 - minuteScrollView.bounds.height + 80
            minuteScrollView.setContentOffset(CGPoint(x: 0, y: max(0, minuteOffset)), animated: true)
        }
    }

    // Helper function to generate the formatted day string
    private func formattedDayString(for date: Date) -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return TranslationsViewModel.shared.getTranslation(key: "CALENDAR.TODAY", defaultText: "Today")
        } else if calendar.isDateInYesterday(date) {
            return TranslationsViewModel.shared.getTranslation(key: "CALENDAR.YESTERDAY", defaultText: "Yesterday")
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")
            dateFormatter.dateFormat = "EEE.dd.MMM"
            return dateFormatter.string(from: date)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCustomDatePicker()
        setupBottomView()
        setupSelectionIndicators()
        populateDateComponents()
        if rashModel.shared.initialRashState != nil {
            scrollToInitialState()
        }else{
            scrollToBottom(scrollView: dayScrollView)
            // Get current hour and minute
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: Date())
            let currentMinute = calendar.component(.minute, from: Date())
            
            // Calculate Y offset for hour and minute to scroll them to the bottom of their scroll views
            let hourOffset = CGFloat(hours.count - currentHour - 1) * 80 - hourScrollView.bounds.height + 80
            let minuteOffset = CGFloat(minutes.count - currentMinute - 1) * 80 - minuteScrollView.bounds.height + 80
            
            // Ensure offsets are not negative
            let finalHourOffset = max(0, hourOffset)
            let finalMinuteOffset = max(0, minuteOffset)
            
            // Scroll to the calculated positions
            hourScrollView.setContentOffset(CGPoint(x: 0, y: finalHourOffset), animated: true)
            minuteScrollView.setContentOffset(CGPoint(x: 0, y: finalMinuteOffset), animated: true)
        }
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
        
        // Populate hours
        for i in 0..<hours.count {
            let label = createLabel(with: String(format: hours[i], i))
            hourScrollView.addSubview(label)
            label.frame = CGRect(x: 0, y: CGFloat(i) * 80, width: hourScrollView.frame.width, height: 80)
            hourLabels.append(label)
        }
        hourScrollView.contentSize = CGSize(width: hourScrollView.frame.width, height: CGFloat(hours.count) * 80)
        
        // Populate minutes
        for i in 0..<minutes.count {
            let label = createLabel(with: String(format: minutes[i], i))
            minuteScrollView.addSubview(label)
            label.frame = CGRect(x: 0, y: CGFloat(i) * 80, width: minuteScrollView.frame.width, height: 80)
            minuteLabels.append(label)
        }
        minuteScrollView.contentSize = CGSize(width: minuteScrollView.frame.width, height: CGFloat(minutes.count) * 80)
        
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
        } else if scrollView == hourScrollView {
            labels = hourLabels
        } else if scrollView == minuteScrollView {
            labels = minuteLabels
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
        let tableHeight: CGFloat = isSmallScreenHeight ? 170 : 250
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
        let tableHeight: CGFloat = isSmallScreenHeight ? 170 : 250
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
    }

    
}
