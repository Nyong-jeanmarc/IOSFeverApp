//
//  HeightViewController.swift
//  FeverApp ios
//
//  Created by user on 8/13/24.
//

import UIKit

class AddProfileHeightViewController: UIViewController, UITextFieldDelegate {
    var profilesHeight : Float?
    let profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var messageView: UIView!
    
    
    @IBOutlet var WriteHereUITextField: UITextField!
    
    
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet var noAnswerUIButton: UIButton!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func handleNextUIButtonClick(_ sender: Any) {
        getProfileHeight()
        giveProfilesHeightToAddProfileHeightModel()
        
    }
    @IBAction func handleNoAnswerUIButtonClick(_ sender: Any) {
        handleNavigationToAddProfileWeightScreen()
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
    func getProfileHeight(){
        let heightTextFieldText = WriteHereUITextField.text// User-entered height in cm

        if let heightMeters = convertHeightCMtoMeters(heightTextFieldText ?? "") {
            profilesHeight = heightMeters
            print("Profile Height: \(profilesHeight!) meters")
        } else {
            print("Invalid height input")
        }
    }
    func convertHeightCMtoMeters(_ heightCM: String) -> Float? {
        guard let heightFloat = Float(heightCM) else {
            return nil
        }
        
        return heightFloat
    }
    func validateProfileHeight() -> Bool{
        if profilesHeight! >= 40{
          return true
        }else{
            return false
        }
    }
    func giveProfilesHeightToAddProfileHeightModel(){
       
        if validateProfileHeight(){
            AddProfileHeightModel.shared.saveProfilesHeight(profilesHeight!){
                isSavedSuccessfully in
                if isSavedSuccessfully!{
                    self.handleNavigationToAddProfileWeightScreen()
                }else{
                    // Show alert popup
                    let alertController = UIAlertController(title: "failed to save height", message: "An error occurred please try again", preferredStyle: .alert)
                    let retryAction = UIAlertAction(title: "retry", style: .default)
                    alertController.addAction(retryAction)
                    self.present(alertController, animated: true)
                }
            }
        }else{
            // Show alert popup
            let alertController = UIAlertController(title: TranslationsViewModel.shared.getTranslation(key: "HEIGHT_INPUT.WARNING.MESSAGE", defaultText: "Check the values you entered. They are unrealistic! "), message: "", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close"), style: .default)
            alertController.addAction(retryAction)
            self.present(alertController, animated: true)
        }
    }
    func  handleNavigationToAddProfileWeightScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let AddProfileWeightVC = storyboard.instantiateViewController(withIdentifier: "ProfileWeight") as? AddProfileWeightViewController {
            self.navigationController?.pushViewController(AddProfileWeightVC, animated: true)
        }
    }
    func updateNextUIButtonIsEnabledPropertyToTrue(){
        nextButton.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WriteHereUITextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "TEXT_INPUT.PLACEHOLDER", defaultText: "Write here")
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.3
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        messageView.layer.shadowColor = UIColor.lightGray.cgColor
        messageView.layer.shadowOpacity = 0.3
        messageView.layer.shadowRadius = 5
        messageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
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
        nextButton.isEnabled = false
        WriteHereUITextField.layer.borderWidth = 0.5
        WriteHereUITextField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        nextButton.configuration?.background.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1)
                // TEXFIELD
        WriteHereUITextField.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: WriteHereUITextField.frame.height))
        WriteHereUITextField.leftView = paddingView
        WriteHereUITextField.leftViewMode = .always

        // Ajoutez cette ligne pour décaler le placeholder
        WriteHereUITextField.attributedPlaceholder = NSAttributedString(string: WriteHereUITextField.placeholder ?? "", attributes: [NSAttributedString.Key.kern: 0])
        
        
    
        
            // Set corner radius for the views
        
            topView.layer.cornerRadius = 25
        
        
            bottomView.layer.cornerRadius = 25
            bottomView.layer.masksToBounds = true
        
        WriteHereUITextField.layer.cornerRadius = 8
        WriteHereUITextField.layer.masksToBounds = true
            
        noAnswerUIButton.layer.cornerRadius = 8
        noAnswerUIButton.layer.masksToBounds = true
        
        noAnswerUIButton.layer.borderWidth = 0.5
        noAnswerUIButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        nextButton.layer.cornerRadius = 8
       nextButton.layer.masksToBounds = true
        
        
        
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
       }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard when the "Done" key is clicked
            textField.resignFirstResponder()
            return true
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
            nextButton.isEnabled = false
        }else{
            updateNextUIButtonIsEnabledPropertyToTrue()
        }
    }
    
    
    
    
    func setupUI() {
        messageLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.HEIGHT.QUESTION",defaultText: "How tall is {{name}} in cm?").replacingOccurrences(of: "{{name}}", with: profileName)
        messageView.layer.cornerRadius = 10
        messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    
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
        noAnswerUIButton.setAttributedTitle(skipButtonTitle, for: .normal)
        

      
    }
    
    
    
      
    }
