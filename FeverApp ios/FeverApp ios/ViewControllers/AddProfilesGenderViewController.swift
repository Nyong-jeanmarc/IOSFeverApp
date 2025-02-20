//
//  AddGenderViewController.swift
//  FeverApp ios
//
//  Created by user on 8/7/24.
//


import UIKit

class AddProfilesGenderViewController: UIViewController {
    
    
    var profileGender = ""
    let profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myLogo: UIImageView!
    

    @IBOutlet var FemaleGenderUIButtons: UIButton!
    @IBOutlet var MaleGenderUIButton: UIButton!
    @IBOutlet var OthersGenderUIButton: UIButton!
    
    let genderTranslations: [String: String] = [
        "FEMALE": TranslationsViewModel.shared.getTranslation(key: "PROFILE.GENDER.OPTION.2.LABEL", defaultText: "Female"),
        "MALE": TranslationsViewModel.shared.getTranslation(key: "PROFILE.GENDER.OPTION.1.LABEL", defaultText: "Male"),
        "VARIOUS": TranslationsViewModel.shared.getTranslation(key: "PROFILE.GENDER.OPTION.3.LABEL", defaultText: "Various"),

    ]
    
    @IBAction func handleGenderUIButtonClick(_ sender: Any) {
        getProfilesGender(sender: sender)
        giveProfilesGenderToAddProfileGenderModel()
    }
    
    var selectedButton: UIButton?

    class CustomRoundedView: UIView {
        override func layoutSubviews() {
            super.layoutSubviews()
            applyRoundedCornersAndShadow()
        }
        
        private func applyRoundedCornersAndShadow() {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight, .bottomRight],
                                    cornerRadii: CGSize(width: 10, height: 10))
            
            // Rounded corners
            layer.cornerRadius = 10
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            layer.backgroundColor = UIColor.white.cgColor
            layer.masksToBounds = true
            
            // Shadow
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 5
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowPath = path.cgPath
            layer.masksToBounds = false
        }
    }


       func applyEffects(to button: UIButton) {
           let maskView = UIView()
           maskView.backgroundColor = .clear
           maskView.layer.cornerRadius = 10
           maskView.layer.masksToBounds = true

           button.insertSubview(maskView, at: 0)

           button.layer.shadowColor = UIColor.lightGray.cgColor
           button.layer.shadowOpacity = 0.5
           button.layer.shadowRadius = 4
           button.layer.shadowOffset = CGSize(width: 0, height: 4)
           button.layer.cornerRadius = 10
           button.clipsToBounds = false
           button.layer.masksToBounds = false
       }

       override func viewDidLoad() {
           super.viewDidLoad()
           // Set button titles with translations
           FemaleGenderUIButtons.setTitle(genderTranslations["FEMALE"], for: .normal)
           MaleGenderUIButton.setTitle(genderTranslations["MALE"], for: .normal)
           OthersGenderUIButton.setTitle(genderTranslations["VARIOUS"], for: .normal)
           setupUI()
           topView.layer.shadowColor = UIColor.lightGray.cgColor
           topView.layer.shadowOpacity = 0.5
           topView.layer.shadowRadius = 5
           topView.layer.shadowOffset = CGSize(width: 0, height: 2)
           
         
           topView.layer.cornerRadius = 25
      
           

              // Apply visual effects (border radius, shadow, etc.) to the buttons
              applyEffects(to: FemaleGenderUIButtons)
              applyEffects(to: MaleGenderUIButton)
              applyEffects(to: OthersGenderUIButton)
           let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
               let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 24, height: 24))
           let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
           backButton.tintColor = .gray
           // Create a custom UILabel for the title
               let navtitleLabel = UILabel()
               navtitleLabel.text =  TranslationsViewModel.shared.getTranslation(key: "PROFILE.PROFILE-SURVEY.TEXT.3", defaultText:"Add Profile")
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
    


    func getProfilesGender(sender: Any){
        let button = sender as? UIButton
        
        guard let translatedTitle = button?.titleLabel?.text else { return }

        // Find the English value for the translated title
        if let englishValue = genderTranslations.first(where: { $0.value == translatedTitle })?.key {
            profileGender = englishValue.localizedUppercase // Use the English value
            print("Selected gender: \(profileGender)")
        } else {
            print("Error: Could not find the English value for the translated title.")
        }
        
//        profileGender =  (button?.titleLabel?.text ?? "").localizedUppercase
    }
    func giveProfilesGenderToAddProfileGenderModel(){
        AddProfileGenderModel.shared.saveProfilesGender(profileGender){
            isSavedSuccessfully in
            if isSavedSuccessfully!{
                self.handleNavigationToAddProfilePediatricianScreen()
            }else{
                // Show alert popup
                       let alertController = UIAlertController(title: "Failed to reach server", message: "An error occured please try again", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "retry", style: .default)
                       alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
    }
    func handleNavigationToAddProfilePediatricianScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let AddProfilePediatricianVC = storyboard.instantiateViewController(withIdentifier: "choosepediatrician") as? ChoosepediatricianViewController {
            self.navigationController?.pushViewController(AddProfilePediatricianVC, animated: true)
        }
    }
       func setupUI() {
           
           
           FemaleGenderUIButtons.addTarget(self, action: #selector(  FemaleGenderUIButtonsTouchedDown), for: .touchDown)
           FemaleGenderUIButtons.addTarget(self, action: #selector(  FemaleGenderUIButtonsTouchedUp), for: [.touchUpInside, .touchUpOutside])
           
           
           MaleGenderUIButton.addTarget(self, action: #selector(  MaleGenderUIButtonTouchedDown), for: .touchDown)
           MaleGenderUIButton.addTarget(self, action: #selector(  MaleGenderUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
           
           OthersGenderUIButton.addTarget(self, action: #selector(  OthersGenderUIButtonTouchedDown), for: .touchDown)
           OthersGenderUIButton.addTarget(self, action: #selector(   OthersGenderUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
           
           
           
           
           
           
           let topContainerView = CustomRoundedView()
         
           topContainerView.backgroundColor = .white
           topContainerView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(topContainerView)

           let topLabel = UILabel()
           topLabel.numberOfLines = 0
           topLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.GENDER.QUESTION", defaultText: "What is the gender of {{name}}?").replacingOccurrences(of: "{{name}}", with: profileName)
           topLabel.font = .systemFont(ofSize: 15)
           topLabel.translatesAutoresizingMaskIntoConstraints = false
           topContainerView.addSubview(topLabel)
           myLogo.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               topContainerView.bottomAnchor.constraint(equalTo: FemaleGenderUIButtons.topAnchor, constant: -20),
               topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
               topContainerView.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -120),
               topContainerView.heightAnchor.constraint(equalToConstant: 55),

               topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
               topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
               topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
               topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10),

               myLogo.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
               myLogo.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: -37),
               myLogo.widthAnchor.constraint(equalToConstant: 30),
               myLogo.heightAnchor.constraint(equalToConstant: 30)
           ])
       }
    
    
    @objc func FemaleGenderUIButtonsTouchedUp() {
        FemaleGenderUIButtons.backgroundColor = .white
    }
    @objc func FemaleGenderUIButtonsTouchedDown() {
        FemaleGenderUIButtons.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
   
    
    @objc func   MaleGenderUIButtonTouchedUp() {
        MaleGenderUIButton.backgroundColor = .white
    }
    @objc func   MaleGenderUIButtonTouchedDown() {
        MaleGenderUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    
    
    @objc func OthersGenderUIButtonTouchedUp() {
        OthersGenderUIButton.backgroundColor = .white
    }
    @objc func OthersGenderUIButtonTouchedDown() {
        OthersGenderUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    
   }
