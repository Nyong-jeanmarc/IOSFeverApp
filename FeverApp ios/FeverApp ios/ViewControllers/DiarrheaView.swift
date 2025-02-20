//
//  DiarrheaView.swift
//  FeverApp ios
//
//  Created by user on 8/27/24.
//

//
//  DiarrheaView.swift
//  Diarrhea View
//
//  Created by user on 8/23/24.
//

import UIKit
class DiarrheaView: UIViewController {
    
    
    
    @IBOutlet var headView: UIView!
    
    @IBOutlet var bottomView: UIView!
    
    
    @IBOutlet var confirmButton: UIButton!
    
    
    @IBOutlet var skipButton: UIButton!
    
    
    
    // ScrollView container
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    // Configuration properties
    let buttonWidth: CGFloat = 95
    let buttonHeight: CGFloat = 70
    let imageSize: CGFloat = 30
    let textSize: CGFloat = 12
    let containerHeight: CGFloat = 100
    let topPadding: CGFloat = 10
    // end of ScrollView container
    
    var verticalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView() //scrollView
        setupButtons() //scrollView
        setupBar() //scrollView
        setupUI()
        
        skipButton.layer.borderColor = UIColor.lightGray.cgColor
        skipButton.layer.borderWidth = 1
        skipButton.layer.cornerRadius = 8
        skipButton.layer.masksToBounds = true
        
        confirmButton.layer.borderColor = UIColor.lightGray.cgColor
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.cornerRadius = 8
        confirmButton.layer.masksToBounds = true
        
        // Set rounded corners for headView
        headView.layer.cornerRadius = 14
        headView.layer.masksToBounds = true
        
        // Create a new view with shadow and border radius
        let myView = UIView()
        myView.backgroundColor = .white
        myView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add shadow
        myView.layer.shadowColor = UIColor.black.cgColor
        myView.layer.shadowOpacity = 0.3
        myView.layer.shadowRadius = 4
        myView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Add border radius
        myView.layer.cornerRadius = 10
        myView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        // Add to view hierarchy
        view.addSubview(myView)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Leading constraint: 50 points from the leading edge of the view
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            // Trailing constraint: 50 points from the trailing edge of the view
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myView.heightAnchor.constraint(equalToConstant: 60),
            myView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -315),
        ])
        
        
        // Create a label
        let label = UILabel()
        label.text = "Has <name> had any diarrhea and/or vomiting?"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add label to view
        myView.addSubview(label)
        
        // Add constraints to label
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: myView.centerYAnchor)
        ])
        
    }
    
    //BEGINING OF SCROLL VIEW CODE
    
    func setupScrollView() {
        // Add ScrollView to view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        // Set constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headView.bottomAnchor, constant: 4),
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
            ("Teperature", "Temperature"),
            ("Pain", "Pain"),
            ("Liquid", "liquidss"),
            ("Diarrhea", "Blue diarrhea"),
            ("Rash", "Rash"),
            ("Symptoms", "Symptoms"),
            ("Warning signs", "Warning"),
            ("Feeling confi...", "Feeling confi"),
            ("Contact with...", "Contact"),
            ("Medication", "Medication"),
            ("Measures", "Measures"),
            ("Note", "Note")
        ]
        
        for (_, (text, imageName)) in buttonsConfig.enumerated() {
            let button = createButton(imageName: imageName, title: text)
            if text == "Diarrhea"{
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
    
    var radioButtons: [UIButton] = []
    
    func setupUI() {
        
        
        // Create a new view with rounded corners
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // StackView to hold the options
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        // Add options
        let options = [
            "No",
            "Yes, Diarrhea and vomiting",
            "Yes, Diarrhea",
            "Yes, vomiting"
        ]
        for (index, option) in options.enumerated() {
            let optionView = createOptionView(text: option, isSelected: index == 0) // Select the first option by default
            stackView.addArrangedSubview(optionView)
            
            // Add a gray bar separating each option
            if index < options.count - 1 {
                let separatorView = UIView()
                separatorView.backgroundColor = UIColor.lightGray
                separatorView.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(separatorView)
                
                NSLayoutConstraint.activate([
                    separatorView.heightAnchor.constraint(equalToConstant: 1),
                    separatorView.topAnchor.constraint(equalTo: optionView.bottomAnchor, constant: 60),
                    separatorView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 2),
                    separatorView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -2),
                ])
            }
            
            // Create a light gray bar at the bottom of the container view
               let lightGrayBar = UIView()
               lightGrayBar.backgroundColor = UIColor.lightGray
               lightGrayBar.translatesAutoresizingMaskIntoConstraints = false
               containerView.addSubview(lightGrayBar)

               NSLayoutConstraint.activate([
                   lightGrayBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -13), // Adjusted to be 5 points above the bottom anchor
                   lightGrayBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 9),
                   lightGrayBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                   lightGrayBar.heightAnchor.constraint(equalToConstant: 1)
               ])

            
        }
        // Constraints
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
        ])
    }
    
    func createOptionView(text: String, isSelected: Bool) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        // Radio Button
        let radioButton = UIButton(type: .system)
        radioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        radioButton.tag = radioButtons.count // Use tag to identify the button
        radioButton.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        radioButton.tintColor = .lightGray // Set the tint color to gray
        container.addSubview(radioButton)
        // Option Label
        let optionLabel = UILabel()
        optionLabel.text = text
        optionLabel.font = UIFont.systemFont(ofSize: 16)
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.isUserInteractionEnabled = true // Enable user interaction
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        optionLabel.addGestureRecognizer(tapGesture)
        container.addSubview(optionLabel)
        // Add the radio button to the array
        radioButtons.append(radioButton)
        // Constraints
        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            radioButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 24),
            radioButton.heightAnchor.constraint(equalToConstant: 24),
            optionLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 10),
            optionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            optionLabel.topAnchor.constraint(equalTo: container.topAnchor),
            optionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        guard let container = label.superview else { return }
        guard let radioButton = container.subviews.first as? UIButton else { return }
        radioButtonTapped(radioButton)
    }

    @objc func radioButtonTapped(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(systemName: "largecircle.fill.circle") {
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            sender.tintColor = .gray
        } else {
            for button in radioButtons {
                button.setImage(UIImage(systemName: "circle"), for: .normal)
                button.tintColor = .gray
            }
            sender.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            sender.tintColor = UIColor(red: 0.392, green: 0.584, blue: 0.929, alpha: 1.0)
        }
        confirmButton.backgroundColor = radioButtons.contains(where: { $0.image(for: .normal) == UIImage(systemName: "largecircle.fill.circle") }) ?
                                        UIColor(red: 0.392, green: 0.584, blue: 0.929, alpha: 1.0) : .lightGray
    }
    
}

