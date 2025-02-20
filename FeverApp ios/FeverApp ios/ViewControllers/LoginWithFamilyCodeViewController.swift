//
//  LoginWithFamilyCodeViewController.swift
//  FeverApp ios
//
//  Created by NEW on 02/08/2024.
//

import UIKit
import CoreData
extension String {
    func matchesRege(_ regex: String) -> Bool {
        let range = self.range(of: regex, options: .regularExpression)
        return range != nil
    }
}
class LoginWithFamilyCodeViewController: UIViewController, UITextFieldDelegate {
    func handleNavigationToChooseFamilyRoleScreen(){
        
//        let profiles = fetchAllLocalProfiles() ?? []
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chooseFamilyRoleVC = storyboard.instantiateViewController(withIdentifier: "FamilyRole") as? ChooseFamilyRoleViewController {
            self.navigationController?.pushViewController(chooseFamilyRoleVC , animated: true)
        }
    }
    
    
    func handleNavigationToOverview() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let overviewVC = storyboard.instantiateViewController(withIdentifier: "overview") as? overviewViewController {
            overviewVC.modalPresentationStyle = .fullScreen
            self.present(overviewVC, animated: true, completion: nil)
        }
    }
    
    func updateLoginUIButtonIsEnabledPropertyToTrue(){
        loginButton.isEnabled = true
    }
    var usersFamilyCode =  ""
    func getUsersFamilyCode() {
        usersFamilyCode =  ""
        for box in boxes {
            usersFamilyCode += box.text!
        }

    }
    
    @IBOutlet weak var invalidFamilyCodeUILabel: UILabel!
    
    
    @IBAction func handleLoginUIButtonClick(_ sender: Any) {
        getUsersFamilyCode()
        if LoginWithFamilyCodeModel.shared.validateFamilyCode(usersFamilyCode){
            invalidFamilyCodeUILabel.isHidden = true
            LoginWithFamilyCodeModel.shared.giveUsersFamilyCodeToLoginWithFamilyCodeModel( usersFamilyCode){
                isRegisteredSuccessfully, hasProfiles in
                if isRegisteredSuccessfully ?? false{
                    self.invalidFamilyCodeUILabel.isHidden = true
//                    self.handleNavigationToChooseFamilyRoleScreen()
                    // Navigate based on the hasProfiles value
                    if hasProfiles {
                        // If hasProfiles is true, navigate to Overview
                        self.saveFirstProfileToCoreData()
                            let profileName = (UIApplication.shared.delegate as! AppDelegate).fetchProfileName()
                            print("Profile Name: \(profileName)")
                            self.handleNavigationToOverview()
                        
                    } else {
                        // If hasProfiles is false, navigate to ChooseFamilyRoleScreen
                        self.handleNavigationToChooseFamilyRoleScreen()
                    }
                }else{
                    // Show alert popup
                           let alertController = UIAlertController(title: "Failed to login", message: "An error occured please enter a family code that exist", preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "retry", style: .default)
                           alertController.addAction(retryAction)
                    self.present(alertController, animated: true)
                }
               
            }
        }else{
            invalidFamilyCodeUILabel.isHidden = false
        }
        
    }
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet weak var codeView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var boxes: [UITextField]! // Connect your text fields to this outlet
    @IBOutlet weak var loginText: UILabel!
    
    override func viewDidLoad() {
        loginText.text = TranslationsViewModel.shared.getAdditionalTranslation( key: "LOGIN.FAMILY.CODE.TEXT", defaultText: "Please enter your 8 digits family code received from your doctor")
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
        invalidFamilyCodeUILabel.isHidden = true
        loginButton.isEnabled = false
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        loginButton.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
        loginButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "LOGIN.TITLE", defaultText: "login"), for: .normal)
        loginButton.layer.cornerRadius = 8
        boxes.forEach { $0.textAlignment = .center }
        boxes.forEach { $0.layer.cornerRadius = 8 }
        codeView.layer.cornerRadius = 15
        codeView.layer.shadowColor = UIColor.lightGray.cgColor
        codeView.layer.shadowOpacity = 0.3
        codeView.layer.shadowRadius = 5
        codeView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topView.layer.cornerRadius = 30
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        bottomView.layer.cornerRadius = 30
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.3
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Set delegate for each text field
        boxes.forEach { $0.delegate = self }

      

        // Add target to text fields for .editingChanged event
        boxes.forEach { $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            setupDoneButton(for: $0) // Add "Done" button to keyboard
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard for all text fields in the boxes array
        boxes.forEach { $0.resignFirstResponder() }

        // Return true to indicate the text field should process the return key press
        return true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View did appear") // Debugging statement
       boxes[0].becomeFirstResponder()
    }
    
    func setupDoneButton(for textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done"),
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }


    var digitCount = 0
    @objc func textFieldDidChange() {
    }
    func resizeImage(image: UIImage, to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    @objc func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    // Example of a validation method (you can customize this as needed)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if string.isEmpty{
            if string == "" && textField.text == "" {
                    // Move to previous text field and delete its last character
                    if let currentIndex = boxes.firstIndex(of: textField), currentIndex > 0 {
                        let previousTextField = boxes[currentIndex - 1]
                        previousTextField.text = ""
                    }
                return true
                }
            else{
                textField.text = ""
                digitCount -= 1
                if digitCount == 8 {
                    UIView.transition(with: loginButton, duration: 0.5, options: .transitionCrossDissolve) {
                        self.loginButton.backgroundColor = UIColor(red: 0.65, green: 0.76, blue: 0.97, alpha: 1.0)
                    }
                    self.loginButton.isEnabled = true
                } else {
                    UIView.transition(with: loginButton, duration: 0.5, options: .transitionCrossDissolve) { self.loginButton.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
                    }
                }
                if let currentIndex = boxes.firstIndex(of: textField), currentIndex > 0 {
                    boxes[currentIndex - 1].becomeFirstResponder()
                }
            }
            
        }else{
            // Get the current text in the text field
            let currentText = textField.text ?? ""
            digitCount += 1
            // Check if the text field is empty
            if currentText.isEmpty {
                // Fill the text field with the typed digit
                textField.text = string
                // Move to the next text field
                if let currentIndex = boxes.firstIndex(of: textField), currentIndex < boxes.count - 1 {
                    boxes[currentIndex + 1].becomeFirstResponder()
                }
            }
            if digitCount == 8 {
                UIView.transition(with: loginButton, duration: 0.5, options: .transitionCrossDissolve) {
                    self.loginButton.backgroundColor = UIColor(red: 0.65, green: 0.76, blue: 0.97, alpha: 1.0)
                    self.boxes[5].resignFirstResponder()
                }
                updateLoginUIButtonIsEnabledPropertyToTrue()
            } else {
                UIView.transition(with: loginButton, duration: 0.5, options: .transitionCrossDissolve) { self.loginButton.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
                }
            }
        }
        return false
    }
    
    func saveFirstProfileToCoreData() {
        // Get the managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate is nil")
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        // Create a fetch request for the Profile entity
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()

        do {
            // Fetch all profiles
            let profiles = try managedContext.fetch(fetchRequest)
            print("Profiles count: \(profiles.count)")

            // Ensure there is at least one profile
            if profiles.count > 1 {
                let secondProfile = profiles[1]
                print("Second profile found")
                // Check if the second profile has a valid name and date of birth
                if let profileName = secondProfile.profileName, !profileName.isEmpty,
                   let profileDob = secondProfile.profileDateOfBirth?.description {

                    // Save the profile details to Core Data
                    appDelegate.saveProfileName(profileName: profileName)
                    appDelegate.saveProfileDateOfBirth(profileDateOfBirth: profileDob)
                    appDelegate.saveProfileId(profileId: secondProfile.profileId)
                    appDelegate.saveProfileOnlineId(profileOnlineId: secondProfile.onlineProfileId)
                    appDelegate.saveProfileGender(profileGender: secondProfile.profileGender ?? "")

                    // Commit the changes to Core Data
                    do {
                        try managedContext.save() // Save the context to commit changes
                        print("Profile saved successfully.")
                        self.handleNavigationToOverview() // This should be called now
                    } catch let error as NSError {
                        print("Error saving Core Data context: \(error.localizedDescription), \(error.userInfo)")
                    }
                } else {
                    print("Profile data is incomplete.")
                }
            } else {
                print("Less than two profiles found.")
            }
        } catch let error as NSError {
            print("Error fetching profiles: \(error.localizedDescription), \(error.userInfo)")
        }
    }
}


