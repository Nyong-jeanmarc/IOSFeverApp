//
//  EditContactInfoViewController.swift
//  FeverApp ios
//
//  Created by Bar Bie  on 06/09/2024.
//

import UIKit
import CoreData

protocol ContactInfoDelegate: AnyObject {
    func contactInfoDidChange()
}

class EditContactInfoViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    
    weak var delegate: ContactInfoDelegate?
    
        @IBAction func backButtonTapAction(_ sender: UIButton) {
            backButtonTapped()
        }
        // Back button action
        @objc private func backButtonTapped() {
            // Perform action for the back button, like dismissing the view controller
            // If you're not using a navigation controller, just dismiss
            self.dismiss(animated: true, completion: nil)
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        return true
    }
    func addDoneOnTextFields(){
        // Create a toolbar with a "Done" button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.DONE", defaultText: "Done"), style: .done, target: self, action: #selector(dismissKeyboard))
           toolbar.setItems([doneButton], animated: false)
        // Set the toolbar as the inputAccessoryView for the painTextField
        emailTextField.inputAccessoryView = toolbar
        phoneTextField.inputAccessoryView = toolbar
     
    }
    // Dismiss the keyboard when the "Done" button is tapped
    @objc private func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Get the managed object context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create a fetch request to retrieve the existing entity
        let fetchRequest = NSFetchRequest<UserContactInfoEntity>(entityName: "UserContactInfoEntity")
        
        do {
            // Fetch the existing entity
            let existingEntities = try context.fetch(fetchRequest)
            
            if let existingEntity = existingEntities.first {
                // Update the properties of the existing entity
                existingEntity.phonenumber = phoneTextField.text ?? ""
                existingEntity.email = emailTextField.text ?? ""
                existingEntity.isSync = false
                
                // Save the changes to the context
                try context.save()
            } else {
                // If no existing entity is found, create a new one
                let entity = NSEntityDescription.entity(forEntityName: "UserContactInfoEntity", in: context)!
                let contactInfo = UserContactInfoEntity(entity: entity, insertInto: context)
                
                // Set properties of the contactInfo object
                contactInfo.contactInfoId = Int64.random(in: 1...Int64.max) // Generate a random ID if none exists
                contactInfo.phonenumber = phoneTextField.text ?? ""
                contactInfo.email = emailTextField.text ?? ""
                contactInfo.isSync = false
                
                // Save the new entity to the context
                try context.save()
            }
        } catch {
            print("Error updating or creating contact info entity: \(error)")
        }
        
        // Notify delegate before dismissing
        delegate?.contactInfoDidChange()
        
        self.dismiss(animated: true, completion: nil)
    }

    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "CONTACT.EMAIL", defaultText: "E-mail address")
        label.font = UIFont(name: "Arial", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = TranslationsViewModel.shared.getAdditionalTranslation(key: "LOGIN.EMAIL.TEXT1.PLACEHOLDER", defaultText: "Enter e-mail address")
        textField.font = UIFont(name: "Arial", size: 14)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "DOCTOR_FORM.PHONE", defaultText: "Phone number")
        label.font = UIFont(name: "Arial", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PEDIATRICIAN.TEXT6.PLACEHOLDER", defaultText: "Enter phone number")
        textField.font = UIFont(name: "Arial", size: 14)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        addDoneOnTextFields()
        if let userContactInfo = fetchUserContactInfo() {
            emailTextField.text = userContactInfo.first?.email
            phoneTextField.text = userContactInfo.first?.phonenumber
        } else {
            // Handle the error
        }
        
        titleLable.text = TranslationsViewModel.shared.getTranslation(key: "ROLE.EDIT-ROLE.HEADER", defaultText: "\(TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.EDIT", defaultText: "Edit") + " " + TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.CONTACT.INFO", defaultText: "Contact info"))")
        
        saveButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.SAVE", defaultText: "Save"), for: .normal)
        cancelButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CANCEL", defaultText: "Cancel"), for: .normal)
        
        saveButton.layer.borderColor = UIColor.lightGray.cgColor
        saveButton.layer.borderWidth = 1
        saveButton.layer.cornerRadius = 8
        saveButton.layer.masksToBounds = true
        cancelButton.layer.borderColor = UIColor.lightGray.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.masksToBounds = true
        
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 20
        bottomView.layer.masksToBounds = true
        
        setupLayout()
        setupTextFieldTargets()
        updateSaveButtonState() // Update initial button state
    }
    
    func setupLayout() {
        view.addSubview(containerView)
        containerView.addSubview(emailLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(phoneLabel)
        containerView.addSubview(phoneTextField)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            
            emailLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            phoneLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            
            phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 10),
            phoneTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            phoneTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
    }
    
    func setupTextFieldTargets() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange() {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let isFormFilled = !(emailTextField.text?.isEmpty ?? true) && !(phoneTextField.text?.isEmpty ?? true)
        if isFormFilled {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(red: 0.631, green: 0.761, blue: 0.988, alpha: 1.0)
            saveButton.setTitleColor(.white, for: .normal)
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .lightGray
            saveButton.setTitleColor(.darkGray, for: .normal)
        }
    }
}
