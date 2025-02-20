//
//  loginEmailViewController.swift
//  FeverApp ios
//
//  Created by user on 8/4/24.
//

import UIKit

class LoginEmailViewController: UIViewController, UITextFieldDelegate {

    let passwordTextField = UITextField()
    let emailTextField = UITextField()
    let eyeButton = UIButton(type: .custom)
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var loginButton: UIButton! // Outlet pour le bouton "Login"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        myView.layer.cornerRadius = 25
        myView.layer.masksToBounds = true
        
        secondView.layer.cornerRadius = 25
        secondView.layer.masksToBounds = true
        
        let attributedTitle = NSAttributedString(
            string: "Login",
            attributes: [
                .foregroundColor: UIColor.white, // Définit la couleur du texte en blanc
                .font: UIFont.systemFont(ofSize: 17) // Définit la police et la taille du texte
            ]
        )

        loginButton.setAttributedTitle(attributedTitle, for: .normal)
        // Create container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10.0
        view.addSubview(containerView)
        
        // Set up container view constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 120 : 90),
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? 32 : 16),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIDevice.current.userInterfaceIdiom == .pad ? -32 : -16),
                containerView.heightAnchor.constraint(equalToConstant: UIDevice.current.userInterfaceIdiom == .pad ? 200 : 210)
        ])
        
        // Create email label
        let emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.text = "E-mail address"
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.textColor = .black
        containerView.addSubview(emailLabel)
        
        // Create email text field
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Login with e-mail"
        emailTextField.backgroundColor = .white
        emailTextField.layer.cornerRadius = 5
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.delegate = self
        containerView.addSubview(emailTextField)
        
        // Add icon to email text field
        let emailIcon = UIImage(named: "emailImage")
        let emailImageView = UIImageView(image: emailIcon)
        emailImageView.contentMode = .scaleAspectFit
        emailImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let emailLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: emailTextField.frame.height))
        emailLeftView.addSubview(emailImageView)
        emailImageView.center = emailLeftView.center
        emailTextField.leftView = emailLeftView
        emailTextField.leftViewMode = .always
        
        // Set constraints for email label and text field
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Create password label
        let passwordLabel = UILabel()
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont.systemFont(ofSize: 14)
        passwordLabel.textColor = .black
        containerView.addSubview(passwordLabel)
        
        // Create password text field
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Enter password"
        passwordTextField.backgroundColor = .white
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.isSecureTextEntry = true // Initially mask the password
        passwordTextField.delegate = self
        containerView.addSubview(passwordTextField)
        
        // Add icon to password text field
        let passwordIcon = UIImage(named: "lockImage")
        let passwordImageView = UIImageView(image: passwordIcon)
        passwordImageView.contentMode = .scaleAspectFit
        passwordImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let passwordLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: passwordTextField.frame.height))
        passwordLeftView.addSubview(passwordImageView)
        passwordImageView.center = passwordLeftView.center
        passwordTextField.leftView = passwordLeftView
        passwordTextField.leftViewMode = .always
        
        // Add eye icon to toggle password visibility
        let eyeIcon = UIImage(named: "eyeImage")
        let eyeImageView = UIImageView(image: eyeIcon?.withRenderingMode(.alwaysTemplate))
        eyeImageView.tintColor = .gray // Initial color
        eyeImageView.contentMode = .scaleAspectFit
        eyeImageView.frame = CGRect(x: 0, y: 0, width: 45, height: 25) // Adjust size here
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 25)) // Vue de padding
        eyeButton.addSubview(paddingView)

        eyeButton.addSubview(eyeImageView)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 10, height: 30) // Adjust size here

        // Center the eyeImageView vertically in the eyeButton
        eyeImageView.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.addSubview(eyeImageView)
        NSLayoutConstraint.activate([
            eyeImageView.centerXAnchor.constraint(equalTo: eyeButton.centerXAnchor),
            eyeImageView.leadingAnchor.constraint(equalTo: paddingView.trailingAnchor),
            eyeImageView.topAnchor.constraint(equalTo: eyeButton.bottomAnchor, constant: -30),
            eyeImageView.widthAnchor.constraint(equalToConstant: 25),
            eyeImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        
        // Set constraints for password label and text field
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            passwordLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            passwordLabel.heightAnchor.constraint(equalToConstant: 20),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 4),
            passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Ajouter des observateurs pour les changements dans les champs de texte
        emailTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        
        // Configuration initiale du bouton Login
        configureLoginButton()
    }
    
    func configureLoginButton() {
        loginButton.backgroundColor = UIColor(red:243/255, green: 243/255, blue: 243/255, alpha: 1)
        
        // Définir la couleur du texte du bouton en blanc
            loginButton.setTitleColor(.white, for: .normal)
            
            // Définir la couleur du texte pour les autres états si nécessaire
            loginButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .disabled)
        
        loginButton.isEnabled = false
    }

    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        eyeButton.subviews.forEach { $0.tintColor = passwordTextField.isSecureTextEntry ? UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1)
  : UIColor(red:161/255, green: 194/255, blue: 252/255, alpha: 1) }
    }
    
    @objc func textFieldsDidChange(_ textField: UITextField) {
            let emailText = emailTextField.text ?? ""
            let passwordText = passwordTextField.text ?? ""
            
            if !emailText.isEmpty && !passwordText.isEmpty {
                loginButton.backgroundColor = UIColor(red:161/255, green: 194/255, blue: 252/255, alpha: 1)
                loginButton.setTitleColor(.white, for: .normal)
                // Change color to blue when both text fields are filled
            } else {
                loginButton.backgroundColor = UIColor(red:243/255, green: 243/255, blue: 243/255, alpha: 1)
                
                loginButton.setTitleColor(.white, for: .normal)
 // Change color to gray otherwise
            }
        }

    
    
    
    
    // UITextFieldDelegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
    }
}


