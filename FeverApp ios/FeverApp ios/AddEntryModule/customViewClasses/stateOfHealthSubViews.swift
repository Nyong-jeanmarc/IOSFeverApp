//
//  customViewClass.swift
//  FeverApp ios
//
//  Created by NEW on 05/11/2024.
//

import UIKit
// Define the protocol outside of the class
protocol FirstCustomViewDelegate: AnyObject {
    func didTapButton(with imageName: String)
}
// Enum representing the user's state of health response
enum StateOfHealthResponse: String, CaseIterable {
    
    case excellent = "EXCELLENT"
    case fine = "FINE"
    case neutral = "NEUTRAL"
    case unwell = "UNWELL"
    case verySick = "VERY_SICK"
    // Computed property to provide user-friendly text
        var userFriendlyDescription: String {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let profileName = appDelegate.fetchProfileName()
            switch self {
            case .excellent:
                return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.4.TEXT", defaultText: "{{name}} feels very well").replacingOccurrences(of: "{{name}}", with: profileName!)
            case .fine:
                return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.3.TEXT", defaultText: "{{name}} feels fine").replacingOccurrences(of: "{{name}}", with: profileName!)
            case .neutral:
                return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.2.TEXT", defaultText: "{{name}} feels neither well nor unwell").replacingOccurrences(of: "{{name}}", with: profileName!)
            case .unwell:
                return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.1.TEXT", defaultText: "{{name}} feels unwell").replacingOccurrences(of: "{{name}}", with: profileName!)
            case .verySick:
                return TranslationsViewModel.shared.getAdditionalTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.4.TEXT", defaultText: "{{name}} feels very sick")
            }
        }
}


class StateOfHealthFirstSubview: UIView {
    weak var delegate: FirstCustomViewDelegate?
    let mystateOfHealthView = UIView()
    let stateOfHealthImage = UIImageView()
    let iconImages = ["star", "smile", "nutral", "icon sad", "worry"]
    // Configuration properties for icon buttons
    let stateOfHealthiconSize: CGFloat = 30
    let stateOfHealthbuttonSize: CGFloat = 70
    let stateOfHealthnoskipButton = UIButton()
    let stateOfHealthnoskipButtonHeight: CGFloat = 40
    let stateOfHealthbottomView = UIView()
    var stateIconName: ((String) -> Void)?
    // Map buttons to their associated state of health response
       var stateOfHealthMapping: [UIButton: StateOfHealthResponse] = [:]
       
    func setupstateOfHealthView() {
        let attributedString = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "NoAnswer") + " " + TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"))
        stateOfHealthnoskipButton.addTarget(self, action: #selector(stateOfHealthnoskipButtonTouchedDown), for: .touchDown)
        stateOfHealthnoskipButton.addTarget(self, action: #selector(stateOfHealthnoskipButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 9))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
        stateOfHealthnoskipButton.setAttributedTitle(attributedString, for: .normal)
        mystateOfHealthView.backgroundColor = .white
        mystateOfHealthView.translatesAutoresizingMaskIntoConstraints = false
        // Add shadow
        mystateOfHealthView.layer.shadowColor = UIColor.black.cgColor
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
            mystateOfHealthView.heightAnchor.constraint(equalToConstant: 40)
        ])
        stateOfHealthImage.translatesAutoresizingMaskIntoConstraints = false
        stateOfHealthImage.image = UIImage(named: "Logo")
        stateOfHealthImage.contentMode = .scaleAspectFit
        self.addSubview( stateOfHealthImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        // Create a label
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.QUESTION", defaultText: "How does {{name}} feel?").replacingOccurrences(of: "{{name}}", with: profileName!)
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Add label to view
        mystateOfHealthView.addSubview(label)
        
        // Add constraints to label
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: mystateOfHealthView.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: mystateOfHealthView.centerYAnchor),
            stateOfHealthImage.bottomAnchor.constraint(equalTo: mystateOfHealthView.bottomAnchor),
            stateOfHealthImage.leadingAnchor.constraint(equalTo: mystateOfHealthView.leadingAnchor, constant: -37),
            stateOfHealthImage.widthAnchor.constraint(equalToConstant: 30),
            stateOfHealthImage.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    // Define the mapping of state strings to button indices (order in the stack view)
        let stateIndexMapping: [String: Int] = [
            "EXCELLENT": 0,
            "FINE": 1,
            "NEUTRAL": 2,
            "UNWELL": 3,
            "VERY_SICK": 4
        ]
        
    func updateIconColorsForEditingState() {
        // Unwrap the initial state and corresponding selected index
        guard let initialState = stateOfHealthModel.shared.initialStateOfHealth?.state,
              let selectedIndex = stateIndexMapping[initialState] else {
            return
        }
        
        // Iterate over the buttons in the stack view
        for (index, subview) in iconStackView.arrangedSubviews.enumerated() {
            guard let button = subview as? UIButton else { continue }
            
            // Handle the selected button
            if index == selectedIndex {
                // Restore the original image for the selected button
                if let originalImageName = iconImages[safe: button.tag] {
                    button.setImage(UIImage(named: originalImageName), for: .normal)
                }
            } else {
                
                // Apply a gray tint to all other buttons
                if let originalImageName = iconImages[safe: button.tag],
                   var originalImage = UIImage(named: originalImageName) {
                    if originalImageName == "nutral" {
                        originalImage = UIImage(named: "neutral")!
                      let grayImage = originalImage.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
                        button.setImage(originalImage, for: .normal)
                        
                    }else{
                        let grayImage = originalImage.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
                        button.setImage(grayImage, for: .normal)
                    }
                
                }
            }
        }
    }
    func createGraySmiley(from image: UIImage) -> UIImage? {
        let rect = CGRect(origin: .zero, size: image.size)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Flip the context vertically (Core Graphics coordinate system is inverted)
        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Draw the original image
        context.draw(image.cgImage!, in: rect)
        
        // Apply a gray tint to the face while preserving the white areas
        context.setBlendMode(.sourceIn)
        UIColor.lightGray.setFill()
        context.fill(rect)
        
        // Draw the original image again to preserve the white areas (eyes and mouth)
        context.setBlendMode(.destinationOver)
        context.draw(image.cgImage!, in: rect)
        
        // Get the final tinted image
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintedImage
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
    let iconMapping: [Int: String] = [
        0 : "white laughter",
        1 : "white smile",
        2 : "white normal",
        3 : "white angry",
        4 : "white worry"
    ]
    var iconButtonTapped: (() -> Void)?
    var passIconImage: ((_ iconName: String)->Void)?
    func getIconName(sender: UIButton) {
        // Simulate some work
      
               let senderImageTag = sender.tag
                   let image = UIImage(named: iconMapping[senderImageTag]!)
                  
                  
                    passIconImage?(iconMapping[senderImageTag]!)
                    delegate?.didTapButton(with: iconMapping[senderImageTag]!)
                    
                
    }
    var displayErrorMessage : (()->Void)?
    // Icon button action handler
    @objc func iconButtonTapped(_ sender: UIButton) {
        let index = sender.tag
               guard StateOfHealthResponse.allCases.indices.contains(index) else {
                   print("Invalid button index.")
                   return
               }
               
               // Get the corresponding state of health
               let selectedState = StateOfHealthResponse.allCases[index]
        stateOfHealthModel.shared.saveStateOfHealth(stateOfHealth: selectedState.rawValue){ isSavedSuccess in
            if isSavedSuccess{
                self.iconButtonTapped?()
            }else{
                self.displayErrorMessage?()
            }
            
        }
        
        print("Icon button tapped!")
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
        
        // Constraints for noskipButton
        NSLayoutConstraint.activate([
            stateOfHealthnoskipButton.centerXAnchor.constraint(equalTo: stateOfHealthbottomView.centerXAnchor),
            stateOfHealthnoskipButton.bottomAnchor.constraint(equalTo: stateOfHealthbottomView.bottomAnchor, constant: -25),
            stateOfHealthnoskipButton.heightAnchor.constraint(equalToConstant: 44),
            stateOfHealthnoskipButton.leadingAnchor.constraint(equalTo: stateOfHealthbottomView.leadingAnchor, constant: 20),
            stateOfHealthnoskipButton.trailingAnchor.constraint(equalTo: stateOfHealthbottomView.trailingAnchor, constant: -20),
        ])
    }
    var skipButtonTapped: (() -> Void)?
    @objc func stateOfHealthnoskipButtonTouchedDown() {
        skipButtonTapped?()
    }
    
    @objc func stateOfHealthnoskipButtonTouchedUp() {
        stateOfHealthnoskipButton.backgroundColor = .white
     
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
        setupstateOfHealthBottomViewIcons()
        setupstateOfHealthNoSkipButton()
        setupstateOfHealthView()
        updateIconColorsForEditingState()
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
        updateIconColorsForEditingState()
    }
}
class StateOfHealthSecondSubview: UIView, UIScrollViewDelegate, FirstCustomViewDelegate{
    func didTapButton(with imageName: String) {
     
    }
    // Method to update the image
        func updateImage(with image: String) {
            // Set up mysubviewView2 (assuming it's already added to the main view)
                  // Create and configure the UIImageView
                  let imageView = UIImageView()
                  imageView.image = UIImage(named: image) // Replace with your image name
                  imageView.translatesAutoresizingMaskIntoConstraints = false
                  imageView.contentMode = .scaleAspectFit
                  
                  // Add imageView to mysubviewView2
                  mysubviewView2.addSubview(imageView)
                  
                  // Set the constraints to center the image and fix its size
                  NSLayoutConstraint.activate([
                      imageView.centerXAnchor.constraint(equalTo: mysubviewView2.centerXAnchor),
                      imageView.centerYAnchor.constraint(equalTo: mysubviewView2.centerYAnchor),
                      imageView.widthAnchor.constraint(equalToConstant: 50),
                      imageView.heightAnchor.constraint(equalToConstant: 50)
                  ])
        }
    private let dayScrollView = UIScrollView()
    private let hourScrollView = UIScrollView()
    private let minuteScrollView = UIScrollView()
    private let selectionIndicatorHeight: CGFloat = 40
    let chevronButton = UIButton(type: .system)
    let selectionIndicator = UIView()
    let noAnswerButton = UIButton()
    let bottomView = UIView()
    let confirmButton = UIButton()
    private var dayLabels = [UILabel]()
    private var hourLabels = [UILabel]()
    private var minuteLabels = [UILabel]()
    let mysubviewView1 = UIView()
    let  mysubviewView1Image = UIImageView()
    let mysubviewView2 = UIView()
    let mysubviewView3 = UIView()
    let  mysubviewView3Image  = UIImageView()
    let stateOfhealthFirstView = StateOfHealthFirstSubview()
    
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
    func setupMessages(){
        
            mysubviewView3.backgroundColor = .white
            mysubviewView3.translatesAutoresizingMaskIntoConstraints = false
            
            // Add shadow
            mysubviewView3.layer.shadowColor = UIColor.black.cgColor
            mysubviewView3.layer.shadowOpacity = 0.3
            mysubviewView3.layer.shadowRadius = 4
            mysubviewView3.layer.shadowOffset = CGSize(width: 0, height: 2)
         
            
            // Add border radius
            mysubviewView3.layer.cornerRadius = 8
            mysubviewView3.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
            
            
            mysubviewView2.backgroundColor = .lightGray
            mysubviewView2.translatesAutoresizingMaskIntoConstraints = false
            
            // Add shadow
            mysubviewView2.layer.shadowColor = UIColor.black.cgColor
            mysubviewView2.layer.shadowOpacity = 0.3
            mysubviewView2.layer.shadowRadius = 4
            mysubviewView2.layer.shadowOffset = CGSize(width: 0, height: 2)
            // Add border radius
            mysubviewView2.layer.cornerRadius = 8
            mysubviewView2.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
      
            mysubviewView1.backgroundColor = .white
            mysubviewView1.translatesAutoresizingMaskIntoConstraints = false
            
            // Add shadow
            mysubviewView1.layer.shadowColor = UIColor.black.cgColor
            mysubviewView1.layer.shadowOpacity = 0.3
            mysubviewView1.layer.shadowRadius = 4
            mysubviewView1.layer.shadowOffset = CGSize(width: 0, height: 2)
            // Add border radius
            mysubviewView1.layer.cornerRadius = 8
            mysubviewView1.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            
            // Add to view hierarchy
          self.addSubview(mysubviewView3)
            self.addSubview(mysubviewView2)
            self.addSubview(mysubviewView1)
            
            let isSmallScreen = UIScreen.main.bounds.height <= 667 // iPhone SE 2nd gen height

            var mySubview1Con: NSLayoutConstraint
            if isSmallScreen {
                mySubview1Con = mysubviewView1.bottomAnchor.constraint(equalTo: dayScrollView.topAnchor, constant: -10)
            } else {
                mySubview1Con = mysubviewView1.bottomAnchor.constraint(equalTo: dayScrollView.topAnchor, constant: -20)
            }
               
            
            NSLayoutConstraint.activate([
                mysubviewView1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
                mysubviewView1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -140),
                mysubviewView1.heightAnchor.constraint(equalToConstant: 60),
                mySubview1Con,
            
                mysubviewView2.widthAnchor.constraint(equalToConstant: 70),
                mysubviewView2.heightAnchor.constraint(equalToConstant: 50),
                mysubviewView2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
                mysubviewView2.heightAnchor.constraint(equalToConstant: 60),
                mysubviewView2.bottomAnchor.constraint(equalTo: mysubviewView1.topAnchor, constant: 8),
       
                mysubviewView3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
                mysubviewView3.widthAnchor.constraint(equalToConstant: 300),
                mysubviewView3.heightAnchor.constraint(equalToConstant: 40),
                mysubviewView3.heightAnchor.constraint(equalToConstant: 60),
                mysubviewView3.bottomAnchor.constraint(equalTo: mysubviewView2.topAnchor, constant: -10),
                
            ])
            
            mysubviewView1Image.translatesAutoresizingMaskIntoConstraints = false
            mysubviewView1Image.image = UIImage(named: "Logo")
            mysubviewView1Image.contentMode = .scaleAspectFit
           self.addSubview( mysubviewView1Image)
            mysubviewView3Image.translatesAutoresizingMaskIntoConstraints = false
            mysubviewView3Image.image = UIImage(named: "Logo")
            mysubviewView3Image.contentMode = .scaleAspectFit
            self.addSubview( mysubviewView3Image)
      
            // Create a label
            let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.MEASUREMENTS_DATE-TEMPERATURE-EXTREMITIES.QUESTION", defaultText: "To which time does your information refer?")
            label.font = .systemFont(ofSize: 13)
            label.textAlignment = .left
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 8

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let profileName = appDelegate.fetchProfileName()
            let mysubviewView3label = UILabel()
        mysubviewView3label.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.QUESTION", defaultText: "How does {{name}} feel?").replacingOccurrences(of: "{{name}}", with: profileName!)
            mysubviewView3label.font = .systemFont(ofSize: 13)
            mysubviewView3label.textAlignment = .left
            mysubviewView3label.translatesAutoresizingMaskIntoConstraints = false
            mysubviewView3label.numberOfLines = 8
        
            // Add label to view
            mysubviewView1.addSubview(label)
            mysubviewView3.addSubview( mysubviewView3label)
            
            // Add constraints to label
            NSLayoutConstraint.activate([
                
                label.leadingAnchor.constraint(equalTo: mysubviewView1.leadingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: mysubviewView1.trailingAnchor, constant: -10),
                label.topAnchor.constraint(equalTo: mysubviewView1.topAnchor, constant: 5),
                label.bottomAnchor.constraint(equalTo: mysubviewView1.bottomAnchor, constant: -5),
                
                mysubviewView1Image.bottomAnchor.constraint(equalTo: mysubviewView1.bottomAnchor),
                mysubviewView1Image.leadingAnchor.constraint(equalTo: mysubviewView1.leadingAnchor, constant: -37),
                mysubviewView1Image.widthAnchor.constraint(equalToConstant: 30),
                mysubviewView1Image.heightAnchor.constraint(equalToConstant: 30),
                
                mysubviewView3label.leadingAnchor.constraint(equalTo: mysubviewView3.leadingAnchor, constant: 10),
                mysubviewView3label.trailingAnchor.constraint(equalTo: mysubviewView3.trailingAnchor, constant: -10),
                mysubviewView3label.topAnchor.constraint(equalTo: mysubviewView3.topAnchor, constant: 5),
                mysubviewView3label.bottomAnchor.constraint(equalTo:mysubviewView3.bottomAnchor, constant: -5),
                
                mysubviewView3Image.bottomAnchor.constraint(equalTo: mysubviewView3.bottomAnchor),
                mysubviewView3Image.leadingAnchor.constraint(equalTo: mysubviewView3.leadingAnchor, constant: -37),
                mysubviewView3Image.widthAnchor.constraint(equalToConstant: 30),
                mysubviewView3Image.heightAnchor.constraint(equalToConstant: 30)
            ])
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
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        noAnswerButton.addTarget(self, action: #selector(noAnswerButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            chevronButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            chevronButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            chevronButton.widthAnchor.constraint(equalToConstant: 30),
            chevronButton.heightAnchor.constraint(equalToConstant: 30),
          
            
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
        let screenHeight = UIScreen.main.bounds.height
        
        let isSmallScreenHeight = screenHeight < 844 // Screen height of iPhone 15
        
        // Set view height based on screen size
        let viewHeight: CGFloat = isSmallScreenHeight ? 460 : 600
        let tableHeight: CGFloat = isSmallScreenHeight ? 150 : 250
        dayScrollView.frame = CGRect(x: 0, y: 0, width: scrollWidth, height: tableHeight)
        hourScrollView.frame = CGRect(x: scrollWidth, y: 0, width: scrollWidth, height: tableHeight)
        minuteScrollView.frame = CGRect(x: 2 * scrollWidth, y: 0, width: scrollWidth, height: tableHeight)
        // Position the scroll views in the center of the view
        dayScrollView.translatesAutoresizingMaskIntoConstraints = false
        hourScrollView.translatesAutoresizingMaskIntoConstraints = false
        minuteScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            dayScrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            dayScrollView.heightAnchor.constraint(equalToConstant: tableHeight),
            dayScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            hourScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            hourScrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            hourScrollView.heightAnchor.constraint(equalToConstant: tableHeight),
            hourScrollView.leadingAnchor.constraint(equalTo: dayScrollView.trailingAnchor),
            
            minuteScrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            minuteScrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            minuteScrollView.heightAnchor.constraint(equalToConstant: tableHeight),
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
            // Reverse the index to calculate offset for a bottom-aligned scroll view
            let reversedDayIndex = days.count - dayIndex - 1
            let dayOffset = CGFloat(reversedDayIndex) * 80 - dayScrollView.bounds.height + 80 // 80 is assumed row height
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
        setupMessages()
        if stateOfHealthModel.shared.initialStateOfHealth != nil {
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
        NSLayoutConstraint.activate([
            // Constraints for TemperaturemeasurementMainView
            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: viewHeight),
        ])
    }
    var confirmButtonTap: ((_ selectedDate: Date)-> Void)?
    var noAnswerButtonTap: (()-> Void)?
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

    var displayError : (()->Void)?
    @objc func confirmButtonTapped() {
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
        
        stateOfHealthModel.shared.saveStateOfHealthDate(stateDate: selectedDate ?? Date()){ isSaved in
            if isSaved{
                self.confirmButtonTap?(selectedDate!)
                let entryId = AddEntryModel.shared.entryId!
                AddEntryNetworkManager.shared.fetchAndUpdateLocalEntry(with: entryId, overallDate: selectedDate ?? Date())
            }else{
                self.displayError?()
            }
        }
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

    @objc func noAnswerButtonTapped() {
        noAnswerButtonTap?()
    }
}
