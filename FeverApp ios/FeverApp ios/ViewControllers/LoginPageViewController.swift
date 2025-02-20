//
//  loginPage.swift
//  FeverApp ios
//
//  Created by user on 8/2/24.
//

import UIKit
import CoreData

class LoginPageViewController: UIViewController {
    @IBOutlet weak var loginPediatricianCodeLabel: UIButton!
    
    @IBOutlet weak var loginFamilyCodeLabel: UIButton!
    
    @IBOutlet weak var loginWithoutCodeLabel: UIButton!
    
    
    @IBOutlet weak var loginWithoutCodeIcon: UIButton!
    
    func handleNavigationToLoginWithPediatricianCodeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let PediatritianCodeVC = storyboard.instantiateViewController(withIdentifier: "PediatricianCode") as? LoginWithPediatricianCodeViewController {
            self.navigationController?.pushViewController(PediatritianCodeVC , animated: true)
        }
    }
    @IBOutlet var loginButtons: [UIButton]!
    
    @IBOutlet var topView: UIButton!
    @IBAction func handleContinueWithPediatricianCodeUIButtonClick(_ sender: Any) {
        handleNavigationToLoginWithPediatricianCodeScreen()
    }
    func handleNavigationToLoginWithFamilyCodeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let FamilyCodeVC = storyboard.instantiateViewController(withIdentifier: "FamilyCode") as? LoginWithFamilyCodeViewController {
            self.navigationController?.pushViewController(FamilyCodeVC, animated: true)
        }
    }
    @IBAction func handleLoginWithFamilyCodeUIButtonClick(_ sender: Any) {
        handleNavigationToLoginWithFamilyCodeScreen()
    }
    func  handleNavigationToCopyFamilyCodeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let CopyFamilyCodeVC = storyboard.instantiateViewController(withIdentifier: "CopyFamilyCode") as? loginWithFamilyCode {
            self.navigationController?.pushViewController(CopyFamilyCodeVC , animated: true)
        }
    }
    
    @IBOutlet var backButton: UIButton!
    
    @IBAction func handleContinueWithoutCodeUIButtonClick(_ sender: Any) {
//        LoginWithPediatricianCodeModel.shared.giveUsersPediatricianCodeToLoginWithPediatricianCodeModel("9999"){
//            isSavedSuccessfully in
//            if isSavedSuccessfully ?? false{
//                self.handleNavigationToCopyFamilyCodeScreen()
//            }else{
//                // Show alert popup
//                       let alertController = UIAlertController(title: "Server error", message: "Failed to login please try again", preferredStyle: .alert)
//                let retryAction = UIAlertAction(title: "retry", style: .default)
//                       alertController.addAction(retryAction)
//                self.present(alertController, animated: true)
//            }
//        }
        // Create and configure the spinner
        // Hide the button
            loginWithoutCodeIcon.isHidden = true

            // Create and configure the spinner
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = .gray
            spinner.translatesAutoresizingMaskIntoConstraints = false

            // Add the spinner to the button's superview
            loginWithoutCodeIcon.superview?.addSubview(spinner)

            // Center the spinner in the button's superview
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: loginWithoutCodeIcon.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: loginWithoutCodeIcon.centerYAnchor)
            ])

            // Start the spinner animation
            spinner.startAnimating()

            // Send the request
            LoginWithPediatricianCodeModel.shared.giveUsersPediatricianCodeToLoginWithPediatricianCodeModel("9999") { isSavedSuccessfully in
                DispatchQueue.main.async {
                    // Stop and remove the spinner
                    spinner.stopAnimating()
                    spinner.removeFromSuperview()

                    // Show the button again
                    self.loginWithoutCodeIcon.isHidden = false

                    if isSavedSuccessfully ?? false {
                        self.handleNavigationToCopyFamilyCodeScreen()
                    } else {
                        // Show alert popup
                        let alertController = UIAlertController(title: "Server error", message: "Failed to login please try again", preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Retry", style: .default)
                        alertController.addAction(retryAction)
                        self.present(alertController, animated: true)
                    }
                }
            }
    }
    func addShadowToLoginButtons(){
        for button in loginButtons{
            button.layer.shadowColor = UIColor.lightGray.cgColor
            button.layer.shadowOpacity = 0.5
            button.layer.shadowRadius = 5
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    func configureButton(
        button: UIButton,
        icon: UIImage?,
        text: String,
        fontSize: CGFloat
    ) {
        // Clear existing subviews (if any)
        button.subviews.forEach { $0.removeFromSuperview() }
        
        // Disable button's default title rendering
        button.setTitle(nil, for: .normal)
        
        // Create an image view for the icon
        let iconImageView = UIImageView(image: icon)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(iconImageView)
        
        // Create a label for the text
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.font = UIFont.systemFont(ofSize: fontSize)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(titleLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Constraints for the icon
            iconImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24), // Adjust width as needed
            iconImageView.heightAnchor.constraint(equalToConstant: 24), // Adjust height as needed

            // Constraints for the label
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
        ])
        
        // Style the button

        button.backgroundColor = .white
        button.contentHorizontalAlignment = .fill
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 5
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
//        loginPediatricianCodeLabel.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "LOGIN.PEDIATRIC.CODE.TITLE", defaultText: "Login with pediatric code"), for:  .normal)
//        loginFamilyCodeLabel.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "LOGIN.FAMILY.CODE.TITLE", defaultText: "Login with family code"), for:  .normal)
//        loginWithoutCodeLabel.setTitle(TranslationsViewModel.shared.getTranslation(key: "LOGIN.CODE.SKIP", defaultText: "Continue without code"), for:  .normal)

        configureButton(
            button: loginPediatricianCodeLabel,
            icon: UIImage(systemName: ""),
            text: TranslationsViewModel.shared.getAdditionalTranslation(
                key: "LOGIN.PEDIATRIC.CODE.TITLE",
                defaultText: "Login with pediatric code"
            ),
            fontSize: 16
        )
        
        configureButton(
            button: loginFamilyCodeLabel,
            icon: UIImage(systemName: ""),
            text: TranslationsViewModel.shared.getAdditionalTranslation(
                key: "LOGIN.FAMILY.CODE.TITLE",
                defaultText: "Login with family code"
            ),
            fontSize: 16
        )
        
        configureButton(
            button: loginWithoutCodeLabel,
            icon: UIImage(systemName: ""),
            text: TranslationsViewModel.shared.getTranslation(
                key: "LOGIN.CODE.SKIP",
                defaultText: "Continue without code"
            ),
            fontSize: 16
        )
        addShadowToLoginButtons()
        topView.layer.cornerRadius = 20
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.4
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 18, height: 18))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = UIColor(hex: "B9BCC8")
        // Create a custom UILabel for the title
            let navtitleLabel = UILabel()
        navtitleLabel.text = TranslationsViewModel.shared.getTranslation(key: "LOGIN.TITLE", defaultText: "Login")
            navtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            navtitleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: navtitleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
             
              
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
       }
        
        
 
