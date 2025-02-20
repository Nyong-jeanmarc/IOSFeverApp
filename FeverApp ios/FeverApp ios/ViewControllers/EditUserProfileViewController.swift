//
//
//  EditUserProfileViewController.swift
//  FeverApp ios
//
//  Created by Bar Bie  on 06/09/2024.
//

import UIKit
import CoreData

protocol PersonalInfoDelegate: AnyObject {
    func personalInfoDidChange()
}

class EditUserProfileViewController:UIViewController, UITextFieldDelegate{
    
    private var selectedEnglishRole: String?

    @IBOutlet var topView: UIView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var CancelButton: UIButton!
    
    @IBOutlet var SaveButton: UIButton!
    @IBAction func backButtonTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
       lastNameTextField.resignFirstResponder()
        roleTextField.resignFirstResponder()
        birthdayTextField.resignFirstResponder()
        return false
    }
    func setupDoneOnTextFields(){
        // Create a toolbar with a "Done" button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.DONE", defaultText: "Done"), style: .done, target: self, action: #selector(dismissKeyboard))
           toolbar.setItems([doneButton], animated: false)
        // Set the toolbar as the inputAccessoryView for the painTextField
        firstNameTextField.inputAccessoryView = toolbar
        lastNameTextField.inputAccessoryView = toolbar
         roleTextField.inputAccessoryView = toolbar
         birthdayTextField.inputAccessoryView = toolbar
    }
    // Dismiss the keyboard when the "Done" button is tapped
    @objc private func dismissKeyboard() {
        firstNameTextField.resignFirstResponder()
       lastNameTextField.resignFirstResponder()
        roleTextField.resignFirstResponder()
        birthdayTextField.resignFirstResponder()
    }
    // Back button action
    @objc private func backButtonTapped() {
        // Perform action for the back button, like dismissing the view controller
        // If you're not using a navigation controller, just dismiss
        self.dismiss(animated: true, completion: nil)
    }
    // Middle view to hold text fields
    let middleView = UIView()
    
    // TextFields
    let firstNameTextField = UITextField()
    let lastNameTextField = UITextField()
    let roleTextField = UITextField()
    let birthdayTextField = UITextField()
    
    // Triangle down buttons
    let roleButton = UIButton(type: .system)
    let birthdayButton = UIButton(type: .system)
    
    // Labels for the textfields
    let firstNameLabel = UILabel()
    let lastNameLabel = UILabel()
    let roleLabel = UILabel()
    let birthdayLabel = UILabel()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    weak var delegate: PersonalInfoDelegate?
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Get the managed object context
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create a fetch request to retrieve the existing entity
        let fetchRequest = NSFetchRequest<UserPersonalInformationEntity>(entityName: "UserPersonalInformationEntity")
        
        do {
            // Fetch the existing entity
            let existingEntities = try context.fetch(fetchRequest)
            
            if let existingEntity = existingEntities.first {
                // Update the properties of the existing entity
                existingEntity.userFirstName = firstNameTextField.text ?? ""
                existingEntity.userLastName = lastNameTextField.text ?? ""
                existingEntity.familyRole = selectedEnglishRole ?? ""
                existingEntity.userYearOfBirth = birthdayTextField.text ?? ""
                existingEntity.educationalLevel = ""
                existingEntity.nationality = ""
                existingEntity.countryOfResidence = ""
                existingEntity.postcode = ""
                existingEntity.isSync = false
                
                // Save the changes to the context
                try context.save()
            } else {
                // If no existing entity is found, create a new one
                let entity = NSEntityDescription.entity(forEntityName: "UserPersonalInformationEntity", in: context)!
                let personalInfo = UserPersonalInformationEntity(entity: entity, insertInto: context)
                
                // Set properties of the personalInfo object
                personalInfo.userFirstName = firstNameTextField.text ?? ""
                personalInfo.userLastName = lastNameTextField.text ?? ""
                personalInfo.familyRole =  selectedEnglishRole ?? ""
                personalInfo.userYearOfBirth = birthdayTextField.text ?? ""
                personalInfo.educationalLevel = ""
                personalInfo.nationality = ""
                personalInfo.countryOfResidence = ""
                personalInfo.postcode = ""
                personalInfo.isSync = false
                
                // Save the new entity to the context
                try context.save()
            }
        } catch {
            print("Error updating or creating personal info entity: \(error)")
        }
        
        // Notify delegate before dismissing
        delegate?.personalInfoDidChange()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    let roleTranslations: [String: String] = [
        "Mom": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.MOTHER", defaultText: "Mom"),
        "Dad": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.FATHER", defaultText: "Dad"),
        "Grandpa": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.GRANDPA", defaultText: "Grandpa"),
        "Grandma": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.GRANDMA", defaultText: "Grandma"),
        "Other": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.OTHER", defaultText: "Other"),
        "Not specified": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.NO_ANSWER", defaultText: "Not specified")
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupDoneOnTextFields()
//        if let userPersonalInfo = fetchUserPersonalInfo() {
//            firstNameTextField.text = userPersonalInfo.first?.userFirstName
//            lastNameTextField.text = userPersonalInfo.first?.userLastName
//            roleTextField.text = userPersonalInfo.first?.familyRole
//            birthdayTextField.text = userPersonalInfo.first?.userYearOfBirth
//        } 
        if let userPersonalInfo = fetchUserPersonalInfo() {
            firstNameTextField.text = userPersonalInfo.first?.userFirstName
            lastNameTextField.text = userPersonalInfo.first?.userLastName
            
            // Fetch the English role from the database
            if let englishRole = userPersonalInfo.first?.familyRole {
                // Use the dictionary to find the translated value
                roleTextField.text = roleTranslations[englishRole] ?? englishRole // Fallback to English if no translation is found
            }
            
            birthdayTextField.text = userPersonalInfo.first?.userYearOfBirth
        }

        else {
            // Handle the error
        }
        
        titleLabel.text = TranslationsViewModel.shared.getTranslation(key: "ROLE.EDIT-ROLE.HEADER",defaultText: "Edit personal info")
        
        saveBtn.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.SAVE",defaultText: "Save"), for: .normal)
        cancelBtn.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CANCEL" ,defaultText: "Cancel"), for: .normal)
        
        // Round the corners for topView and bottomView
        topView.layer.cornerRadius = 25
        topView.layer.masksToBounds = true
        
        bottomView.layer.cornerRadius = 20
        bottomView.layer.masksToBounds = true
        
        // Cancel and Save button styling
        CancelButton.layer.borderColor = UIColor.lightGray.cgColor
        CancelButton.layer.borderWidth = 1
        CancelButton.layer.cornerRadius = 8
        
        SaveButton.layer.borderColor = UIColor.lightGray.cgColor
        SaveButton.layer.borderWidth = 1
        SaveButton.layer.cornerRadius = 8
        
        // Setup middleView and its elements
        setupMiddleView()
        setupTextFieldsWithLabels()
        setupButtons()
        
        // Add target for textField editing
        firstNameTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        // Show keyboard
        firstNameTextField.becomeFirstResponder()
        
        // Add tap gesture to the roleTextField to present the popup
        let roleTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(showRoleSelectionPopup))
        roleTextField.addGestureRecognizer(roleTextFieldTapGesture)
        roleTextField.isUserInteractionEnabled = true // Ensure text field is interactable
        // Add tap gesture to the birthdayTextField to present the popup
        let birthdayTextFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(showBirthdayPopup))
        birthdayTextField.addGestureRecognizer(birthdayTextFieldTapGesture)
        birthdayTextField.isUserInteractionEnabled = true // Ensure text field is interactable
    }
    
    @objc func showRoleSelectionPopup() {
        let roleSelectionVC = FilRoleSelectionViewController()
        // Handle role selection closure if needed
        roleSelectionVC.onRoleSelected = { [weak self] translatedRole, englishRole in
            self?.roleTextField.text = translatedRole // Use the translated value for display
            // Optionally handle the `englishRole` here if needed
            self?.selectedEnglishRole = englishRole
            print("Selected English Role: \(englishRole)") // For debugging purposes
        }

        // Present the role selection view controller as a popup
        roleSelectionVC.modalPresentationStyle = .overFullScreen
        roleSelectionVC.modalTransitionStyle = .crossDissolve
        present(roleSelectionVC, animated: true, completion: nil)
    }
    
    @objc func showBirthdayPopup() {
        // Create an instance of BirthdayPopupViewController
        let birthdayPopupVC = BirthdayPopupViewController()
        
        // Define the onDateSelected closure
        birthdayPopupVC.onDateSelected = { [weak self] selectedDate in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium // Customize the date format as needed
            let formattedDate = dateFormatter.string(from: selectedDate)
            self?.birthdayTextField.text = formattedDate
        }
        
        // Present the birthday popup view controller as a modal
        birthdayPopupVC.modalPresentationStyle = .overFullScreen
        birthdayPopupVC.modalTransitionStyle = .crossDissolve
        present(birthdayPopupVC, animated: true, completion: nil)
    }

    func setupMiddleView() {
        // Add middleView below topView, spaced by 20 points
        middleView.translatesAutoresizingMaskIntoConstraints = false
        middleView.backgroundColor = .white // Set white background color
        middleView.layer.cornerRadius = 15 // Set border radius for middleView
        middleView.layer.masksToBounds = true // Ensure corners are clipped
        view.addSubview(middleView)
        
        NSLayoutConstraint.activate([
            middleView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
            middleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            middleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            middleView.heightAnchor.constraint(equalToConstant: 430) // Adjust as necessary
        ])
    }
    
    func setupTextFieldsWithLabels() {
        // Create and position the labels and text fields
        setupTextFieldWithLabel(textField: firstNameTextField, label: firstNameLabel, placeholder: TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PEDIATRICIAN.TEXT1.PLACEHOLDER",defaultText: "Enter first name"), labelText: TranslationsViewModel.shared.getTranslation(key: "DOCTOR_FORM.FIRST_NAME",defaultText: "First name"))
        setupTextFieldWithLabel(textField: lastNameTextField, label: lastNameLabel, placeholder: TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PEDIATRICIAN.TEXT2.PLACEHOLDER",defaultText: "Enter last name"), labelText: TranslationsViewModel.shared.getTranslation(key: "DOCTOR_FORM.LAST_NAME",defaultText: "Last name"))
        setupTextFieldWithLabel(textField: roleTextField, label: roleLabel, placeholder: TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.PLEASE_CHOOSE_ROLE", defaultText: "What is your role in the family?"), labelText: TranslationsViewModel.shared.getTranslation(key: "ROLE.EDIT-ROLE.TYPE",defaultText: "Role"))
        setupTextFieldWithLabel(textField: birthdayTextField, label: birthdayLabel, placeholder: TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.DOB.PLACEHOLDER",defaultText: "Enter date of birth"), labelText: TranslationsViewModel.shared.getTranslation(key: "PDF_EXPORT.DATE_OF_BIRTH", defaultText: "Date of birth"))
        
        // Disable input for role and birthday
        roleTextField.isUserInteractionEnabled = false
        birthdayTextField.isUserInteractionEnabled = false
        
        // Add text fields to middle view with top distance of 20 from previous text field
        middleView.addSubview(firstNameTextField)
        NSLayoutConstraint.activate([
            firstNameTextField.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 60),
            firstNameTextField.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            firstNameTextField.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -16),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        middleView.addSubview(lastNameTextField)
        NSLayoutConstraint.activate([
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 45),
            lastNameTextField.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            lastNameTextField.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -16),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        middleView.addSubview(roleTextField)
        NSLayoutConstraint.activate([
            roleTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 45),
            roleTextField.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            roleTextField.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -16),
            roleTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        middleView.addSubview(birthdayTextField)
        NSLayoutConstraint.activate([
            birthdayTextField.topAnchor.constraint(equalTo: roleTextField.bottomAnchor, constant: 45),
            birthdayTextField.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 16),
            birthdayTextField.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -16),
            birthdayTextField.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func setupTextFieldWithLabel(textField: UITextField, label: UILabel, placeholder: String, labelText: String) {
        // Set up the text field
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 15 // Set the border radius to match middleView
        
        // Set up the label
        label.text = labelText
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Add label and textField to the middleView
        middleView.addSubview(label)
        middleView.addSubview(textField)
        
        // Ensure constraints are added correctly
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 100),
            label.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -5),
            label.widthAnchor.constraint(equalToConstant: 100) // Set label width
        ])
    }
    
    func setupButtons() {
        // Role Button - Replace with triangle down symbol
        roleButton.setTitle("▼", for: .normal)
        roleButton.setTitleColor(.gray, for: .normal) // Set title color to gray
        roleButton.addTarget(self, action: #selector(roleButtonTapped), for: .touchUpInside)
        roleTextField.rightView = roleButton
        roleTextField.rightViewMode = .always
        
        // Birthday Button - Replace with triangle down symbol
        birthdayButton.setTitle("▼", for: .normal)
        birthdayButton.setTitleColor(.lightGray, for: .normal) // Set title color to gray
        birthdayButton.addTarget(self, action: #selector(birthdayButtonTapped), for: .touchUpInside)
        birthdayTextField.rightView = birthdayButton
        birthdayTextField.rightViewMode = .always
    }
    
    // Change border color and radius on focus
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8 // Match border radius on focus
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 0
        textField.layer.cornerRadius = 8 // Keep border radius after editing
    }
    
    // Actions for role and birthday buttons
    @objc func roleButtonTapped() {
        print("Role button tapped")
        // Future popup implementation here
    }
    
    @objc func birthdayButtonTapped() {
        showBirthdayPopup() // Present the birthday pop-up
    }

    class BirthdayPopupViewController: UIViewController {
        
        // Declare the container view, date picker, and buttons
        let containerView = UIView()
        let datePicker = UIDatePicker()
        let cancelButton = UIButton()
        let okButton = UIButton()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Add a dim background
            setupUI()
        }
        
        private func setupUI() {
            // Configure the container view
            containerView.backgroundColor = UIColor.white
            containerView.layer.cornerRadius = 10
            containerView.layer.masksToBounds = true
            containerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(containerView)
            
            // Configure Date Picker
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(datePicker)
            
            // Configure Cancel Button
            cancelButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CANCEL" ,defaultText: "Cancel"), for: .normal)
            cancelButton.setTitleColor(.systemBlue, for: .normal)
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            containerView.addSubview(cancelButton)
            
            // Configure OK Button
            okButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.OK", defaultText: "Okay"), for: .normal)
            okButton.setTitleColor(.gray, for: .normal)
            okButton.translatesAutoresizingMaskIntoConstraints = false
            okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
            containerView.addSubview(okButton)
            
            setupConstraints()
        }
        
        // Setup constraints for the UI elements
        func setupConstraints() {
            NSLayoutConstraint.activate([
                // Container View constraints
                containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                containerView.heightAnchor.constraint(equalToConstant: 370),
                
                // DatePicker constraints inside container view
                datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                datePicker.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
                
                // Cancel Button constraints inside container view
                cancelButton.trailingAnchor.constraint(equalTo: okButton.leadingAnchor, constant: -10),
                cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
                cancelButton.widthAnchor.constraint(equalToConstant: 80),
                
                // OK Button constraints inside container view
                okButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                okButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
                okButton.widthAnchor.constraint(equalToConstant: 50)
            ])
        }

        @objc func cancelButtonTapped() {
            dismiss(animated: true, completion: nil)
        }
        
        @objc func okButtonTapped() {
            let selectedDate = datePicker.date
            // Assuming `onDateSelected` closure exists
            onDateSelected?(selectedDate)
            dismiss(animated: true, completion: nil)
        }
        
        var onDateSelected: ((Date) -> Void)?
    }

    class FilRoleSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
        // Struct to hold translated value and its corresponding English value
        struct RoleOption {
            let translatedValue: String
            let englishValue: String
        }
        
        // Array of roles with both translated and English values
        let roles: [RoleOption] = [
            RoleOption(translatedValue: TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.MOTHER", defaultText: "Mom"), englishValue: "Mom"),
            RoleOption(translatedValue: TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.FATHER", defaultText: "Dad"), englishValue: "Dad"),
            RoleOption(translatedValue: TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.GRANDPA", defaultText: "Grandpa"), englishValue: "Grandpa"),
            RoleOption(translatedValue: TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.GRANDMA", defaultText: "Grandma"), englishValue: "Grandma"),
            RoleOption(translatedValue: TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.OTHER", defaultText: "Other"), englishValue: "Other"),
            RoleOption(translatedValue: TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.NO_ANSWER", defaultText: "Not specified"), englishValue: "Not specified")
        ]
        
        // Variables to hold the selected role's translated and English values
        var selectedRoleTranslated: String? // Translated value of the selected role
        var selectedRoleEnglish: String? // English value of the selected role
        
        var onRoleSelected: ((String, String) -> Void)? // Closure to pass selected role back (both translated and English values)
        
        let tableView = UITableView() // The table view
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            modalPresentationStyle = .overCurrentContext
            setupHeaderView()
            setupTableView()
            
            // Add tap gesture to dismiss when clicking outside of the table view
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        }
        
        // MARK: - Setup Header View
        var headerView: UIView!
        
        func setupHeaderView() {
            headerView = UIView()
            headerView.backgroundColor = .white
            
            headerView.layer.cornerRadius = 20
            headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            view.addSubview(headerView)
            headerView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 90)
            ])
            
            // Top bar and title
            let topBar = UIView()
            topBar.backgroundColor = .lightGray
            topBar.layer.cornerRadius = 2.5
            headerView.addSubview(topBar)
            topBar.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                topBar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
                topBar.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                topBar.widthAnchor.constraint(equalToConstant: 40),
                topBar.heightAnchor.constraint(equalToConstant: 5)
            ])
            
            let titleLabel = UILabel()
            titleLabel.text = TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.PLEASE_CHOOSE_ROLE", defaultText: "What is your role in the family?")
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.textColor = .black
            headerView.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 40),
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20)
            ])
            
            let closeButton = UIButton(type: .system)
            closeButton.setTitle("X", for: .normal)
            closeButton.setTitleColor(.gray, for: .normal)
            closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
            headerView.addSubview(closeButton)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10)
            ])
        }
        
        // MARK: - Setup Table View
        func setupTableView() {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.separatorStyle = .singleLine
            tableView.layer.cornerRadius = 0
            tableView.isScrollEnabled = false
            
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.heightAnchor.constraint(equalToConstant: 280)
            ])
        }
        
        // MARK: - TableView DataSource and Delegate
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return roles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let role = roles[indexPath.row]
            cell.textLabel?.text = role.translatedValue
            
            cell.accessoryView = nil
            let checkBoxImageView = UIImageView()
            let isChecked = role.translatedValue == selectedRoleTranslated
            checkBoxImageView.image = UIImage(named: isChecked ? "check__1_" : "check")
            checkBoxImageView.contentMode = .scaleAspectFit
            checkBoxImageView.isUserInteractionEnabled = true
            checkBoxImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped(_:)))
            checkBoxImageView.addGestureRecognizer(tapGesture)
            checkBoxImageView.tag = indexPath.row
            
            cell.accessoryView = checkBoxImageView
            return cell
        }
        
        @objc func checkBoxTapped(_ sender: UITapGestureRecognizer) {
            guard let imageView = sender.view as? UIImageView else { return }
            let selectedRoleOption = roles[imageView.tag]
            
            if selectedRoleTranslated == selectedRoleOption.translatedValue {
                selectedRoleTranslated = nil
                selectedRoleEnglish = nil
            } else {
                selectedRoleTranslated = selectedRoleOption.translatedValue
                selectedRoleEnglish = selectedRoleOption.englishValue
            }
            
            onRoleSelected?(selectedRoleTranslated ?? "", selectedRoleEnglish ?? "")
            tableView.reloadData()
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedRoleOption = roles[indexPath.row]
            
            if selectedRoleTranslated == selectedRoleOption.translatedValue {
                selectedRoleTranslated = nil
                selectedRoleEnglish = nil
            } else {
                selectedRoleTranslated = selectedRoleOption.translatedValue
                selectedRoleEnglish = selectedRoleOption.englishValue
            }
            
            onRoleSelected?(selectedRoleTranslated ?? "", selectedRoleEnglish ?? "")
            tableView.reloadData()
        }
        
        // MARK: - Dismiss Popup
        @objc func dismissViewController() {
            dismiss(animated: true, completion: nil)
        }
    }
}
