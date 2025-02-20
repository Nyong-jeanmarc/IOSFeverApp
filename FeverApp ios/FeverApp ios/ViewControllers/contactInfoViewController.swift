//
//  File.swift
//  FeverApp ios
//
//  Created by Bar Bie  on 06/09/2024.
//

import UIKit

class contactInfoViewController:UIViewController, ContactInfoDelegate{
    func contactInfoDidChange() {
        setupTextFields()
    }
    
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBAction func backButtonTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    // Back button action
    @objc private func backButtonTapped() {
        // Perform action for the back button, like dismissing the view controller
        // If you're not using a navigation controller, just dismiss
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var editText: UILabel!
    @IBOutlet weak var titlelLabel: UILabel!
    
    @objc func labelTapped() {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EditContactInfoViewController") as? EditContactInfoViewController
        
        // Set the delegate
        viewController?.delegate = self

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController!, animated: true)
        } else {
            // Otherwise, present it modally in full screen
            viewController?.modalPresentationStyle = .fullScreen
            present(viewController!, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 20
        bottomView.layer.masksToBounds = true
        // Set up the phone and email text fields
        setupTextFields()
        // Enable user interaction on the label
        editText.isUserInteractionEnabled = true
        editText.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.EDIT",defaultText: "Edit")
        titlelLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.CONTACT.INFO",defaultText: "Contact info")
        
        // Add a tap gesture recognizer to the label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        editText.addGestureRecognizer(tapGesture)
        
        setupCustomTabBar()
      }
    
    private func setupCustomTabBar() {
        let customTabBar = CustomTabBarView()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.parentViewController = self // Assign the parent view controller
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        customTabBar.updateTranslations()
        customTabBar.updateTabBarItemColors()
    }
    func setupTextFields() {
        
        let contactInfo = fetchUserContactInfo()
        
        // White view with borders
        let textFieldView = UIView()
        textFieldView.backgroundColor = .white
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = UIColor.white.cgColor
        textFieldView.layer.cornerRadius = 10
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldView)

        // Phone Number TextField
        let phoneTextField = UITextField()
        phoneTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "DOCTOR_FORM.PHONE", defaultText: "Phone number")
        phoneTextField.borderStyle = .none
        phoneTextField.isUserInteractionEnabled = false // Disabling interaction
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(phoneTextField)

        // Phone Number Default Value Label
        let phoneDefaultValueLabel = UILabel()
        phoneDefaultValueLabel.text = contactInfo?.first?.phonenumber ?? ""
        phoneDefaultValueLabel.textAlignment = .right
        phoneDefaultValueLabel.font = UIFont.systemFont(ofSize: 14)
        phoneDefaultValueLabel.textColor = .darkGray
        phoneDefaultValueLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(phoneDefaultValueLabel)

        // Bottom border for the Phone Number field
        let phoneBottomBorder = UIView()
        phoneBottomBorder.backgroundColor = .lightGray
        phoneBottomBorder.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(phoneBottomBorder)

        // Email Address TextField
        let emailTextField = UITextField()
        emailTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "CONTACT.EMAIL", defaultText: "E-mail address")
        emailTextField.borderStyle = .none
        emailTextField.isUserInteractionEnabled = false // Disabling interaction
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(emailTextField)

        // Email Default Value Label
        let emailDefaultValueLabel = UILabel()
        emailDefaultValueLabel.text = contactInfo?.first?.email ??  ""
        emailDefaultValueLabel.textAlignment = .right
        emailDefaultValueLabel.font = UIFont.systemFont(ofSize: 14)
        emailDefaultValueLabel.textColor = .darkGray
        emailDefaultValueLabel.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(emailDefaultValueLabel)

        // Bottom border for the Email Address field
        let emailBottomBorder = UIView()
        emailBottomBorder.backgroundColor = .lightGray
        emailBottomBorder.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.addSubview(emailBottomBorder)

        // Constraints
        NSLayoutConstraint.activate([
            // TextField View Constraints
            textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textFieldView.heightAnchor.constraint(equalToConstant: 120),

            // Phone TextField Constraints
            phoneTextField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 20),
            
            // Phone Default Value Label Constraints
            phoneDefaultValueLabel.centerYAnchor.constraint(equalTo: phoneTextField.centerYAnchor),
            phoneDefaultValueLabel.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -20),
            phoneDefaultValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: phoneTextField.trailingAnchor, constant: 10),
            
            // Phone Bottom Border Constraints
            phoneBottomBorder.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 5),
            phoneBottomBorder.leadingAnchor.constraint(equalTo: phoneTextField.leadingAnchor),
            phoneBottomBorder.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -20),
            phoneBottomBorder.heightAnchor.constraint(equalToConstant: 1),

            // Email TextField Constraints
            emailTextField.topAnchor.constraint(equalTo: phoneBottomBorder.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 20),
            
            // Email Default Value Label Constraints
            emailDefaultValueLabel.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor),
            emailDefaultValueLabel.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -20),
            emailDefaultValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: emailTextField.trailingAnchor, constant: 10),
            
            // Email Bottom Border Constraints
            emailBottomBorder.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            emailBottomBorder.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailBottomBorder.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -20),
            emailBottomBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    }








    

