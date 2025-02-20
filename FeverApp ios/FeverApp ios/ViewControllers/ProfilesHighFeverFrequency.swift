//
//  40DegreesViewController.swift
//  FeverApp ios
//
//  Created by NEW on 14/08/2024.
//

import UIKit
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
class ProfilesHighFeverFrequencyViewController: UIViewController{
    var profilesHighFeverResponse = ""
    let profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet var AlwaysHighFeverResponseUIButton: UIButton!
    
    @IBOutlet var MostlyHighFeverResponseUIButton: UIButton!
    
    @IBOutlet var RarelyHighFeverResponseUIButton: UIButton!
    
    @IBOutlet var NeverHighFeverResponseUIButton: UIButton!
    
    @IBOutlet var NoAnswerUIButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    let responseTranslations: [String: String] = [
        "Always": TranslationsViewModel.shared.getTranslation(key: "PROFILE.TYPICAL_HIGH-TEMPERATURE.OPTION.1.LABEL", defaultText: "Always"),
        "Mostly": TranslationsViewModel.shared.getTranslation(key: "PROFILE.TYPICAL_HIGH-TEMPERATURE.OPTION.2.LABEL", defaultText: "Mostly"),
        "Rarely": TranslationsViewModel.shared.getTranslation(key: "PROFILE.TYPICAL_HIGH-TEMPERATURE.OPTION.3.LABEL", defaultText: "Rarely"),
        "Never": TranslationsViewModel.shared.getTranslation(key: "PROFILE.TYPICAL_HIGH-TEMPERATURE.OPTION.4.LABEL", defaultText: "Never"),

    ]
    
    @IBAction func handleHighFeverResponseUIButtonClick(_ sender: Any) {
        getProfilesHighFeverResponse(button: sender as! UIButton)
        giveProfilesHighFeverResponseToAddProfileHighFeversModel()
       
    }
    
    @IBAction func handleNoAnswerUIButtonClick(_ sender: Any) {
        handleNavigationToProfileHasTakenAntipyreticsScreen()
    }
    func getProfilesHighFeverResponse(button: UIButton){
//        profilesHighFeverResponse = (button.titleLabel?.text ?? "").localizedUppercase
        
        guard let translatedTitle = button.titleLabel?.text else { return }

        // Find the English value for the translated title
        if let englishValue = responseTranslations.first(where: { $0.value == translatedTitle })?.key {
            profilesHighFeverResponse = englishValue.localizedUppercase // Use the English value
            print("Selected response: \(profilesHighFeverResponse)")
        } else {
            print("Error: Could not find the English value for the translated title.")
        }
    }
    func giveProfilesHighFeverResponseToAddProfileHighFeversModel(){
        AddProfileHighFeversModel.shared.saveProfilesHighFeverResponse(profilesHighFeverResponse){
            isSavedSuccessfully in
            if isSavedSuccessfully!{
                self.handleNavigationToProfileHasTakenAntipyreticsScreen()
            }else{
                // Show alert popup
                       let alertController = UIAlertController(title: "server error", message: "An error occurred please try again", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "retry", style: .default)
                       alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
    }
    func handleNavigationToProfileHasTakenAntipyreticsScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ProfileHasTakenAntipyreticsVC = storyboard.instantiateViewController(withIdentifier: "ProfileHasTakenAntipyretics") as? ProfileHasTakenAntipyreticsViewController {
            self.navigationController?.pushViewController(ProfileHasTakenAntipyreticsVC, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AlwaysHighFeverResponseUIButton.setTitle(responseTranslations["Always"], for: .normal)
        
         MostlyHighFeverResponseUIButton.setTitle(responseTranslations["Mostly"], for: .normal)
        
        RarelyHighFeverResponseUIButton.setTitle(responseTranslations["Rarely"], for: .normal)
        
        NeverHighFeverResponseUIButton.setTitle(responseTranslations["Never"], for: .normal)
        
        buttoncolorsetupUI()
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.3
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 24, height: 24))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = .gray
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
        setupUI()
        
        topView.layer.cornerRadius = 20
     
        
        bottomView.layer.cornerRadius = 20
 
        
        
        
     
        // Apply shadow to yesButton
        AlwaysHighFeverResponseUIButton.layer.shadowColor = UIColor.black.cgColor
        AlwaysHighFeverResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        AlwaysHighFeverResponseUIButton.layer.shadowOpacity = 0.2
        AlwaysHighFeverResponseUIButton.layer.shadowRadius = 3
                
                // Apply shadow to noButton
        MostlyHighFeverResponseUIButton.layer.shadowColor = UIColor.black.cgColor
        MostlyHighFeverResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        MostlyHighFeverResponseUIButton.layer.shadowOpacity = 0.2
        MostlyHighFeverResponseUIButton.layer.shadowRadius = 3
        
                //apply shadow to knowButton
        RarelyHighFeverResponseUIButton.layer.shadowColor = UIColor.black.cgColor
        RarelyHighFeverResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        RarelyHighFeverResponseUIButton.layer.shadowOpacity = 0.2
        RarelyHighFeverResponseUIButton.layer.shadowRadius = 3
        
        //apply shadow to knowButton
        NeverHighFeverResponseUIButton.layer.shadowColor = UIColor.black.cgColor
        NeverHighFeverResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        NeverHighFeverResponseUIButton.layer.shadowOpacity = 0.2
        NeverHighFeverResponseUIButton.layer.shadowRadius = 3


        
        // Apply shadow to noButton
        NoAnswerUIButton.layer.shadowColor = UIColor.black.cgColor
        NoAnswerUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        NoAnswerUIButton.layer.shadowOpacity = 0.2
        NoAnswerUIButton.layer.shadowRadius = 4
        NoAnswerUIButton.layer.borderWidth = 0.5
        NoAnswerUIButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        NoAnswerUIButton.layer.cornerRadius = 8
        AlwaysHighFeverResponseUIButton.layer.cornerRadius = 8
        MostlyHighFeverResponseUIButton.layer.cornerRadius = 8
        RarelyHighFeverResponseUIButton.layer.cornerRadius = 8
        NeverHighFeverResponseUIButton.layer.cornerRadius = 8
        
        initialAlwaysButtonColor = AlwaysHighFeverResponseUIButton.backgroundColor
        initialMostlyButtonColor = MostlyHighFeverResponseUIButton.backgroundColor
        initialMyButtonColor = NoAnswerUIButton.backgroundColor
        initialRarelyButtonColor = RarelyHighFeverResponseUIButton.backgroundColor
        initialNeverButtonColor = NeverHighFeverResponseUIButton.backgroundColor
        
    }
                                   
  
    
    var initialAlwaysButtonColor: UIColor?
    var initialMostlyButtonColor: UIColor?
    var initialMyButtonColor: UIColor?
    var initialRarelyButtonColor: UIColor?
    var initialNeverButtonColor: UIColor?
    
    
    func resetButtonColors() {
        AlwaysHighFeverResponseUIButton.backgroundColor = initialAlwaysButtonColor
        MostlyHighFeverResponseUIButton.backgroundColor = initialMostlyButtonColor
        RarelyHighFeverResponseUIButton.backgroundColor = initialRarelyButtonColor
        NeverHighFeverResponseUIButton.backgroundColor = initialNeverButtonColor
        
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
    

    func buttoncolorsetupUI(){
        AlwaysHighFeverResponseUIButton.addTarget(self, action: #selector(AlwaysButtontouchDownSetup), for: .touchDown)
        AlwaysHighFeverResponseUIButton.addTarget(self, action: #selector(AlwaysButtontouchUpSetup), for: [.touchUpInside, .touchUpOutside])
        
        
        RarelyHighFeverResponseUIButton.addTarget(self, action: #selector(rarelyButtontouchDownSetup), for: .touchDown)
        RarelyHighFeverResponseUIButton.addTarget(self, action: #selector(rarelyButtontouchUpSetup), for: [.touchUpInside, .touchUpOutside])
        
        MostlyHighFeverResponseUIButton.addTarget(self, action: #selector(mostlyButtontouchDownSetup), for: .touchDown)
        MostlyHighFeverResponseUIButton.addTarget(self, action: #selector( mostlyButtontouchUpSetup), for: [.touchUpInside, .touchUpOutside])
        
        NeverHighFeverResponseUIButton.addTarget(self, action: #selector(neverButtontouchDownsetup), for: .touchDown)
        NeverHighFeverResponseUIButton.addTarget(self, action: #selector(neverButtontouchUpSetup), for: [.touchUpInside, .touchUpOutside])
        
    }
    @objc func AlwaysButtontouchDownSetup(){
        AlwaysHighFeverResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    @objc func AlwaysButtontouchUpSetup(){
        AlwaysHighFeverResponseUIButton.backgroundColor = .white
    }
    @objc func rarelyButtontouchUpSetup(){
        RarelyHighFeverResponseUIButton.backgroundColor = .white
    }
    @objc func rarelyButtontouchDownSetup(){
        RarelyHighFeverResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    @objc func mostlyButtontouchDownSetup(){
        MostlyHighFeverResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    @objc func mostlyButtontouchUpSetup(){
        MostlyHighFeverResponseUIButton.backgroundColor = .white
    }
    @objc func neverButtontouchUpSetup(){
        NeverHighFeverResponseUIButton.backgroundColor = .white
    }
    @objc func neverButtontouchDownsetup(){
       NeverHighFeverResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
    func setupUI() {
        
            // ...

        let defaultText = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer")
        let skipButtonTitle = NSMutableAttributedString(string: defaultText)

        // Dynamically calculate the ranges based on the text length
        let blackRangeLength = min(defaultText.count, 10) // Ensure range does not exceed text length
        if blackRangeLength > 0 {
            skipButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: blackRangeLength))
        }

        let grayStart = blackRangeLength
        let grayRangeLength = max(0, defaultText.count - grayStart) // Remaining text length
        if grayRangeLength > 0 {
            skipButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: grayStart, length: grayRangeLength))
        }
        NoAnswerUIButton.setAttributedTitle(skipButtonTitle, for: .normal)

            // ...
    
        
        
        let topContainerView = CustomRoundedView()
        topContainerView.corners = [.topLeft, .topRight, .bottomRight]
        topContainerView.backgroundColor = .white
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.layer.shadowColor = UIColor.lightGray.cgColor
        topContainerView.layer.shadowOpacity = 0.4
        topContainerView.layer.shadowRadius = 5
        topContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.addSubview(topContainerView)

        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.TYPICAL_HIGH-TEMPERATURE.QUESTION",defaultText: "Does {{name}} tend to have high fevers (over 40 degrees)?").replacingOccurrences(of: "{{name}}", with: profileName)
        topLabel.font = .systemFont(ofSize: 15)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topLabel)
        myImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topContainerView.bottomAnchor.constraint(equalTo: AlwaysHighFeverResponseUIButton.topAnchor, constant: -20),
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
    func Ifuncnit (hexCode: String) {
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
        _ = UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)

    }
}
    
    
    

