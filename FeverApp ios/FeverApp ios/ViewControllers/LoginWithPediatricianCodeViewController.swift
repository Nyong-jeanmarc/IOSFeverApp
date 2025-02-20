//
//  LoginWithPediatricianCodeViewController.swift
//  FeverApp ios
//
//  Created by NEW on 02/08/2024.
//

import UIKit

import UIKit
extension String {
    func matchesRegex(_ regex: String) -> Bool {
        let range = self.range(of: regex, options: .regularExpression)
        return range != nil
    }
}
class LoginWithPediatricianCodeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var invalidPediatricianCodeUILabel: UILabel!
    
    @IBOutlet var topView: UIView!
    
    func updateLoginUIButtonIsEnabledPropertyToTrue(){
        loginButton.isEnabled = true
    }
    func  handleNavigationToCopyFamilyCodeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let CopyFamilyCodeVC = storyboard.instantiateViewController(withIdentifier: "CopyFamilyCode") as? loginWithFamilyCode {
            self.navigationController?.pushViewController(CopyFamilyCodeVC , animated: true)
        }
    }
    @IBOutlet weak var loginText: UILabel!
    
    var usersPediatricianCode = ""
    func getUsersPediatricianCode() -> String {
        usersPediatricianCode =  ""
        for box in boxes {
            usersPediatricianCode += box.text!
        }
     return usersPediatricianCode
    }
    // Example of a validation method (you can customize this as needed)
    private func validatePediatricianCode(code: String)  -> Bool {
        if code == "0000"{
            print("Valid family code")
         return true
        }else {
               print("Invalid family code")
               return false
           }
       }
    @IBAction func handleLoginUIButtonClick(_ sender: Any) {
        getUsersPediatricianCode()
        if validatePediatricianCode(code: usersPediatricianCode){
            LoginWithPediatricianCodeModel.shared.giveUsersPediatricianCodeToLoginWithPediatricianCodeModel(usersPediatricianCode){ isRegisteredSuccesfully in
              if isRegisteredSuccesfully! {
                  self.handleNavigationToCopyFamilyCodeScreen()
                  self.invalidPediatricianCodeUILabel.isHidden = true
                   
              }else{
                  // Show alert popup
                         let alertController = UIAlertController(title: "Failed to login", message: "An error occured please check your internet connection and try again", preferredStyle: .alert)
                  let retryAction = UIAlertAction(title: "retry", style: .default)
                         alertController.addAction(retryAction)
                  self.present(alertController, animated: true)
              }
            }
        }else{
            invalidPediatricianCodeUILabel.isHidden = false
        }
     
           
    }
    
    @IBOutlet weak var codeView: UIView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet var boxes: [UITextField]! // Connect your text fields to this outlet

    override func viewDidLoad() {
        super.viewDidLoad()
        loginText.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "LOGIN.PEDIATRIC.CODE.TEXT", defaultText: "Your pediatrician code or number you received from your doctor")
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 18, height: 18))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = .gray
        // Create a custom UILabel for the title
            let titleLabel = UILabel()
        titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "LOGIN.PEDIATRIC.CODE.TITLE", defaultText: "Login with pediatric code")
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            titleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
        bottomView.layer.cornerRadius = 25
        topView.layer.cornerRadius = 30
        codeView.layer.shadowColor = UIColor.lightGray.cgColor
        codeView.layer.shadowOpacity = 0.5
        codeView.layer.shadowRadius = 5
        codeView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        loginButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "LOGIN.TITLE", defaultText: "login"), for: .normal)
        loginButton.isEnabled = false
        invalidPediatricianCodeUILabel.isHidden = true
        loginButton.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
        loginButton.layer.cornerRadius = 8
        boxes.forEach { $0.textAlignment = .center }
        boxes.forEach { $0.layer.cornerRadius = 9 }
        codeView.layer.cornerRadius = 15
        // Set delegate for each text field
        boxes.forEach { $0.delegate = self }

        // Set keyboard type to number pad for each text field
        boxes.forEach { $0.keyboardType = .numberPad }
        // Add target to text fields for .editingChanged event
        boxes.forEach { $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            setupDoneButton(for: $0)
        }
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
    @objc func textFieldDidChange(_ textField: UITextField) {
 
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        usersPediatricianCode = getUsersPediatricianCode() + string
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
                if digitCount == 4 {
                    UIView.transition(with: loginButton, duration: 0.5, options: .transitionCrossDissolve) {
                        self.loginButton.backgroundColor = UIColor(red: 0.65, green: 0.76, blue: 0.97, alpha: 1.0)
                    }
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
            if digitCount == 4 && validatePediatricianCode(code: usersPediatricianCode) {
                UIView.transition(with: loginButton, duration: 0.5, options: .transitionCrossDissolve) {
                    self.loginButton.backgroundColor = UIColor(red: 0.65, green: 0.76, blue: 0.97, alpha: 1.0)
                }
                updateLoginUIButtonIsEnabledPropertyToTrue()
                self.boxes[3].resignFirstResponder()
            } else {
                UIView.transition(with: loginButton, duration: 0.5, options: .transitionCrossDissolve) { self.loginButton.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
                }
            }
        }
        return false
    }
}

