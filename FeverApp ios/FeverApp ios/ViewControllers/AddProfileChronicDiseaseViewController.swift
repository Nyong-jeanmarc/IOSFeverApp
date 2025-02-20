//
//  chroniciseaseListViewController.swift
//  FeverApp ios
//
//  Created by user on 8/10/24.
//

import UIKit

class AddProfileChronicDiseaseViewController: UIViewController, UITextFieldDelegate {
    var profilesChronicDiseases : [String]?
    var profileName = AddProfileNameModel.shared.userProfileName ?? "no name"

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet var messageView: UIView!
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var writeHereUITextField: UITextField!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet var nextButton: UIButton!
    
    @IBAction func handleNoAnswerUIButtonClick(_ sender: Any) {
        handleNavigationToAddProfileHeightScreen()

    }
    
    @IBAction func handleNextUIButtonClick(_ sender: Any) {
        profilesChronicDiseases = getProfileChronicDiseases(from: writeHereUITextField)
        giveProfilesChronicDiseaseToAddProfileChronicDiseaseModel()
       
    }
        func getProfileChronicDiseases(from textField: UITextField) -> [String] {
            // Remove leading/trailing whitespace and split by comma
            let diseases = textField.text?.trimmingCharacters(in: .whitespaces)
                .components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            
            return diseases ?? []
        }
    func giveProfilesChronicDiseaseToAddProfileChronicDiseaseModel(){
        AddProfileChronicDiseaseModel.shared.saveProfileChronicDisease(profilesChronicDiseases ?? [""]){
            isSavedSuccessfully in
            if isSavedSuccessfully ?? false{
                self.handleNavigationToAddProfileHeightScreen()
            }else{
                
                // Show alert popup
                       let alertController = UIAlertController(title: "Failed to save chronic diseases", message: "An error occured please try again", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "retry", style: .default)
                       alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
    }
    func  handleNavigationToAddProfileHeightScreen(){
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
        writeHereUITextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "TEXT_INPUT.PLACEHOLDER", defaultText: "Write here")
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
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
        nextButton.isEnabled = false
        setupUI()
        writeHereUITextField.layer.borderWidth = 0.5
        writeHereUITextField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        nextButton.configuration?.background.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1)
                // TEXFIELD
    
        writeHereUITextField.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: writeHereUITextField.frame.height))
        writeHereUITextField.leftView = paddingView
        writeHereUITextField.leftViewMode = .always

        // Ajoutez cette ligne pour décaler le placeholder
        writeHereUITextField.attributedPlaceholder = NSAttributedString(string: writeHereUITextField.placeholder ?? "", attributes: [NSAttributedString.Key.kern: 0])
        
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.5
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        messageView.layer.shadowColor = UIColor.lightGray.cgColor
        messageView.layer.shadowOpacity = 0.3
        messageView.layer.shadowRadius = 5
        messageView.layer.shadowOffset = CGSize(width: 0, height: 2)
            // Set corner radius for the views
        
            topView.layer.cornerRadius = 20
        
        
            bottomView.layer.cornerRadius = 20
     
        
        writeHereUITextField.layer.cornerRadius = 8
        writeHereUITextField.layer.masksToBounds = true
            
        skipButton.layer.cornerRadius = 8
       skipButton.layer.masksToBounds = true
        
        skipButton.layer.borderWidth = 0.5
        skipButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        nextButton.layer.cornerRadius = 8
       nextButton.layer.masksToBounds = true
        
        
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let newText = text + string
        if newText.isEmpty || newText == "" {
            nextButton.configuration?.background.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1)
        } else {
            nextButton.configuration?.background.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1)
            updateNextUIButtonIsEnabledPropertyToTrue()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            nextButton.configuration?.background.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1)
            writeHereUITextField.isEnabled = false
        }else{
            nextButton.configuration?.background.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1)
            updateNextUIButtonIsEnabledPropertyToTrue()
        }
    }
    func updateNextUIButtonIsEnabledPropertyToTrue(){
        nextButton.isEnabled = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard when the "Done" key is clicked
            textField.resignFirstResponder()
            return true
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
    func setupUI() {
        messageView.layer.cornerRadius = 10
        messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        messageLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.CHRONIC_DISEASES-OTHER.QUESTION",  defaultText: "What chronic diseases does \(profileName) have? Please list all separated by commas e-g Test,Test2,Test3").replacingOccurrences(of: "{{name}}", with: profileName)
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
        skipButton.setAttributedTitle(skipButtonTitle, for: .normal)
        
    
    
    }
    
    
    
      
    }

    





