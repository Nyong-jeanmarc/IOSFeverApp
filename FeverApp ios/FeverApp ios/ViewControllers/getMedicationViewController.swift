//
//  getMedicationViewController.swift
//  FeverApp ios
//
//  Created by NEW on 04/09/2024.
//

import UIKit
class getMedicationViewController: UIViewController{


    @IBOutlet var topView: UIView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var confirmButton: UIButton!
    
    @IBOutlet var noButton: UIButton!
    
    @IBOutlet var myImage: UIImageView!
    
    @IBOutlet var skipButton: UIButton!
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    // Configuration properties
    let buttonWidth: CGFloat = 95
    let buttonHeight: CGFloat = 70
    let imageSize: CGFloat = 30
    let textSize: CGFloat = 14
    let containerHeight: CGFloat = 100
    let topPadding: CGFloat = 10
 // end of ScrollView container
 
 
    
    
    
    
 
 class CustomRoundedView: UIView {
         var corners: UIRectCorner = []
         
         override func layoutSubviews() {
             super.layoutSubviews()
             applyCornerRadius()
         }
         
         private func applyCornerRadius() {
             let path = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: 10, height: 10))
             let mask = CAShapeLayer()
             mask.path = path.cgPath
             layer.mask = mask
         }
     }
     
     var verticalStackView: UIStackView!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
         setupSymptomsView()
         
         setupScrollView() //scrollView
         setupButtons() //scrollView
         setupBar() //scrollView
         // Add actions for buttons
         confirmButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                 noButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
         
         
     }
 
 //BEGINING OF SCROLL VIEW CODE
     
 func setupScrollView() {
     // Add ScrollView to view
     scrollView.translatesAutoresizingMaskIntoConstraints = false
     scrollView.showsHorizontalScrollIndicator = false
     view.addSubview(scrollView)
     
     // Set constraints for scrollView
     NSLayoutConstraint.activate([
         scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
         scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         scrollView.heightAnchor.constraint(equalToConstant: containerHeight)
     ])
     
     // Add stackView to scrollView
     stackView.axis = .horizontal
     stackView.spacing = 10
     stackView.distribution = .fillEqually
     stackView.alignment = .center
     stackView.translatesAutoresizingMaskIntoConstraints = false
     scrollView.addSubview(stackView)
     
     // Set constraints for stackView
     NSLayoutConstraint.activate([
         stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
         stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
         stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
     ])
 }
 func setupButtons() {
     let buttonsConfig = [
         ("State of health", "State of health"),
         ("Temperature", "temp"),
         ("Pain", "Icon (7)"),
         ("Liquids", "liquid"),
         ("Diarrhea", "Diarrhea"),
         ("Rash", "Rash"),
         ("Symptoms", "Icon (15)"),
         ("Warning signs", "warning"),
         ("Feeling confi...", "Feeling confi"),
         ("Contact with...", "Contact"),
         ("Medication", "sarahdrug"),
         ("Measures", "Measures"),
         ("Note", "note")
     ]

     for (i, (text, imageName)) in buttonsConfig.enumerated() {
         let button = createButton(imageName: imageName, title: text)
         if i == 10 {
             button.layer.borderColor = UIColor.blue.cgColor
             button.layer.borderWidth = 1
         } else {
             button.layer.borderColor = UIColor.white.cgColor
             button.layer.borderWidth = 0
         }
         stackView.addArrangedSubview(button)
     }
 }
 
 func setupBar() {
     let bar = UIView()
     bar.translatesAutoresizingMaskIntoConstraints = false
     bar.backgroundColor = .lightGray
     view.addSubview(bar)
     
     NSLayoutConstraint.activate([
         bar.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
         bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
         bar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
         bar.heightAnchor.constraint(equalToConstant: 1)
     ])
 }
 
func createButton(imageName: String, title: String) -> UIButton {
 let button = UIButton(type: .custom)
 button.translatesAutoresizingMaskIntoConstraints = false
 button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
 button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
 button.backgroundColor = .white
 
 button.layer.cornerRadius = 8
 button.layer.shadowColor = UIColor.lightGray.cgColor
 button.layer.shadowOpacity = 0.5
 button.layer.shadowRadius = 2
 button.layer.shadowOffset = CGSize(width: 2, height: 2)
 
 // Image configuration
 let imageView = UIImageView(image: UIImage(named: imageName))
 imageView.contentMode = .scaleAspectFit
 imageView.translatesAutoresizingMaskIntoConstraints = false
 imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
 imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
 
 // Label configuration
 let label = UILabel()
 label.text = title
 label.font = UIFont.systemFont(ofSize: textSize)
 label.textAlignment = .center
 label.numberOfLines = 1
 
 // Stack view to combine image and text
 let verticalStackView = UIStackView(arrangedSubviews: [imageView, label])
 verticalStackView.axis = .vertical
 verticalStackView.alignment = .center
 verticalStackView.spacing = 5
 verticalStackView.translatesAutoresizingMaskIntoConstraints = false
 
 button.addSubview(verticalStackView)
 
 // Center stackView inside button
 
 NSLayoutConstraint.activate([
     verticalStackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
     verticalStackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
 ])
 
 return button
}

//END OF SCROLL VIEW CODE

 
     func setupUI() {
         let skipButtonTitle = NSMutableAttributedString(string: "No answer Skip")
         skipButton.addTarget(self, action: #selector(skipButtonTouchedDown), for: .touchDown)
         skipButton.addTarget(self, action: #selector(skipButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
         skipButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 10))
         skipButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
         skipButton.setAttributedTitle(skipButtonTitle, for: .normal)
         
         skipButton.layer.borderWidth = 0.5
         skipButton.layer.borderColor = UIColor.lightGray.cgColor
         skipButton.layer.cornerRadius = 8
         skipButton.layer.masksToBounds = true
         
         topView.layer.cornerRadius = 20
         topView.layer.masksToBounds = true
         
         confirmButton.layer.cornerRadius = 8
         confirmButton.layer.masksToBounds = true
         
         noButton.layer.cornerRadius = 8
         noButton.layer.masksToBounds = true
     }
     
     func setupSymptomsView() {
         
         let containerView = UIView()
         containerView.translatesAutoresizingMaskIntoConstraints = false
         containerView.backgroundColor = .white
         containerView.layer.cornerRadius = 15
         containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top corners
         view.addSubview(containerView)
         
         NSLayoutConstraint.activate([
             containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             containerView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
             containerView.heightAnchor.constraint(equalToConstant: 10)
         ])
         
         let scrollView = UIScrollView()
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         scrollView.showsVerticalScrollIndicator = false
         containerView.addSubview(scrollView)
         
         NSLayoutConstraint.activate([
             scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
             scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
             scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
             scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
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
         
         let topContainerView = CustomRoundedView()
         topContainerView.corners = [.topLeft, .topRight, .bottomRight]
         topContainerView.backgroundColor = .white
         topContainerView.translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(topContainerView)
         
         let topLabel = UILabel()
         topLabel.numberOfLines = 0
         topLabel.text = "Does <name> gotten medication?"
         topLabel.font = .systemFont(ofSize: 13)
         topLabel.translatesAutoresizingMaskIntoConstraints = false
         topContainerView.addSubview(topLabel)
         myImage.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             topContainerView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -13),
             topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
             topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
             topContainerView.heightAnchor.constraint(equalToConstant: 40),//taille du pop texte
             
             topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
             topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
             topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
             topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10),
             
             myImage.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
             myImage.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: -37),
             myImage.widthAnchor.constraint(equalToConstant: 30),
                        myImage.heightAnchor.constraint(equalToConstant: 30)
                    ])
                    
         self.verticalStackView = scrollableStackView
                }
    
    @objc func skipButtonTouchedUp() {
        skipButton.backgroundColor = .lightGray
    }
    @objc func skipButtonTouchedDown() {
        skipButton.backgroundColor = .lightGray
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let selectedColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
        
        // Reset all buttons to default state
        resetButtonAppearance(confirmButton)
        resetButtonAppearance(noButton)
        
        // Apply the selected color to the tapped button
        if sender == confirmButton {
            confirmButton.backgroundColor = selectedColor
        } else if sender == noButton {
            noButton.backgroundColor = selectedColor
        }
    }

    private func resetButtonAppearance(_ button: UIButton) {
        button.backgroundColor = .systemGray3
        button.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    
   }
