//
//  ChooseDateOfBirthViewController.swift
//  FeverApp ios
//
//  Created by NEW on 06/08/2024.
//
import UIKit

class CustomDatePickerView: UIView{

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        // Fetch the user's selected language
           let appDelegate = UIApplication.shared.delegate as? AppDelegate
           let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English
        picker.locale = Locale(identifier: userLanguageCode) // Use the fetched language
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addPanGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        addPanGestureRecognizer()
    }
    private func addPanGestureRecognizer() {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            addGestureRecognizer(panGestureRecognizer)
        }
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)

            if recognizer.state == .ended {
                if self.frame.minY > self.superview!.bounds.height / 2 {
                    hideView()
                } else {
                    showView()
                }
            }
        }
    private func hideView() {
           UIView.animate(withDuration: 0.5) {
               self.transform = CGAffineTransform(translationX: 0, y: self.superview!.bounds.height)
           }
       }
    private func showView() {
        NSLayoutConstraint.deactivate(hideConstraints)
            UIView.animate(withDuration: 0.5) {
                self.transform = .identity
            }
        }
    private func setupView() {
                self.layer.cornerRadius = 20
                self.layer.masksToBounds = true

        self.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
}
var hideConstraints: [NSLayoutConstraint] = []
var showConstraints: [NSLayoutConstraint] = []
class AddProfileDateOfBirthViewController : UIViewController, UITextFieldDelegate{
    let profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
   var ProfileDateOfBirth = ""
    @IBOutlet var enterDateOfBirthUITextField: UITextField!
    
    @IBOutlet var messageLabel: UILabel!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var inputArea: UITextField!
    
    @IBAction func buttonAction(_ sender: Any) {
        showDatePickerAnimated()
      
    }
    
    
    
    @IBAction func handleNextButtonClickEvent(_ sender: Any) {
        getProfileDateOfBirth()
        if validateDate(ProfileDateOfBirth){
            giveProfileDateOfBirthToAddProfileDateOfBirthModel()
        }else{
            // Show alert popup
                   let alertController = UIAlertController(title: "Please enter a valid date", message: "", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "retry", style: .default)
                   alertController.addAction(retryAction)
            self.present(alertController, animated: true)
        }
       
    }
    
    @IBOutlet weak var chatView: UIView!
    
    
    @IBAction func hideView(_ sender: Any) {
        hideDatePickerView()
    }
    
    
    private let customDatePickerView: CustomDatePickerView = {
            let view = CustomDatePickerView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        override func viewDidLoad() {
            super.viewDidLoad()
            topView.layer.shadowColor = UIColor.lightGray.cgColor
            topView.layer.shadowOpacity = 0.3
            topView.layer.shadowRadius = 2
            topView.layer.shadowOffset = CGSize(width: 0, height: 2)
            messageLabel.text =  TranslationsViewModel.shared.getTranslation(key: "PROFILE.DATE_OF-BIRTH.QUESTION", defaultText: "When was {{name}} born?").replacingOccurrences(of: "{{name}}", with: profileName)
            enterDateOfBirthUITextField.isEnabled = false
            inputArea.attributedPlaceholder = NSAttributedString(
                string: TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.DOB.PLACEHOLDER", defaultText: "Enter date of birth"),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14), // Set the desired font size
                    .foregroundColor: UIColor.lightGray // Optional: Set the placeholder color
                ]
            )

            nextButton.isEnabled = false
            nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
            enterDateOfBirthUITextField.delegate = self
            chatView.layer.shadowColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1).cgColor
            chatView.layer.shadowOpacity = 0.2
            chatView.layer.shadowRadius = 4
            chatView.layer.shadowOffset = CGSize(width: 0, height: 4)
            topView.layer.cornerRadius = 20
            bottomView.layer.cornerRadius = 14
            nextButton.layer.cornerRadius = 10
            enterDateOfBirthUITextField.layer.cornerRadius = 5
            chatView.layer.cornerRadius = 8
                chatView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            enterDateOfBirthUITextField.layer.shadowColor = UIColor.gray.cgColor
            enterDateOfBirthUITextField.layer.shadowOpacity = 0.3
            enterDateOfBirthUITextField.layer.shadowRadius = 2
            enterDateOfBirthUITextField.layer.shadowOffset = CGSize(width: 0, height: 2)
            customDatePickerView.tintColor = .gray
            setupCustomDatePickerView()
            customDatePickerView.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            enterDateOfBirthUITextField.defaultTextAttributes = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.black, // Text color
                .kern: 1.0, // Letter spacing
                .backgroundColor: UIColor.clear // Background color (if needed)
            ]
            
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
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
        enterDateOfBirthUITextField.text = dateFormatter.string(from: sender.date)
        enterDateOfBirthUITextField.textColor = .black
        updateNextButtonBackgroundColorToSkyBlue()
        updateNextButtonIsEnabledToTrue()
       }
    func updateNextButtonIsEnabledToTrue(){
        nextButton.isEnabled = true
    }
    func updateNextButtonBackgroundColorToSkyBlue(){
        nextButton.backgroundColor = UIColor(red: 165/255, green: 189/255, blue: 242/255, alpha: 1)
    }
    func showDatePickerAnimated() {
        showConstraints = [
               customDatePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               customDatePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               customDatePickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               customDatePickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
           ]
               NSLayoutConstraint.deactivate(hideConstraints)
               NSLayoutConstraint.activate(showConstraints)
        customDatePickerView.transform = .identity // Remove the transform
               UIView.animate(withDuration: 0.5) {
                   self.view.layoutIfNeeded()
               }
        
          
    }
    func hideDatePickerView() {
        hideConstraints = [
              customDatePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
              customDatePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
              customDatePickerView.topAnchor.constraint(equalTo: view.bottomAnchor),
              customDatePickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
          ]
          customDatePickerView.transform = .identity // Remove the transform
        UIView.animate(withDuration: 0.5) { [self] in
              self.view.layoutIfNeeded()
              customDatePickerView.transform = CGAffineTransform(translationX: 0, y: self.customDatePickerView.superview!.bounds.height)
              
          }
    }
    func validateDate(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            return false
        }
        return date <= Date()
    }
    func getProfileDateOfBirth(){
        ProfileDateOfBirth = enterDateOfBirthUITextField.text ?? ""
    }
    func giveProfileDateOfBirthToAddProfileDateOfBirthModel(){
        print(AddProfileNameModel.shared.userProfileName!)
//        print(userDataModel.shared.userId!)
        print(ProfileDateOfBirth)
        AddProfileDateOfBirthModel.shared.saveProfileDateOfBirth(ProfileDateOfBirth){
            isSavedSuccessfully in
            if isSavedSuccessfully!{
                self.handleNavigationToAddProfileGenderScreen()
            }else{
                // Show alert popup
                       let alertController = UIAlertController(title: "Failed to login", message: "An error occured please try again", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "retry", style: .default)
                       alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
    }
    func handleNavigationToAddProfileGenderScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let AddProfileGenderVC = storyboard.instantiateViewController(withIdentifier: "genderProfile") as? AddProfilesGenderViewController {
            self.navigationController?.pushViewController(AddProfileGenderVC, animated: true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard when the "Done" key is clicked
            textField.resignFirstResponder()
            return true
        }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showDatePickerAnimated()
        updateNextButtonIsEnabledToTrue()
        
        
       }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideDatePickerView()
        updateNextButtonIsEnabledToTrue()
    }
    
        private func setupCustomDatePickerView() {
            let horizontalBar = UIView()
            horizontalBar.backgroundColor = .gray
            horizontalBar.layer.cornerRadius = 5
            horizontalBar.translatesAutoresizingMaskIntoConstraints = false

            customDatePickerView.addSubview(horizontalBar)

            NSLayoutConstraint.activate([
                horizontalBar.topAnchor.constraint(equalTo: customDatePickerView.topAnchor, constant: 10), // Add a 10-point space
                horizontalBar.centerXAnchor.constraint(equalTo: customDatePickerView.centerXAnchor),
                horizontalBar.heightAnchor.constraint(equalToConstant: 5),
                horizontalBar.widthAnchor.constraint(equalToConstant: 40), // Set the width to 100 points
                
            ])
            self.view.addSubview(customDatePickerView)
            customDatePickerView.backgroundColor = .white // Set it here instead
            NSLayoutConstraint.activate([
                customDatePickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                customDatePickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                customDatePickerView.topAnchor.constraint(equalTo: self.view.bottomAnchor),
                customDatePickerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5)
            ])
        }
}

