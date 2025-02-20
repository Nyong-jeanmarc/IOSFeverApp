//
//  infoLibraryViewController.swift
//  FeverApp ios
//
//  Created by user on 8/25/24.
//

import  UIKit
class infoLibraryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var topView: UIView!
    
    @IBOutlet weak var infoLibTitle: UILabel!
    
    
    var selectedButton: UIButton?

    let scrollView = UIScrollView()
    let container = UIView()
    var buttons: [UIButton] = []
    @IBOutlet weak var infoLibraryItem: UITabBarItem!
    
    @IBAction func backBtnTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    
    // Back button action
    @objc private func backButtonTapped() {
        // Perform action for the back button, like dismissing the view controller
        // If you're not using a navigation controller, just dismiss
        self.dismiss(animated: true, completion: nil)
    }
    // Creating the search text field
    let searchTextField = UITextField()
    
    // Dismiss the keyboard when the "Done" button is tapped
    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        infoLibraryItem.title  = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL",defaultText: "Info Library")
        infoLibTitle.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL",defaultText: "Info Library")

        
        
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true

       
        // Create a container view for the search text field
                              let searchContainerView = UIView()
                              searchContainerView.translatesAutoresizingMaskIntoConstraints = false
                              searchContainerView.backgroundColor = .white // Optional: Set background color
                          searchContainerView.layer.cornerRadius = 8
                          searchContainerView.layer.shadowColor = UIColor.black.cgColor
                          searchContainerView.layer.shadowOpacity = 0.1
                          searchContainerView.layer.shadowRadius = 5
                          searchContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
                              searchContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
                              
                              // Adding the searchContainerView to the view
                              view.addSubview(searchContainerView)
                              
        
        
        
      
                   
                   // Create a second container view
                   let secondContainer = UIView()
                   secondContainer.translatesAutoresizingMaskIntoConstraints = false
                   secondContainer.backgroundColor = .white
                   secondContainer.layer.cornerRadius = 8
                   secondContainer.layer.shadowColor = UIColor.black.cgColor
                   secondContainer.layer.shadowOpacity = 0.1
                   secondContainer.layer.shadowRadius = 5
                   secondContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
                   secondContainer.heightAnchor.constraint(equalToConstant: 250).isActive = true

                   // Adding the second container view to the view
                   view.addSubview(secondContainer)
        
        // Create a container view for the tableOfContentButton
        let tableOfContentContainerView = UIView()
        tableOfContentContainerView.translatesAutoresizingMaskIntoConstraints = false
        tableOfContentContainerView.backgroundColor = .white
        tableOfContentContainerView.layer.cornerRadius = 8
        tableOfContentContainerView.layer.shadowColor = UIColor.black.cgColor
        tableOfContentContainerView.layer.shadowOpacity = 0.1
        tableOfContentContainerView.layer.shadowRadius = 5
        tableOfContentContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableOfContentContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // Adding the tableOfContentContainerView to the view
        view.addSubview(tableOfContentContainerView)
        
        // Create a container view for the videoButton
        let videoContainerView = UIView()
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        videoContainerView.backgroundColor = .white
        videoContainerView.layer.cornerRadius = 8
        videoContainerView.layer.shadowColor = UIColor.black.cgColor
        videoContainerView.layer.shadowOpacity = 0.1
        videoContainerView.layer.shadowRadius = 5
        videoContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        videoContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // Adding the videoContainerView to the view
        view.addSubview(videoContainerView)
        
        // Create a container view for the basicPrinciplesButton
        let basicPrinciplesContainerView = UIView()
        basicPrinciplesContainerView.translatesAutoresizingMaskIntoConstraints = false
        basicPrinciplesContainerView.backgroundColor = .white
        basicPrinciplesContainerView.layer.cornerRadius = 8
        basicPrinciplesContainerView.layer.shadowColor = UIColor.black.cgColor
        basicPrinciplesContainerView.layer.shadowOpacity = 0.1
        basicPrinciplesContainerView.layer.shadowRadius = 5
        basicPrinciplesContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        basicPrinciplesContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // Adding the basicPrinciplesContainerView to the view
        view.addSubview(basicPrinciplesContainerView)
        
        
        // Creating the tableOfContentButton
        let tableOfContentButton = UIButton()
        tableOfContentButton.translatesAutoresizingMaskIntoConstraints = false
        tableOfContentButton.backgroundColor = .white
        
//        // Configure the tableOfContentButton
//        var config = UIButton.Configuration.plain()
//        config.title = "Table of Content"
//        config.image = UIImage(named: "Icon-17 1")
//        config.imagePlacement = .top
//        config.titleAlignment = .center
//        config.imagePadding = 10
//        config.background.backgroundColor = .white
//        config.attributedTitle = AttributedString("Table of Content", attributes: AttributeContainer([.foregroundColor: UIColor.black]))
//        tableOfContentButton.configuration = config
//        
//        tableOfContentButton.configurationUpdateHandler = { (button: UIButton) in
//            switch button.state {
//            case .normal:
//                config.background.backgroundColor = .white
//            case .highlighted:
//                config.background.backgroundColor = .lightGray
//            default:
//                break
//            }
//            button.configuration = config
//        }
//        
//        tableOfContentButton.configuration = config
//        // Adding the tableOfContentButton to the tableOfContentContainerView
//        tableOfContentContainerView.addSubview(tableOfContentButton)
        var config = UIButton.Configuration.plain()
        config.title = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-LIST.TEXT.1", defaultText: "Table of contents")
        
        let tableimage = UIImage(named: "ic_principle")
        let tablenewSize = CGSize(width: 24, height: 24) // Replace with your desired size
        let tableresizedImage = tableimage?.resize(to: tablenewSize)
        config.image = tableresizedImage
//        config.image = UIImage(named: "ic_info_main")
        config.imagePlacement = .top
        config.titleAlignment = .center
        config.imagePadding = 10
        config.background.backgroundColor = .white

        // Set the font size for the button text
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.systemFont(ofSize: 14), // Adjust font size as needed
            .foregroundColor: UIColor.black
        ])
        config.attributedTitle = AttributedString(TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-LIST.TEXT.1", defaultText: "Table of contents"), attributes: attributes)

        tableOfContentButton.configuration = config

        tableOfContentButton.configurationUpdateHandler = { (button: UIButton) in
            switch button.state {
            case .normal:
                config.background.backgroundColor = .white
            case .highlighted:
                config.background.backgroundColor = .lightGray
            default:
                break
            }
            button.configuration = config
        }
        // Add target action for navigation
        tableOfContentButton.addTarget(self, action: #selector(navigateToTableOfContent), for: .touchUpInside)
        // Adding the tableOfContentButton to the tableOfContentContainerView
        tableOfContentContainerView.addSubview(tableOfContentButton)

        // Creating the videoButton
        let videoButton = UIButton()
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        videoButton.backgroundColor = .white
        
        // Configure the videoButton
        var videoConfig = UIButton.Configuration.plain()
        videoConfig.title = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-LIST.TEXT.2", defaultText: "Videos")
//        videoConfig.image = UIImage(named: "ic_video")
        
        let image = UIImage(named: "ic_video")
        let newSize = CGSize(width: 24, height: 24) // Replace with your desired size
        let resizedImage = image?.resize(to: newSize)
        videoConfig.image = resizedImage
        videoConfig.imagePlacement = .top
        videoConfig.titleAlignment = .center
        videoConfig.imagePadding = 10
        videoConfig.background.backgroundColor = .white
        videoConfig.attributedTitle = AttributedString(TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-LIST.TEXT.2", defaultText: "Videos"), attributes: attributes)
        videoButton.configuration = videoConfig
        

        videoButton.configurationUpdateHandler = { (button: UIButton) in
            switch button.state {
            case .normal:
                videoConfig.background.backgroundColor = .white
            case .highlighted:
                videoConfig.background.backgroundColor = .lightGray
            default:
                break
            }
            button.configuration = videoConfig
        }

        // Add target action for navigation
        videoButton.addTarget(self, action: #selector(navigateToVideo), for: .touchUpInside)
        // Adding the videoButton to the videoContainerView
        videoContainerView.addSubview(videoButton)

        // Creating the basicPrinciplesButton
        let basicPrinciplesButton = UIButton()
        basicPrinciplesButton.translatesAutoresizingMaskIntoConstraints = false
        basicPrinciplesButton.backgroundColor = .white

        // Configure the basicPrinciplesButton
        var basicPrinciplesConfig = UIButton.Configuration.plain()
        basicPrinciplesConfig.title = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-LIST.TEXT.3", defaultText: "Basic principles")
//        basicPrinciplesConfig.image = UIImage(named: "ic_principle")
        
        let basicPrinciplesimage = UIImage(named: "ic_principle")
        let basicPrinciplesnewSize = CGSize(width: 24, height: 24) // Replace with your desired size
        let basicPrinciplesresizedImage = basicPrinciplesimage?.resize(to: basicPrinciplesnewSize)
        basicPrinciplesConfig.image = basicPrinciplesresizedImage
        basicPrinciplesConfig.imagePlacement = .top
        basicPrinciplesConfig.titleAlignment = .center
        basicPrinciplesConfig.imagePadding = 10
        basicPrinciplesConfig.background.backgroundColor = .white
        basicPrinciplesConfig.attributedTitle = AttributedString(TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-LIST.TEXT.3", defaultText: "Basic principles"), attributes: attributes)
        basicPrinciplesButton.configuration = basicPrinciplesConfig

        basicPrinciplesButton.configurationUpdateHandler = { (button: UIButton) in
            switch button.state {
            case .normal:
                basicPrinciplesConfig.background.backgroundColor = .white
            case .highlighted:
                basicPrinciplesConfig.background.backgroundColor = .lightGray
            default:
                break
            }
            button.configuration = basicPrinciplesConfig
        }

        // Add target action for navigation
        basicPrinciplesButton.addTarget(self, action: #selector(navigateToBasicPrinciples), for: .touchUpInside)
        // Adding the basicPrinciplesButton to the basicPrinciplesContainerView
        basicPrinciplesContainerView.addSubview(basicPrinciplesButton)

        // Constraints for the buttons within their container views
        NSLayoutConstraint.activate([
            tableOfContentButton.leadingAnchor.constraint(equalTo: tableOfContentContainerView.leadingAnchor, constant: 8),
            tableOfContentButton.trailingAnchor.constraint(equalTo: tableOfContentContainerView.trailingAnchor, constant: -8),
            tableOfContentButton.topAnchor.constraint(equalTo: tableOfContentContainerView.topAnchor, constant: 8),
            tableOfContentButton.bottomAnchor.constraint(equalTo: tableOfContentContainerView.bottomAnchor, constant: -8),
            
            videoButton.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor, constant: 3),
            videoButton.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor, constant: -3),
            videoButton.topAnchor.constraint(equalTo: videoContainerView.topAnchor, constant: 3),
            videoButton.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor, constant: -3),
            
            basicPrinciplesButton.leadingAnchor.constraint(equalTo: basicPrinciplesContainerView.leadingAnchor, constant: 3),
            basicPrinciplesButton.trailingAnchor.constraint(equalTo: basicPrinciplesContainerView.trailingAnchor, constant: -3),
            basicPrinciplesButton.topAnchor.constraint(equalTo: basicPrinciplesContainerView.topAnchor, constant: 3),
            basicPrinciplesButton.bottomAnchor.constraint(equalTo: basicPrinciplesContainerView.bottomAnchor, constant: -3),
        ])

        
        
        
                 
        searchTextField.placeholder = TranslationsViewModel.shared.getTranslation(key: "INFOS.SEARCH.PLACEHOLDER", defaultText: "Search")
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
                   searchTextField.font = UIFont.systemFont(ofSize: 16)
                   searchTextField.textColor = .black
                   searchTextField.backgroundColor = UIColor.clear // Transparent background
                   searchTextField.layer.cornerRadius = 10
                   searchTextField.layer.borderWidth = 1
                   searchTextField.layer.borderColor = UIColor.lightGray.cgColor
                   searchTextField.translatesAutoresizingMaskIntoConstraints = false
                   searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
                   searchTextField.leftViewMode = .always
                   searchTextField.delegate = self
        // Create a toolbar with a "Done" button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
        let doneButton = UIBarButtonItem(title: TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.DONE", defaultText: "Done"), style: .done, target: self, action: #selector(dismissKeyboard))
           toolbar.setItems([doneButton], animated: false)
        // Set the toolbar as the inputAccessoryView for the painTextField
           searchTextField.inputAccessoryView = toolbar
                   // Adding the search text field to the searchContainerView
                   searchContainerView.addSubview(searchTextField)
                   
        
        
        // Constraints for the search text field within the searchContainerView
                   NSLayoutConstraint.activate([
                       searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
                       searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
                       searchTextField.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 15),
                       searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -8)
                   ])
                   
        // Creating the container view for the search icon
                let rightViewContainer = UIView()
                rightViewContainer.translatesAutoresizingMaskIntoConstraints = false

                // Creating the search icon
                let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
                searchIcon.tintColor = .lightGray
                searchIcon.translatesAutoresizingMaskIntoConstraints = false

                // Add the search icon to the container view
                rightViewContainer.addSubview(searchIcon)

        
        // Adding constraints to the search icon inside the container view
                NSLayoutConstraint.activate([
                    searchIcon.centerYAnchor.constraint(equalTo: rightViewContainer.centerYAnchor),
                    searchIcon.centerXAnchor.constraint(equalTo: rightViewContainer.centerXAnchor),
                    searchIcon.widthAnchor.constraint(equalToConstant: 20),
                    searchIcon.heightAnchor.constraint(equalToConstant: 20)
                ])

        // Setting the right view container as the rightView of the text field
                searchTextField.rightView = rightViewContainer
                searchTextField.rightViewMode = .always

                // Adjusting the right view container size
                rightViewContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
                rightViewContainer.heightAnchor.constraint(equalToConstant: 30).isActive = true

        
                   // Constraints for the searchContainerView within the view
                   NSLayoutConstraint.activate([
                       searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                       searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                       searchContainerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15)
                   ])
        
        
        
        // Constraints for the container views
        NSLayoutConstraint.activate([
            tableOfContentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableOfContentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableOfContentContainerView.topAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: 15),

            videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            videoContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.47), // 45% of the view width
            videoContainerView.topAnchor.constraint(equalTo: tableOfContentContainerView.bottomAnchor, constant: 15),
            videoContainerView.heightAnchor.constraint(equalToConstant: 65), // Set height to 70
               basicPrinciplesContainerView.heightAnchor.constraint(equalTo: videoContainerView.heightAnchor), // Same height as videoContainerView
            basicPrinciplesContainerView.leadingAnchor.constraint(equalTo: videoContainerView.trailingAnchor, constant: 20), // Distance between buttons
            basicPrinciplesContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            basicPrinciplesContainerView.topAnchor.constraint(equalTo: tableOfContentContainerView.bottomAnchor, constant: 15),
            basicPrinciplesContainerView.widthAnchor.constraint(equalTo: videoContainerView.widthAnchor) // Same width as videoContainerView
            
        ])
        
        
        
        
        
        
        
        
        
        
        
        
        
        // Set up scrollView and container
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
//        container.backgroundColor = .clear
        view.addSubview(scrollView)
        scrollView.addSubview(container)
        container.heightAnchor.constraint(equalToConstant: CGFloat(23 * 109)).isActive = true

        // Set up constraints for scrollView and container
        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 355),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 355),
            container.topAnchor.constraint(equalTo: scrollView.topAnchor), // Match directly to scrollView

            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -107),

//            container.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 355),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Create 23 buttons
//        for _ in 1...23{
//            let button = createButton()
//            buttons.append(button)
//            container.addSubview(button)
//        }
        
        for (index, _) in (1...23).enumerated() {
                   let button = createButton()
                   button.tag = index + 1 // Tag starts from 1
                   print("Button created with tag: \(button.tag)") // Debug
                   button.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
                   buttons.append(button)
                   container.addSubview(button)
        }



        // Set up constraints for buttons
//        for (index, button) in buttons.enumerated() {
//            button.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
//                       button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
//                       button.topAnchor.constraint(equalTo: index == 0 ?  scrollView.topAnchor : buttons[index - 1].bottomAnchor, constant: index == 0 ? 0 : 14),
//                button.heightAnchor.constraint(equalToConstant: 95),
//                button.widthAnchor.constraint(equalToConstant: 200)
//            ])
//        }
        
        for (index, button) in buttons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
                button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
                button.topAnchor.constraint(equalTo: index == 0 ? container.topAnchor : buttons[index - 1].bottomAnchor, constant: 14), // Correct reference to container
                button.heightAnchor.constraint(equalToConstant: 95)
            ])
        }
        let heading2 = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.6")
        let heading20 = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.64")
        let parsedHeading2 = heading2.contains(":") ? heading2.split(separator: ":").map { String($0).trimmingCharacters(in: .whitespaces) }.first ?? heading2 : heading2
        let parsedHeading20 = heading20.contains("-") ? heading20.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) }.first ?? heading20 : heading20


        let titleAttributesText = [
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.1"),
            parsedHeading2,
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.7"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.8"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.9"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.10"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.11"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.12"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.20"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.23"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.31"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.32"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.46"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.47"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.48"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.53"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.56"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.62"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.63"),
            parsedHeading20,
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.65"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.66"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.67")
        ]

        let subtitleAttributesText = [
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.1"),
            {
                // Extract text2 by splitting based on ":"
                let heading6 = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.6")
                if heading6.contains(":") {
                    return heading6.split(separator: ":").map { String($0).trimmingCharacters(in: .whitespaces) }[1]
                } else {
                    return ""
                }
            }(),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.85").replacingOccurrences(of: "<strong>", with: ""),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.98"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.112"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.119"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.129"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.140"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.20") ,
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.24"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.256"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.260"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.514") ,
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.541"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.49"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.609"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.647"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.699"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.717"),
            {
                // Extract text20 by splitting based on "-" or "–"
                let heading64 = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.64")
                if heading64.contains("-") {
                    return heading64.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) }[1]
                } else if heading64.contains("–") {
                    return heading64.split(separator: "–").map { String($0).trimmingCharacters(in: .whitespaces) }[1]
                } else {
                    return ""
                }
            }(),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.727"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.730"),
            TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.731")
        ]

        let bottomTextAttributesText = [
            "temperature, for example, to fight ag...",
            "", // Button 2 has no bottom text
            "With their sick child",
            "the following questions during your vi...",
            "inhibits or kills many viruses and bact...",
            "ambient temperatures. No matter if a...",
            "important that you learn to assess ho...",
            "there and how good are they?",
            "fever befor a vaccination",
            "(heartbeat), Respiratory rate, Fever a..",
            "clear cause and without other compla... ",
            "defensive reactionto the first (someti..",
            "signs:, After ther convulsions:",
            "", // Button 14 has no bottom text
            "enemas, Naturopathic remedies, Teas",
            "non-medical measurres. You help him...",
            "and weight of the chiled.",
            "they are active substances that inhibi...",
            "hav disappeared for 2 days, the acut...",
            "", // Button 20 has no bottom text
            "syptoms, please talk to your doctor.",
            "exception. Here the danger of infectio...",
            "Federation Proceedings [internet]. 19...",
            // ... (add more bottom texts here...)
        ]
        
        
        // Configure buttons
        for (index, button) in buttons.enumerated() {
            let imageName = "Rectangle. \(index + 1)"
            // Check if index is within bounds
               if index < titleAttributesText.count && index < subtitleAttributesText.count && index < bottomTextAttributesText.count {
                   configureButton(button, image: UIImage(named: imageName)!, title: titleAttributesText[index], subtitle: subtitleAttributesText[index], bottomText: bottomTextAttributesText[index])
               } else {
                   // Handle out of range error
                   print("Index out of range")
               }
            
            
            
            // Configure the last button separately
            let lastIndex = buttons.count - 1
            let lastButton = buttons[lastIndex]
            lastButton.backgroundColor = .red
            lastButton.setImage(UIImage(named: "Rectangle. 23")!, for: .normal)

            let paragraphStyleTitle = NSMutableParagraphStyle()
            paragraphStyleTitle.lineSpacing = 3.0

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyleTitle
            ]

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6.0

            let subtitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor(red: 0x8E/255.0, green: 0x94/255.0, blue: 0xA7/255.0, alpha: 1.0),
                .paragraphStyle: paragraphStyle
            ]

            let bottomTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.gray
            ]

            let attributedTitle = NSMutableAttributedString(string: "")

            if lastIndex < titleAttributesText.count {
                attributedTitle.append(NSAttributedString(string: "\(titleAttributesText[lastIndex])\n"))
                attributedTitle.addAttributes(titleAttributes, range: NSRange(location: 0, length: titleAttributesText[lastIndex].count + 1))
            }

            if lastIndex < subtitleAttributesText.count {
                let subtitle = subtitleAttributesText[lastIndex]
                let subtitleHeight = subtitle.height(withConstrainedWidth: 200, font: UIFont.systemFont(ofSize: 14))
                let subtitleLines = Int(subtitleHeight / 18) // Assuming 18 is the line height
                var truncatedSubtitle = subtitle
                if subtitleLines > 2 {
                    truncatedSubtitle = String(subtitle.prefix(50)) + "..."
                }
                
                attributedTitle.append(NSAttributedString(string: "\(truncatedSubtitle)"))
                attributedTitle.addAttributes(subtitleAttributes, range: NSRange(location: attributedTitle.length - truncatedSubtitle.count, length: truncatedSubtitle.count))
            }

            lastButton.setAttributedTitle(attributedTitle, for: .normal)
            lastButton.layoutIfNeeded()
            
            
            // Set background color before setting target-action
            button.backgroundColor = .white
            
            button.layer.cornerRadius = 10
            
            // Add shadow
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOpacity = 0.2
            button.layer.shadowRadius = 4
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
            
            // Set content insets
            var config = button.configuration
            config?.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 0)
            button.configuration = config
            
//            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
//            button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
        }
        setupCustomTabBar()
    }
    
    private func setupCustomTabBar() {
        let customTabBar = CustomTabBarView()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.parentViewController = self // Assign the parent view controller
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 88)
        ])
        
        customTabBar.updateTranslations()
        customTabBar.updateTabBarItemColors()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text, !searchText.isEmpty else {
                // If search text is empty, show all buttons again
                updateButtonConstraints(filteredButtons: buttons)
                return
            }
            
            // Filter buttons that start with the search text
            let filteredButtons = buttons.filter { button in
                guard let title = button.attributedTitle(for: .normal)?.string.lowercased() else { return false }
                return title.hasPrefix(searchText.lowercased()) // Use hasPrefix instead of contains
            }
            
            // Update constraints for filtered buttons
            updateButtonConstraints(filteredButtons: filteredButtons)
        scrollToTop()
       }
    // Function to scroll the scrollView to the top
    func scrollToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    func updateButtonConstraints(filteredButtons: [UIButton]) {
        // Remove all existing constraints for the buttons
        for button in buttons {
            button.removeFromSuperview() // Clear buttons from container
        }
        
        // Add filtered buttons back to the container
        for (index, button) in filteredButtons.enumerated() {
            container.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
                button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
                button.topAnchor.constraint(equalTo: index == 0 ? container.topAnchor : filteredButtons[index - 1].bottomAnchor, constant: 14),
                button.heightAnchor.constraint(equalToConstant: 95)
            ])
        }
        // Update container height dynamically
          let newHeight = CGFloat(filteredButtons.count * 109)
          container.heightAnchor.constraint(equalToConstant: newHeight).isActive = true
          
          // Update scrollView content size
          scrollView.contentSize = CGSize(width: scrollView.frame.width, height: newHeight)
        // Refresh the layout
        container.layoutIfNeeded()
    }

    // Define the navigation method
    @objc private func navigateToTableOfContent() {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "tableOfContentViewController")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
    }
    @objc private func navigateToVideo() {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "summaryVideoViewController")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
    }
    @objc private func navigateToBasicPrinciples() {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "basicPrinciplesViewController")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
    }
    func createButton() -> UIButton {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        var config = UIButton.Configuration.plain()
        config.imagePadding = 10
        button.configuration = config
        return button
    }

    func configureButton(_ button: UIButton, image: UIImage, title: String, subtitle: String, bottomText: String) {
        button.setImage(image, for: .normal)

        let paragraphStyleTitle = NSMutableParagraphStyle()
        paragraphStyleTitle.lineSpacing = 3.0
        // Define attributes for different parts of the text
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyleTitle
        ]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0

        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor(red: 0x8E/255.0, green: 0x94/255.0, blue: 0xA7/255.0, alpha: 1.0),
            .paragraphStyle: paragraphStyle
        ]
        let bottomTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor(red: 0x8E/255.0, green: 0x94/255.0, blue: 0xA7/255.0, alpha: 1.0)
        ]

        // Truncate subtitle to two lines
        let subtitleHeight = subtitle.height(withConstrainedWidth: 200, font: UIFont.systemFont(ofSize: 14))
        let subtitleLines = Int(subtitleHeight / 18) // Assuming 18 is the line height
        var truncatedSubtitle = subtitle
        if subtitleLines > 2 {
            truncatedSubtitle = String(subtitle.prefix(50)) + "..."
        }

        // Create a mutable attributed string
        let attributedTitle = NSMutableAttributedString()

        // Append the title
        let titleRangeStart = attributedTitle.length
        attributedTitle.append(NSAttributedString(string: "\(title)\n"))
        attributedTitle.addAttributes(titleAttributes, range: NSRange(location: titleRangeStart, length: title.count))

        // Append the truncated subtitle
        let subtitleRangeStart = attributedTitle.length
        attributedTitle.append(NSAttributedString(string: "\(truncatedSubtitle)"))
        attributedTitle.addAttributes(subtitleAttributes, range: NSRange(location: subtitleRangeStart, length: truncatedSubtitle.count))

        // Set the attributed title to the button
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        // Force the button to layout its subviews
        button.layoutIfNeeded()
    }

    
    @objc func buttonTapped(_ sender: UIButton) {
        sender.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
//        let tag = sender.tag
//        navigateToScreen(forTag: tag)
    }
    
    @objc func infoButtonTapped(_ sender: UIButton) {
        print("Button tapped with tag: \(sender.tag)") // Debug
        sender.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        let tag = sender.tag
        navigateToScreen(forTag: tag)
    }


    let screenMappings: [Int: String] = [
        1: "whatIsFeverViewController",
        2: "InfoLibraryWarningSignsViewController",
        3: "certificateFortheEmployer",
        4: "doctorQuestions",
        5:"InfoLibraryWhyDoseTheBodyRaisTheTemperatureViewController",
        6: "bodyTemperatureAndFeverViewController",
        7: "measureInfoViewController",
        8: "correctMeasureViewController",
        9: "feverAndVaccinationViewController",
        10: "feverWithAccompanyingSymptomsViewContoller",
        11: "feverWithoutAccompanyingSymptomsViewContoller",
        12: "febrileDiseaseViewController",
        13: "febrileConvulsionsInfoViewController",
        14: "InfoLibraryEmergencyViewController",
        15: "holisticSupportViewController",
        16: "compressAndWatchingViewController",
        17: "AntipyreticMedicationViewController",
        18: "antibioticsViewController",
        19: "healthyChildViewController",
        20: "Convalescence",
        21: "frequentFeverViewController",
        22: "AvoidFeverViewController",
        23: "scientificLiterature"
    ]

    private func navigateToScreen(forTag tag: Int) {
        // Get the destination view controller identifier from the screenMappings dictionary
        guard let destinationVCIdentifier = screenMappings[tag] else {
            print("No view controller mapped for button \(tag)")
            return
        }
        
        // Check if the destination view controller identifier is not empty
        if destinationVCIdentifier.isEmpty {
            print("No view controller configured for button \(tag)")
            return
        }
        
        // Instantiate the destination view controller
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: destinationVCIdentifier) else {
            print("Failed to instantiate view controller with identifier \(destinationVCIdentifier)")
            return
        }
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(destinationVC, animated: true)
        } else {
            // Present modally if no navigation controller
            destinationVC.modalPresentationStyle = .fullScreen
            present(destinationVC, animated: true, completion: nil)
        }
    }


    @objc func buttonReleased(_ sender: UIButton) {
        sender.backgroundColor = .white
    }
    
  /*  func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.count ?? 0 > 0 {
            textField.font = UIFont.boldSystemFont(ofSize: 16)
        } else {
            textField.font = UIFont.systemFont(ofSize: 16)
        }
    }*/
    
    
    @objc func buttonTapped() {
           print("Warning signs button tapped")
           // Navigate or perform action
       }
    
  
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        let box = self.boundingRect(with: constraintBox, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(box.height)
    }
}
extension UIImage {
    func resize(to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
