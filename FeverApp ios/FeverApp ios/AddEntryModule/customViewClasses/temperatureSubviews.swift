//
//  temperatureSubviews.swift
//  FeverApp ios
//
//  Created by NEW on 10/11/2024.
//

import UIKit
class textFieldValueView: UIView, UITextFieldDelegate {
    
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
        guard let initialState = temperatureModel.shared.initialTemperatureState,
              let tempValue = initialState.value else {
            print("NO INITIAL STATE FOR TEMP")
            return
        }
        painTextField.text = String(tempValue)
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
        questionLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE.QUESTION", defaultText: "How high is the temperature of {{name}}").replacingOccurrences(of: "{{name}}", with: profileName!)
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
        painTextField.keyboardType = .decimalPad // Set the keyboard type to number pad
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
        nextButton.isEnabled = false

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
    var displayErrorMessage : ((_ message: String)->Void)?
    // Button action handlers
    @objc func handleNext() {
        // Preprocess input: Replace commas with dots
           guard let text = painTextField.text?.replacingOccurrences(of: ",", with: ".") else {
               displayErrorMessage?("Please enter a valid temperature.")
               return
           }

           // Check for empty input
           if text.isEmpty {
               displayErrorMessage?("Temperature field cannot be empty.")
               return
           }

           // Check for non-numeric characters
           let validCharacters = CharacterSet(charactersIn: "0123456789.").inverted
           if text.rangeOfCharacter(from: validCharacters) != nil {
               displayErrorMessage?("Temperature can only contain numeric characters.")
               return
           }

           // Check for multiple decimal points
           if text.components(separatedBy: ".").count > 2 {
               displayErrorMessage?("Temperature cannot have multiple decimal points.")
               return
           }

           // Convert to Double and validate range
           if let temperature = Double(text) {
               // Ensure the value is positive and within range
               if temperature < 0 {
                   displayErrorMessage?("Temperature cannot be negative.")
               } else if !(35...42).contains(temperature) {
                   displayErrorMessage?("Temperature must be between 35 and 42.")
               } else {
                   temperatureModel.shared.saveTemperatureValue(temperature: temperature){isSaved in
                       if isSaved{
                           // All validations passed
                           self.handleNextTap?()
                       }else{
                           self.displayErrorMessage?("failed saving temperature please try again")
                       }
                   }
               }
           } else {
               displayErrorMessage?("Please enter a valid numeric temperature.")
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
enum TemperatureComparedToForehead: String {
    case equallyWarmOrWarmerHandsAndFeet = "EQUALLY_WARM_OR_WARMER_HANDS_AND_FEET"
    case coolerHandsAndFeet = "COOLER_HANDS_AND_FEET"
    
    // Computed property to get the user-friendly description
    var description: String {
        switch self {
        case .equallyWarmOrWarmerHandsAndFeet:
            return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.OPTION.1.DISPLAYLABEL", defaultText: "equally warm or warmer hands and/or equally warm or warmer feet?")
        case .coolerHandsAndFeet:
            return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.OPTION.2.DISPLAYLABEL", defaultText: "cooler hands and/or cooler feet?")
        }
    }
    
    // New initializer to map tags to enum cases
    static func fromTag(_ tag: Int) -> TemperatureComparedToForehead? {
        switch tag {
        case 0:
            return .equallyWarmOrWarmerHandsAndFeet
        case 1:
            return .coolerHandsAndFeet
        default:
            return nil
        }
    }
}

class TemperatureFirstView: UIView{
    let TemperatureBottomView = UIView()
    let TemperatureSubviewBottomView = BottomView()
    let TemperatureSubviewSkipButton = UIButton()
    let TemperatureSubviewConfirmButton = UIButton()
    let TemperatureTimeMessage = UIView()
    let TemperatureTopView = UIView()
    let TempBottomView = UIView()
    let firstButtonView = UIView()
    let secondButtonView = UIView()
    let thirdButtonView = UIView()
    let logoImageBView = UIImageView()
    let logoImageView = UIImageView()
    let topLabel = UILabel()
    let BottomLabel = UILabel()
    let firstLabel = UILabel()
    let secondLabel = UILabel()
    let thirdLabel = UILabel()
    // Constraints
    var thirdButtonToBottomViewConstraint: NSLayoutConstraint!
    var thirdButtonToMainViewConstraint: NSLayoutConstraint!
  
    enum WayOfDealingWithTemperature: String {
        case warm = "WARM"
        case cool = "COOL"
        case neitherWarmNorCool = "NEITHER_WARM_NOR_COOL"

        static func fromTag(_ tag: Int) -> WayOfDealingWithTemperature? {
            switch tag {
            case 0: return .warm
            case 1: return .cool
            case 2: return .neitherWarmNorCool
            default: return nil
            }
        }
    }
    func checkForInitialState(){
        // Unwrap the initial state and extract the date
        guard let initialState = temperatureModel.shared.initialTemperatureState,
              let comparison = initialState.comparison else {
            print("LEFT OHH NO INITIAL STATE FOR TEMP")
            return
        }
        // Check which button corresponds to the comparison value
           if comparison == "EQUALLY_WARM_OR_WARMER_HANDS_AND_FEET" {
               // Simulate tap on the first button view
          simulateButtonTapped(firstButtonView)
           } else if comparison == "COOLER_HANDS_AND_FEET" {
               // Simulate tap on the second button view
              simulateButtonTapped(secondButtonView)
           }else {
               // Simulate tap on the third button view
             simulateButtonTapped(thirdButtonView)
           }
    }
   

    // Tracks which button is selected
    var selectedButton: UIView?
    func setupTViews(){
        // Setup bottom view
        TempBottomView.backgroundColor = .white
        TempBottomView.translatesAutoresizingMaskIntoConstraints = false
        TempBottomView.layer.cornerRadius = 15
       self.addSubview(TempBottomView)
        
        // Setup button views
        [firstButtonView, secondButtonView, thirdButtonView].forEach { buttonView in
            buttonView.translatesAutoresizingMaskIntoConstraints = false
            buttonView.backgroundColor = .lightGray
            buttonView.layer.cornerRadius = 10
            buttonView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
            buttonView.addGestureRecognizer(tapGesture)
            self.addSubview(buttonView)
            // Button titles
            let buttonTitles = [TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.MEASURE.OPTION.1.LABEL", defaultText: "warm"), TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.MEASURE.OPTION.2.LABEL", defaultText: "cool"), TranslationsViewModel.shared.getTranslation(key: "PROFILE.MEASURE_FEVER_RISE.OPTION.3.LABEL", defaultText: "neither warm nor cool."), TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip")]
            // Create buttons with rounded borders
            var buttons: [UIButton] = []
            for (index, title) in buttonTitles.enumerated() {
                let button = UIButton(type: .system)
                button.addTarget(self, action: #selector(tempButtonTapped), for: .touchUpInside)
                button.setTitle(title, for: .normal)
                button.setTitleColor(.black, for: .normal) // Set text color to black
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                button.backgroundColor = .white
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.layer.borderWidth = 1
                button.layer.cornerRadius = 8 // Adjust corner radius as desired
                button.tag = index // Assign tag corresponding to the index
                button.translatesAutoresizingMaskIntoConstraints = false
                TempBottomView.addSubview(button)
                buttons.append(button)
            }
            
            // Set button constraints (2x2 grid)
            NSLayoutConstraint.activate([
                // Top left button
                buttons[0].topAnchor.constraint(equalTo: TempBottomView.topAnchor, constant: 15),
                buttons[0].leadingAnchor.constraint(equalTo: TempBottomView.leadingAnchor, constant: 10),
                buttons[0].widthAnchor.constraint(equalTo: TempBottomView.widthAnchor, multiplier: 0.46),
                buttons[0].heightAnchor.constraint(equalToConstant: 40),
                // Top right button
                buttons[1].topAnchor.constraint(equalTo: TempBottomView.topAnchor, constant: 15),
                buttons[1].trailingAnchor.constraint(equalTo: TempBottomView.trailingAnchor, constant: -10),
                buttons[1].widthAnchor.constraint(equalTo: TempBottomView.widthAnchor, multiplier: 0.46),
                buttons[1].heightAnchor.constraint(equalToConstant: 40),
                // Bottom left button
                buttons[2].topAnchor.constraint(equalTo: buttons[0].bottomAnchor, constant: 10),
                buttons[2].leadingAnchor.constraint(equalTo: TempBottomView.leadingAnchor, constant: 10),
                buttons[2].widthAnchor.constraint(equalTo: TempBottomView.widthAnchor, multiplier: 0.46),
                buttons[2].heightAnchor.constraint(equalToConstant: 40),
                
                // Bottom right button
                buttons[3].topAnchor.constraint(equalTo: buttons[1].bottomAnchor, constant: 10),
                buttons[3].trailingAnchor.constraint(equalTo: TempBottomView.trailingAnchor, constant: -10),
                buttons[3].widthAnchor.constraint(equalTo: TempBottomView.widthAnchor, multiplier: 0.46),
                buttons[3].heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        self.addSubview(TemperatureTopView)
        // Setup topView
        TemperatureTopView.translatesAutoresizingMaskIntoConstraints = false
        TemperatureTopView.backgroundColor = .white
        TemperatureTopView.layer.cornerRadius = 10
        TemperatureTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        TemperatureTopView.layer.shadowColor = UIColor.black.cgColor
        TemperatureTopView.layer.shadowOpacity = 0.3
        TemperatureTopView.layer.shadowOffset = CGSize(width: 0, height: 2)
        TemperatureTopView.layer.shadowRadius = 4
        // Adding top view to the main container view
        self.addSubview(TemperatureBottomView)
        
        // Setup bottomView
        TemperatureBottomView.translatesAutoresizingMaskIntoConstraints = false
        TemperatureBottomView.backgroundColor = .white
        TemperatureBottomView.layer.cornerRadius = 10
        TemperatureBottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        TemperatureBottomView.layer.shadowColor = UIColor.black.cgColor
        TemperatureBottomView.layer.shadowOpacity = 0.3
        TemperatureBottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        TemperatureBottomView.layer.shadowRadius = 4
        
        NSLayoutConstraint.activate([
            TemperatureTopView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            TemperatureTopView.trailingAnchor.constraint(equalTo:  self.trailingAnchor, constant: -133),
            TemperatureTopView.bottomAnchor.constraint(equalTo: firstButtonView.topAnchor, constant:-27),
            TemperatureTopView.heightAnchor.constraint(equalToConstant: 70),
            
            TemperatureBottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            TemperatureBottomView.trailingAnchor.constraint(equalTo:  self.trailingAnchor, constant: -156),
            TemperatureBottomView.bottomAnchor.constraint(equalTo: TempBottomView.topAnchor, constant:-18),
            TemperatureBottomView.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        // Add image to topView
        self.addSubview(logoImageBView)
        logoImageBView.translatesAutoresizingMaskIntoConstraints = false
        logoImageBView.image = UIImage(named: "Logo")
        logoImageBView.contentMode = .scaleAspectFit
        // Add image to topView
       self.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "Logo")
        logoImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            logoImageBView.bottomAnchor.constraint(equalTo: TemperatureBottomView.bottomAnchor),
            logoImageBView.leadingAnchor.constraint(equalTo: TemperatureBottomView.leadingAnchor, constant: -35),
            logoImageBView.widthAnchor.constraint(equalToConstant: 30),
            logoImageBView.heightAnchor.constraint(equalToConstant: 30),
            logoImageView.bottomAnchor.constraint(equalTo: TemperatureTopView.bottomAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: TemperatureTopView.leadingAnchor, constant: -35),
            logoImageView.widthAnchor.constraint(equalToConstant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        // Add label to topView BottomLabel
        TemperatureBottomView.addSubview(BottomLabel)
        BottomLabel.translatesAutoresizingMaskIntoConstraints = false
        BottomLabel.numberOfLines = 0
        BottomLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.MEASURE.QUESTION", defaultText: "Do you keep {{name}}").replacingOccurrences(of: "{{name}}", with: profileName!)
        BottomLabel.font = UIFont.systemFont(ofSize: 14)
        
        TemperatureTopView.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.numberOfLines = 0
        topLabel.attributedText = NSAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.QUESTION", defaultText: "Does {{name}} have compared to the forehead …").replacingOccurrences(of: "{{name}}", with: profileName!).replacingOccurrences(of: "{{pp}}", with: profileName!), attributes: [.kern: 0.5, .paragraphStyle: { let p = NSMutableParagraphStyle(); p.lineSpacing = 5; return p }()])
        topLabel.font = UIFont.systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
            BottomLabel.leadingAnchor.constraint(equalTo:TemperatureBottomView.leadingAnchor, constant: 10),
            BottomLabel.trailingAnchor.constraint(equalTo:TemperatureBottomView.trailingAnchor, constant: -10),
            BottomLabel.centerYAnchor.constraint(equalTo: TemperatureBottomView.centerYAnchor),
            
            
            topLabel.leadingAnchor.constraint(equalTo:TemperatureTopView.leadingAnchor, constant: 10),
            topLabel.trailingAnchor.constraint(equalTo:TemperatureTopView.trailingAnchor, constant: -10),
            topLabel.centerYAnchor.constraint(equalTo: TemperatureTopView.centerYAnchor)
        ])
    }
    func hideTopView(){
        TemperatureTopView.isHidden = true
        logoImageView.isHidden = true
    }
    func revealTopView(){
        TemperatureTopView.isHidden = false
        logoImageView.isHidden = false
    }
    var comparismButtonViews : [UIView] = []
    func setupConstraints() {
        // First button
        setupSingleButton(buttonView: firstButtonView, label: firstLabel, text: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.OPTION.1.LABEL", defaultText: "equally warm or warmer hands and/or equally warm or warmer feet?"))
        
        // Second button
        setupSingleButton(buttonView: secondButtonView, label: secondLabel, text: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.OPTION.2.LABEL", defaultText: "cooler hands and/or cooler feet?"))
        // Third button
        setupSingleButton(buttonView: thirdButtonView, label: thirdLabel, text: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "no answer"))
        giveTagsToButtonViews()
        // Constraints for bottomView
        NSLayoutConstraint.activate([
            TempBottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            TempBottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            TempBottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            TempBottomView.heightAnchor.constraint(equalToConstant: 160) // Fixed height of 130 points
        ])
        
        // Constraints for button views
        NSLayoutConstraint.activate([
            firstButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 150),
            firstButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            firstButtonView.heightAnchor.constraint(equalToConstant: 80),
            
            secondButtonView.leadingAnchor.constraint(equalTo: firstButtonView.leadingAnchor),
            secondButtonView.trailingAnchor.constraint(equalTo: firstButtonView.trailingAnchor),
            secondButtonView.heightAnchor.constraint(equalToConstant: 55),
            secondButtonView.topAnchor.constraint(equalTo: firstButtonView.bottomAnchor, constant: 15),
            
            thirdButtonView.leadingAnchor.constraint(equalTo: firstButtonView.leadingAnchor),
            thirdButtonView.trailingAnchor.constraint(equalTo: firstButtonView.trailingAnchor),
            thirdButtonView.heightAnchor.constraint(equalToConstant: 45),
            thirdButtonView.topAnchor.constraint(equalTo: secondButtonView.bottomAnchor, constant: 15),
        ])
        
        // Constraints for thirdButtonView based on bottomView visibility
        thirdButtonToBottomViewConstraint = thirdButtonView.bottomAnchor.constraint(equalTo: TempBottomView.topAnchor, constant: -80)
        thirdButtonToMainViewConstraint = thirdButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -35)
    }
    func giveTagsToButtonViews(){
        for (i, buttonView) in comparismButtonViews.enumerated(){
            buttonView.tag = i
        }
    }
    func setupSingleButton(buttonView: UIView, label: UILabel, text: String) {
      self.addSubview(buttonView)
        // Add shadow
        buttonView.layer.shadowColor = UIColor.black.cgColor
        buttonView.layer.shadowOpacity = 0.5
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonView.layer.masksToBounds = false
        
        // Setup button view
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.backgroundColor = UIColor.lightGray
        buttonView.layer.cornerRadius = 10
        buttonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        
        // Add tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonTapped(_:)))
        buttonView.addGestureRecognizer(tapGestureRecognizer)
        buttonView.isUserInteractionEnabled = true
        comparismButtonViews.append(buttonView)
        // Add label to button view
        buttonView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        
        // Set up the paragraph style with line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5  // Adjust line spacing as needed
        
        // Create attributed string with the paragraph style
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: label.font!  // Apply the font style to match the label's font
            ]
        )
        
        label.attributedText = attributedString
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
    }
    
    @objc func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let buttonView = sender.view else { return }
        
        if buttonView == selectedButton {
            revealTopView()
            // If the same button is tapped again, deselect and hide views
            buttonView.backgroundColor = UIColor.lightGray
            TemperatureBottomView.isHidden = true
            TempBottomView.isHidden = true
            logoImageBView.isHidden = true
            thirdButtonToBottomViewConstraint.isActive = false
            thirdButtonToMainViewConstraint.isActive = true
            selectedButton = nil // Deselect the button
        } else {
            let isSmallScreen = UIScreen.main.bounds.height < 700
            // Reset the background color of the previously selected button
            selectedButton?.backgroundColor = UIColor.lightGray
            
            // Set the new selected button to blue
            buttonView.backgroundColor = UIColor(red: 50/255, green: 90/255, blue: 200/255, alpha: 1)
            if isSmallScreen == true {
                hideTopView()
            }
            // Show the views
            TemperatureBottomView.isHidden = false
            TempBottomView.isHidden = false
            logoImageBView.isHidden = false
            thirdButtonToMainViewConstraint.isActive = false
            thirdButtonToBottomViewConstraint.isActive = true
            
            // Set the selected button to the current buttonView
            selectedButton = buttonView
        }
    }
     func simulateButtonTapped(_ buttonView: UIView) {
       
        
        if buttonView == selectedButton {
            revealTopView()
            // If the same button is tapped again, deselect and hide views
            buttonView.backgroundColor = UIColor.lightGray
            TemperatureBottomView.isHidden = true
            TempBottomView.isHidden = true
            logoImageBView.isHidden = true
            thirdButtonToBottomViewConstraint.isActive = false
            thirdButtonToMainViewConstraint.isActive = true
            selectedButton = nil // Deselect the button
        } else {
            let isSmallScreen = UIScreen.main.bounds.height < 700
            // Reset the background color of the previously selected button
            selectedButton?.backgroundColor = UIColor.lightGray
            
            // Set the new selected button to blue
            buttonView.backgroundColor = UIColor(red: 50/255, green: 90/255, blue: 200/255, alpha: 1)
            if isSmallScreen == true {
                hideTopView()
            }
            // Show the views
            TemperatureBottomView.isHidden = false
            TempBottomView.isHidden = false
            logoImageBView.isHidden = false
            thirdButtonToMainViewConstraint.isActive = false
            thirdButtonToBottomViewConstraint.isActive = true
            
            // Set the selected button to the current buttonView
            selectedButton = buttonView
        }
    }
    var tempButtonTap : (()->Void)?
    var displayErrorMessage : (()->Void)?
    @objc func tempButtonTapped(_ sender: UIButton){
     
        var wayOfDealingWithTemperature = sender.titleLabel?.text
        var temperatureComparism : String?
        
        if let temperatureComparison = TemperatureComparedToForehead.fromTag(selectedButton?.tag ?? 9) {
            temperatureComparism = temperatureComparison.rawValue
            print("Mapped to enum case: \(temperatureComparison.rawValue)") // Outputs: Mapped to enum case: COOLER_HANDS_AND_FEET
        } else {
            temperatureComparism = nil
            print("Invalid temperature comparison.")
        }
        
        if let dealingWithTemperature = WayOfDealingWithTemperature.fromTag(sender.tag) {
            if let dealingWithTemperature = WayOfDealingWithTemperature.fromTag(sender.tag) {
                print("Mapped to enum case: \(dealingWithTemperature.rawValue)") // Outputs: Mapped to enum case: WARM
                wayOfDealingWithTemperature = dealingWithTemperature.rawValue
            } else {
                print("Invalid way of dealing with temperature.")
                wayOfDealingWithTemperature = "skip"
            }
        } else {
            print("Invalid way of dealing with temperature.")
        }

        if temperatureComparism != nil{
            temperatureModel.shared.saveTemperatureComparedToForeHead(comparism: temperatureComparism!){isSaved in
                if isSaved{
                   
                }else{
                   
                }
            }
        }
        if sender.tag != 3{
            temperatureModel.shared.saveWayOfDealingWithTemperature(wayOfDealing: wayOfDealingWithTemperature!){isSaved in
                if isSaved{
                    self.tempButtonTap?()
                }else{
                    self.displayErrorMessage?()
                }
            }
        }else {
            self.tempButtonTap?()
        }
    }
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Check if the screen height is less than the height of iPhone XR
        let isSmallScreen = UIScreen.main.bounds.height < 896
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreen ? 460 : 600
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
        setupTViews()
        setupConstraints()
        // Initially hide bottomView and set constraints
        TemperatureBottomView.isHidden = true
        TempBottomView.isHidden = true
        logoImageBView.isHidden = true
        thirdButtonToBottomViewConstraint.isActive = false
        thirdButtonToMainViewConstraint.isActive = true
        checkForInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // Check if the screen height is less than the height of iPhone XR
        let isSmallScreen = UIScreen.main.bounds.height < 896

        // Set the button height based on screen size
 

        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreen ? 460 : 600
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight)
        ])
        setupTViews()
        setupConstraints()
        // Initially hide bottomView and set constraints
        TemperatureBottomView.isHidden = true
        TempBottomView.isHidden = true
        logoImageBView.isHidden = true
        thirdButtonToBottomViewConstraint.isActive = false
        thirdButtonToMainViewConstraint.isActive = true
        checkForInitialState()
    }
   
}
enum TemperatureMeasurementLocations: String {
    case inTheRectum = "IN_THE_RECTUM"
    case inTheEar = "IN_THE_EAR"
    case inTheMouth = "IN_THE_MOUTH"
    case onTheForehead = "ON_THE_FOREHEAD"
    case underTheArm = "UNDER_THE_ARM"

    // Computed property for user-friendly descriptions
    var description: String {
        switch self {
        case .inTheRectum:
            return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.1.LABEL", defaultText: "In the rectum")
        case .inTheEar:
            return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.2.LABEL", defaultText: "In the ear")
        case .inTheMouth:
            return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.3.LABEL", defaultText: "In the mouth")
        case .onTheForehead:
            return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.4.LABEL", defaultText: "On the forehead")
        case .underTheArm:
            return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.5.LABEL", defaultText: "Under the arm")
        }
    }

    // New method to convert from tag to enum case
    static func fromTag(_ tag: Int) -> TemperatureMeasurementLocations? {
        switch tag {
        case 0:
            return .inTheRectum
        case 1:
            return .inTheEar
        case 2:
            return .inTheMouth
        case 3:
            return .onTheForehead
        case 4:
            return .underTheArm
        default:
            return nil
        }
    }
}

class TemperatureLocationView: UIView {

    // MARK: - Properties
    let TemperaturemeasurementTopView = UIView()
    let firstRectumButtonView = UIButton()
    let secondearButtonView = UIButton()
    let thirdmouthButtonView = UIButton()
    let fourthheadButtonView = UIButton()// New fourth button view
    let fiftharmButtonView = UIButton()// New fifth button view
    let logoImageAView = UIImageView()
    let topALabel = UILabel()
    let firstRectumLabel = UILabel()
    let secondearLabel = UILabel()
    let thirdmouthLabel = UILabel()
    let fourthheadLabel = UILabel() // New fourth label
    let fiftharmLabel = UILabel() // New fifth label
    
    // Tracks which button is selected
    var selectedButton: UIView?
    func checkForInitialState(){
        // Unwrap the initial state and extract the date
        guard let initialState = temperatureModel.shared.initialTemperatureState,
              let tempLocation = initialState.location else {
            print("NO INITIAL STATE FOR TEMP")
            return
        }
        switch tempLocation {
        case "IN_THE_RECTUM" :
            firstRectumButtonView.backgroundColor = UIColor(white: 0.5, alpha: 1) // Lighter gray
            break
        case "IN_THE_EAR" :
         secondearButtonView.backgroundColor = UIColor(white: 0.5, alpha: 1) // Lighter gray
            break
        case "IN_THE_MOUTH" :
            thirdmouthButtonView.backgroundColor = UIColor(white: 0.5, alpha: 1) // Lighter gray
            break
        case "ON_THE_FOREHEAD" :
            fourthheadButtonView.backgroundColor = UIColor(white: 0.5, alpha: 1) // Lighter gray
            break
        case "UNDER_THE_ARM" :
          fiftharmButtonView.backgroundColor = UIColor(white: 0.5, alpha: 1) // Lighter gray
            break
        default: break
            
        }
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLogoImageView()
        setupConstraints()
        checkForInitialState()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupLogoImageView()
        setupConstraints()
        checkForInitialState()
    }

    // MARK: - Setup Methods

    private func setupViews() {
        // Setup Temperature measurement views
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
   

        TemperaturemeasurementTopView.translatesAutoresizingMaskIntoConstraints = false
        TemperaturemeasurementTopView.backgroundColor = .white
        TemperaturemeasurementTopView.layer.cornerRadius = 10
        TemperaturemeasurementTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        TemperaturemeasurementTopView.layer.shadowColor = UIColor.black.cgColor
        TemperaturemeasurementTopView.layer.shadowOpacity = 0.3
        TemperaturemeasurementTopView.layer.shadowOffset = CGSize(width: 0, height: 2)
        TemperaturemeasurementTopView.layer.shadowRadius = 4
        self.addSubview(TemperaturemeasurementTopView)
        
        // Setup button views
        let buttonViews = [firstRectumButtonView, secondearButtonView, thirdmouthButtonView, fourthheadButtonView, fiftharmButtonView]
        for (index, buttonView) in buttonViews.enumerated(){
            buttonView.translatesAutoresizingMaskIntoConstraints = false
            buttonView.backgroundColor = UIColor(white: 0.9, alpha: 1) // Lighter gray
            buttonView.layer.cornerRadius = 10
            buttonView.tag = index
            buttonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            buttonView.isUserInteractionEnabled = true
            setupButtonInteractions(buttonView: buttonView)
            self.addSubview(buttonView)
        }

        // Setup buttons with labels
        setupSingleButton(buttonView: firstRectumButtonView, label: firstRectumLabel, text: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.1.LABEL", defaultText: "In the rectum"))
        setupSingleButton(buttonView: secondearButtonView, label: secondearLabel, text: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.2.LABEL", defaultText: "In the ear"))
        setupSingleButton(buttonView: thirdmouthButtonView, label: thirdmouthLabel, text: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.3.LABEL", defaultText: "In the mouth"))
        setupSingleButton(buttonView: fourthheadButtonView, label: fourthheadLabel, text: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.4.LABEL", defaultText: "On the forehead"))
        setupSingleButton(buttonView: fiftharmButtonView, label: fiftharmLabel, text: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.5.LABEL", defaultText: "Under the arm"))

        // Setup logo image view
        setupLogoImageView()
        
        // Setup label in the top view
        topALabel.translatesAutoresizingMaskIntoConstraints = false
        topALabel.numberOfLines = 0
        topALabel.attributedText = NSAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.QUESTION", defaultText: "How did you measure it?"))
        topALabel.font = UIFont.systemFont(ofSize: 14)
        TemperaturemeasurementTopView.addSubview(topALabel)
    }
    private func setupButtonInteractions(buttonView: UIButton) {
        // Set initial background color
        buttonView.addTarget(self, action: #selector(tempButtontTap), for: .touchUpInside)
    }
    var handleTempLocationTap : (()->Void)?
    private func setupLogoImageView() {
        logoImageAView.image = UIImage(named: "Logo") // Ensure the image name is correct
        logoImageAView.translatesAutoresizingMaskIntoConstraints = false
        logoImageAView.contentMode = .scaleAspectFit
        self.addSubview(logoImageAView)
    }

    private func setupSingleButton(buttonView: UIView, label: UILabel, text: String) {
        buttonView.layer.shadowColor = UIColor.black.cgColor
        buttonView.layer.shadowOpacity = 0.3
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonView.layer.shadowRadius = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        buttonView.addSubview(label)
    }
    var displayErrorMessage: (()->Void)?
    @objc func tempButtontTap(_ sender : UIView){
        var temperatureLocationEnumString : String?
        // Use the `fromDescription` method to find the corresponding enum case
        if let locationEnum = TemperatureMeasurementLocations.fromTag(sender.tag) {
            temperatureLocationEnumString = locationEnum.rawValue
        } else {
            // The description didn't match any enum case
            print("Invalid description.")
        }
        
        temperatureModel.shared.saveTemperatureMeasurementLocation(temperatureLocation: temperatureLocationEnumString!){isSaved in
            if isSaved{
                self.handleTempLocationTap?()
            }else{
                self.displayErrorMessage?()
            }
        }
     
    }

    // MARK: - Setup Constraints

    private func setupConstraints() {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 20
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        // Set up the "No answer Skip" button with different colors for "No answer" and "Skip"
         let skipButton = UIButton(type: .system)
         // Create an attributed title with "No answer" in black and "Skip" in gray
         let noAnswerAttributes: [NSAttributedString.Key: Any] = [
           .foregroundColor: UIColor.black
         ]
         let skipAttributes: [NSAttributedString.Key: Any] = [
           .foregroundColor: UIColor.gray
         ]
         let attributedTitle = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"), attributes: noAnswerAttributes)
         let skipString = NSAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"), attributes: skipAttributes)
         attributedTitle.append(skipString)
         skipButton.setAttributedTitle(attributedTitle, for: .normal)
         skipButton.backgroundColor = .white
         skipButton.layer.cornerRadius = 10 // Rounded corners
         skipButton.layer.borderWidth = 1
         skipButton.layer.borderColor = UIColor.lightGray.cgColor
         skipButton.translatesAutoresizingMaskIntoConstraints = false
         // Add action to button
         skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
         // Add button to the TemperaturemeasurementMainView
         bottomView.addSubview(skipButton)
        
        self.addSubview(bottomView)
         // Set up button constraints
         NSLayoutConstraint.activate([
           skipButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30),
           skipButton.heightAnchor.constraint(equalToConstant: 40),
           skipButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15),
           skipButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15),
           bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
           bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
           bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
           bottomView.heightAnchor.constraint(equalToConstant: 90),
         ])
         // Add chevron button
         let chevronButton = UIButton()
         chevronButton.translatesAutoresizingMaskIntoConstraints = false
         chevronButton.layer.cornerRadius = 10
         // Add chevron image to button
         let chevronConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
         let chevronImage = UIImage(systemName: "chevron.up", withConfiguration: chevronConfig)
         chevronButton.setImage(chevronImage, for: .normal)
         chevronButton.tintColor = .lightGray
         // Add action to button
         chevronButton.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
         // Add button to TemperatureMainView
         self.addSubview(chevronButton)
         // Set up button constraints
         NSLayoutConstraint.activate([
           chevronButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -150),
           chevronButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
           chevronButton.bottomAnchor.constraint(equalTo: TemperaturemeasurementTopView.topAnchor, constant: -15),
           chevronButton.widthAnchor.constraint(equalToConstant: 100),
           chevronButton.heightAnchor.constraint(equalToConstant: 100)
         ])
        // Check if the screen height is less than the height of iPhone XR
        let isSmallScreen = false

        // Set the button height based on screen size
        let buttonHeight: CGFloat = isSmallScreen ? 30 : 45  // Smaller height for screens shorter than iPhone XR
        let buttonSpacing: CGFloat = isSmallScreen ? 15 : 20  // Reduce spacing for smaller screens
      

        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreen ? 460 : 600
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),

            // Constraints for TemperaturemeasurementTopView
            TemperaturemeasurementTopView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            TemperaturemeasurementTopView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -133),
            TemperaturemeasurementTopView.bottomAnchor.constraint(equalTo: firstRectumButtonView.topAnchor, constant: -27),
            TemperaturemeasurementTopView.heightAnchor.constraint(equalToConstant: 45),
            
            // Constraints for topALabel
            topALabel.leadingAnchor.constraint(equalTo: TemperaturemeasurementTopView.leadingAnchor, constant: 10),
            topALabel.trailingAnchor.constraint(equalTo: TemperaturemeasurementTopView.trailingAnchor, constant: -20),
            topALabel.centerYAnchor.constraint(equalTo: TemperaturemeasurementTopView.centerYAnchor),

            // Constraints for the logo image view
            logoImageAView.bottomAnchor.constraint(equalTo: TemperaturemeasurementTopView.bottomAnchor),
            logoImageAView.leadingAnchor.constraint(equalTo: TemperaturemeasurementTopView.leadingAnchor, constant: -35),
            logoImageAView.widthAnchor.constraint(equalToConstant: 30),
            logoImageAView.heightAnchor.constraint(equalToConstant: 30),

            // Constraints for button views
            firstRectumButtonView.topAnchor.constraint(equalTo: TemperaturemeasurementTopView.bottomAnchor, constant: 20),
            firstRectumButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 70),
            firstRectumButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            firstRectumButtonView.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            secondearButtonView.topAnchor.constraint(equalTo: firstRectumButtonView.bottomAnchor, constant: buttonSpacing),
            secondearButtonView.leadingAnchor.constraint(equalTo: firstRectumButtonView.leadingAnchor),
            secondearButtonView.trailingAnchor.constraint(equalTo: firstRectumButtonView.trailingAnchor),
            secondearButtonView.heightAnchor.constraint(equalTo: firstRectumButtonView.heightAnchor),
            
            thirdmouthButtonView.topAnchor.constraint(equalTo: secondearButtonView.bottomAnchor, constant: 20),
            thirdmouthButtonView.leadingAnchor.constraint(equalTo: firstRectumButtonView.leadingAnchor),
            thirdmouthButtonView.trailingAnchor.constraint(equalTo: firstRectumButtonView.trailingAnchor),
            thirdmouthButtonView.heightAnchor.constraint(equalTo: firstRectumButtonView.heightAnchor),
            
            fourthheadButtonView.topAnchor.constraint(equalTo: thirdmouthButtonView.bottomAnchor, constant: 20),
            fourthheadButtonView.leadingAnchor.constraint(equalTo: firstRectumButtonView.leadingAnchor),
            fourthheadButtonView.trailingAnchor.constraint(equalTo: firstRectumButtonView.trailingAnchor),
            fourthheadButtonView.heightAnchor.constraint(equalTo: firstRectumButtonView.heightAnchor),
            
            fiftharmButtonView.topAnchor.constraint(equalTo: fourthheadButtonView.bottomAnchor, constant: 20),
            fiftharmButtonView.leadingAnchor.constraint(equalTo: firstRectumButtonView.leadingAnchor),
            fiftharmButtonView.trailingAnchor.constraint(equalTo: firstRectumButtonView.trailingAnchor),
            fiftharmButtonView.heightAnchor.constraint(equalTo: firstRectumButtonView.heightAnchor),
            fiftharmButtonView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10),
        ])

        // Constraints for each button's label
        setupButtonLabelConstraints(buttonView: firstRectumButtonView, label: firstRectumLabel)
        setupButtonLabelConstraints(buttonView: secondearButtonView, label: secondearLabel)
        setupButtonLabelConstraints(buttonView: thirdmouthButtonView, label: thirdmouthLabel)
        setupButtonLabelConstraints(buttonView: fourthheadButtonView, label: fourthheadLabel)
        setupButtonLabelConstraints(buttonView: fiftharmButtonView, label: fiftharmLabel)
    }
    @objc func skipButtonTapped() {
        handleTempLocationTap?()
      // Action for skip button
      print("Skip button tapped!")
    }
    @objc func chevronButtonTapped() {
      // Action for chevron button
      print("Chevron button tapped!")
    }

    private func setupButtonLabelConstraints(buttonView: UIView, label: UILabel) {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
    }
}
class TemperatureValueDateView: UIView, UIScrollViewDelegate{
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
        confirmButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
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
        if stateOfHealthModel.shared.initialStateOfHealth != nil {
            scrollToInitialState()
        }else{
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
    func scrollToInitialState() {
        // Unwrap the initial state and extract the date
        guard let initialState = stateOfHealthModel.shared.initialStateOfHealth,
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
    var handleNoAnswerTap: (()->Void)?
    var handleConfirmTap: ((_ selectedDate: Date)->Void)?
    @objc func handleNoAnswer() {
       handleNoAnswerTap?()
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

    // Helper function to localize and parse the date part
    private func localizedDate(from datePart: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateStyle = .medium
        return formatter.date(from: datePart) ?? Date.distantPast
    }

    var displayError : (()->Void)?
    @objc func handleConfirm() {
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
        temperatureModel.shared.saveTemperatureValueDate(date: selectedDate!){ isSaved in
            if isSaved{
                self.handleConfirmTap?(selectedDate ?? Date())
                let entryId = AddEntryModel.shared.entryId
                AddEntryNetworkManager.shared.fetchAndUpdateLocalEntry(with: entryId!, overallDate: selectedDate ?? Date())
                
            }else{
                self.displayError?()
            }
        
        }
    }
}
class TemperatureVaccineDateView: UIView, UIScrollViewDelegate{
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
    var vaccineDate : Date?
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        // Question Label
        questionLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.INJECTION_DATE.QUESTION", defaultText: "When did {{name}} receive a vaccination?").replacingOccurrences(of: "{{name}}", with: profileName!)
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
      
       let vaccineDateString = getSelectedDate()
    
            print("Selected Date: \(vaccineDateString)")
       
        // Convert the selected date string to a Date object
            if let SelectedDate = parseSelectedDate(from: vaccineDateString) {
                print("Selected Date (Date object): \(SelectedDate)")
                vaccineDate = SelectedDate
                vaccinationModel.shared.saveVaccinationDate(vaccineDate: SelectedDate){isSaved in
                    if isSaved{
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

class TemperatureVaccineListView: UIView, UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate{
    // mainPainTimeView components

     let messageBubbleView = UIView()
     let messageLabel = UILabel()
     let smileyFaceImageView = UIImageView()
     let dropdownTextField = UITextField()
     let dropdownButton = UIButton(type: .system)
     let skipContainerView = UIView()
     let skipButton = UIButton(type: .system)
     let upArrowButton = UIButton(type: .system)
     
     // Table properties
     let vaccinesTableView = UITableView()
     let vaccines =  [
         // A
         "Act-Hib",
         "Apexxnar",
         // B
         "Bexsero",
         "Beyfortus",
         "Boostrix",
         "Boostrix Polio",
         // C
         "Cervarix",
         "COVID-19-Vaccines(anyone)",
         "COVID-19-Vaxzevria (Astra Zenca)",
         "COVID-19-Cominaty (BioNTech)",
         "COVID-19-Spikevax (Moderna)",
         "COVID-19-Vaccine (Janssen)",
         "COVID-19-Sputnik V (Biocad)",
         "Covaxis",
         // D
         "Dipheterie NF",
         "Dukoral",
         // E
         "Encepur adults",
         "Encepur children",
         "Engerix B adults",
         "Engerix B children",
         // F
         "Fluad",
         "FSME-Immun Adult",
         "FSME-Immun Junior",
         "Flu Vaccination",
         // G
         "Gardasil",
         "HAVpur",
         // H
         "Havrix 1440 adults",
         "Havrix 1440 children",
         "HBVAXPRO",
         "Hexacima",
         "Hexyon",
         // I
         "Imovax polio",
         "Infanrix",
         "Infanrix hexa",
         "Infanrix-IPV + Hib",
         "Influspit Tetra",
         "IXIARO",
         // M
         "Masern Merieux",
         "Meningitec",
         "Meningitec",
         "Menjugate",
         "MenQuadfi",
         "Menveo",
         "MMR-VaxPro",
         "NeisVacC",
         // N
         "Nimenrix",
         // P
         "Pentavac",
         "Pneumovax 23",
         "Prevenar13",
         "Priorix",
         "Priorix-Tetra",
         "ProQuad",
         // R
         "Rabipur",
         "Repevax",
         "Revaxis",
         "Rotarix",
         "RotaTEq",
         "Shingrix",
         // S
         "Stamaril",
         "Synagis",
         "Synflorix",
         // T
         "Tdap-IMMUN",
         "Td-Impfstoff Merieux",
         "Td-IMMUN",
         "Td-pur",
         "Td-Rix",
         "Tetagam P",
         "Tetanol pur",
         "Tetanus Merieux",
         "Tetravac",
         "Rabies vaccine (HDC)",
         "Tritanrix-Hep B",
         "Trumenba",
         "Twinrix adults",
         "Twinrix children",
         "Typhim Vi",
         "Typhoral",
         "VAQTA",
         "VAQTA Children",
         "Varicellon",
         "Varilrix",
         "Varitect CP",
         "VARIVAX",
         "Vaxelis",
         "VAXIGRIP TETRA",
         "Vaxneuvance",
         "Viatim",
         "ZOSTAVAX",
         "- Other vaccines"
     ]
    var selectedVaccines: [String] = []
    
     func setupRedContainerView() {
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
     func setupMessageBubble() {
         self.addSubview(dropdownTextField)
         // Configure the bubble view
         messageBubbleView.translatesAutoresizingMaskIntoConstraints = false
         messageBubbleView.backgroundColor = .white
         messageBubbleView.layer.cornerRadius = 10
         self.addSubview(messageBubbleView)
         messageBubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
         messageBubbleView.layer.shadowColor = UIColor.black.cgColor
            messageBubbleView.layer.shadowOpacity = 0.2
            messageBubbleView.layer.shadowOffset = CGSize(width: 0, height: 4)
            messageBubbleView.layer.shadowRadius = 4
         NSLayoutConstraint.activate([
             messageBubbleView.bottomAnchor.constraint(equalTo: dropdownTextField.topAnchor, constant: -20),
             messageBubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
             messageBubbleView.heightAnchor.constraint(equalToConstant: 155),
             messageBubbleView.widthAnchor.constraint(equalToConstant: 130),
            
             messageBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -130)
         ])
         
         // Set up the message label inside the bubble
         messageLabel.translatesAutoresizingMaskIntoConstraints = false
         messageLabel.numberOfLines = 0
         messageLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.INJECTION_VACCINE.QUESTION", defaultText: "Please select the vaccine you have received or, if necessary, several vaccines at once. The information can be found on the sticker in the vaccination certificate.")
         messageLabel.font = UIFont.systemFont(ofSize: 16)
         messageBubbleView.addSubview(messageLabel)
         NSLayoutConstraint.activate([
             messageLabel.topAnchor.constraint(equalTo: messageBubbleView.topAnchor, constant: 10),
             messageLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 10),
             messageLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -10),
             messageLabel.bottomAnchor.constraint(equalTo: messageBubbleView.bottomAnchor, constant: -10)
         ])
         // Set up the smiley face image
         smileyFaceImageView.translatesAutoresizingMaskIntoConstraints = false
         smileyFaceImageView.image = UIImage(named: "Logo") // Make sure to add "Logo" to assets
         smileyFaceImageView.contentMode = .scaleAspectFit
         self.addSubview(smileyFaceImageView)
         NSLayoutConstraint.activate([
             smileyFaceImageView.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: -35),
             smileyFaceImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 260),
             smileyFaceImageView.widthAnchor.constraint(equalToConstant: 30),
             smileyFaceImageView.heightAnchor.constraint(equalToConstant: 30)
         ])
     }
     func setupDropdown() {
         dropdownTextField.translatesAutoresizingMaskIntoConstraints = false
         dropdownTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.PLEASE_SELECT", defaultText: "Please select")
         dropdownTextField.borderStyle = .roundedRect
         dropdownTextField.font = UIFont.systemFont(ofSize: 17)
         
         NSLayoutConstraint.activate([
             dropdownTextField.topAnchor.constraint(equalTo: messageBubbleView.bottomAnchor, constant: 40),
             dropdownTextField.bottomAnchor.constraint(equalTo: skipContainerView.topAnchor, constant: -30),
             dropdownTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 90),
             dropdownTextField.heightAnchor.constraint(equalToConstant: 50),
             dropdownTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
         ])
         dropdownButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
         dropdownButton.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(dropdownButton)
         dropdownButton.tintColor = .lightGray
         
         NSLayoutConstraint.activate([
             dropdownButton.centerYAnchor.constraint(equalTo: dropdownTextField.centerYAnchor),
             dropdownButton.trailingAnchor.constraint(equalTo: dropdownTextField.trailingAnchor, constant: -10)
         ])
         dropdownButton.addTarget(self, action: #selector(dropdownTapped), for: .touchUpInside)
     }
     func setupBottomSkipContainer() {
         skipContainerView.translatesAutoresizingMaskIntoConstraints = false
         skipContainerView.backgroundColor = .white
         skipContainerView.layer.cornerRadius = 10
         self.addSubview(skipContainerView)
         
         NSLayoutConstraint.activate([
             skipContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
             skipContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
             skipContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             skipContainerView.heightAnchor.constraint(equalToConstant: 100)
             ])
     }
     func setupSkipButton() {
         skipButton.translatesAutoresizingMaskIntoConstraints = false
         let attributedTitle = NSMutableAttributedString(
             string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"),
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
         )
         attributedTitle.append(NSAttributedString(
             string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"),
             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
         ))
         skipButton.setAttributedTitle(attributedTitle, for: .normal)
         skipButton.layer.cornerRadius = 10
         skipButton.backgroundColor = .white
         skipButton.layer.borderWidth = 1
         skipButton.layer.borderColor = UIColor.lightGray.cgColor
         skipButton.translatesAutoresizingMaskIntoConstraints = false
         self.addSubview(skipButton)
         
         NSLayoutConstraint.activate([
                 skipButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                 skipButton.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: -30),
                 skipButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                 skipButton.trailingAnchor.constraint(equalTo:  self.trailingAnchor, constant: -20),
                 skipButton.heightAnchor.constraint(equalToConstant: 50)
               ])
         
         skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
     }
     func setupUpArrowButton() {
         upArrowButton.translatesAutoresizingMaskIntoConstraints = false
         upArrowButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
         upArrowButton.tintColor = .darkGray
         self.addSubview(upArrowButton)
         
         NSLayoutConstraint.activate([
             upArrowButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             upArrowButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
             upArrowButton.widthAnchor.constraint(equalToConstant: 30),
             upArrowButton.heightAnchor.constraint(equalToConstant: 30)
         ])
         upArrowButton.addTarget(self, action: #selector(upArrowTapped), for: .touchUpInside)
     }
     func setupTableView() {
         vaccinesTableView.translatesAutoresizingMaskIntoConstraints = false
         vaccinesTableView.delegate = self
         vaccinesTableView.dataSource = self
         vaccinesTableView.isHidden = true
         vaccinesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "vaccineCell")
         
         // Add rounded corners to the table view
         vaccinesTableView.layer.cornerRadius = 15
         vaccinesTableView.clipsToBounds = true
         
         self.addSubview(vaccinesTableView)
         
         NSLayoutConstraint.activate([
             vaccinesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             vaccinesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             vaccinesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             vaccinesTableView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
         ])
         
         // Create table view header
         let tableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 90))
         tableViewHeader.backgroundColor = .white
         
         // Add gray bar at the top
         let grayBar = UIView()
         grayBar.translatesAutoresizingMaskIntoConstraints = false
         grayBar.backgroundColor = UIColor.lightGray
         grayBar.layer.cornerRadius = 2
         tableViewHeader.addSubview(grayBar)
         grayBar.translatesAutoresizingMaskIntoConstraints = false
         grayBar.centerXAnchor.constraint(equalTo: tableViewHeader.centerXAnchor).isActive = true
         grayBar.topAnchor.constraint(equalTo: tableViewHeader.topAnchor, constant: 16).isActive = true
         grayBar.widthAnchor.constraint(equalTo: tableViewHeader.widthAnchor, multiplier: 0.12).isActive = true
         grayBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
         NSLayoutConstraint.activate([
            
           
         ])
         
         // Add "Choose vaccines received" label
         let chooseVaccinesLabel = UILabel()
         chooseVaccinesLabel.translatesAutoresizingMaskIntoConstraints = false
         chooseVaccinesLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.VACCINATION.BOTTOMSHEET.CHOOSE", defaultText: "Choose vaccines received")
         chooseVaccinesLabel.font = UIFont.boldSystemFont(ofSize: 17)
         tableViewHeader.addSubview(chooseVaccinesLabel)
         
         NSLayoutConstraint.activate([
             chooseVaccinesLabel.leadingAnchor.constraint(equalTo: tableViewHeader.leadingAnchor, constant: 15),
             chooseVaccinesLabel.bottomAnchor.constraint(equalTo: tableViewHeader.bottomAnchor, constant: -15),
             chooseVaccinesLabel.topAnchor.constraint(equalTo:  grayBar.topAnchor, constant: 35)
         ])
         
         // Add "Done" label
         let doneLabel = UILabel()
         doneLabel.translatesAutoresizingMaskIntoConstraints = false
         doneLabel.text = TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.DONE", defaultText: "Done")
         doneLabel.font = UIFont.systemFont(ofSize: 17)
         doneLabel.textColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
         tableViewHeader.addSubview(doneLabel)
         
         NSLayoutConstraint.activate([
             doneLabel.trailingAnchor.constraint(equalTo: tableViewHeader.trailingAnchor, constant: -15),
             doneLabel.bottomAnchor.constraint(equalTo: tableViewHeader.bottomAnchor, constant: -15)
         ])
         
         // Make "Done" label tappable
         let doneTapGesture = UITapGestureRecognizer(target: self, action: #selector(doneTapped))
         doneLabel.isUserInteractionEnabled = true
         doneLabel.addGestureRecognizer(doneTapGesture)
         
         vaccinesTableView.tableHeaderView = tableViewHeader
     }
     // Actions
     @objc func dropdownTapped() {
         vaccinesTableView.isHidden.toggle()
     }
         @objc func skipButtonTapped() {
             print("Skip button tapped")
         }
         @objc func upArrowTapped() {
             print("Up arrow tapped")
         }
    var doneTap: (()->Void)?
    var displayErrorMessage: (()->Void)?
         @objc func doneTapped() {
             vaccinesTableView.isHidden = true
             vaccinationModel.shared.saveVaccinationsRecieved(vaccinationsRecieved: selectedVaccines){isSaved in
                 if isSaved{
                     self.doneTap?()
                 }else{
                     self.displayErrorMessage?()
                    
                 }
             }
          
         }
         // TableView DataSource and Delegate Methods
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             return vaccines.count
         }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "vaccineCell", for: indexPath)
         
         let vaccineText = vaccines[indexPath.row]
         cell.textLabel?.text = vaccineText
         
         // Configure checkmark image view to show selection status
         let checkmarkImageView = UIImageView()
         checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
         checkmarkImageView.contentMode = .scaleAspectFit
         // Check if the vaccineText is in the selectedVaccines array
         let isSelected = selectedVaccines.contains(vaccineText)
         checkmarkImageView.image = UIImage(named: isSelected ? "Property 1=on.png" : "Property 1=off.png")
         // Add the checkmark image to the cell
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
         let vaccine = vaccines[indexPath.row]

         if let index = selectedVaccines.firstIndex(of: vaccine) {
             // Vaccine is already selected, so remove it
             selectedVaccines.remove(at: index)
         } else {
             // Vaccine is not selected, so add it
             selectedVaccines.append(vaccine)
         }

      
         // Reload all rows to update the checkbox state
         tableView.reloadData()
     }

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRedContainerView()
        setupMessageBubble()
        setupBottomSkipContainer()
        setupDropdown()
        setupSkipButton()
        setupUpArrowButton()
        setupTableView()
        dropdownTextField.isEnabled = false
     
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupRedContainerView()
        setupMessageBubble()
        setupBottomSkipContainer()
        setupDropdown()
        setupSkipButton()
        setupUpArrowButton()
        setupTableView()
        dropdownTextField.isEnabled = false
    }
  
    }
class TemperatureVaccinesView: UIView {
    let temperatureTopView = UIView()
    let firstYesButtonView = UIButton()
    let secondNoButtonView = UIButton()
    let logoImageView = UIImageView()
    let topLabel = UILabel()
    let firstYesLabel = UILabel()
    let secondNoLabel = UILabel()
    var selectedButton: UIView?
    let skipButton = UIButton(type: .system)
    var vaccinatedOrNot: String?
    // Custom initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        setupTemperatureTopView()
        setupLogoImageView()
        setupButtonViews()
        setupSkipButton()
        setupChevronButton()
    }
    
    private func setupTemperatureTopView() {
        temperatureTopView.translatesAutoresizingMaskIntoConstraints = false
        temperatureTopView.backgroundColor = .white
        temperatureTopView.layer.cornerRadius = 10
        temperatureTopView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        temperatureTopView.layer.shadowColor = UIColor.black.cgColor
        temperatureTopView.layer.shadowOpacity = 0.3
        temperatureTopView.layer.shadowOffset = CGSize(width: 0, height: 2)
        temperatureTopView.layer.shadowRadius = 4
        addSubview(temperatureTopView)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.numberOfLines = 0
     
        topLabel.attributedText = NSAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.INJECTION.QUESTION", defaultText: "Has {{name}} been vaccinated during the last 2 weeks?").replacingOccurrences(of: "{{name}}", with: profileName!))
        topLabel.font = UIFont.systemFont(ofSize: 14)
        temperatureTopView.addSubview(topLabel)
    }
    
    private func setupLogoImageView() {
        logoImageView.image = UIImage(named: "Logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        addSubview(logoImageView)
    }
    
    private func setupButtonViews() {
        [firstYesButtonView, secondNoButtonView].forEach { buttonView in
            buttonView.translatesAutoresizingMaskIntoConstraints = false
            buttonView.backgroundColor = UIColor(white: 0.9, alpha: 1)
            buttonView.layer.cornerRadius = 10
            buttonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            buttonView.isUserInteractionEnabled = true
           
            addSubview(buttonView)
        }
        firstYesButtonView.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        secondNoButtonView.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        setupSingleButton(buttonView: firstYesButtonView, label: firstYesLabel, text: TranslationsViewModel.shared.getTranslation(key: "PROFILE.ALERT.YES", defaultText: "Yes"))
        setupSingleButton(buttonView: secondNoButtonView, label: secondNoLabel, text: TranslationsViewModel.shared.getTranslation(key: "PROFILE.ALERT.NO", defaultText: "No"))
    }
    var yesButtonTap: (()->Void)?
    var noButtonTap: (()->Void)?
    var displayErrorMessage: (()->Void)?
    @objc func yesButtonTapped(_ sender: UIView){
      
        if let label = sender.subviews.compactMap({ $0 as? UILabel }).first {
            vaccinatedOrNot = label.text?.uppercased() ?? ""
        }
        vaccinationModel.shared.saveVaccinatedOrNot(vaccinatedOrNot: vaccinatedOrNot!){isSaved in
            if isSaved{
                self.yesButtonTap?()
            }else{
                self.displayErrorMessage?()
            }
            
        }
     
    }
    @objc func noButtonTapped(_ sender: UIView){
        
          if let label = sender.subviews.compactMap({ $0 as? UILabel }).first {
              vaccinatedOrNot = label.text?.uppercased() ?? ""
          }
          vaccinationModel.shared.saveVaccinatedOrNot(vaccinatedOrNot: vaccinatedOrNot!){isSaved in
              if isSaved{
                  self.noButtonTap?()
              }else{
                  self.displayErrorMessage?()
              }
              
          }
    }
    @objc private func handleTouch(_ gesture: UILongPressGestureRecognizer) {
        guard let buttonView = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            // Touch down - change background color to blue
            buttonView.backgroundColor = .blue
        case .ended, .cancelled:
            // Touch up - revert to original color
            buttonView.backgroundColor = UIColor(white: 0.9, alpha: 1) // Lighter gray
        default:
            break
        }
    }
    private func setupSingleButton(buttonView: UIView, label: UILabel, text: String) {
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.shadowColor = UIColor.black.cgColor
        buttonView.layer.shadowOpacity = 0.3
        buttonView.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonView.layer.shadowRadius = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        buttonView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)
        ])
    }
    
    private func setupSkipButton() {
        let bottomView = UIView()
        bottomView.backgroundColor = .blue
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomView)
  
        let attributedTitle = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "no answer"), attributes: [.foregroundColor: UIColor.black])
        attributedTitle.append(NSAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"), attributes: [.foregroundColor: UIColor.gray]))
        skipButton.setAttributedTitle(attributedTitle, for: .normal)
        skipButton.backgroundColor = .white
        skipButton.layer.cornerRadius = 10
        skipButton.layer.borderWidth = 1
        skipButton.layer.borderColor = UIColor.lightGray.cgColor
        skipButton.isEnabled = true
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        bottomView.addSubview(skipButton)
        NSLayoutConstraint.activate([
            skipButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -30),
            skipButton.heightAnchor.constraint(equalToConstant: 45),
            skipButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15),
            skipButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15),
                 bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                 bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                 bottomView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
                 bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                 ])
    }
    
    private func setupChevronButton() {
        let chevronButton = UIButton()
        chevronButton.translatesAutoresizingMaskIntoConstraints = false
        chevronButton.layer.cornerRadius = 10
        let chevronConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
        let chevronImage = UIImage(systemName: "chevron.up", withConfiguration: chevronConfig)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = .lightGray
        chevronButton.addTarget(self, action: #selector(chevronButtonTapped), for: .touchUpInside)
        addSubview(chevronButton)
        NSLayoutConstraint.activate([
                   chevronButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                   chevronButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
                   chevronButton.widthAnchor.constraint(equalToConstant: 30),
                   chevronButton.heightAnchor.constraint(equalToConstant: 30)
                 ])
    }
    
    private func setupConstraints() {
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
            
            temperatureTopView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            temperatureTopView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -133),
            temperatureTopView.bottomAnchor.constraint(equalTo: firstYesButtonView.topAnchor, constant: -27),
            temperatureTopView.heightAnchor.constraint(equalToConstant: 65),
            
            topLabel.leadingAnchor.constraint(equalTo: temperatureTopView.leadingAnchor, constant: 10),
            topLabel.trailingAnchor.constraint(equalTo: temperatureTopView.trailingAnchor, constant: -20),
            topLabel.centerYAnchor.constraint(equalTo: temperatureTopView.centerYAnchor),
            
            logoImageView.bottomAnchor.constraint(equalTo: temperatureTopView.bottomAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: temperatureTopView.leadingAnchor, constant: -35),
            logoImageView.widthAnchor.constraint(equalToConstant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            firstYesButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 150),
            firstYesButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            firstYesButtonView.heightAnchor.constraint(equalToConstant: 45),
            
            secondNoButtonView.leadingAnchor.constraint(equalTo: firstYesButtonView.leadingAnchor),
            secondNoButtonView.trailingAnchor.constraint(equalTo: firstYesButtonView.trailingAnchor),
            secondNoButtonView.heightAnchor.constraint(equalToConstant: 45),
            secondNoButtonView.topAnchor.constraint(equalTo: firstYesButtonView.bottomAnchor, constant: 15),
            secondNoButtonView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50)
      
        ])
    }
    var skipButtonTap : (()->Void)?
    @objc private func skipButtonTapped() {
        print("Skip button tapped!")
     skipButtonTap?()
    }
    
    @objc private func chevronButtonTapped() {
        print("Chevron button tapped!")
    }

    }
