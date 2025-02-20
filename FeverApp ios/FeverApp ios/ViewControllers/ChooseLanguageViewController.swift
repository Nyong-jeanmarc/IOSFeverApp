//
//  ViewController.swift
//  FeverApp ios
//
//  Created by NEW on 15/07/2024.
//

import UIKit
import CoreData
/// Custom UITableViewCell to display language options.
class LanguageCell: UITableViewCell {
    // Label to display the language name
    let languageLabel = UILabel()
    // Button to display a checkbox
    let checkBox = UIButton()

    
    // Initializer for creating the cell programmatically
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        // Set up contraints and add subviews
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(languageLabel)
        contentView.addSubview(checkBox)

        languageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        languageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 24).isActive = true

        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkBox.tintColor = UIColor.gray
    }

    // Required initializer for creating the cell from a storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


/// ViewController to allow the user to choose a language.
class ChooseLanguageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate  {
    
    
    @IBOutlet weak var yourlanguagelLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var selectedLanguage = ""
    // MARK: - Outlets
    @IBOutlet weak var dropButton: UIButton!
    // MARK: - Action
    /// Toggles the visibility of the table view when the drop button is pressed.
    ///
    ///  - Parameter sender: The button that trigged this action.
    @IBAction func dropButtonAction(_sender: Any) {
        tableView.isHidden = !tableView.isHidden
    }
    
    
    @IBAction func handleNextButtonUIclick(_ sender: Any) {
        if ChooseLanguageModel.shared.languageSavedToServerSuccesfully {
            // Save the selected language
            ChooseLanguageModel.shared.saveLanguage(selectedLanguage)
            handleNavigationToReadDataProtectionAgreementScreen()
        }else{
            // Show alert popup
                   let alertController = UIAlertController(title: "", message: "An error occured please check your internet connection and try again", preferredStyle: .alert)
                   let okayAction = UIAlertAction(title: "OK", style: .default)
                   alertController.addAction(okayAction)
                   present(alertController, animated: true)
            }
    }
    
    @IBOutlet var bottomView: UIView!
    
    
    @IBOutlet var topView: UIView!
    
    
    @IBOutlet var messageView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chooseYourLanguageTitleLabel: UITextField!
        
    // MARK: - Properties
//    let languages = ["Deutsch","English","Русский","العربية","فارسی","Türkçe","Français","Italiano","Polski","Nederlands"]
    let languages =  AppUtils.supportedLanguages.map { $0.languageName }
    var checkedLanguages: [Bool] = []

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        yourlanguagelLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "LANGUAGE.SELECT.TEXT", defaultText: "Your language")
        nextButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for:  .normal)
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.3
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        messageView.layer.shadowColor = UIColor.lightGray.cgColor
        messageView.layer.shadowOpacity = 0.3
        messageView.layer.shadowRadius = 5
        messageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 18, height: 18))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = .gray
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
        bottomView.layer.cornerRadius = 16
        topView.layer.cornerRadius = 20
        messageView.layer.cornerRadius = 16
        chooseYourLanguageTitleLabel.isEnabled = false
        super.viewDidLoad()
        // Create a custom UILabel for the title
            let titleLabel = UILabel()
        titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "LANGUAGE.BOTTOMSHEET.CHOOSE", defaultText: "Choose your language")
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            titleLabel.sizeToFit() // Adjust the size to fit the content
        
            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
        
        checkedLanguages = Array(repeating: false, count: languages.count)
        setTextFieldTextToDeviceLanguage()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: chooseYourLanguageTitleLabel.frame.height))
        chooseYourLanguageTitleLabel.leftView = paddingView
        chooseYourLanguageTitleLabel.leftViewMode = .always
        chooseYourLanguageTitleLabel.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        chooseYourLanguageTitleLabel.inputView = UIView()
        chooseYourLanguageTitleLabel.isUserInteractionEnabled = false
        chooseYourLanguageTitleLabel.layer.borderWidth = 1
        chooseYourLanguageTitleLabel.layer.cornerRadius = 10
        chooseYourLanguageTitleLabel.layer.borderColor = UIColor.lightGray.cgColor
        chooseYourLanguageTitleLabel.delegate = self
        
        // Set up the table view
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LanguageCell.self, forCellReuseIdentifier: "LanguageCell")

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        tableView.layer.cornerRadius = 20
           tableView.layer.masksToBounds = true
       
        // Set up the table view header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 70))
          headerView.backgroundColor = .white
        let topBar = UIView()
        topBar.backgroundColor = UIColor.gray
        headerView.addSubview(topBar)
        
        let tableTitleLabel = UILabel(frame: CGRect(x: 16, y: 15, width: headerView.bounds.width - 32, height: headerView.bounds.height))
        tableTitleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "LANGUAGE.BOTTOMSHEET.CHOOSE", defaultText: "Choose your language")
        tableTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
          headerView.addSubview(tableTitleLabel)
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.darkGray
        closeButton.addTarget(self, action: #selector(hideTableView), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        topBar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12).isActive = true
        topBar.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.12).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
          
        tableView.tableHeaderView = headerView
        
      }
    func resizeImage(image: UIImage, to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    func setTextFieldTextToDeviceLanguage(){
        chooseYourLanguageTitleLabel.text = defaultLanguage
        if let index = languages.firstIndex(of: defaultLanguage) {
            checkedLanguages[index] = true
        }
    }
    @objc func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Helper Methods
    /// Hides the table view.
     @objc func hideTableView() {
          tableView.isHidden = true
       
     }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = false
       }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath) as! LanguageCell

        cell.languageLabel.text = languages[indexPath.row]

        if checkedLanguages[indexPath.row] {
            cell.checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
       
        } else {
            cell.checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        }

        return cell
    }
    @objc func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func handleNavigationToReadDataProtectionAgreementScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let DataProtectionVC = storyboard.instantiateViewController(withIdentifier: "protectionData") as? protectionDataViewController {
            self.navigationController?.pushViewController(DataProtectionVC, animated: true)
        }
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = languages[indexPath.row]
        chooseYourLanguageTitleLabel.text = selectedLanguage
        
       
        // Deselect all checkboxes
        for i in 0..<checkedLanguages.count {
            checkedLanguages[i] = false
        }
        
        // Select the current checkbox
        checkedLanguages[indexPath.row] = true
        
        // Reload the table view to update the checkboxes
        tableView.reloadData()
        tableView.isHidden = true
    }

}



