//
//  loginWithFamilyCode.swift
//  FeverApp ios
//
//  Created by user on 8/5/24.
//

import UIKit

class loginWithFamilyCode: UIViewController {
    
    let containerView = UIView()
    let topLabel = UILabel()
    let codeTextField = UITextField()
    let copyImageView = UIImageView()
    let bottomLabel = UILabel()
    func handleNavigationToChooseFamilyRoleScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("\n\nnavigationController: \(navigationController)")
        if let chooseFamilyRoleVC = storyboard.instantiateViewController(withIdentifier: "FamilyRole") as? ChooseFamilyRoleViewController {
            self.navigationController?.pushViewController(chooseFamilyRoleVC , animated: true)
        }
    }
    @IBAction func handleNextUIButtonClick(_ sender: Any) {
        handleNavigationToChooseFamilyRoleScreen()
    }
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var myView: UIView!
    
    @IBOutlet weak var myView2: UIView!
    
    override func viewDidLoad() {
        nextBtn.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 18, height: 18))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = UIColor(hex: "B9BCC8")
        // Create a custom UILabel for the title
            let navtitleLabel = UILabel()
        navtitleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "LOGIN.FAMILY.CODE.TITLE", defaultText: "Login with family code")
            navtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            navtitleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: navtitleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
        super.viewDidLoad()
        setupUI()
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    
        myView2.layer.cornerRadius = 25
        myView2.layer.masksToBounds = true
        
        myView.layer.cornerRadius = 25
        myView.layer.masksToBounds = true
        
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView2.translatesAutoresizingMaskIntoConstraints = false
        
    }
    @objc func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    func resizeImage(image: UIImage, to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    func setupUI() {
        myView.layer.shadowColor = UIColor.lightGray.cgColor
        myView.layer.shadowOpacity = 0.3
        myView.layer.shadowRadius = 5
        myView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        
        myView2.layer.shadowColor = UIColor.lightGray.cgColor
        myView2.layer.shadowOpacity = 0.3
        myView2.layer.shadowRadius = 5
        myView2.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        // Container View
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.backgroundColor = UIColor.white // Ensure container view is visible
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 145),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])

       
        
        
        
        
        // Top Label
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.numberOfLines = 0
        topLabel.textColor = .black // Ensure text color is visible
        topLabel.text = TranslationsViewModel.shared.getTranslation(key: "USERNAME.TEXT.1", defaultText: "With the family code below, you can access the same data of your family with other smartphones. Please do not pass it on outside the family. Because it is only a randomly generated code, you are always 100% anonymous in FeverApp.")
        containerView.addSubview(topLabel)

        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            topLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            topLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])

        // Code Text Field
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        codeTextField.borderStyle = .roundedRect
        codeTextField.textColor = .black // Ensure text color is visible
        codeTextField.layer.borderColor = UIColor.black.cgColor
        
        codeTextField.font = UIFont.boldSystemFont(ofSize: 18) // Bold and set size to 18
        codeTextField.font = codeTextField.font?.withSize(22)  // Set the font size to 22

        
        
        codeTextField.text = LoginWithFamilyCodeModel.shared.usersFamilyCode
        codeTextField.isUserInteractionEnabled = false
        containerView.addSubview(codeTextField)

        NSLayoutConstraint.activate([
            codeTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10),
            codeTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            codeTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            codeTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Copy Image View
        copyImageView.translatesAutoresizingMaskIntoConstraints = false
        copyImageView.image = UIImage(named: "Frame")
        copyImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyCode))
        copyImageView.addGestureRecognizer(tapGesture)
        containerView.addSubview(copyImageView)

        NSLayoutConstraint.activate([
            copyImageView.centerYAnchor.constraint(equalTo: codeTextField.centerYAnchor),
            copyImageView.leadingAnchor.constraint(equalTo: codeTextField.trailingAnchor, constant: 10),
            copyImageView.trailingAnchor.constraint(equalTo: codeTextField.trailingAnchor, constant: -34),
            copyImageView.heightAnchor.constraint(equalToConstant: 20),
            copyImageView.widthAnchor.constraint(equalToConstant: 20)
        ])

        // Bottom Label
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.numberOfLines = 0
        bottomLabel.textColor = .black // Ensure text color is visible
//        bottomLabel.text = """
//        Please write down the code and/or take a screenshot of it! Furthermore, the code is displayed in the menu. Without this code, you will not be able to access your data later on!
//        """
        containerView.addSubview(bottomLabel)
        
        let boldText = getAttributedString( TranslationsViewModel.shared.getTranslation(key: "USERNAME.TEXT.2", defaultText: "<strong>Please write down the code and/or take a screenshot of it! Furthermore, the code is displayed in the menu. Without this code, you will not be able to access your data later on!</strong>"))

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: bottomLabel.font.pointSize)
        ]

        bottomLabel.attributedText = boldText


        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            bottomLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            bottomLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            bottomLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
        ])
    }

    func generateRandomCode() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map{ _ in letters.randomElement()! })
    }

    @objc func copyCode() {
        // Copy text to clipboard
        UIPasteboard.general.string = codeTextField.text

        // Change image to text "Code copied!"
        copyImageView.image = nil
        let label = UILabel()
        label.text = "Code copied!"
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        copyImageView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: copyImageView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: copyImageView.centerYAnchor)
        ])
    }
}


    
    


