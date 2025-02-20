//  settingViewController.swift
//  FeverApp ios
//
//  Created by user on 9/19/24.
//

import UIKit


class settingViewController: UIViewController{
    
    var modalView: UIView? // Modal view for language selection
    var dimmingView: UIView? // Dimming view for background
    var checkBoxButtons: [UIButton] = [] // Store checkboxes
    var selectedLanguage: String?
    var languageSelector: UIButton?// Initialize this in code
    
    let languages = AppUtils.supportedLanguages.map { $0.languageName }
    
    var languageLabel: UILabel!
    var familyCodeLabel: UILabel!
    var darkModeLabel:UILabel!


    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var settingdTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        // Load the selected language from Core Data
        loadSelectedLanguage()
        
        settingdTitle.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "SETTINGS.SETTING", defaultText: "Settings")
        
            
            topView.layer.cornerRadius = 20
            topView.layer.masksToBounds = true
            
            mainView.layer.cornerRadius = 20
            mainView.layer.masksToBounds = true
            
            for (index, _) in languages.enumerated() {
                let checkBox = UIButton()
                checkBox.tag = index
                // ...
            }
            // Section: Language
            let languageSection = UIView()
            languageSection.backgroundColor = .white
            
            
        let languageLabel = UILabel()
        self.languageLabel = languageLabel
        languageLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.LANGUAGE", defaultText: "Language")
            languageLabel.font = .systemFont(ofSize: 16)
            languageSection.addSubview(languageLabel)
            
            let languageSelector = UIButton(type: .system)
            languageSelector.tintColor = .black
            languageSelector.backgroundColor = .white
            languageSelector.layer.cornerRadius = 5
            
            
            // Configure button with text and image
            var config = UIButton.Configuration.plain()
            config.title = selectedLanguage
            config.image = UIImage(named: "ic_drop_down")
            config.imagePlacement = .trailing
            config.imagePadding = 8
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            languageSelector.configuration = config
            
            languageSelector.addTarget(self, action: #selector(languageSelectorTapped), for: .touchUpInside)
            languageSelector.titleLabel?.numberOfLines = 1
            languageSelector.titleLabel?.lineBreakMode = .byTruncatingTail
            
        self.languageSelector = languageSelector // Assign to the class variable
        
            view.addSubview(languageSelector)
            // Add the button and the section to the view hierarchy
            view.addSubview(languageSection) // Assuming languageSection is a UIView
            languageSection.addSubview(languageSelector) // Add languageSelector inside languageSection
            
            // Constraints for button size and position
            languageSelector.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                languageSelector.trailingAnchor.constraint(equalTo: languageSection.trailingAnchor, constant: -1),
                languageSelector.centerYAnchor.constraint(equalTo: languageSection.centerYAnchor),
                languageSection.widthAnchor.constraint(equalToConstant: 150),
                languageSelector.widthAnchor.constraint(equalToConstant: 150),  // Adjust width
                languageSelector.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            let separator1 = UIView()
            separator1.backgroundColor = .lightGray
            mainView.addSubview(separator1)
            separator1.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                separator1.topAnchor.constraint(equalTo: languageSection.bottomAnchor),
                separator1.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
                separator1.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
                separator1.heightAnchor.constraint(equalToConstant: 1),
            ])
            
            // Section: Family Code
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (_, familyCode) = appDelegate.fetchUserData()
        
            let familyCodeSection = UIView()
            familyCodeSection.backgroundColor = .white
            mainView.addSubview(familyCodeSection)
            
            let familyCodeLabel = UILabel()
        self.familyCodeLabel = familyCodeLabel
        familyCodeLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.USERCODE", defaultText: "Family code")
            familyCodeLabel.font = .systemFont(ofSize: 16)
            familyCodeSection.addSubview(familyCodeLabel)
            
            let familyCodeField = UITextField()
            familyCodeField.text = familyCode
            familyCodeField.font = .systemFont(ofSize: 16)
            familyCodeField.borderStyle = .none
            familyCodeField.isEnabled = false
        familyCodeField.backgroundColor = .white
            familyCodeSection.addSubview(familyCodeField)
            
            let copyIcon = UIButton()
            copyIcon.setImage(UIImage(named: "ic_copy"), for: .normal)
            copyIcon.addTarget(self, action: #selector(copyCode), for: .touchUpInside)
            familyCodeSection.addSubview(copyIcon)
            
            let separator2 = UIView()
            separator2.backgroundColor = .lightGray
            mainView.addSubview(separator2)
            
            // Section: Dark Mode
            let darkModeSection = UIView()
            darkModeSection.backgroundColor = .white
            mainView.addSubview(darkModeSection)
            
            let darkModeLabel = UILabel()
        self.darkModeLabel = darkModeLabel
        darkModeLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "SETTINGS.DARKMODE", defaultText: "Dark mode")
            darkModeLabel.font = .systemFont(ofSize: 16)
            darkModeSection.addSubview(darkModeLabel)
            
            let darkModeSwitch = UISwitch()
            darkModeSwitch.isOn = false
            darkModeSwitch.addTarget(self, action: #selector(toggleDarkMode), for: .valueChanged)
            darkModeSection.addSubview(darkModeSwitch)
            
            // Auto Layout
            languageSection.translatesAutoresizingMaskIntoConstraints = false
            languageLabel.translatesAutoresizingMaskIntoConstraints = false
            familyCodeSection.translatesAutoresizingMaskIntoConstraints = false
            familyCodeLabel.translatesAutoresizingMaskIntoConstraints = false
            familyCodeField.translatesAutoresizingMaskIntoConstraints = false
            copyIcon.translatesAutoresizingMaskIntoConstraints = false
            separator2.translatesAutoresizingMaskIntoConstraints = false
            darkModeSection.translatesAutoresizingMaskIntoConstraints = false
            darkModeLabel.translatesAutoresizingMaskIntoConstraints = false
            darkModeSwitch.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                languageSection.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 20),
                languageSection.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                languageSection.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
                languageSection.heightAnchor.constraint(equalToConstant: 50),
                
                languageLabel.leadingAnchor.constraint(equalTo: languageSection.leadingAnchor, constant: 16),
                languageLabel.centerYAnchor.constraint(equalTo: languageSection.centerYAnchor),
                
                familyCodeSection.topAnchor.constraint(equalTo: separator1.bottomAnchor),
                familyCodeSection.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                familyCodeSection.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
                familyCodeSection.heightAnchor.constraint(equalToConstant: 50),
                
                familyCodeLabel.leadingAnchor.constraint(equalTo: familyCodeSection.leadingAnchor, constant: 16),
                familyCodeLabel.centerYAnchor.constraint(equalTo: familyCodeSection.centerYAnchor),
                
                familyCodeField.trailingAnchor.constraint(equalTo: familyCodeSection.trailingAnchor, constant: -40),
                familyCodeField.centerYAnchor.constraint(equalTo: familyCodeSection.centerYAnchor),
                familyCodeField.widthAnchor.constraint(equalToConstant: 80),
                
                copyIcon.trailingAnchor.constraint(equalTo: familyCodeField.trailingAnchor, constant: 20),
                copyIcon.centerYAnchor.constraint(equalTo: familyCodeSection.centerYAnchor),
                
                separator2.topAnchor.constraint(equalTo: familyCodeSection.bottomAnchor),
                separator2.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
                    separator2.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
                separator2.heightAnchor.constraint(equalToConstant: 1),
                
                darkModeSection.topAnchor.constraint(equalTo: separator2.bottomAnchor),
                darkModeSection.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                darkModeSection.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
                darkModeSection.heightAnchor.constraint(equalToConstant: 50),
                
                darkModeLabel.leadingAnchor.constraint(equalTo: darkModeSection.leadingAnchor, constant: 16),
                darkModeLabel.centerYAnchor.constraint(equalTo: darkModeSection.centerYAnchor),
                
                darkModeSwitch.trailingAnchor.constraint(equalTo: darkModeSection.trailingAnchor, constant: -16),
                darkModeSwitch.centerYAnchor.constraint(equalTo: darkModeSection.centerYAnchor),
            ])
        // Observe language change notification
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: NSNotification.Name("LanguageChanged"), object: nil)
        
        // update the UI
        updateLanguage()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
    
    @objc func backButtonTapped() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "rhfyjf")
        viewController?.modalPresentationStyle = .fullScreen
        self.present(viewController!, animated: true, completion: nil)
    }
    
    
    
    deinit {
        // Remove observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("LanguageChanged"), object: nil)
    }
    @objc func updateLanguage() {
        // Fetch the current selected language from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, currentLanguage) = appDelegate.fetchUserLanguage()
        
//        selectedLanguage = currentLanguage
        if let currentlang = currentLanguage {
            selectedLanguage = currentlang
        }

        // Update the UI elements with the new translations
        let appVersion = "1.14.1"
        let translatedText = TranslationsViewModel.shared.getTranslation(key:"MENU.APP_VERSION", defaultText: "App version") + " " + appVersion;


        // Update the title of the languageSelector button
        if let config = languageSelector?.configuration {
            var updatedConfig = config // Copy the current configuration
            updatedConfig.title = selectedLanguage // Update the title
            languageSelector?.configuration = updatedConfig // Reassign the updated configuration
        }

        // Update any other UI elements
        if let languageLabel = view.subviews.first(where: { $0 is UILabel }) as? UILabel {
            languageLabel.text = translatedText
            languageLabel.font = .systemFont(ofSize: 16)
        }
        
        // Update the languageLabel text
            languageLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.LANGUAGE", defaultText: "Language")
        
        familyCodeLabel.text = TranslationsViewModel.shared.getTranslation(key: "MENU.USERCODE", defaultText: "Family code")
        
        darkModeLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "SETTINGS.DARKMODE", defaultText: "Dark mode")
        
        settingdTitle.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "SETTINGS.SETTING", defaultText: "Settings")
        
        print("UI updated with new language: \(String(describing: currentLanguage))")
    }
    
    private func loadSelectedLanguage() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (_, currentLanguage) = appDelegate.fetchUserLanguage()

        // Set the selectedLanguage to the current language from Core Data or fallback to "English"
        selectedLanguage = currentLanguage ?? "English"
        print("Loaded selected language from Core Data: \(selectedLanguage ?? "None")")

        // Update the UI with the current selected language
        var config = languageSelector?.configuration
        config?.title = selectedLanguage
        languageSelector?.configuration = config
    }

        @objc func languageSelectorTapped() {
            
            // Add dimming view
            dimmingView = UIView(frame: self.view.bounds)
            dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            guard let dimmingView = dimmingView else { return }
            view.addSubview(dimmingView)
            
            // Add modal view
            modalView = UIView()
            guard let modalView = modalView else { return }
            modalView.backgroundColor = .white
            modalView.layer.cornerRadius = 20
            modalView.layer.masksToBounds = true
            view.addSubview(modalView)
            
            modalView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                modalView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                modalView.heightAnchor.constraint(equalToConstant: 400)
            ])
            
            //Création de la scroll view
            let scrollView = UIScrollView()
            modalView.addSubview(scrollView)
            
            let contentView = UIView()
            scrollView.addSubview(contentView)
            
            // Autolayout pour la scroll view
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: modalView.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: modalView.bottomAnchor),
                
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Assure que le contenu ne dépasse pas la largeur de la scroll view
            ])
            
            
            // Titre et bouton de fermeture
            let titleLabel = UILabel()
            titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "LANGUAGE.BOTTOMSHEET", defaultText: "Choisissez votre langue")
            titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
            contentView.addSubview(titleLabel)
            
            let closeButton = UIButton(type: .system)
            closeButton.setTitle("✖️", for: .normal)
            closeButton.titleLabel?.font = .systemFont(ofSize: 18)
            closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
            contentView.addSubview(closeButton)
            
            
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 1
            stackView.alignment = .fill
            stackView.distribution = .fill
            contentView.addSubview(stackView)
            
            // Ajouter les pays à la stack view
            for (index, country) in languages.enumerated() {
                let container = UIView()
                container.backgroundColor = .white
                
                let checkBox = UIButton()
                checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
                checkBox.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
                checkBox.tintColor = .black
                checkBox.tag =   index
                checkBox.addTarget(self, action:  #selector(checkBoxTapped(_:)), for: .touchUpInside)
                checkBoxButtons.append(checkBox) // Store reference to checkboxes
                container.addSubview(checkBox)
                
                
                let languageLabel = UILabel()
                languageLabel.text = country
                languageLabel.font = .systemFont(ofSize: 16)
                container.addSubview(languageLabel)
                
                // Ligne de séparation
                let separator = UIView()
                separator.backgroundColor = .lightGray
                container.addSubview(separator)
                
                // Autolayout pour le container
                container.translatesAutoresizingMaskIntoConstraints = false
                checkBox.translatesAutoresizingMaskIntoConstraints = false
                languageLabel.translatesAutoresizingMaskIntoConstraints = false
                separator.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    languageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                    languageLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                    
                    checkBox.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
                    checkBox.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                    
                    separator.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    separator.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                    separator.heightAnchor.constraint(equalToConstant: 1),
                    
                    container.heightAnchor.constraint(equalToConstant: 35)
                ])
                
                stackView.addArrangedSubview(container)
            }
            
            // Autolayout pour le titre, le bouton de fermeture et la stack view
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                
                closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                
                stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            ])
            
            
            // Animate modal appearance
            dimmingView.alpha = 0
            modalView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.dimmingView?.alpha = 1
                self.modalView?.alpha = 1
            }
            
            // Tap gesture to close modal
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeModal))
            dimmingView.addGestureRecognizer(tapGesture)
        }
        
        // Fonction pour gérer la sélection des checkboxes
//        @objc func checkBoxTapped(_ sender: UIButton) {
//            print("Checkbox cliqué : \(sender.tag)")
//            
//            // Désélectionner tous les autres checkboxes
//            for checkBox in checkBoxButtons {
//                checkBox.isSelected = false
//            }
//
//            // Sélectionner le checkbox cliqué
//            sender.isSelected = true
//            // Enregistrer la langue sélectionnée
////            ChooseLanguageModel.shared.saveLanguage(selectedLanguage)        // Récupérer l'index du checkbox cliqué
//            let selectedIndex = sender.tag
//            print("Index sélectionné : \(selectedIndex)")
//            
//            // Optionnel: Mettre à jour l'affichage du sélecteur de langue
//                var config = languageSelector?.configuration
//                config?.title = selectedLanguage
//                languageSelector?.configuration = config
//
//
//
//            // Récupérer la langue correspondante
//            let selectedLanguage = languages[selectedIndex]
//            print("Langue sélectionnée : \(selectedLanguage)")
//            
//            // Mettre à jour le titre du languageSelector via UIButton.Configuration
//            languageSelector?.configuration?.title = selectedLanguage
//            
//            // Forcer la mise à jour visuelle du languageSelector
//            languageSelector?.setNeedsLayout()
//            languageSelector?.layoutIfNeeded()
//            
//            // Fermer la modal après sélection
//            closeModal()
//        }
        
    @objc func checkBoxTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        let selectedLanguage = languages[selectedIndex]
        self.selectedLanguage = selectedLanguage

        print("Selected language: \(selectedLanguage)")

        // Save the selected language to Core Data and load translations
        preferencesNetworkManager.shared.saveSelectedLanguage(currentLanguage: selectedLanguage)

        // Update the title of the languageSelector button
        var config = languageSelector?.configuration
        config?.title = selectedLanguage
        languageSelector?.configuration = config

        // Post a notification to update the UI
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)

        // Close the modal view
        closeModal()
    }

        @objc func closeModal() {
            UIView.animate(withDuration: 0.5, animations: {
                self.dimmingView?.alpha = 0
                self.modalView?.alpha = 0
            }) { _ in
                self.dimmingView?.removeFromSuperview()
                self.modalView?.removeFromSuperview()
            }
        }
        
    @objc func copyCode() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (_, familyCode) = appDelegate.fetchUserData()
            UIPasteboard.general.string = familyCode
            print("Code copied to clipboard")
        }
        
        @objc func toggleDarkMode(sender: UISwitch) {
            let isDarkModeEnabled = sender.isOn
            if isDarkModeEnabled {
                // Change to dark mode
                view.window?.overrideUserInterfaceStyle = .dark
            } else {
                // Change to light mode
                view.window?.overrideUserInterfaceStyle = .light
            }
        }
        
    }
