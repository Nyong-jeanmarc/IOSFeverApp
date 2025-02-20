//
//  feelingConfidentViewController.swift
//  FeverApp ios
//
//  Created by Bar Bie  on 03/09/2024.
//

//
//



import UIKit
class feelingConfidentViewController: UIViewController{
    
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var skipButton: UIButton!
    
    @IBOutlet var confirmButton: UIButton!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var myImage: UIImageView!
    
    
    
    
    
    // ScrollView container
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
            ("State of health", "healt"),
            ("Teperature", "temp"),
            ("Pain", "pain"),
            ("Liquid", "liquid"),
            ("Diarrhea", "Diarrhea"),
            ("Rash", "rash"),
            ("Symptoms", "Symptoms"),
            ("Warning signs", "warning"),
            ("Feeling confi...", "confident"),
            ("Contact with...", "Contact"),
            ("Medication", "medica"),
            ("Measures", "measure"),
            ("Note", "note")
        ]

        for (i, (text, imageName)) in buttonsConfig.enumerated() {
            let button = createButton(imageName: imageName, title: text)
            if i == 8 {
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
                containerView.heightAnchor.constraint(equalToConstant: 250)
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
            topLabel.text = "When <name> has a fever, do you feel confident that youcan deal with it appropriately?"
            topLabel.font = .systemFont(ofSize: 13)
            topLabel.translatesAutoresizingMaskIntoConstraints = false
            topContainerView.addSubview(topLabel)
            myImage.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                topContainerView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -13),
                topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                topContainerView.heightAnchor.constraint(equalToConstant: 75),
                
                topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
                topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
                topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
                topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10),
                
                myImage.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
                myImage.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: -37),
                myImage.widthAnchor.constraint(equalToConstant: 30),
                           myImage.heightAnchor.constraint(equalToConstant: 30)
                       ])
                       
                       let warningSigns = ["No", "Yes,touch sensitivity", "Yes, shrill screaming like i've never heard it before", "Yes, acting differently, clouded consciousness, apathy", "Yes, seems seriously sick"]

                       for (index, symptom) in warningSigns.enumerated() {
                           let symptomView = createCheckboxWithLabel(text: symptom, tag: index)
                           scrollableStackView.addArrangedSubview(symptomView)

                           let divider = UIView()
                           divider.translatesAutoresizingMaskIntoConstraints = false
                           divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                           divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
                           scrollableStackView.addArrangedSubview(divider)
                       }

                       self.verticalStackView = scrollableStackView
                   }

    func createCheckboxWithLabel(text: String, tag: Int) -> UIStackView {
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.spacing = 8
        containerStackView.alignment = .center
        containerStackView.distribution = .fill

        let checkbox = UIButton(type: .custom)
        checkbox.tag = tag
        checkbox.setImage(UIImage(systemName: "square")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1), renderingMode: .alwaysOriginal), for: .selected)
        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 24).isActive = true

        // Create a stack view for the goldstar images
        let starsStackView = UIStackView()
        starsStackView.axis = .horizontal
        starsStackView.spacing = 4
        starsStackView.alignment = .center
        starsStackView.distribution = .fill

        // Add goldstar images based on the tag
        let numberOfStars: Int
        switch tag {
        case 0:
            numberOfStars = 5
        case 1:
            numberOfStars = 4
        case 2:
            numberOfStars = 3
        case 3:
            numberOfStars = 2
        default:
            numberOfStars = 1
        }

        for (index, _) in (0..<numberOfStars).enumerated() {
            let starImageView = UIImageView(image: UIImage(named: "goldstar"))
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            starImageView.contentMode = .scaleAspectFit // Maintain aspect ratio
            starsStackView.addArrangedSubview(starImageView)

            // Apply additional leading space to the last star
            if index == numberOfStars - 1 {
                let spacerView = UIView()
                spacerView.translatesAutoresizingMaskIntoConstraints = false
                spacerView.widthAnchor.constraint(equalToConstant: 88).isActive = true // Adjust space as needed
                starsStackView.addArrangedSubview(spacerView)
            }
        }

        // Add checkbox and stars stack view to the container
        containerStackView.addArrangedSubview(checkbox)
        containerStackView.addArrangedSubview(starsStackView)

        return containerStackView
    }

                   @objc func labelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
                       guard let label = gestureRecognizer.view as? UILabel else { return }
                       guard let stackView = label.superview as? UIStackView else { return }
                       guard let checkbox = stackView.arrangedSubviews.first as? UIButton else { return }
                       toggleCheckbox(checkbox)
                   }

                   @objc func toggleCheckbox(_ sender: UIButton) {
                       if sender.tag == 0 {
                           for view in self.verticalStackView.arrangedSubviews {
                               if let stackView = view as? UIStackView, stackView != sender.superview {
                                   if let checkbox = stackView.arrangedSubviews.first as? UIButton {
                                       checkbox.isSelected = false
                                   }
                               }
                           }
                           sender.isSelected.toggle()
                       } else {
                           if let firstCheckbox = self.verticalStackView.arrangedSubviews[0] as? UIStackView,
                              let firstCheckboxButton = firstCheckbox.arrangedSubviews.first as? UIButton {
                               firstCheckboxButton.isSelected = false
                           }
                           sender.isSelected.toggle()
                       }
                       
                       
                       
                       
                   }
    
    @objc func skipButtonTouchedDown() {
        skipButton.backgroundColor = .lightGray
    }

    @objc func skipButtonTouchedUp() {
        skipButton.backgroundColor = .white
    }
               }


