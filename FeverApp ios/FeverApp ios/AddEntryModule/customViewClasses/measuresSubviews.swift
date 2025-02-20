//
//  measuresSubviews.swift
//  FeverApp ios
//
//  Created by NEW on 10/11/2024.
//

import Foundation
import UIKit
class MeasuresFirstSubview : UIView{
    let getMedicationBottomView = UIView()
    let YesButton = UIButton()
    let NoButton = UIButton()
    let  getMedicationskipButton = UIButton()
    let getMedicationtopContainerView = customRoundedView()
    let getMedicationImage = UIImageView()
    func setupgetMedicationBottomView() {
        // Configure painBottomView
        getMedicationBottomView.translatesAutoresizingMaskIntoConstraints = false
        getMedicationBottomView.backgroundColor = .white
        // Add painBottomView to the main view
       self.addSubview(getMedicationBottomView)
        // Set painBottomView constraints
        NSLayoutConstraint.activate([
            getMedicationBottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            getMedicationBottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            getMedicationBottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            getMedicationBottomView.heightAnchor.constraint(equalToConstant: 150),
            
            getMedicationtopContainerView.bottomAnchor.constraint(equalTo:  getMedicationBottomView.topAnchor, constant: -13),
            getMedicationtopContainerView.leadingAnchor.constraint(equalTo: getMedicationBottomView.leadingAnchor, constant: 40),
            getMedicationtopContainerView.trailingAnchor.constraint(equalTo: getMedicationBottomView.trailingAnchor, constant: -50),
            getMedicationtopContainerView.heightAnchor.constraint(equalToConstant: 40),//taille du pop texte
        ])
        
    }
    func  getMedicationsetupUI() {
        NoButton.layer.borderColor = UIColor.lightGray.cgColor
        NoButton.layer.borderWidth = 1.0
        NoButton.layer.cornerRadius = 10
        YesButton.layer.borderColor = UIColor.lightGray.cgColor
        YesButton.layer.borderWidth = 1.0
        YesButton.layer.cornerRadius = 10
        // Configure skipButton
        NoButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "PROFILE.ALERT.NO", defaultText: "No"), for: .normal)
        NoButton.setTitleColor(.black, for: .normal)
        NoButton.backgroundColor = .lightGray
        NoButton.layer.cornerRadius = 10
        NoButton.translatesAutoresizingMaskIntoConstraints = false
        // Configure confirmButton
        YesButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "DIARY.HEADER.FINISH_EPISODE.ALERT.YES", defaultText: "yes"), for: .normal)
        YesButton.setTitleColor(.black, for: .normal)
        YesButton.backgroundColor = .lightGray
        YesButton.layer.cornerRadius = 10
        YesButton.translatesAutoresizingMaskIntoConstraints = false
        // Add buttons to painBottomView
        getMedicationBottomView.addSubview(YesButton)
        getMedicationBottomView.addSubview(NoButton)
        // Set constraints for the buttons
        NSLayoutConstraint.activate([
            NoButton.leadingAnchor.constraint(equalTo: getMedicationBottomView.leadingAnchor, constant: 16),
            NoButton.heightAnchor.constraint(equalToConstant: 45),
            NoButton.topAnchor.constraint(equalTo:getMedicationBottomView.topAnchor, constant: 15),
            // Confirm Button Constraints
            YesButton.trailingAnchor.constraint(equalTo:getMedicationBottomView.trailingAnchor, constant: -16),
            YesButton.heightAnchor.constraint(equalToConstant: 45),
            YesButton.topAnchor.constraint(equalTo: getMedicationBottomView.topAnchor, constant: 15),
            // Make the buttons equal width
            NoButton.widthAnchor.constraint(equalTo:YesButton.widthAnchor),
            // Add spacing between the buttons
            YesButton.leadingAnchor.constraint(equalTo: NoButton.trailingAnchor, constant: 16)
        ])
        
        NoButton.addTarget(self, action: #selector(NoButtonTouchedDown), for: .touchDown)
        NoButton.addTarget(self, action: #selector(NoButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        YesButton.addTarget(self, action: #selector(YesButtonTouchedDown), for: .touchDown)
        YesButton.addTarget(self, action: #selector(YesButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        let getMedicationskipButtonTitle = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer") + " " + TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"))
        getMedicationskipButton.addTarget(self, action: #selector(getMedicationskipButtonTouchedDown), for: .touchDown)
        getMedicationskipButton.addTarget(self, action: #selector(getMedicationskipButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        getMedicationskipButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 10))
        getMedicationskipButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
        getMedicationskipButton.setAttributedTitle(getMedicationskipButtonTitle, for: .normal)
        getMedicationskipButton.layer.borderColor = UIColor.lightGray.cgColor
        getMedicationskipButton.layer.borderWidth = 1.0
        getMedicationskipButton.layer.cornerRadius = 10
        // Configure skipButton
        getMedicationskipButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer") + " " + TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"), for: .normal)
        getMedicationskipButton.setTitleColor(.black, for: .normal)
        getMedicationskipButton.backgroundColor = .white
        getMedicationskipButton.layer.borderWidth = 1
        getMedicationskipButton.layer.borderColor = UIColor.gray.cgColor
        getMedicationskipButton.layer.cornerRadius = 10
        getMedicationskipButton.translatesAutoresizingMaskIntoConstraints = false
        // Add buttons to painBottomView
        getMedicationBottomView.addSubview(getMedicationskipButton)
        
        // Set constraints for the buttons
        NSLayoutConstraint.activate([
            getMedicationskipButton.leadingAnchor.constraint(equalTo:getMedicationBottomView.leadingAnchor, constant: 16),
            getMedicationskipButton.trailingAnchor.constraint(equalTo:getMedicationBottomView.trailingAnchor, constant: -16),
            getMedicationskipButton.heightAnchor.constraint(equalToConstant: 45),
            getMedicationskipButton.topAnchor.constraint(equalTo:getMedicationBottomView.topAnchor, constant: 80),
        ])
    }
    
    func setupgetMedicationView() {
        
        getMedicationtopContainerView.backgroundColor = .white
        getMedicationtopContainerView.translatesAutoresizingMaskIntoConstraints = false
        getMedicationBottomView.addSubview(getMedicationtopContainerView)
        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.MEASURE.QUESTION", defaultText: "Have you taken other measures?")
        topLabel.font = .systemFont(ofSize: 13)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        getMedicationtopContainerView.addSubview(topLabel)
        getMedicationImage.translatesAutoresizingMaskIntoConstraints = false
        getMedicationImage.image = UIImage(named: "Logo")
        getMedicationImage.contentMode = .scaleAspectFit
        getMedicationBottomView.addSubview( getMedicationImage)
        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: getMedicationtopContainerView.topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: getMedicationtopContainerView.leadingAnchor, constant: 10),
            topLabel.trailingAnchor.constraint(equalTo: getMedicationtopContainerView.trailingAnchor, constant: -10),
            topLabel.bottomAnchor.constraint(equalTo: getMedicationtopContainerView.bottomAnchor, constant: -10),
            
            getMedicationImage.bottomAnchor.constraint(equalTo: getMedicationtopContainerView.bottomAnchor),
            getMedicationImage.leadingAnchor.constraint(equalTo: getMedicationtopContainerView.leadingAnchor, constant: -37),
            getMedicationImage.widthAnchor.constraint(equalToConstant: 30),
            getMedicationImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    var yesTap : (()->Void)?
    var NoTap  : (()->Void)?
    var displayError : (()->Void)?
    @objc func getMedicationskipButtonTouchedUp() {
        getMedicationskipButton.backgroundColor = . white
        NoTap?()
    }
    @objc func getMedicationskipButtonTouchedDown() {
        getMedicationskipButton.backgroundColor = .lightGray
     
    }
    @objc func NoButtonTouchedUp() {
        NoButton.backgroundColor = . lightGray
    }
    @objc func NoButtonTouchedDown(_ sender: UIButton) {
        NoButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
       
        // Get the title label text and capitalize it
        if let title = sender.currentTitle {
            let capitalizedTitle = title.uppercased()
            print("Capitalized Title: \(capitalizedTitle)")
            measuresModel.shared.saveTakeMeasures(take: capitalizedTitle){isSaved in
                if isSaved {
                    // Execute the closure if it exists
                    self.NoTap?()
                }else{
                    self.displayError?()
                }
                
            }
        }
    }
    
    @objc func YesButtonTouchedUp() {
        YesButton.backgroundColor = .lightGray
    }
    @objc func YesButtonTouchedDown(_ sender: UIButton) {
        YesButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    
        // Get the title label text and capitalize it
        if let title = sender.currentTitle {
            let capitalizedTitle = title.uppercased()
            print("Capitalized Title: \(capitalizedTitle)")
            measuresModel.shared.saveTakeMeasures(take: capitalizedTitle){isSaved in
                if isSaved {
                    // Execute the closure if it exists
                    self.yesTap?()
                }else{
                    self.displayError?()
                }
                
            }
        }
    }
    /// Function to update button states based on initial medication state
       func updateButtonStateBasedOnInitialMeasureState() {
           guard let initialState = measuresModel.shared.initialMeasuresState?.takeMeasures else { return }

           // Define the background color
           let selectedBackgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)

           // Reset both buttons to their default background color
           NoButton.backgroundColor = .lightGray
           YesButton.backgroundColor = .lightGray

           // Update the background color based on the state
           switch initialState {
           case "YES":
               YesButton.backgroundColor = selectedBackgroundColor
           case "NO":
               NoButton.backgroundColor = selectedBackgroundColor
           default:
               break
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
        getMedicationsetupUI()
        setupgetMedicationView()
        setupgetMedicationBottomView()
        getMedicationBottomView.layer.cornerRadius = 18
        updateButtonStateBasedOnInitialMeasureState()
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
        getMedicationsetupUI()
        setupgetMedicationView()
        setupgetMedicationBottomView()
        getMedicationBottomView.layer.cornerRadius = 18
        updateButtonStateBasedOnInitialMeasureState()
    }
}

class otherMeasuresTextFieldView: UIView, UITextFieldDelegate {
    
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
        guard let initialState = measuresModel.shared.initialMeasuresState,
              let otherMeasures = initialState.otherMeasures else {
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
        questionLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.OTHER.ACTIONS", defaultText: "What other actions have you taken?")
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
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        bottomView.addSubview(nextButton)
    }
    var nextTap : (()->Void)?
    var displayError : (()->Void)?
    @objc func nextButtonTapped(){
        let text = painTextField.text ?? ""
        measuresModel.shared.saveOtherMeasures(other: text){isSaved in
            if isSaved{
                self.nextTap?()
            }else{
                self.displayError?()
            }
            
        }
      
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
    }
    private func registerKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
     
        
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

   

enum MeasuresEnum: String {
    case worryAndInsecurity = "LEG_COMPRESSES"
    case highFever = "CLOTHS_ON_THE_FOREHEAD"
    case warningSigns = "ENEMA"
    case getAttestation = "LEMON_WATER_RUBS"
    case other = "OTHER_MEASURES"
    
    var userFriendlyDescription: String {
          switch self {
          case .worryAndInsecurity:
              return "leg compresses"
          case .highFever:
              return "cloths on the forehead"
          case .warningSigns:
              return "enema"
          case .getAttestation:
              return "lemon water rubs"
          case .other:
              return "other measures"
          }
      }
    // Get an enum case from an integer tag
       static func fromTag(_ tag: Int) -> MeasuresEnum? {
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

class MeasuresTakenView : UIView{
    
     let WarningSignscontainerView = UIView()
     let noAnswerButton = UIButton()
     let bottomView = UIView()
     let confirmButton = UIButton()
     let WarningSignsImage = UIImageView()
     var WarningSignsverticalStackView: UIStackView!
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
         
         let  WarningSignstopLabel = UILabel()
         WarningSignstopLabel.numberOfLines = 0
         WarningSignstopLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.MEASURE_KIND.QUESTION", defaultText: "Which measure(s) have you taken?")
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
         
         let warningSigns = [TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.MEASURE_KIND.OPTION.2.LABEL", defaultText: "Leg compresses"), TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.MEASURE_KIND.OPTION.3.LABEL", defaultText: "Cloths on the forehead"), TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.MEASURE_KIND.OPTION.10.LABEL", defaultText: "Enema"),TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.MEASURE_KIND.OPTION.11.LABEL", defaultText: "Lemon water rubs"),TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.MEASURE_KIND.OPTION.4.LABEL", defaultText: "Other measures")
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
         var enumStrings: [String] = []
         var checkedType = ""  // Initialize the checkedType string
            var selectedTags = [Int]()  // Array to hold the tags of selected checkboxes
            
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
         // Map tags to reasons and corresponding enum values
            let allMeasures = ["Leg compresses", "Cloths on the forehead", "Enema","Lemon water rubs","Other measures"]
            
            for tag in selectedTags {
                if tag < allMeasures.count {
                    let description = allMeasures[tag]
                    
                    // Map the description to its corresponding enum value
                    if let enumValue = MeasuresEnum.fromTag(tag) {
                        enumStrings.append(enumValue.rawValue)  // Append the rawValue (capitalized, with underscores)
                    }
                }
            }
            
         measuresModel.shared.saveMeasures(measures: enumStrings){isSaved in
             if isSaved{
                 // Call the closure with the determined checkedType
                 self.confirmButtonTap?(checkedType)
             }else{
                 self.displayError?()
             }
             
         }
            // Print the enumStrings array
            print("Selected reasons (enum values): \(enumStrings)")
     }
    func updateViewForEditingState() {
        guard let initialState = measuresModel.shared.initialMeasuresState else {
            return // No initial state, meaning this is a new entry
        }
        
        guard let measures = initialState.measures else {
            return // No measures to process
        }
        
        // Iterate through all arranged subviews in the stack view
        for view in WarningSignsverticalStackView.arrangedSubviews {
            if let stackView = view as? UIStackView,
               let checkbox = stackView.arrangedSubviews.first as? UIButton {
                
                // Get the tag and check if it corresponds to any measure in the initial state
                if let measure = MeasuresEnum.fromTag(checkbox.tag),
                   measures.contains(measure.rawValue) {
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
class CustomTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = UIEdgeInsets(top: 0, left: bounds.size.width, bottom: 0, right: 0) // This should hide it
        selectionStyle = .none // Optional: If you want no selection highlight
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
class MeasureDateTimeView: UIView, UIScrollViewDelegate{
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
    var displayError: (()->Void)?
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
        measuresModel.shared.saveMeasuresDateTime(date: selectedDate!){isSaved in
            if isSaved{
                self.confirmButtonTap?(selectedDate ?? Date())
                let entryId = AddEntryModel.shared.entryId
                AddEntryNetworkManager.shared.fetchAndUpdateLocalEntry(with: entryId!, overallDate: selectedDate ?? Date())
                
            }else{
                self.displayError?()
            }
            
        }
       
    
    }
    @objc func noAnswerButtonTapped(){
        noAnswerButtonTap?()
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
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCustomDatePicker()
        setupBottomView()
        setupSelectionIndicators()
        populateDateComponents()
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

