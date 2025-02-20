//
//  seizureViewController.swift
//  FeverApp ios
//
//  Created by user on 8/14/24.
//

import UIKit

class ProfileHasFeverSeizuresOrNotViewController: UIViewController {
   var profilesFeverSeizureResponse = ""
    let profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet var FeverSeizureResponseUIButton: [UIButton]!
    
    @IBOutlet var yesFeverSeizureResponseUIButton: UIButton!
    
    @IBOutlet var noFeverSeizureResponseUIButton: UIButton!
    
    
    @IBOutlet var NoAnswerUIButton: UIButton!
        
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    let responseTranslations: [String: String] = [
        "YES": TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.OPTION.2.LABEL", defaultText: "YES"),
        "NO": TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.OPTION.1.LABEL", defaultText: "NO")
    ]
    
    @IBAction func handleFeverSeizureResponseUIButtonClick(_ sender: UIButton) {
        getProfilesFeverSeizureResponse(button: sender)
        giveProfilesFeverSeizureResponseToProfileEverHadFeverSeizureOrNotModel()
      
        
    }
    
    @IBAction func handleNoAnswerUIButtonClick(_ sender: Any) {
        handleNavigationToProfileHadFebrileConvulsionsOrNotScreen()
    }
    
    func getProfilesFeverSeizureResponse(button: UIButton){
//        profilesFeverSeizureResponse = (button.titleLabel?.text ?? "").localizedUppercase
        // Get the title of the clicked button
        guard let translatedTitle = button.titleLabel?.text else { return }

        // Find the English value for the translated title
        if let englishValue = responseTranslations.first(where: { $0.value == translatedTitle })?.key {
            profilesFeverSeizureResponse = englishValue.localizedUppercase // Use the English value
            print("Selected response: \(profilesFeverSeizureResponse)")
        } else {
            print("Error: Could not find the English value for the translated title.")
        }
    }
    func giveProfilesFeverSeizureResponseToProfileEverHadFeverSeizureOrNotModel(){
        ProfileEverHadFeverSeizureOrNotModel.shared.saveProfilesFeverSeizureResponse(profilesFeverSeizureResponse){
            isSavedSuccessfully in
            if isSavedSuccessfully ?? false{
                self.handleNavigationToProfileHadFebrileConvulsionsOrNotScreen()
            }else{
                // Show alert popup
                       let alertController = UIAlertController(title: "server error", message: "An error occured please try again", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "retry", style: .default)
                       alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
    }
    func handleNavigationToProfileHadFebrileConvulsionsOrNotScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ProfileHadFebrileConvulsionsOrNotVC = storyboard.instantiateViewController(withIdentifier: "FebrileConvulsionsOrNot") as? ProfileHadFebrileConvulsionsOrNotViewController {
            self.navigationController?.pushViewController(ProfileHadFebrileConvulsionsOrNotVC , animated: true)
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
        yesFeverSeizureResponseUIButton.setTitle(responseTranslations["YES"], for: .normal)
        noFeverSeizureResponseUIButton.setTitle(responseTranslations["NO"], for: .normal)
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        yesFeverSeizureResponseUIButton.addTarget(self, action: #selector(  yesFeverSeizureResponseUIButtonTouchedDown), for: .touchDown)
        yesFeverSeizureResponseUIButton.addTarget(self, action: #selector(  yesFeverSeizureResponseUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        
        noFeverSeizureResponseUIButton.addTarget(self, action: #selector( noFeverSeizureResponseUIButtonTouchedDown), for: .touchDown)
        noFeverSeizureResponseUIButton.addTarget(self, action: #selector( noFeverSeizureResponseUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
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
        setupUI()
        
        topView.layer.cornerRadius = 20
      
        
        bottomView.layer.cornerRadius = 20
        
        
     
        // Apply shadow to yesButton
        yesFeverSeizureResponseUIButton.layer.shadowColor = UIColor.lightGray.cgColor
        yesFeverSeizureResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        yesFeverSeizureResponseUIButton.layer.shadowOpacity = 0.5
        yesFeverSeizureResponseUIButton.layer.shadowRadius = 4
                
                // Apply shadow to noButton
        noFeverSeizureResponseUIButton.layer.shadowColor = UIColor.lightGray.cgColor
        noFeverSeizureResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        noFeverSeizureResponseUIButton.layer.shadowOpacity = 0.5
        noFeverSeizureResponseUIButton.layer.shadowRadius = 4
                
              
        // Apply shadow to noButton
        NoAnswerUIButton.layer.shadowColor = UIColor.black.cgColor
        NoAnswerUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        NoAnswerUIButton.layer.shadowOpacity = 0.2
        NoAnswerUIButton.layer.shadowRadius = 4
        NoAnswerUIButton.layer.borderWidth = 0.5
        NoAnswerUIButton.layer.borderColor = UIColor.lightGray.cgColor
        
        NoAnswerUIButton.layer.cornerRadius = 8
        noFeverSeizureResponseUIButton.layer.cornerRadius = 8
        yesFeverSeizureResponseUIButton.layer.cornerRadius = 8
        
        initialYesButtonColor = yesFeverSeizureResponseUIButton.backgroundColor
        initialNoButtonColor = noFeverSeizureResponseUIButton.backgroundColor
        initialMyButtonColor = NoAnswerUIButton.backgroundColor
        
      
    }
                                   
  
    
    var initialYesButtonColor: UIColor?
    var initialNoButtonColor: UIColor?
    var initialMyButtonColor: UIColor?
    
    
    func resetButtonColors() {
        yesFeverSeizureResponseUIButton.backgroundColor = initialYesButtonColor
        noFeverSeizureResponseUIButton.backgroundColor = initialNoButtonColor
        
    }
   
    @objc func NoAnswerUIButtonTapped() {
        resetButtonColors()
        NoAnswerUIButton.backgroundColor = .lightGray
      
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
    
   
    @objc func  yesFeverSeizureResponseUIButtonTouchedUp() {
        yesFeverSeizureResponseUIButton.backgroundColor = .white
    }
    @objc func yesFeverSeizureResponseUIButtonTouchedDown() {
        yesFeverSeizureResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
   
    
    @objc func   noFeverSeizureResponseUIButtonTouchedUp() {
        noFeverSeizureResponseUIButton.backgroundColor = .white
    }
    @objc func noFeverSeizureResponseUIButtonTouchedDown() {
        noFeverSeizureResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
 
    
    
    
    
    func setupUI() {
        
            // ...

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
        NoAnswerUIButton.setAttributedTitle(myButtonTitle, for: .normal)

            // ...
    
        
        
        let topContainerView = CustomRoundedView()
        topContainerView.corners = [.topLeft, .topRight, .bottomRight]
        topContainerView.backgroundColor = .white
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)

        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "PROFILE.FEVERSEIZURE", defaultText: "Has {{name}} ever had a fever seizure?").replacingOccurrences(of: "{{name}}", with: profileName)
        topLabel.font = .systemFont(ofSize: 15)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topLabel)
        myImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topContainerView.bottomAnchor.constraint(equalTo: yesFeverSeizureResponseUIButton.topAnchor, constant: -20),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            topContainerView.heightAnchor.constraint(equalToConstant: 75),

            topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
            topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
            topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10),

            myImage.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            myImage.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: -37),
            myImage.widthAnchor.constraint(equalToConstant: 30),
            myImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
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


