//
//  medicationSubviews.swift
//  FeverApp ios
//
//  Created by NEW on 11/11/2024.
//

import Foundation
import UIKit
class MedicationFirstSubview : UIView{
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        
        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.MEDICATION.MEDICATION.QUESTION", defaultText: "Has {{name}} gotten medication?").replacingOccurrences(of: "{{name}}", with: profileName!)
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
    @objc func getMedicationskipButtonTouchedUp() {
        getMedicationskipButton.backgroundColor = . white
    }
    @objc func getMedicationskipButtonTouchedDown() {
        noButtonTap?()
        getMedicationskipButton.backgroundColor = .lightGray
     
    }
    var noButtonTap: (()->Void)?
    var yesButtonTap: (()->Void)?
    var displayError: (()->Void)?
    @objc func NoButtonTouchedUp(_ sender: UIButton) {
        NoButton.backgroundColor = . lightGray
      
    }
    @objc func NoButtonTouchedDown(_ sender: UIButton) {
        NoButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
        // Get the title label text and capitalize it
        if let title = sender.currentTitle {
            let capitalizedTitle = title.uppercased()
            print("Capitalized Title: \(capitalizedTitle)")
            medicationModel.shared.saveHasTakenMedication(hasTaken: capitalizedTitle){isSaved in
                if isSaved {
                    self.noButtonTap?()
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
        // Change the button's background color
        YesButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
        
        // Get the title label text and capitalize it
        if let title = sender.currentTitle {
            let capitalizedTitle = title.uppercased()
            print("Capitalized Title: \(capitalizedTitle)")
            medicationModel.shared.saveHasTakenMedication(hasTaken: capitalizedTitle){isSaved in
                if isSaved {
                    // Execute the closure if it exists
                    self.yesButtonTap?()
                }else{
                    self.displayError?()
                }
                
            }
        }
        
       
    }
    /// Function to update button states based on initial medication state
       func updateButtonStateBasedOnInitialMedicationState() {
           guard let initialState = medicationModel.shared.initialMedicationState else { return }

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
        updateButtonStateBasedOnInitialMedicationState()
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
        getMedicationsetupUI()
        setupgetMedicationView()
        setupgetMedicationBottomView()
        getMedicationBottomView.layer.cornerRadius = 18
        updateButtonStateBasedOnInitialMedicationState()
    }
}
