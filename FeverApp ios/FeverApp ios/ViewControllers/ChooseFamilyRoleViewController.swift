//
//  ChooseFamilyRoleViewController.swift
//  FeverApp ios
//
//  Created by NEW on 05/08/2024.
//

import UIKit

class ChooseFamilyRoleViewController: UIViewController {
    @IBOutlet var FamilyRoleUIButtons: [UIButton]!
    @IBOutlet weak var chatView: UIView!
    var usersFamilyRole = ""
    
    @IBOutlet var topView: UIView!
    @IBOutlet weak var momButton: UIButton!
    @IBOutlet weak var dadButton: UIButton!
    @IBOutlet weak var grandmaButton: UIButton!
    @IBOutlet weak var grandpaButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var notspecifiedButton: UIButton!
    
    @IBOutlet weak var roletextLabel: UILabel!
    
    let familyRoleTranslations: [String: String] = [
        "MOM": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.MOTHER", defaultText: "MOM"),
        "DAD": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.FATHER", defaultText: "DAD"),
        "GRANDPA": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.GRANDPA", defaultText: "GRANDPA"),
        "GRANDMA": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.GRANDMA", defaultText: "GRANDMA"),
        "OTHER": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.OTHER", defaultText: "OTHER"),
        "NOT_SPECIFIED": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.NO_ANSWER", defaultText: "NOT_SPECIFIED")
    ]

    
    
//    func getUserFamilyRole(_ sender: UIButton) {
//            // Get the title of the clicked button
//        guard let title = sender.titleLabel?.text else { return }
//            
//            // Save the title in the variable
//        usersFamilyRole = (title).localizedUppercase
//        print("Selected Family Role: \(usersFamilyRole)")
//        }
    func getUserFamilyRole(_ sender: UIButton) {
        // Get the title of the clicked button
        guard let translatedTitle = sender.titleLabel?.text else { return }

        // Find the English value for the translated title
        if let englishValue = familyRoleTranslations.first(where: { $0.value == translatedTitle })?.key {
            usersFamilyRole = englishValue.localizedUppercase // Use the English value
            print("Selected Family Role: \(usersFamilyRole)")
        } else {
            print("Error: Could not find the English value for the translated title.")
        }
    }

    func  handleNavigationToAddProfileNameScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let AddProfileNameVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? AddProfileNameViewController {
            self.navigationController?.pushViewController(AddProfileNameVC, animated: true)
        }
    }
    func giveUserFamilyRoleToChooseFamilyRoleModel(){
        chooseFamilyRoleModel.shared.saveUsersFamilyRole(usersFamilyRole){
            isSavedSuccessfully in
            if isSavedSuccessfully!{
                self.handleNavigationToAddProfileNameScreen()
            }else{
                // Show alert popup
                       let alertController = UIAlertController(title: "Failed to save family role", message: "An error occured please try again", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "retry", style: .default)
                       alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set button titles with translations
        momButton.setTitle(familyRoleTranslations["MOM"], for: .normal)
        dadButton.setTitle(familyRoleTranslations["DAD"], for: .normal)
        grandmaButton.setTitle(familyRoleTranslations["GRANDMA"], for: .normal)
        grandpaButton.setTitle(familyRoleTranslations["GRANDPA"], for: .normal)
        otherButton.setTitle(familyRoleTranslations["OTHER"], for: .normal)
        notspecifiedButton.setTitle(familyRoleTranslations["NOT_SPECIFIED"], for: .normal)
        roletextLabel.text = TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.PLEASE_CHOOSE_ROLE", defaultText: "What is your role in the family?")
        topView.layer.cornerRadius = 20
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttoncolorsetupUI()
        chatView.layer.cornerRadius = 8
        chatView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        FamilyRoleUIButtons.forEach { $0.layer.shadowColor = UIColor.lightGray.cgColor }
        FamilyRoleUIButtons.forEach { $0.layer.shadowOpacity = 0.4 }
        FamilyRoleUIButtons.forEach { $0.layer.shadowOffset = CGSize(width: 4, height: 4) }
        FamilyRoleUIButtons.forEach { $0.layer.shadowRadius = 5 }
        FamilyRoleUIButtons.forEach { $0.layer.masksToBounds = false}
        FamilyRoleUIButtons.forEach { $0.addTarget(self, action: #selector(handleFamilyRoleUIButtonClick(_:)), for: .touchUpInside)}
        
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 18, height: 18))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = UIColor(hex: "B9BCC8")
        // Create a custom UILabel for the title
            let navtitleLabel = UILabel()
        navtitleLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.PROFILE-SURVEY.TEXT.3", defaultText:"Add Profile")
            navtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            navtitleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: navtitleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
        
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
    
@objc   func handleFamilyRoleUIButtonClick(_ sender: UIButton){
    getUserFamilyRole(sender)
    print(usersFamilyRole)
    giveUserFamilyRoleToChooseFamilyRoleModel()
    }
    
    func buttoncolorsetupUI(){
        
        
        // Shadow
        chatView.layer.shadowColor = UIColor.lightGray.cgColor
        chatView.layer.shadowOpacity = 0.2
        chatView.layer.shadowRadius = 5
        chatView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chatView.layer.masksToBounds = false
        
        
        
        styleButton(momButton)
                styleButton(dadButton)
                styleButton(grandmaButton)
                styleButton(grandpaButton)
                styleButton(otherButton)
                styleButton(notspecifiedButton)
        
        momButton.addTarget(self, action: #selector(  momButtonTouchedDown), for: .touchDown)
        momButton.addTarget(self, action: #selector(  momButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        
        dadButton.addTarget(self, action: #selector(  dadButtonTouchedDown), for: .touchDown)
        dadButton.addTarget(self, action: #selector(  dadButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        grandmaButton.addTarget(self, action: #selector(  grandmaButtonTouchedDown), for: .touchDown)
        grandmaButton.addTarget(self, action: #selector(  grandmaButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        grandpaButton.addTarget(self, action: #selector(  grandpaButtonTouchedDown), for: .touchDown)
        grandpaButton.addTarget(self, action: #selector(  grandpaButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        
        otherButton.addTarget(self, action: #selector(  otherButtonTouchedDown), for: .touchDown)
        otherButton.addTarget(self, action: #selector(  otherButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        
        notspecifiedButton.addTarget(self, action: #selector(  notspecifiedButtonTouchedDown), for: .touchDown)
        notspecifiedButton.addTarget(self, action: #selector(  notspecifiedButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        
    }
    
    func styleButton(_ button: UIButton) {
        button.layer.cornerRadius = 10 // Set the corner radius
        button.layer.borderColor = UIColor.clear.cgColor // Set border color
        button.layer.borderWidth = 1.0 // Set border width
        
        // Add shadow properties
        button.layer.shadowColor = UIColor.black.cgColor // Shadow color
        button.layer.shadowOpacity = 0.5 // Shadow opacity
        button.layer.shadowOffset = CGSize(width: 0, height: 4) // Increased shadow offset height for more pronounced shadow at the bottom
        button.layer.shadowRadius = 4 // Shadow radius
        button.layer.masksToBounds = false // Ensure shadow is not clipped
    }
    
    
    
    @objc func momButtonTouchedUp() {
        momButton.backgroundColor = .white
    }
    @objc func momButtonTouchedDown() {
        momButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
   
    
    @objc func dadButtonTouchedUp() {
        dadButton.backgroundColor = .white
    }
    @objc func dadButtonTouchedDown() {
        dadButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    
    
    @objc func grandmaButtonTouchedUp() {
        grandmaButton.backgroundColor = .white
    }
    @objc func grandmaButtonTouchedDown() {
        grandmaButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    
    
    @objc func grandpaButtonTouchedUp() {
        grandpaButton.backgroundColor = .white
    }
    @objc func grandpaButtonTouchedDown() {
        grandpaButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    
    
    @objc func otherButtonTouchedUp() {
        otherButton.backgroundColor = .white
    }
    @objc func otherButtonTouchedDown() {
        otherButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    
    
    @objc func notspecifiedButtonTouchedUp() {
        notspecifiedButton.backgroundColor = .white
    }
    @objc func notspecifiedButtonTouchedDown() {
        notspecifiedButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    
}
