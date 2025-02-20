
//
//  profileViewController.swift
//  FeverApp ios
//
//  Created by user on 8/6/24.
//
import UIKit




class AddProfileNameViewController: UIViewController, UITextFieldDelegate {
    var userProfileName = ""

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
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 5
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowPath = path.cgPath
            layer.masksToBounds = false
        }
    }
    
    
    @IBOutlet weak var myView1: UIView!
    
    
    
    @IBOutlet weak var myView2: UIView!
    
    
    
    @IBOutlet var EnterNameUITextField: UITextField!
    
    
  
    
    @IBOutlet var NextUIButton: UIButton!
    
    
    
    @IBOutlet var myLogo: UIImageView!
    
    
    @IBAction func handleNextUIButtonClick(_ sender: Any) {
        getUserProfileName()
        giveUserProfileNameToAddProfileNameMode()
    }
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var placeholderLabel: UITextField!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
         
        placeholderLabel.placeholder = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.NAME.PLACEHOLDER", defaultText: "Enter name")
                // TEXFIELD
        EnterNameUITextField.delegate = self
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: EnterNameUITextField.frame.height))
        EnterNameUITextField.leftView = paddingView
        EnterNameUITextField.leftViewMode = .always

        // Ajoutez cette ligne pour décaler le placeholder
        EnterNameUITextField.attributedPlaceholder = NSAttributedString(
            string: EnterNameUITextField.placeholder ?? "",
            attributes: [
                .foregroundColor: UIColor(hex: "B9BCC8"), // Set placeholder text color to black
                .font: UIFont.systemFont(ofSize: 14), // Set font size to 14
                .kern: 0 // Set the letter spacing
            ]
        )

        
        
        
            myView1.layer.cornerRadius = 25
            myView1.layer.masksToBounds = true
            
            myView2.layer.cornerRadius = 20
            myView2.layer.masksToBounds = true
        
        
        EnterNameUITextField.defaultTextAttributes = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor.black, // Text color
            .kern: 1.0, // Letter spacing
            .backgroundColor: UIColor.clear // Background color (if needed)
        ]
            
            
        EnterNameUITextField.layer.cornerRadius = 5
        EnterNameUITextField.layer.masksToBounds = true
            
   
        EnterNameUITextField.layer.borderColor = UIColor.lightGray.cgColor // Set border color
        EnterNameUITextField.layer.borderWidth = 1.0 // Set border width
               
               // Add shadow properties
        EnterNameUITextField.layer.shadowColor = UIColor.lightGray.cgColor // Shadow color
        EnterNameUITextField.layer.shadowOpacity = 0.5 // Shadow opacity
        EnterNameUITextField.layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset
        EnterNameUITextField.layer.shadowRadius = 4 // Shadow radius
        EnterNameUITextField.layer.masksToBounds = false // Ensure shadow is not clipped
        
        
        
        
        
        NextUIButton.layer.cornerRadius = 5
        NextUIButton.layer.masksToBounds = true
        NextUIButton.backgroundColor = .clear
        nextBtn.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        
        
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 18, height: 18))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = UIColor(hex: "B9BCC8")
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

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard when the "Done" or "return" key is clicked
            textField.resignFirstResponder()
            return true
        }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let newText = text + string
        if newText.isEmpty || newText == "" {
            NextUIButton.configuration?.background.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1)
            NextUIButton.isEnabled = false
        } else {
            NextUIButton.configuration?.background.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1)
            updateNextUIButtonIsEnabledPropertyToTrue()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            NextUIButton.configuration?.background.backgroundColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1)
        }
    }
    
    func updateNextUIButtonIsEnabledPropertyToTrue(){
        NextUIButton.isEnabled = true
      }
      
      func getUserProfileName(){
          userProfileName = EnterNameUITextField.text ?? ""
      }
      func giveUserProfileNameToAddProfileNameMode(){
          AddProfileNameModel.shared.saveUserProfileName(userProfileName){
              isSavedSuccessfully in
              if isSavedSuccessfully!{
                  self.handleNavigationToAddProfileDateOfBirthScreen()
              }else{
                  // Show alert popup
                         let alertController = UIAlertController(title: "Failed to login", message: "An error occured ", preferredStyle: .alert)
                  let retryAction = UIAlertAction(title: "retry", style: .default)
                         alertController.addAction(retryAction)
                  self.present(alertController, animated: true)
              }
          }
          
      }
      func handleNavigationToAddProfileDateOfBirthScreen(){
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let AddProfileDateOfBirthVC = storyboard.instantiateViewController(withIdentifier: "AddDateOfBirth") as? AddProfileDateOfBirthViewController {
              self.navigationController?.pushViewController(AddProfileDateOfBirthVC, animated: true)
          }
      }
    
        func setupUI() {
            let topContainerView = CustomRoundedView()
            topContainerView.backgroundColor = .white
            topContainerView.translatesAutoresizingMaskIntoConstraints = false
       
            
            view.addSubview(topContainerView)
            let topLabel = UILabel()
            topLabel.numberOfLines = 0
            topLabel.text = extractTextInfo(text: TranslationsViewModel.shared.getTranslation(key: "PROFILE.NAME.QUESTION", defaultText: "Children will be referred to in the course of the app, since this app is intended as a fever documentation for children . In case you only want to test the app, please create a profile named “TEST” so that the collected data can be discarded."), defaultText: "Children will be referred to in the course of the app, since this app is intended as a fever documentation for children . In case you only want to test the app, please create a profile named “TEST” so that the collected data can be discarded.").1
            topLabel.font = .systemFont(ofSize: 13)
            topLabel.translatesAutoresizingMaskIntoConstraints = false
            topContainerView.addSubview(topLabel)
            
            let bottomContainerView = CustomRoundedView()
            bottomContainerView.backgroundColor = .white
            bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bottomContainerView)
            
            let bottomLabel = UILabel()
            bottomLabel.numberOfLines = 0
            bottomLabel.textColor = .black
            bottomLabel.text = extractTextInfo(text:TranslationsViewModel.shared.getTranslation(key: "PROFILE.NAME.QUESTION", defaultText: "Now please enter the first name of the family member you are monitoring"), defaultText: "Now please enter the first name of the family member you are monitoring").0
            bottomLabel.font = .systemFont(ofSize: 13)
            bottomLabel.translatesAutoresizingMaskIntoConstraints = false
            bottomContainerView.addSubview(bottomLabel)
            myLogo.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                topContainerView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: -10),
                   topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                   topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -155),
                   topContainerView.heightAnchor.constraint(equalToConstant: 200),
                
                topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 5),
                topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
                topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
                topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -5),
                
                bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 10),
                bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
                bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -155),
                bottomContainerView.heightAnchor.constraint(equalToConstant: 96),
                bottomContainerView.bottomAnchor.constraint(equalTo: EnterNameUITextField.topAnchor, constant: -20),
                bottomLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 10),
                bottomLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
                bottomLabel.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
                bottomLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -10),
                
                //myImage
                myLogo.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),
                myLogo.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: -37),
                myLogo.widthAnchor.constraint(equalToConstant: 30), // ajustez la largeur de l'image
                myLogo.heightAnchor.constraint(equalToConstant: 30) // ajustez la hauteur de l'image
            
            ])

        }
    
    func resizeImage(image: UIImage, to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    @objc func handleBackButtonTap() {
        print ("Add profile name back button tapped")
//        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
      }
    
    }

func extractTextInfo(text: String, defaultText: String) -> (String, String) {
    // Extract the text between <b> and </b>
    let regexPattern = "<b>(.*?)</b>"
    var textBetweenBTags = defaultText
    var textAfterBTag = defaultText

    do {
        let regex = try NSRegularExpression(pattern: regexPattern, options: [])
        if let match = regex.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)) {
            if let range = Range(match.range(at: 1), in: text) {
                textBetweenBTags = String(text[range])
            }
        }
    } catch {
        print("Regex error: \(error.localizedDescription)")
    }

    // Extract the text after </b>
    let splitText = text.components(separatedBy: "</b>")
    if splitText.count > 1 {
        textAfterBTag = splitText[1].trimmingCharacters(in: .whitespacesAndNewlines)
    }

    return (textBetweenBTags, textAfterBTag)
}
