//
//  chronicDiseaseViewController.swift
//  FeverApp ios
//
//  Created by user on 8/9/24.
//

import UIKit

class AnswerIfProfileHasChronicDiseasesOrNotViewController: UIViewController {
    var  profilesChronicDiseaseResponse = ""
    var profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet var messageView: UIView!
    
    @IBOutlet var YesHasChronicDiseasesResponseUIButton: UIButton!
    
    @IBOutlet var NoHasChronicDiseasesResponseUIButton: UIButton!
    
    @IBOutlet var SkipHasChronicDiseasesResponseUIButton: UIButton!
    
    let responseTranslations: [String: String] = [
        "YES": TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.OPTION.2.LABEL", defaultText: "YES"),
        "NO": TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.OPTION.1.LABEL", defaultText: "NO")
    ]
    
    @IBAction func handleYesHasChronicDiseasesResponseUIButtonClick(_ sender: Any) {
        getProfilesChronicDiseaseResponse(button: sender as! UIButton)
        giveProfilesChronicDiseaseResponseToProfileHasChronicDiseaseOrNotModel(button: sender as! UIButton)
      
    }
    
    @IBAction func handleNoHasChronicDiseasesResponseUIButtonClick(_ sender: Any) {
        getProfilesChronicDiseaseResponse(button: sender as! UIButton)
        giveProfilesChronicDiseaseResponseToProfileHasChronicDiseaseOrNotModel(button: sender as! UIButton)
    }
    
    
    @IBAction func handleSkipHasChronicDiseasesResponseUIButton(_ sender: Any) {
        handleNavigationToAddProfileHeightScreen()
    }
    
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!

    func getProfilesChronicDiseaseResponse(button: UIButton){
//        profilesChronicDiseaseResponse = (button.titleLabel?.text ?? "").localizedUppercase
        // Get the title of the clicked button
        guard let translatedTitle = button.titleLabel?.text else { return }

        // Find the English value for the translated title
        if let englishValue = responseTranslations.first(where: { $0.value == translatedTitle })?.key {
            profilesChronicDiseaseResponse = englishValue.localizedUppercase // Use the English value
            print("Selected response: \(profilesChronicDiseaseResponse)")
        } else {
            print("Error: Could not find the English value for the translated title.")
        }
    }
//    func giveProfilesChronicDiseaseResponseToProfileHasChronicDiseaseOrNotModel(button: UIButton){
//        let buttonLabel = button.titleLabel?.text
//        ProfileHasChronicDiseaseOrNotModel.shared.saveProfilesChronicDiseaseResponse(profilesChronicDiseaseResponse){
//            isSavedSuccessfully in
//            if isSavedSuccessfully! {
//                if buttonLabel == "Yes" {
//                    self.handleNavigationToAddProfileChronicDiseaseViewController()
//                }else{
//                    self.handleNavigationToAddProfileHeightScreen()
//                }
//            }else{
//                // Show alert popup
//                       let alertController = UIAlertController(title: "server error", message: "An error occured please try again", preferredStyle: .alert)
//                let retryAction = UIAlertAction(title: "retry", style: .default)
//                       alertController.addAction(retryAction)
//                self.present(alertController, animated: true)
//            }
//        }
//    }
    func giveProfilesChronicDiseaseResponseToProfileHasChronicDiseaseOrNotModel(button: UIButton) {
        // Use profilesChronicDiseaseResponse (English key)
        ProfileHasChronicDiseaseOrNotModel.shared.saveProfilesChronicDiseaseResponse(profilesChronicDiseaseResponse) { [self] isSavedSuccessfully in
            if isSavedSuccessfully! {
                if profilesChronicDiseaseResponse == "YES" { // Compare against the key, not the translated label
                    self.handleNavigationToAddProfileChronicDiseaseViewController()
                } else if profilesChronicDiseaseResponse == "NO" {
                    self.handleNavigationToAddProfileHeightScreen()
                } else {
                    print("Unexpected response value: \(profilesChronicDiseaseResponse)")
                }
            } else {
                // Show alert popup
                let alertController = UIAlertController(
                    title: "Server Error",
                    message: "An error occurred, please try again.",
                    preferredStyle: .alert
                )
                let retryAction = UIAlertAction(title: "Retry", style: .default)
                alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
    }

    func handleNavigationToAddProfileChronicDiseaseViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let AddProfileChronicDiseaseVC = storyboard.instantiateViewController(withIdentifier: "profilechronicdisease") as? AddProfileChronicDiseaseViewController {
            self.navigationController?.pushViewController(AddProfileChronicDiseaseVC, animated: true)
        }
    }
    func handleNavigationToAddProfileHeightScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let AddProfileHeightVC = storyboard.instantiateViewController(withIdentifier: "profileheight") as? AddProfileHeightViewController {
            self.navigationController?.pushViewController(AddProfileHeightVC, animated: true)
        }
    }
    class CustomRoundedView: UIView {
        var corners: UIRectCorner = []
        
        override func layoutSubviews() {
            super.layoutSubviews()
            applyCornerRadius()
        }

        private func applyCornerRadius() {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: 10, height: 10))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        YesHasChronicDiseasesResponseUIButton.setTitle(responseTranslations["YES"], for: .normal)
        NoHasChronicDiseasesResponseUIButton.setTitle(responseTranslations["NO"], for: .normal)
        topView.layer.cornerRadius = 20
     
        messageView.layer.cornerRadius = 10
        messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        bottomView.layer.cornerRadius = 20
      
        
        
     
        // Apply shadow to yesButton
        YesHasChronicDiseasesResponseUIButton.layer.shadowColor = UIColor.lightGray.cgColor
        YesHasChronicDiseasesResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        YesHasChronicDiseasesResponseUIButton.layer.shadowOpacity = 0.5
        YesHasChronicDiseasesResponseUIButton.layer.shadowRadius = 4
                
                // Apply shadow to noButton
        NoHasChronicDiseasesResponseUIButton.layer.shadowColor = UIColor.lightGray.cgColor
        NoHasChronicDiseasesResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        NoHasChronicDiseasesResponseUIButton.layer.shadowOpacity = 0.5
        NoHasChronicDiseasesResponseUIButton.layer.shadowRadius = 4
        
        // Apply shadow to topView
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topView.layer.shadowOpacity = 0.2
        topView.layer.shadowRadius = 4
              
        // Apply shadow to noButton
        SkipHasChronicDiseasesResponseUIButton.layer.shadowColor = UIColor.lightGray.cgColor
        SkipHasChronicDiseasesResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        SkipHasChronicDiseasesResponseUIButton.layer.shadowOpacity = 0.2
        SkipHasChronicDiseasesResponseUIButton.layer.shadowRadius = 4
        SkipHasChronicDiseasesResponseUIButton.layer.borderWidth = 0.5
        SkipHasChronicDiseasesResponseUIButton.layer.borderColor = UIColor.lightGray.cgColor
        
        SkipHasChronicDiseasesResponseUIButton.layer.cornerRadius = 8
        NoHasChronicDiseasesResponseUIButton.layer.cornerRadius = 8
        YesHasChronicDiseasesResponseUIButton.layer.cornerRadius = 8
        
        
        YesHasChronicDiseasesResponseUIButton.addTarget(self, action: #selector(  YesHasChronicDiseasesResponseUIButtonTouchedDown), for: .touchDown)
        YesHasChronicDiseasesResponseUIButton.addTarget(self, action: #selector(  YesHasChronicDiseasesResponseUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        
        NoHasChronicDiseasesResponseUIButton.addTarget(self, action: #selector( NoHasChronicDiseasesResponseUIButtonTouchedDown), for: .touchDown)
        NoHasChronicDiseasesResponseUIButton.addTarget(self, action: #selector(  NoHasChronicDiseasesResponseUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        
        SkipHasChronicDiseasesResponseUIButton.addTarget(self, action: #selector( SkipHasChronicDiseasesResponseUIButtonTouchedDown), for: .touchDown)
        SkipHasChronicDiseasesResponseUIButton.addTarget(self, action: #selector(  SkipHasChronicDiseasesResponseUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
     
      
        messageView.layer.shadowColor = UIColor.lightGray.cgColor
        messageView.layer.shadowOpacity = 0.3
        messageView.layer.shadowRadius = 5
        messageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        messageView.layer.masksToBounds = false
        
        
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
    
    
                           
    @objc func YesHasChronicDiseasesResponseUIButtonTouchedUp() {
        YesHasChronicDiseasesResponseUIButton.backgroundColor = .white
    }
    @objc func YesHasChronicDiseasesResponseUIButtonTouchedDown() {
        YesHasChronicDiseasesResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
   
    
    @objc func   NoHasChronicDiseasesResponseUIButtonTouchedUp() {
        NoHasChronicDiseasesResponseUIButton.backgroundColor = .white
    }
    @objc func   NoHasChronicDiseasesResponseUIButtonTouchedDown() {
        NoHasChronicDiseasesResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    
    
    @objc func  SkipHasChronicDiseasesResponseUIButtonTouchedUp() {
        SkipHasChronicDiseasesResponseUIButton.backgroundColor = .white
    }
    @objc func  SkipHasChronicDiseasesResponseUIButtonTouchedDown() {
        SkipHasChronicDiseasesResponseUIButton.backgroundColor = .lightGray
    }
    
   
    
    
    
  
    
    
  
    
    
    
    
    func setupUI() {
        
            // ...
        messageLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.QUESTION", defaultText: "Does {{name}} have a chronic disease?").replacingOccurrences(of: "{{name}}", with: profileName)
        
        let defaultText = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer")
        let myButtonTitle = NSMutableAttributedString(string: defaultText)

        // Dynamically calculate the ranges based on the text length
        let blackRangeLength = min(defaultText.count, 10) // Ensure range does not exceed text length
        if blackRangeLength > 0 {
            myButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: blackRangeLength))
        }

        let grayStart = blackRangeLength
        let grayRangeLength = max(0, defaultText.count - grayStart) // Remaining text length
        if grayRangeLength > 0 {
            myButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: grayStart, length: grayRangeLength))
        }

        SkipHasChronicDiseasesResponseUIButton.setAttributedTitle(myButtonTitle, for: .normal)


//        let myButtonTitle = NSMutableAttributedString(string: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER",defaultText: "No answer"))
//            myButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 10))
//            myButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
//        SkipHasChronicDiseasesResponseUIButton.setAttributedTitle(myButtonTitle, for: .normal)

            // ...
        myImage.translatesAutoresizingMaskIntoConstraints = false
    }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

    
    
    
    
    
    
    
    
    
    
   
