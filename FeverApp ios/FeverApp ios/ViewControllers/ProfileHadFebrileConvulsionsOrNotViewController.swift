//
//  ProfileHadFebrileConvulsionsOrNotViewController.swift
//  FeverApp ios
//
//  Created by NEW on 21/09/2024.
//

import UIKit

class ProfileHadFebrileConvulsionsOrNotViewController: UIViewController{
   
    let profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
  
       var profilesFebrileConvulsionsResponse = ""
        
        @IBOutlet weak var myImage: UIImageView!
       
    @IBOutlet var FebrileConvulsionsResponseUIButton: [UIButton]!
    
    @IBOutlet var NoAnswerUIButton: UIButton!
    
    @IBOutlet var yesFebrileConvulsionsResponseUIButton: UIButton!
    
    
    @IBOutlet var noFebrileConvulsionsResponseUIButtonClick: UIButton!
    
        
        @IBOutlet weak var topView: UIView!
        
        @IBOutlet weak var bottomView: UIView!
    
    let responseTranslations: [String: String] = [
        "YES": TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.OPTION.2.LABEL", defaultText: "YES"),
        "NO": TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES.OPTION.1.LABEL", defaultText: "NO")
    ]
        
    @IBAction func handleFebrileConvulsionsResponseUIButtonClick(_ sender: Any) {
        
        getProfilesFebrileConvulsionsResponse(button: sender as! UIButton)
        giveProfilesFebrileConvulsionsResponseToProfileHadFebrileConvulsionsOrNotModel()
        handleNavigationToTourAppScreen()
    }
    
    @IBAction func handleNoAnswerUIButtonClick(_ sender: Any) {
        handleNavigationToTourAppScreen()
    }
    
    
    
        func getProfilesFebrileConvulsionsResponse(button: UIButton){
//            profilesFebrileConvulsionsResponse = button.titleLabel?.text ?? ""
            
            // Get the title of the clicked button
            guard let translatedTitle = button.titleLabel?.text else { return }

            // Find the English value for the translated title
            if let englishValue = responseTranslations.first(where: { $0.value == translatedTitle })?.key {
                profilesFebrileConvulsionsResponse = englishValue.localizedUppercase // Use the English value
                print("Selected response: \(profilesFebrileConvulsionsResponse)")
            } else {
                print("Error: Could not find the English value for the translated title.")
            }
        }
        func giveProfilesFebrileConvulsionsResponseToProfileHadFebrileConvulsionsOrNotModel(){
            ProfileHadFebrileConvulsionsOrNotModel.shared.saveProfilesFebrileConvulsionsResponse( profilesFebrileConvulsionsResponse)
        }
        func handleNavigationToTourAppScreen(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let TourAppVC = storyboard.instantiateViewController(withIdentifier: "overview") as? overviewViewController{
                self.navigationController?.pushViewController(TourAppVC , animated: true)
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
            yesFebrileConvulsionsResponseUIButton.setTitle(responseTranslations["YES"], for: .normal)
            noFebrileConvulsionsResponseUIButtonClick.setTitle(responseTranslations["NO"], for: .normal)
            setupUI()
            topView.layer.shadowColor = UIColor.lightGray.cgColor
            topView.layer.shadowOpacity = 0.5
            topView.layer.shadowRadius = 5
            topView.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            bottomView.layer.shadowColor = UIColor.lightGray.cgColor
            bottomView.layer.shadowOpacity = 0.5
            bottomView.layer.shadowRadius = 5
            bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
            yesFebrileConvulsionsResponseUIButton.addTarget(self, action: #selector(  yesFebrileConvulsionsResponseUIButtonTouchedDown), for: .touchDown)
            yesFebrileConvulsionsResponseUIButton.addTarget(self, action: #selector(  yesFebrileConvulsionsResponseUIButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
            
            
            noFebrileConvulsionsResponseUIButtonClick.addTarget(self, action: #selector( noFebrileConvulsionsResponseUIButtonClickTouchedDown), for: .touchDown)
            noFebrileConvulsionsResponseUIButtonClick.addTarget(self, action: #selector( noFebrileConvulsionsResponseUIButtonClickTouchedUp), for: [.touchUpInside, .touchUpOutside])
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
    
            
            
         
            // Apply shadow to yesButton
            yesFebrileConvulsionsResponseUIButton.layer.shadowColor = UIColor.lightGray.cgColor
            yesFebrileConvulsionsResponseUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            yesFebrileConvulsionsResponseUIButton.layer.shadowOpacity = 0.5
            yesFebrileConvulsionsResponseUIButton.layer.shadowRadius = 4
                    
                    // Apply shadow to noButton
            noFebrileConvulsionsResponseUIButtonClick.layer.shadowColor = UIColor.lightGray.cgColor
            noFebrileConvulsionsResponseUIButtonClick.layer.shadowOffset = CGSize(width: 0, height: 2)
            noFebrileConvulsionsResponseUIButtonClick.layer.shadowOpacity = 0.5
            noFebrileConvulsionsResponseUIButtonClick.layer.shadowRadius = 4
                    
                  
            // Apply shadow to noButton
            NoAnswerUIButton.layer.shadowColor = UIColor.black.cgColor
            NoAnswerUIButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            NoAnswerUIButton.layer.shadowOpacity = 0.2
            NoAnswerUIButton.layer.shadowRadius = 4
            NoAnswerUIButton.layer.borderWidth = 0.5
            NoAnswerUIButton.layer.borderColor = UIColor.lightGray.cgColor
            
            NoAnswerUIButton.layer.cornerRadius = 8
            noFebrileConvulsionsResponseUIButtonClick.layer.cornerRadius = 8
            yesFebrileConvulsionsResponseUIButton.layer.cornerRadius = 8
            
            initialYesButtonColor = yesFebrileConvulsionsResponseUIButton.backgroundColor
            initialNoButtonColor = noFebrileConvulsionsResponseUIButtonClick.backgroundColor
            initialMyButtonColor = NoAnswerUIButton.backgroundColor
            
            yesFebrileConvulsionsResponseUIButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
            noFebrileConvulsionsResponseUIButtonClick.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
            NoAnswerUIButton.addTarget(self, action: #selector(myButtonTapped), for: .touchUpInside)
        }
                                       
      
        
        var initialYesButtonColor: UIColor?
        var initialNoButtonColor: UIColor?
        var initialMyButtonColor: UIColor?
        
        
        func resetButtonColors() {
            yesFebrileConvulsionsResponseUIButton.backgroundColor = initialYesButtonColor
            noFebrileConvulsionsResponseUIButtonClick.backgroundColor = initialNoButtonColor
            
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
    
        @objc func myButtonTapped() {
            resetButtonColors()
            NoAnswerUIButton.backgroundColor = .lightGray
          
        }
        
        
        @objc func noButtonTapped() {
            resetButtonColors()
            NoAnswerUIButton.backgroundColor = initialMyButtonColor
            noFebrileConvulsionsResponseUIButtonClick.backgroundColor =
            UIColor(hexString: "#A5BDF2")
        }
        
        
        @objc func yesButtonTapped() {
            resetButtonColors()
            NoAnswerUIButton.backgroundColor = initialMyButtonColor
            yesFebrileConvulsionsResponseUIButton.backgroundColor =
            UIColor(hexString: "#A5BDF2")
        }
        
    @objc func yesFebrileConvulsionsResponseUIButtonTouchedUp() {
        yesFebrileConvulsionsResponseUIButton.backgroundColor = .white
    }
    @objc func yesFebrileConvulsionsResponseUIButtonTouchedDown() {
        yesFebrileConvulsionsResponseUIButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
    }
   
    
    @objc func noFebrileConvulsionsResponseUIButtonClickTouchedUp() {
        noFebrileConvulsionsResponseUIButtonClick.backgroundColor = .white
    }
    @objc func noFebrileConvulsionsResponseUIButtonClickTouchedDown() {
        noFebrileConvulsionsResponseUIButtonClick.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
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
            topLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.FEBRILE.CONVULSION", defaultText: "Has {{name}} had febrile convulsions?").replacingOccurrences(of: "{{name}}", with: profileName)
            topLabel.font = .systemFont(ofSize: 15)
            topLabel.translatesAutoresizingMaskIntoConstraints = false
            topContainerView.addSubview(topLabel)
            myImage.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                topContainerView.bottomAnchor.constraint(equalTo: yesFebrileConvulsionsResponseUIButton.topAnchor, constant: -20),
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
    


