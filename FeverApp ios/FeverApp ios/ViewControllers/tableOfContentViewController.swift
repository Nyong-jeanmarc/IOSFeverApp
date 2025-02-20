//
//  tableOfContentViewController.swift
//  FeverApp ios
//
//  Created by user on 9/7/24.
//

import UIKit

class tableOfContentViewController:UIViewController{
    
    @IBOutlet weak var topView: UIView!
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    let buttonTitles = [
//        "What is fever?", "Warning signs", "Certificate for the employer?",
//        "Questions the doctor might ask", "Why does the body raise the temperature?",
//        "Body temperature and fever", "How often should be measured?",
//        "Correct fever measurement", "Fever and vaccinations",
//        "Fever with accompanying symptoms", "Fever without accompanying symptoms",
//        "Febrile diseases in childhood", "Ferbrile convulsions",
//        "Emergency services", "Holistic support",
//        "Compresses and washings", "Antipyretic medication",
//        "Antibiotics", "When will my child be healthy again?",
//        "Convalescence", "What should i be aware of if fever occurs repeatedly?", "Avoid new fever attacks","Scientific literature, international guidelines and links",
//        // add all the way up to 23 items
//    ]
    
    var heading2: String = ""
    var heading20: String = ""
    var parsedHeading2: String = ""
    var parsedHeading20: String = ""
    var buttonTitles: [String] = []
    @IBAction func backBtnTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    
    // Back button action
    @objc private func backButtonTapped() {
        // Perform action for the back button, like dismissing the view controller
        // If you're not using a navigation controller, just dismiss
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        heading2 = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.6")
               heading20 = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.64")
               parsedHeading2 = heading2.contains(":") ? heading2.split(separator: ":").map { String($0).trimmingCharacters(in: .whitespaces) }.first ?? heading2 : heading2
               parsedHeading20 = heading20.contains("-") ? heading20.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) }.first ?? heading20 : heading20
               
               buttonTitles = [
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
         topView.layer.cornerRadius = 20
         topView.layer.masksToBounds = true
         setupScrollView()
         setupButtons()
       }
       func setupScrollView() {
         view.addSubview(scrollView)
         scrollView.addSubview(contentView)
         NSLayoutConstraint.activate([
           scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor), // Change this line
           scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
         ])
         // Setup contentView inside scrollView
         NSLayoutConstraint.activate([
             contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
             contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
             contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
             contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
             contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
           ])
       }
       func setupButtons() {
         var previousButton: UIButton? = nil
         let buttonHeight: CGFloat = 60.0
         let buttonSpacing: CGFloat = 10.0
         let textLeadingSpacing: CGFloat = 40.0 // Add this constant
         for (index, title) in buttonTitles.enumerated() {
           let button = UIButton(type: .system)
           button.setTitle("\(index + 1). \(title)", for: .normal)
           button.backgroundColor = .white
           button.layer.cornerRadius = 10
           button.translatesAutoresizingMaskIntoConstraints = false
           button.tag = index + 1 // for button identification
           button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
           button.contentHorizontalAlignment = .left // Align title to the left
           button.setTitleColor(.black, for: .normal) // Set title color to black
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14) // Set title font to bold
           button.titleLabel?.lineBreakMode = .byWordWrapping // Add this line
               button.titleLabel?.numberOfLines = 0
           contentView.addSubview(button)
           let circleView = UIView()
               circleView.backgroundColor = .lightGray
               circleView.layer.cornerRadius = 15
               circleView.translatesAutoresizingMaskIntoConstraints = false
               button.addSubview(circleView)
               // Add label for numbering
               let numberLabel = UILabel()
               numberLabel.text = "\(index + 1)"
               numberLabel.font = UIFont.boldSystemFont(ofSize: 10)
               numberLabel.textColor = .white
               numberLabel.translatesAutoresizingMaskIntoConstraints = false
               circleView.addSubview(numberLabel)
           NSLayoutConstraint.activate([
                 circleView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 7),
                 circleView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: 36),
                 circleView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                 circleView.widthAnchor.constraint(equalToConstant: 30),
                 circleView.heightAnchor.constraint(equalToConstant: 30),
                 numberLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
                 numberLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
               ])
           button.setTitle(title, for: .normal)
               contentView.addSubview(button)
               // Set button constraints
               NSLayoutConstraint.activate([
                 button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                 button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                 button.heightAnchor.constraint(equalToConstant: buttonHeight),
           ])
           // Set button constraints
           NSLayoutConstraint.activate([
             button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
             button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
             button.heightAnchor.constraint(equalToConstant: buttonHeight),
           ])
           NSLayoutConstraint.activate([
                 button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textLeadingSpacing), // Use the textLeadingSpacing constant here
                 button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                 button.heightAnchor.constraint(equalToConstant: buttonHeight),
           ]);
           var configuration = UIButton.Configuration.plain()
           configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: textLeadingSpacing, bottom: 0, trailing: 0)
           configuration.titlePadding = 50 // Add this line to create space between button and title label
           button.configuration = configuration
           if let previousButton = previousButton {
             button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: buttonSpacing).isActive = true
           } else {
             button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
           }
           previousButton = button
         }
         // Ensure the last button bottom constraint is set to contentView bottom
         previousButton?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
       }
    
    let screenMappings: [Int: String] = [
        1: "whatIsFeverViewController",
        2: "InfoLibraryWarningSignsViewController",
        3: "certificateFortheEmployer",
        4: "doctorQuestions",
        5: "",
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
        20: "",
        21: "frequentFeverViewController",
        22: "AvoidFeverViewController",
        23: ""
    ]

    
    @objc func buttonTapped(_ sender: UIButton) {
        print("Button \(sender.tag) tapped")
        
        // Get the destination view controller identifier from the screenMappings dictionary
        guard let destinationVCIdentifier = screenMappings[sender.tag] else {
            print("No view controller mapped for button \(sender.tag)")
            return
        }
        
        // Check if the destination view controller identifier is not empty
        if destinationVCIdentifier.isEmpty {
            print("No view controller configured for button \(sender.tag)")
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
     }
    
    
    

