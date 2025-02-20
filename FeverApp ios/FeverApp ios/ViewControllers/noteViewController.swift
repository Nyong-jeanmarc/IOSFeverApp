//
//  noteViewController.swift
//  FeverApp ios
//
//  Created by user on 9/4/24.
//


import UIKit

class noteViewController:UIViewController{
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
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
    textField.layer.cornerRadius = 7
        textField.layer.masksToBounds = true
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
        topView.layer.cornerRadius = 14
        topView.layer.masksToBounds = true
        
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
            myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            // Trailing constraint: 50 points from the trailing edge of the view
            myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            myView.heightAnchor.constraint(equalToConstant: 150),
            myView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -40),
        ])
        
        
        // Create a label
        let label = UILabel()
        label.text = "We are glad if you even more exactly describe the process of the illness to us: Was there before sign? When there before sign? When and howthe illness has begun independent of the fever and how was the present course?"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 8
        
        // Add label to view
        myView.addSubview(label)
        
        // Add constraints to label
        NSLayoutConstraint.activate([
        
            label.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: myView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: myView.bottomAnchor, constant: -10)
           
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
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 4),
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
            ("Diarrhea", "Diarrhea"),
            ("Rash", "Rash"),
            ("Symptoms", "Symptoms"),
            ("Warning signs", "Warning"),
            ("Feeling confi...", "Feeling confi"),
            ("Contact with...", "Contact"),
            ("Medication", "Medication"),
            ("Measures", "Measures"),
            ("Note", "Icon-34")
        ]
        
        for (_, (text, imageName)) in buttonsConfig.enumerated() {
            let button = createButton(imageName: imageName, title: text)
            if text == "Note"{
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
        
    }
}

