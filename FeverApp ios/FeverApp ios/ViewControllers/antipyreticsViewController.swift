//
//  antipyreticsViewController.swift
//  FeverApp ios
//
//  Created by user on 8/14/24.
//

//
//  antipyreticsViewController.swift
//  FeverApp ios
//
//  Created by user on 8/14/24.
//
import UIKit
  
class ProfileHasTakenAntipyreticsViewController: UIViewController{
    let profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
    var profilesAntipyreticsIntakeResponse = ""
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet var yesHasTakenAntipyreticsOrNotResponseUIButton: UIButton!
    
    @IBOutlet var NoHasTakenAntipyreticsOrNotResponseUIButton: UIButton!
    
    @IBOutlet var DontKnowHasTakenAntipyreticsOrNotResponseUIButton: UIButton!
    
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    let responseTranslations: [String: String] = [
        "Yes": TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.OPTION.2.LABEL", defaultText: "Yes"),
        "No": TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.OPTION.1.LABEL", defaultText: "No"),
        "Don't know": TranslationsViewModel.shared.getTranslation(key: "PROFILE.ANTIPYRETICS.OPTION.3.LABEL", defaultText: "Don't Know")
    ]
    
    @IBAction func handleHasTakenAntipyreticsOrNotResponseUIButtonClick(_ sender: Any) {
        getProfilesAntipyreticsIntakeResponse(button: sender as! UIButton)
        giveProfilesAntipyreticsIntakeResponseToProfileHasTakenAntipyreticsOrNotModel()
       
    
    }
    
    @IBAction func handleNoAnswerUIButtonClick(_ sender: Any) {
        handleNavigationToProfileHasFeverSeizuresOrNotScreen()
    }
    
    func getProfilesAntipyreticsIntakeResponse(button: UIButton){
//        profilesAntipyreticsIntakeResponse = (button.titleLabel?.text ?? "").localizedUppercase
        // Get the title of the clicked button
        guard let translatedTitle = button.titleLabel?.text else { return }

        // Find the English value for the translated title
        if let englishValue = responseTranslations.first(where: { $0.value == translatedTitle })?.key {
            profilesAntipyreticsIntakeResponse = englishValue.localizedUppercase // Use the English value
            print("Selected response: \(profilesAntipyreticsIntakeResponse)")
        } else {
            print("Error: Could not find the English value for the translated title.")
        }
    }
    func giveProfilesAntipyreticsIntakeResponseToProfileHasTakenAntipyreticsOrNotModel(){
        ProfileHasTakenAntipyreticsOrNotModel.shared.saveProfilesAntipyreticsIntakeResponse(profilesAntipyreticsIntakeResponse){isSavedSuccessfully in 
            if isSavedSuccessfully!{
                self.handleNavigationToProfileHasFeverSeizuresOrNotScreen()
            }else{
                // Show alert popup
                       let alertController = UIAlertController(title: "server error", message: "An error occurred please try again", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "retry", style: .default)
                       alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
        
    }
    func handleNavigationToProfileHasFeverSeizuresOrNotScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ProfileHasFeverSeizuresOrNotVC = storyboard.instantiateViewController(withIdentifier: "seizure") as? ProfileHasFeverSeizuresOrNotViewController {
            self.navigationController?.pushViewController(ProfileHasFeverSeizuresOrNotVC, animated: true)
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
        
        yesHasTakenAntipyreticsOrNotResponseUIButton.setTitle(responseTranslations["Yes"], for: .normal)
        
       NoHasTakenAntipyreticsOrNotResponseUIButton.setTitle(responseTranslations["No"], for: .normal)
        
        DontKnowHasTakenAntipyreticsOrNotResponseUIButton.setTitle(responseTranslations["Don't know"], for: .normal)
        
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
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
        
        topView.layer.cornerRadius = 20
       
        
        bottomView.layer.cornerRadius = 20

        
        yesHasTakenAntipyreticsOrNotResponseUIButton.addTarget(self, action: #selector(  YesHasTakenAntipyreticsOrNotResponseUIButtonTouchedDown), for: .touchDown)
        yesHasTakenAntipyreticsOrNotResponseUIButton.addTarget(self, action: #selector(  YesHasTakenAntipyreticsOrNotResponseUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
        
        NoHasTakenAntipyreticsOrNotResponseUIButton.addTarget(self, action: #selector( NoHasTakenAntipyreticsOrNotResponseUIButtonTouchedDown), for: .touchDown)
        NoHasTakenAntipyreticsOrNotResponseUIButton.addTarget(self, action: #selector(  NoHasTakenAntipyreticsOrNotResponseUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        
     
        // Apply shadow to yesButton
        yesHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowColor = UIColor.black.cgColor
        yesHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        yesHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowOpacity = 0.2
        yesHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowRadius = 3
                
                // Apply shadow to noButton
        NoHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowColor = UIColor.black.cgColor
        NoHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        NoHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowOpacity = 0.2
        NoHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowRadius = 3
        
                //apply shadow to knowButton
        DontKnowHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowColor = UIColor.black.cgColor
        DontKnowHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        DontKnowHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowOpacity = 0.2
        DontKnowHasTakenAntipyreticsOrNotResponseUIButton.layer.shadowRadius = 3
        
        
        
        // Apply shadow to noButton
        myButton.layer.shadowColor = UIColor.black.cgColor
        myButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        myButton.layer.shadowOpacity = 0.2
        myButton.layer.shadowRadius = 4
        myButton.layer.borderWidth = 0.5
        myButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        myButton.layer.cornerRadius = 8
        NoHasTakenAntipyreticsOrNotResponseUIButton.layer.cornerRadius = 8
        yesHasTakenAntipyreticsOrNotResponseUIButton.layer.cornerRadius = 8
        DontKnowHasTakenAntipyreticsOrNotResponseUIButton.layer.cornerRadius = 8
        
        
        initialYesButtonColor = yesHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor
        initialNoButtonColor = NoHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor
        initialMyButtonColor = myButton.backgroundColor
        initialKnowButtonColor = DontKnowHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor
        
    }
                                   
  
    
    var initialYesButtonColor: UIColor?
    var initialNoButtonColor: UIColor?
    var initialMyButtonColor: UIColor?
    var initialKnowButtonColor: UIColor?
    
    
    func resetButtonColors() {
        yesHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor = initialYesButtonColor
        NoHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor = initialNoButtonColor
        DontKnowHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor = initialKnowButtonColor
        
    }
   
    @objc func myButtonTapped() {
        resetButtonColors()
        myButton.backgroundColor = .lightGray
      
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
    

    
    @objc func YesHasTakenAntipyreticsOrNotResponseUIButtonTouchedUp() {
        yesHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor = .white
    }
    @objc func YesHasTakenAntipyreticsOrNotResponseUIButtonTouchedDown() {
        yesHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
   
    
    @objc func   NoHasTakenAntipyreticsOrNotResponseUIButtonTouchedUp() {
        NoHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor = .white
    }
    @objc func   NoHasTakenAntipyreticsOrNotResponseUIButtonTouchedDown() {
        NoHasTakenAntipyreticsOrNotResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
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
            myButton.setAttributedTitle(myButtonTitle, for: .normal)

            // ...
    
        
        
        let topContainerView = CustomRoundedView()
        topContainerView.corners = [.topLeft, .topRight, .bottomRight]
        topContainerView.backgroundColor = .white
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)

        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.ANTIPYRETICS.QUESTION",defaultText: "Has {{name}} taken antipyretics (paracetamol or ibuprofen) during the last 12 months?").replacingOccurrences(of: "{{name}}", with: profileName)
        topLabel.font = .systemFont(ofSize: 15)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topLabel)
        myImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topContainerView.bottomAnchor.constraint(equalTo: yesHasTakenAntipyreticsOrNotResponseUIButton.topAnchor, constant: -20),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -90),
            topContainerView.heightAnchor.constraint(equalToConstant: 90),

            topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 1),
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
    convenience init(hexCode: String) {
        let hex = hexCode.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
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
