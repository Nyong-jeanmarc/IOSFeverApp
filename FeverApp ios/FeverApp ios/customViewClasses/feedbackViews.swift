//
//  feedbackStarView.swift
//  FeverApp ios
//
//  Created by NEW on 05/01/2025.
//

import Foundation
import UIKit
enum GeneralSatisfaction: String {
    case poor = "POOR"
    case faire = "FAIR"
    case good = "GOOD"
    case veryGood = "VERY_GOOD"
    case excellent = "EXCELLENT"

    static func fromRating(_ rating: Int) -> GeneralSatisfaction? {
        switch rating {
        case 1: return .poor
        case 2: return .faire
        case 3: return .good
        case 4: return .veryGood
        case 5: return .excellent
        default: return nil
        }
    }
}
enum UsabilitySatisfaction: String{
    case notSatisfied = "NOT_SATISFIED"
    case slightlySatisfied = "SLIGHTLY_SATISFIED"
    case moderatelySatisfied = "MODERATELY_SATISFIED"
    case verySatisfied = "VERY_SATISFIED"
    case extremelySatisfied = "EXTREMELY_SATISFIED"

    static func fromRating(_ rating: Int) -> UsabilitySatisfaction? {
        switch rating {
        case 1: return .notSatisfied
        case 2: return .slightlySatisfied
        case 3: return .moderatelySatisfied
        case 4: return .verySatisfied
        case 5: return .extremelySatisfied
        default: return nil
        }
    }
}
enum DesignSatisfaction: String{
    case poor = "POOR"
    case fair = "FAIR"
    case good = "GOOD"
    case veryGood = "VERY_GOOD"
    case excellent = "EXCELLENT"

    static func fromRating(_ rating: Int) -> DesignSatisfaction? {
        switch rating {
        case 1: return .poor
        case 2: return .fair
        case 3: return .good
        case 4: return .veryGood
        case 5: return .excellent
        default: return nil
        }
    }
}
enum ConfidenceImpact: String{
    case stronglyDisagree = "STRONGLY_DISAGREE"
    case disagree = "DISAGREE"
    case indifferent = "INDIFFERENT"
    case agree = "AGREE"
    case stronglyAgree = "STRONGLY_AGREE"

    static func fromRating(_ rating: Int) -> ConfidenceImpact? {
        switch rating {
        case 0: return .stronglyAgree
        case 1: return .agree
        case 2: return .indifferent
        case 3: return .disagree
        case 4: return .stronglyDisagree
        default: return nil
        }
    }
}

// Custom View
class feedbackStarView: UIView {
    
    // MARK: - UI Components

    private let emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9)
        ])

        return view
    }()

    private let chatBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()

    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "EVALUATION.RATING_USABILITY.QUESTION", defaultText: "How do you like the usability of the FeverApp?")
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private let starStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 45
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer"), attributes: [.foregroundColor: UIColor.black])
        attributedString.append(NSAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"), attributes: [.foregroundColor: UIColor.gray]))
        button.setAttributedTitle(attributedString, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        return button
    }()

    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CONFIRM", defaultText: "Confirm"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.647, green: 0.741, blue: 0.949, alpha: 1.0)
        button.layer.cornerRadius = 8
        return button
    }()

    private var stars: [UIButton] = []
    private var currentRating: Int = 4

    // MARK: - Callbacks
    var noAnswerTap: (() -> Void)?
    var confirmTap: (() -> Void)?
    var viewIdentity: String?

    // MARK: - Initialization
    // MARK: - Initialization
    init(frame: CGRect, initialRating: Int = 4, feedbackMessage: String, viewIdentity: String) {
         self.currentRating = initialRating
         super.init(frame: frame)
         questionLabel.text = feedbackMessage
        self.viewIdentity = viewIdentity
         setupUI()
         setupConstraints()
         updateStars(rating: currentRating)
     }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        updateStars(rating: currentRating)
    }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemGray6

        

        addSubview(emojiView)
        addSubview(chatBubbleView)
        chatBubbleView.addSubview(questionLabel)

        addSubview(bottomView)
        bottomView.addSubview(starStackView)
        bottomView.addSubview(buttonStackView)

        buttonStackView.addArrangedSubview(skipButton)
        buttonStackView.addArrangedSubview(confirmButton)

        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)

        for i in 0..<5 {
            let starButton = UIButton(type: .custom)
            let config = UIImage.SymbolConfiguration(pointSize: 27, weight: .regular)
            starButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .normal)
            starButton.tag = i
            starButton.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            stars.append(starButton)
            starStackView.addArrangedSubview(starButton)
        }
    }

    private func setupConstraints() {
        let views = [ chatBubbleView, bottomView,   questionLabel, starStackView, buttonStackView]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
          

            // Emoji View
            emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            emojiView.centerYAnchor.constraint(equalTo: chatBubbleView.centerYAnchor, constant: 17),
            emojiView.widthAnchor.constraint(equalToConstant: 30),
            emojiView.heightAnchor.constraint(equalToConstant: 30),

            // Chat Bubble
            chatBubbleView.leadingAnchor.constraint(equalTo: emojiView.trailingAnchor, constant: 10),
            chatBubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45),
            chatBubbleView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -20),

            questionLabel.leadingAnchor.constraint(equalTo: chatBubbleView.leadingAnchor, constant: 12),
            questionLabel.trailingAnchor.constraint(equalTo: chatBubbleView.trailingAnchor, constant: -10),
            questionLabel.topAnchor.constraint(equalTo: chatBubbleView.topAnchor, constant: 16),
            questionLabel.bottomAnchor.constraint(equalTo: chatBubbleView.bottomAnchor, constant: -16),

            // Bottom View
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 200),

            // Star Stack
            starStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30),
            starStackView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            starStackView.heightAnchor.constraint(equalToConstant: 50),

            // Button Stack
            buttonStackView.topAnchor.constraint(equalTo: starStackView.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions
    @objc private func starTapped(_ sender: UIButton) {
        let rating = sender.tag + 1
        updateStars(rating: rating)
    }

    @objc private func skipButtonTapped() {
        noAnswerTap?()
    }

    @objc private func confirmButtonTapped() {
        if viewIdentity == "GeneralSatisfaction"{
            let satisfaction = GeneralSatisfaction.fromRating(currentRating)
               if let satisfaction = satisfaction {
                   feedBackQuestionaireModel.shared.updateFeedBackModel(generalSatisfaction: satisfaction.rawValue)
               }
               confirmTap?()
        }else if viewIdentity == "DesignSatisfaction"{
            let satisfaction = DesignSatisfaction.fromRating(currentRating)
               if let satisfaction = satisfaction {
                   feedBackQuestionaireModel.shared.updateFeedBackModel(designSatisfaction: satisfaction.rawValue)
               }
               confirmTap?()
        }else if viewIdentity == "UsabilitySatisfaction"{
            let satisfaction = UsabilitySatisfaction.fromRating(currentRating)
               if let satisfaction = satisfaction {
                   feedBackQuestionaireModel.shared.updateFeedBackModel(usabilitySatisfaction: satisfaction.rawValue)
               }
               confirmTap?()
        }
    }

    private func updateStars(rating: Int) {
        currentRating = rating
        stars.enumerated().forEach { index, star in
            star.tintColor = index < rating ? UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) : UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        }
    }
}

class ImpressionFeedbackView: UIView {
    weak var delegate: FirstCustomViewDelegate?
    let mystateOfHealthView = UIView()
    let stateOfHealthImage = UIImageView()
    let iconImages = ["star", "smile", "nutral", "icon sad", "worry"]
    // Configuration properties for icon buttons
    let stateOfHealthiconSize: CGFloat = 30
    let stateOfHealthbuttonSize: CGFloat = 70
    let stateOfHealthnoskipButton = UIButton()
    let stateOfHealthConfirmButton = UIButton()
    let stateOfHealthnoskipButtonHeight: CGFloat = 40
    let stateOfHealthbottomView = UIView()
    var stateIconName: ((String) -> Void)?
    // MARK: - UI Components
 
    // Map buttons to their associated state of health response
       var stateOfHealthMapping: [UIButton: StateOfHealthResponse] = [:]
 
    func setupstateOfHealthView() {
        // Add views
        let attributedString = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "NoAnswer") + " " + TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"))
        stateOfHealthnoskipButton.addTarget(self, action: #selector(stateOfHealthnoskipButtonTouchedDown), for: .touchDown)
        stateOfHealthnoskipButton.addTarget(self, action: #selector(stateOfHealthnoskipButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        stateOfHealthConfirmButton.addTarget(self, action: #selector(stateOfHealthConfirmButtonTapped), for: [.touchUpInside, .touchUpOutside])
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 9))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
        stateOfHealthnoskipButton.setAttributedTitle(attributedString, for: .normal)
        stateOfHealthConfirmButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CONFIRM", defaultText: "Confirm"), for: .normal)
        mystateOfHealthView.backgroundColor = .white
        mystateOfHealthView.translatesAutoresizingMaskIntoConstraints = false
        // Add shadow
        mystateOfHealthView.layer.shadowColor = UIColor(white: 0.7, alpha: 1).cgColor
        mystateOfHealthView.layer.shadowOpacity = 0.5
        mystateOfHealthView.layer.shadowRadius = 4
        mystateOfHealthView.layer.shadowOffset = CGSize(width: 0, height: 2)
        // Add border radius
        mystateOfHealthView.layer.cornerRadius = 10
        mystateOfHealthView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        // Add to view hierarchy
        self.addSubview(mystateOfHealthView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            mystateOfHealthView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45),
            mystateOfHealthView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            mystateOfHealthView.bottomAnchor.constraint(equalTo: stateOfHealthbottomView.topAnchor, constant: -15),
            mystateOfHealthView.heightAnchor.constraint(equalToConstant: 70),
        
        ])
        stateOfHealthImage.translatesAutoresizingMaskIntoConstraints = false
        stateOfHealthImage.image = UIImage(named: "Logo")
        stateOfHealthImage.contentMode = .scaleAspectFit
        self.addSubview( stateOfHealthImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        // Create a label
        let label = UILabel()
        label.text = message
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Add label to view
        mystateOfHealthView.addSubview(label)
        
        // Add constraints to label
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: mystateOfHealthView.leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: mystateOfHealthView.topAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: mystateOfHealthView.trailingAnchor, constant: 8),
            stateOfHealthImage.bottomAnchor.constraint(equalTo: mystateOfHealthView.bottomAnchor),
            stateOfHealthImage.leadingAnchor.constraint(equalTo: mystateOfHealthView.leadingAnchor, constant: -37),
            stateOfHealthImage.widthAnchor.constraint(equalToConstant: 30),
            stateOfHealthImage.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    let iconStackView = UIStackView()
    func setupstateOfHealthBottomViewIcons() {
        // Apply corner radius to bottomView
        stateOfHealthbottomView.layer.cornerRadius = 20
         self.addSubview(stateOfHealthbottomView) // Add bottomView to the same view hierarchy
        
        stateOfHealthbottomView.translatesAutoresizingMaskIntoConstraints = false
        stateOfHealthbottomView.backgroundColor = .white// Adjust as necessary
        
        // Constraints for bottomView
        NSLayoutConstraint.activate([
            stateOfHealthbottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stateOfHealthbottomView.trailingAnchor.constraint(equalTo:  self.trailingAnchor, constant: 0),
            stateOfHealthbottomView.bottomAnchor.constraint(equalTo:  self.bottomAnchor, constant: 0),
            stateOfHealthbottomView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Create a horizontal stack view for icon buttons inside bottomView
       
        iconStackView.axis = .horizontal
        iconStackView.alignment = .center
        iconStackView.distribution = .fillEqually
        iconStackView.spacing = 15
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Icon image names
        let iconImages = ["star", "smile", "nutral", "icon sad", "worry"]
               // Add icon buttons to the stack view
               for (index, imageName) in iconImages.enumerated() {
                   let button = createIconButton(imageName: imageName)
                   iconStackView.addArrangedSubview(button)
                   
                   // Assign a tag to the button for identification
                   button.tag = index
               }
        // Add iconStackView to bottomView
        stateOfHealthbottomView.addSubview(iconStackView)
        
        // Constraints for centering the iconStackView in the bottomView
        NSLayoutConstraint.activate([
            iconStackView.leadingAnchor.constraint(equalTo: stateOfHealthbottomView.leadingAnchor, constant: 16),
            iconStackView.trailingAnchor.constraint(equalTo: stateOfHealthbottomView.trailingAnchor, constant: -16),
            iconStackView.topAnchor.constraint(equalTo: stateOfHealthbottomView.topAnchor, constant: 8)
        ])
        
    }
    // Function to update the button images
      func updateButtonImages(selectedButton: UIButton) {
          for button in iconStackView.arrangedSubviews {
              guard let button = button as? UIButton else { continue }

              if button == selectedButton {
                  // Restore the original image for the selected button
                  if let originalImageName = iconImages[safe: button.tag] {
                      button.setImage(UIImage(named: originalImageName), for: .normal)
                  }
              } else {
                  // Apply a gray tint to all other buttons
                  if let originalImageName = iconImages[safe: button.tag],
                     let originalImage = UIImage(named: originalImageName) {
                      let grayImage = originalImage.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
                      button.setImage(grayImage, for: .normal)
                  }
              }
          }
      }
    // Create the icon buttons
    func createIconButton(imageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let iconImage = UIImage(named: imageName)
        button.setImage(iconImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(iconButtonTapped(_:)), for: .touchUpInside)
        
        
        return button
    }
    // Define icon images for each button
    let iconMapping: [String: String] = [
        "star": "white laughter",
        "smile": "white smile",
        "nutral": "white normal",
        "icon sad": "white angry",
        "worry": "white worry"
    ]
    var iconButtonTapped: (() -> Void)?
    var passIconImage: ((_ iconName: String)->Void)?
    func getIconName(sender: UIButton) {
        // Simulate some work
            for (key, value) in iconMapping {
                if let senderImage = sender.image(for: .normal),
                   let image = UIImage(named: key),
                   senderImage == image {
                   let iconName = value
                    passIconImage?(iconName)
                    delegate?.didTapButton(with: iconName)
                    break
                }
            }
    }
    var displayErrorMessage : (()->Void)?
    // Icon button action handler
    var selectedImpressionButtonIndex: Int?
    @objc func iconButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        selectedImpressionButtonIndex = index
        // Update button images based on the selected button
          updateButtonImages(selectedButton: sender)
        // Get the tapped icon's image name
      
        getIconName(sender: sender)
    }
 
    // MARK: - Setup NoSkip Button
    func setupstateOfHealthNoSkipButton() {
        stateOfHealthnoskipButton.layer.borderColor = UIColor.lightGray.cgColor
        stateOfHealthnoskipButton.layer.borderWidth = 1.0
        stateOfHealthnoskipButton.layer.cornerRadius = 10
        stateOfHealthnoskipButton.translatesAutoresizingMaskIntoConstraints = false
        
        stateOfHealthbottomView.addSubview(stateOfHealthnoskipButton)
        stateOfHealthbottomView.addSubview(stateOfHealthConfirmButton)
        // Constraints for noskipButton
        NSLayoutConstraint.activate([
            stateOfHealthnoskipButton.bottomAnchor.constraint(equalTo: stateOfHealthbottomView.bottomAnchor, constant: -45),
            stateOfHealthnoskipButton.widthAnchor.constraint(equalTo: stateOfHealthConfirmButton.widthAnchor),
            stateOfHealthnoskipButton.heightAnchor.constraint(equalToConstant: 44),
            stateOfHealthnoskipButton.leadingAnchor.constraint(equalTo: stateOfHealthbottomView.leadingAnchor, constant: 20),
            stateOfHealthnoskipButton.trailingAnchor.constraint(equalTo: stateOfHealthConfirmButton.leadingAnchor, constant: -20),
        ])
        //
        stateOfHealthConfirmButton.layer.borderColor = UIColor.lightGray.cgColor
        stateOfHealthConfirmButton.layer.borderWidth = 0
        stateOfHealthConfirmButton.layer.cornerRadius = 10
        stateOfHealthConfirmButton.backgroundColor = UIColor(red: 165/255, green: 189/255, blue: 242/255, alpha: 1.0)

        stateOfHealthConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        
     
        
        // Constraints for noskipButton
        NSLayoutConstraint.activate([
           
            stateOfHealthConfirmButton.bottomAnchor.constraint(equalTo: stateOfHealthbottomView.bottomAnchor, constant: -45),   stateOfHealthConfirmButton.widthAnchor.constraint(equalTo: stateOfHealthnoskipButton.widthAnchor),
            stateOfHealthConfirmButton.heightAnchor.constraint(equalToConstant: 44),
            stateOfHealthConfirmButton.leadingAnchor.constraint(equalTo: stateOfHealthnoskipButton.trailingAnchor, constant: 20),
            stateOfHealthConfirmButton.trailingAnchor.constraint(equalTo: stateOfHealthbottomView.trailingAnchor, constant: -20),
        ])
    }
    var noAnswerTap : (()->Void)?
    var confirmTap : (()->Void)?
 
    @objc func stateOfHealthnoskipButtonTouchedDown() {
        noAnswerTap?()
    }
    
    @objc func stateOfHealthnoskipButtonTouchedUp() {
        stateOfHealthnoskipButton.backgroundColor = .white
     
    }
    @objc func stateOfHealthConfirmButtonTapped() {
        if selectedImpressionButtonIndex != nil {
            let impression = ConfidenceImpact.fromRating(selectedImpressionButtonIndex!)
               if let impression = impression {
                   feedBackQuestionaireModel.shared.updateFeedBackModel(confidenceImpact: impression.rawValue)
               }
        }
        confirmTap?()
     
    }
    var message : String?
    // Custom initializer
       init(message: String, frame: CGRect = .zero) {
           self.message = message
           super.init(frame: frame) // Call the designated initializer of UIView
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
           setupstateOfHealthBottomViewIcons()
           setupstateOfHealthNoSkipButton()
           setupstateOfHealthView()
       }

    override init(frame: CGRect) {
        super.init(frame: frame)
      
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
        setupstateOfHealthBottomViewIcons()
        setupstateOfHealthNoSkipButton()
        setupstateOfHealthView()
    }
}
class textFieldFeedbackView: UIView, UITextFieldDelegate {
    
    // View Components
    private let iconImageView = UIImageView()
    private let chatBubble = UIView()
    private let questionLabel = UILabel()
    private let painTextField = UITextField()
    private let noAnswerButton = UIButton()
    private let bottomView = UIView()
    let nextButton = UIButton()  // Public to allow interaction from outside
   
    // MARK: - UI Components

    
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
    }
    var message : String?
    // Custom initializer
       init(message: String, frame: CGRect = .zero) {
           self.message = message
           super.init(frame: frame) // Call the designated initializer of UIView
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
    }
    
    private func setupView() {
        // Add views
      
        
       
        // Chevron Button Configuration
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        let chevronImage = UIImage(systemName: "chevron.up", withConfiguration: configuration)
     
        
        // Icon Image View
        iconImageView.image = UIImage(named: "Logo")
        iconImageView.tintColor = .systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Chat Bubble
        chatBubble.backgroundColor = .white
        chatBubble.layer.cornerRadius = 10
        chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chatBubble.layer.shadowColor = UIColor(white: 0.7, alpha: 1).cgColor
        chatBubble.layer.shadowOpacity = 0.8
        chatBubble.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatBubble.layer.shadowRadius = 4
        chatBubble.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chatBubble)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        // Question Label
        questionLabel.text = message
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
        nextButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CONFIRM", defaultText: "Confirm"), for: .normal)
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
    
    var displayErrorMessage : ((_ message: String)->Void)?
    // Button action handlers
    @objc func handleNext() {
        let positiveAspects = painTextField.text
        feedBackQuestionaireModel.shared.updateFeedBackModel(positiveAspects: positiveAspects)
        confirmTap?()
    }
    var noAnswerTap : (()->Void)?
    var confirmTap : (()->Void)?
    @objc func handleNoAnswer() {
        noAnswerTap?()
    }
    // Dismiss the keyboard when the "Done" button is tapped
    @objc private func dismissKeyboard() {
        painTextField.resignFirstResponder()
    }
   }
class lastTextFieldFeedbackView: UIView, UITextFieldDelegate {
    
    // View Components
    private let iconImageView = UIImageView()
    private let chatBubble = UIView()
    private let questionLabel = UILabel()
    private let painTextField = UITextField()
    
    private let bottomView = UIView()
    let nextButton = UIButton()  // Public to allow interaction from outside
   
    // MARK: - UI Components

    
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
    }
    var message : String?
    // Custom initializer
       init(message: String, frame: CGRect = .zero) {
           self.message = message
           super.init(frame: frame) // Call the designated initializer of UIView
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
    }
    
    private func setupView() {
        // Add views
      
        
       
        // Chevron Button Configuration
        let configuration = UIImage.SymbolConfiguration(weight: .bold)
        _ = UIImage(systemName: "chevron.up", withConfiguration: configuration)
     
        
        // Icon Image View
        iconImageView.image = UIImage(named: "Logo")
        iconImageView.tintColor = .systemGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Chat Bubble
        chatBubble.backgroundColor = .white
        chatBubble.layer.cornerRadius = 10
        chatBubble.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        chatBubble.layer.shadowColor = UIColor(white: 0.7, alpha: 1).cgColor
        chatBubble.layer.shadowOpacity = 0.8
        chatBubble.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatBubble.layer.shadowRadius = 4
        chatBubble.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chatBubble)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        // Question Label
        questionLabel.text = message
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
      
        
        // Next Button
        nextButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "SETTINGS.FEEDBACK.SEND.BUTTON", defaultText: "Send feedback"), for: .normal)
        nextButton.backgroundColor = UIColor(white: 0.80, alpha: 1.0)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(nextButton)
        // Add targets to buttons
        nextButton.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
     
        nextButton.isEnabled = false

    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            
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
    
    var displayErrorMessage : ((_ message: String)->Void)?
    // Button action handlers
    @objc func handleNext(){
        self.confirmTap?()
            let improvementSuggestions = self.painTextField.text
            feedBackQuestionaireModel.shared.updateFeedBackModel(improvementSuggestions: improvementSuggestions)
            // Call saveFeedBack without waiting for it to complete
             Task {
          await feedBackQuestionaireModel.shared.saveFeedBack()
            }
      
    }
    var noAnswerTap : (()->Void)?
    var confirmTap : (()->Void)?
   
    // Dismiss the keyboard when the "Done" button is tapped
    @objc private func dismissKeyboard() {
        painTextField.resignFirstResponder()
    }
   }
extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
