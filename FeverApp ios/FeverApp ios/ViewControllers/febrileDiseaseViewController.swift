//
//  febrileDiseaseViewController.swift
//  FeverApp ios
//
//  Created by user on 9/16/24.
//

import UIKit

class febrileDiseaseViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var prevLabel: UILabel!
    @IBOutlet weak var closeLabel: UIButton!
    @IBOutlet weak var nextlabel: UILabel!
    
    
    
    let descriptionView = UIView()
       
    @IBAction func backBtnTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    
    // Back button action
    @objc private func backButtonTapped() {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "infoLibController")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func previousBtnTapped(_ sender: UIButton) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "feverWithoutAccompanyingSymptomsViewContoller")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: false)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
    }
    
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "febrileConvulsionsInfoViewController")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: false)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
    }
    
       override func viewDidLoad() {
           super.viewDidLoad()
           self.navigationItem.hidesBackButton = true
           
           topView.layer.cornerRadius = 20
           topView.layer.masksToBounds = true
           
           infoLabel.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
           closeLabel.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close") , for: .normal)
           nextlabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next")
           prevLabel.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.1", defaultText: "Previous")
           
           
           // Create a container view
           let containerView = UIView()
           containerView.translatesAutoresizingMaskIntoConstraints = false
           containerView.backgroundColor = .white
           containerView.layer.cornerRadius = 10
           containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
           view.addSubview(containerView)
           
           // Create a content view with rounded corners and height of 400
           let contentViewContainer = UIView()
           contentViewContainer.translatesAutoresizingMaskIntoConstraints = false
           contentViewContainer.layer.cornerRadius = 10
           contentViewContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
           contentViewContainer.backgroundColor = .white
           view.addSubview(contentViewContainer)
           
           // Add constraints to pin the content view to the container view
           NSLayoutConstraint.activate([
               contentViewContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
               contentViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
               contentViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
               contentViewContainer.heightAnchor.constraint(equalToConstant: 620)
           ])
           
           // Create a scroll view and add it to the content view
           let scrollableContent = UIScrollView()
           scrollableContent.translatesAutoresizingMaskIntoConstraints = false
           contentViewContainer.addSubview(scrollableContent)
           
           // Pin the scroll view to the content view
           NSLayoutConstraint.activate([
               scrollableContent.topAnchor.constraint(equalTo: contentViewContainer.topAnchor),
               scrollableContent.leadingAnchor.constraint(equalTo: contentViewContainer.leadingAnchor),
               scrollableContent.trailingAnchor.constraint(equalTo: contentViewContainer.trailingAnchor),
               scrollableContent.bottomAnchor.constraint(equalTo: contentViewContainer.bottomAnchor)
           ])
           
           // Create a static view and add it to the scroll view
           let textContentView = UIView()
           textContentView.translatesAutoresizingMaskIntoConstraints = false
           scrollableContent.addSubview(textContentView)
           
           NSLayoutConstraint.activate([
               textContentView.topAnchor.constraint(equalTo: scrollableContent.topAnchor),
               textContentView.leadingAnchor.constraint(equalTo: scrollableContent.leadingAnchor),
               textContentView.trailingAnchor.constraint(equalTo: scrollableContent.trailingAnchor),
               textContentView.bottomAnchor.constraint(equalTo: scrollableContent.bottomAnchor),
               textContentView.widthAnchor.constraint(equalTo: scrollableContent.widthAnchor)
           ])
           
           // Heading Label
           let titleLabel = UILabel()
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           titleLabel.text = ""
           titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
           textContentView.addSubview(titleLabel)
           
           // Image View
           let illustrationView = UIImageView()
           illustrationView.translatesAutoresizingMaskIntoConstraints = false
           illustrationView.image = UIImage(named: "cryBaby")
           illustrationView.contentMode = .scaleAspectFill
           illustrationView.layer.cornerRadius = 10
           illustrationView.layer.masksToBounds = true
           illustrationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
           textContentView.addSubview(illustrationView)
           
           
           
           let textView = UILabel()
           textView.text = """
           
                       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.260"))\n
                       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.261"))\n
                       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.262"))\n
                        \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.263"))\n
                        \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.264"))\n
                        \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.265"))\n
                        \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.266").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
                        \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.267").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
                               
           """

           let attributedText = NSMutableAttributedString(string: textView.text!)
           let linkRange = attributedText.mutableString.range(of: "https://www.rki.de/DE/Content/InfAZ/InfAZ_marginal_node.html")
           attributedText.addAttribute(.link, value: "https://www.rki.de/DE/Content/InfAZ/InfAZ_marginal_node.html", range: linkRange)
           attributedText.addAttribute(.foregroundColor, value: UIColor.blue, range: linkRange)

           textView.attributedText = attributedText

           textView.font = UIFont.systemFont(ofSize: 14)
           textView.textColor = .black
           textView.numberOfLines = 0
           textView.translatesAutoresizingMaskIntoConstraints = false

           textContentView.addSubview(textView)
        
               NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: illustrationView.bottomAnchor, constant: 16),
               textView.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor, constant: 16),
               textView.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor, constant: -16),
                
           ])

           
           
           // Add second content (from second view controller)
           let detailsStackView = UIStackView()
           detailsStackView.axis = .vertical
           detailsStackView.spacing = 20
           detailsStackView.translatesAutoresizingMaskIntoConstraints = false
           textContentView.addSubview(detailsStackView)
           
           // Adding second content
           addDetailsContent(to: detailsStackView)
           
           // Add constraints
           NSLayoutConstraint.activate([
               // Title Label constraints
               titleLabel.topAnchor.constraint(equalTo: textContentView.topAnchor, constant: 16),
               titleLabel.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor, constant: 16),
               titleLabel.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor, constant: -16),
               
               // IllustrationView constraints
               illustrationView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
               illustrationView.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor, constant: 10),
               illustrationView.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor, constant: -10),
               illustrationView.heightAnchor.constraint(equalToConstant: 200),
               
               // Details StackView constraints
               detailsStackView.topAnchor.constraint(equalTo:  textView.bottomAnchor, constant: 4),
               detailsStackView.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor, constant: 16),
               detailsStackView.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor, constant: -16),
               detailsStackView.bottomAnchor.constraint(equalTo: textContentView.bottomAnchor, constant: -20)
           ])
           
           // Add constraints
           NSLayoutConstraint.activate([
               containerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15),
               containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
               containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
               containerView.heightAnchor.constraint(equalToConstant: 40)
           ])
           
           // Add a bold text label to the container view
           let headerLabel = UILabel()
           headerLabel.translatesAutoresizingMaskIntoConstraints = false
           headerLabel.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.32")
           headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
           headerLabel.textAlignment = .left
           containerView.addSubview(headerLabel)
           
           // Add constraints to the label
           NSLayoutConstraint.activate([
               headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
               headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
           ])
       }
       
    
    
       // Create content for temperature classification
       func addDetailsContent(to stackView: UIStackView) {
           let sections = [
            ("12.1", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.33")),
               ("12.2", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.34")),
               ("12.3", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.35")),
               ("12.4", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.36")),
               ("12.5", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.37")),
               ("12.6", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.38")),
               ("12.7", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.39")),
               ("12.8", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.40")),
               ("12.9",TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.41")),
               ("12.10", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.42")),
               ("12.11", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.43")),
               ("12.12", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.44")),
               ("12.13", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.45")),
               
           ]
           
           let sectionDetails = [
            
               """
                 \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.268"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.269"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.270"))\n
               •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.271"))\n
                 \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.272"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.273"))\n
                 \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.274"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.275"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.276"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.277"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.278"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.268"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.279"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.280").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
               •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.282"))\n
               
               """,
               
               """
  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.282"))\n
  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.283"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.284"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.285"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.286"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.287"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.288"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.289"))\n

  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.290"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.291"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.292"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.293"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.294"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.295"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.296"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.297"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.298"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.299"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.300"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.301"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.302").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.303").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.304"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.305").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.306").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.307"))\n


""",
               
               """

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.314"))\n\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.315"))\n\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.316"))\n\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.317"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.318"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.319"))\n\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.320"))\n\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.321"))\n\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.322"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.323"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.324"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.325"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.326"))\n

""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.327"))\n\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.328"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.329"))\n\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.330"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.331"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.332"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.333"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.334"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.335"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.336"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.337"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.338").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.339"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.340"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.341"))\n
""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.342"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.343"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.344"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.345"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.346"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.347"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.348"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.349"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.350"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.351"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.352"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.353"))\n?

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.354"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.355"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.356"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.357"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.358"))\n
""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.359"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.360"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.361"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.362"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.363"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.364"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.365").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.366"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.367").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.368"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.369"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.370"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.371"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.372"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.373"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.374"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.375"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.376"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.377"))\n

• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.378"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.379"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.380"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.381"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.382"))\n
• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.383"))\n
""",
               
"""
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.389"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.390"))\n\n
              \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.391"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.392"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.393"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.394"))\n
       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.395"))\n
       
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.396"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.397"))\n
       
       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.398"))\n
       
       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.399"))\n
       
       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.400"))\n
       
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.401"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.402"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.403"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.404"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.405"))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.406").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
       • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.407"))\n
       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.408"))\n
       \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.409"))\n
       """,
               
                              """
               
               
                             
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.410"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.411"))\n symptom-free course.
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.412"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.413"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.414"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.415"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.416"))\n
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.417"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.418"))\n
               
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.419"))\n
               
               •  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.420"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.421"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.422"))\n
               
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.423"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.424"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.425"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.426"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.427"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.428"))\n
               """,
               
                              """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.429"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.430"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.431"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.432"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.433"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.434"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.435"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.436"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.437"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.438"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.439"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.440"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.441"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.442"))\n
               """,
               
                              """
               
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.346"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.347"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.348"))\n
               
                               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.347"))\n
               
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.450"))\n
               
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.451"))\n
               
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.452"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.453"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.454"))\n
               
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.455"))\n
               
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.456"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.457"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.458"))\n \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.459"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.460"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.461"))\n \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.462"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.463"))\n \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.464"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.465"))\n
               
               """,
                              """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.466"))\n
               
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.467"))\n
               
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.468"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.469"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.470"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.471"))\n
               
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.472"))\n
               
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.473"))\n
               
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.474"))\n
               
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.475"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.476"))\n
               
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.477"))\n
               
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.478"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.479"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.480"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.481"))\n
               • \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.482"))\n
               """,
                              """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.483").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n,
               
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.484").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.485"))\n
               
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.486"))\n
               
                                             \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.487"))\n
                              1. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.488"))\n
                              2. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.489"))\n
                              3. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.490"))\n
                              4. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.491"))\n
                              5. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.492"))\n
                              6. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.493"))\n
                              7. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.494"))\n,
                              8. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.495"))\n
                              9. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.496"))\n
                              10. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.497"))\n
                              11. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.498"))\n
                              12. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.499"))\n
                              13. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.500"))\n
                              14. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.501"))\n
                              15. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.502"))\n
                              16. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.503"))\n
                              17. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.504"))\n
                              18. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.505"))\n
                              19. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.506"))\n
                              20. \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.507"))\n
               
                                                            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.508").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
               
                                                            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.509"))\n
               
                                                            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.510").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
               
                                                                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.511").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
               """,
               
               
           ]
           
           for (index, section) in sections.enumerated() {
               // Stack for each section
               let sectionStack = UIStackView()
               sectionStack.axis = .horizontal
               sectionStack.spacing = 8
               sectionStack.alignment = .center
               
               // Circle view for numbering
               let numberingView = UIView()
               numberingView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
               numberingView.layer.cornerRadius = 20
               numberingView.translatesAutoresizingMaskIntoConstraints = false
               numberingView.widthAnchor.constraint(equalToConstant: 40).isActive = true
               numberingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
               
               // Number Label inside circle
               let numberLabel = UILabel()
               numberLabel.text = section.0
               numberLabel.font = UIFont.boldSystemFont(ofSize: 14)
               numberLabel.textAlignment = .center
               numberingView.addSubview(numberLabel)
               
               // Center number label inside the circle
               numberLabel.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   numberLabel.centerXAnchor.constraint(equalTo: numberingView.centerXAnchor),
                   numberLabel.centerYAnchor.constraint(equalTo: numberingView.centerYAnchor)
               ])
               
               
               let sectionLabel = UILabel()
               sectionLabel.text = section.1
               sectionLabel.font = UIFont.boldSystemFont(ofSize: 14)
               sectionLabel.numberOfLines = 0
               
               // Arrow button for expanding section
               let arrowButton = UIButton(type: .system)
               arrowButton.tintColor = .lightGray
               arrowButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
               arrowButton.tag = index
               arrowButton.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
               arrowButton.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   arrowButton.widthAnchor.constraint(equalToConstant: 30),
                   arrowButton.heightAnchor.constraint(equalToConstant: 30)
               ])
               
             
               
               // Add views to section stack
               sectionStack.addArrangedSubview(numberingView)
               sectionStack.addArrangedSubview(sectionLabel)
               sectionStack.addArrangedSubview(arrowButton)
               
               // Add section stack to the main stack
               stackView.addArrangedSubview(sectionStack)
               
               
               
               // Add hidden details label for each section
                       let detailsStack = UIStackView()
                       detailsStack.axis = .vertical
                       detailsStack.spacing = 8
                       detailsStack.isHidden = true
                       stackView.addArrangedSubview(detailsStack)
                       detailsStack.tag = 200 + index
               
               if section.0 == "12.8" {
                   // Texte avant l'image 1
                   let textBeforeImage1 = UILabel()

                   // Fetch translations for each section
                   let symptomTranslation = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.384")
                   let TwophaseTranslation = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.385")
                   let AtTheTranslation = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.386")
                   let TipicalTranslation = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.387")
                   // Combine the translations into the label's text
                   textBeforeImage1.text = """
                   \(symptomTranslation)\n\n• \(TwophaseTranslation)\n•\(AtTheTranslation)\n•\(TipicalTranslation)
                   """
                   
                   
                   
                   
                   
                   textBeforeImage1.font = UIFont.systemFont(ofSize: 14)
                   textBeforeImage1.numberOfLines = 0
                   detailsStack.addArrangedSubview(textBeforeImage1)
                   
                   // Image 1
                   let imageView1 = UIImageView()
                   imageView1.image = UIImage(named: "masern") // Remplacez par le nom de votre image
                   imageView1.contentMode = .scaleAspectFit
                   detailsStack.addArrangedSubview(imageView1)
                   
                   // Contraintes pour l'image 1
                   NSLayoutConstraint.activate([
                       imageView1.heightAnchor.constraint(equalToConstant: 150), // Ajustez la hauteur
                       imageView1.widthAnchor.constraint(equalToConstant: 150) // Ajustez la largeur
                   ])
                   
                   // Texte avant l'image 2
                   let textBeforeImage2 = UILabel()
                   textBeforeImage2.text =
"• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.388"))"
                   textBeforeImage2.font = UIFont.systemFont(ofSize: 14)
                   textBeforeImage2.numberOfLines = 0
                   detailsStack.addArrangedSubview(textBeforeImage2)
                   
                   // Image 2
                   let imageView2 = UIImageView()
                   imageView2.image = UIImage(named: "masernausschlag") // Remplacez par le nom de votre image
                   imageView2.contentMode = .scaleAspectFit
                   detailsStack.addArrangedSubview(imageView2)
                   
                   // Contraintes pour l'image 2
                   NSLayoutConstraint.activate([
                       imageView2.heightAnchor.constraint(equalToConstant: 150), // Ajustez la hauteur
                       imageView2.widthAnchor.constraint(equalToConstant: 150) // Ajustez la largeur
                   ])
               }
               
               
               
               
               
               
               
               
               
                       
               if section.0 == "12.11" {
                   
                   let textAfterImage1 = UILabel()
                   // Fetch translations for each section
                   let Translation1 = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.443")
                   let Translation2 = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.444")

                   // Combine the translations into the label's text
                   textAfterImage1.text = """
                   \(Translation1)\n\n• \(Translation2)
                   """
                   textAfterImage1.font = UIFont.systemFont(ofSize: 14)
                   textAfterImage1.numberOfLines = 0
                   detailsStack.addArrangedSubview(textAfterImage1)
                   // Image 1
                   let imageView1 = UIImageView()
                   imageView1.image = UIImage(named: "fleckchen") // Remplacez par le nom de votre image
                   imageView1.contentMode = .scaleAspectFit
                   detailsStack.addArrangedSubview(imageView1)
                   
                   // Contraintes pour l'image 1
                   NSLayoutConstraint.activate([
                       imageView1.heightAnchor.constraint(equalToConstant: 150), // Ajustez la hauteur
                       imageView1.widthAnchor.constraint(equalToConstant: 150) // Ajustez la largeur
                   ])
                   
                   // Texte avant l'image 2
                   let textBeforeImage2 = UILabel()
                   textBeforeImage2.text = "• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.445"))"
                   textBeforeImage2.font = UIFont.systemFont(ofSize: 14)
                   textBeforeImage2.numberOfLines = 0
                   detailsStack.addArrangedSubview(textBeforeImage2)
                   
                   // Image 2
                   let imageView2 = UIImageView()
                   imageView2.image = UIImage(named: "windpocken") // Remplacez par le nom de votre image
                   imageView2.contentMode = .scaleAspectFit
                   detailsStack.addArrangedSubview(imageView2)
                   
                   // Contraintes pour l'image 2
                   NSLayoutConstraint.activate([
                       imageView2.heightAnchor.constraint(equalToConstant: 150), // Ajustez la hauteur
                       imageView2.widthAnchor.constraint(equalToConstant: 150) // Ajustez la largeur
                   ])
                   
                   
               }
        
               if section.0 == "12.3" {
                   
                   let textBeforeImage2 = UILabel()

                   // Fetch translations for each section
                   let symptomsTranslation = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.308")
                   let leadingSymptomsTranslation = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.309")

                   // Combine the translations into the label's text
                   textBeforeImage2.text = """
                   \(symptomsTranslation)\n\n• \(leadingSymptomsTranslation)
                   """

                   
                   textBeforeImage2.font = UIFont.systemFont(ofSize: 14)
                   textBeforeImage2.numberOfLines = 0
                   detailsStack.addArrangedSubview(textBeforeImage2)
                   
                   
                   // Image 1 : Langue en framboise
                   let imageView1 = UIImageView()
                   imageView1.image = UIImage(named: "himbeerzunge") // Remplacez par le nom de votre image
                   imageView1.contentMode = .scaleAspectFit
                   detailsStack.addArrangedSubview(imageView1)
                   
                   // Contraintes pour l'image 1
                   NSLayoutConstraint.activate([
                       imageView1.heightAnchor.constraint(equalToConstant: 150), // Ajustez la hauteur
                       imageView1.widthAnchor.constraint(equalToConstant: 150) // Ajustez la largeur
                   ])
                   
                   // Texte après l'image 1
                   let textAfterImage1 = UILabel()
                   textAfterImage1.text = "• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.310"))"
                   
                   textAfterImage1.font = UIFont.systemFont(ofSize: 14)
                   textAfterImage1.numberOfLines = 0
                   detailsStack.addArrangedSubview(textAfterImage1)
                   
                   // Image 2 : Eruption cutanée
                   let imageView2 = UIImageView()
                   imageView2.image = UIImage(named: "gaensehaut") // Remplacez par le nom de votre image
                   imageView2.contentMode = .scaleAspectFit
                   detailsStack.addArrangedSubview(imageView2)
                   
                   // Contraintes pour l'image 2
                   NSLayoutConstraint.activate([
                       imageView2.heightAnchor.constraint(equalToConstant: 150), // Ajustez la hauteur
                       imageView2.widthAnchor.constraint(equalToConstant: 150) // Ajustez la largeur
                   ])
                   
                   // Texte après l'image 2
                   let textAfterImage2 = UILabel()
                   textAfterImage2.text = "• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.311"))"
                   textAfterImage2.font = UIFont.systemFont(ofSize: 14)
                   textAfterImage2.numberOfLines = 0
                   detailsStack.addArrangedSubview(textAfterImage2)
                   
                   // Image 3 : Triangle pâle
                   let imageView3 = UIImageView()
                   imageView3.image = UIImage(named: "rote-Wangen") // Remplacez par le nom de votre image
                   imageView3.contentMode = .scaleAspectFill
                   detailsStack.addArrangedSubview(imageView3)
                   
                   // Contraintes pour l'image 3
                   NSLayoutConstraint.activate([
                       imageView3.heightAnchor.constraint(equalToConstant: 150), // Ajustez la hauteur
                       imageView3.widthAnchor.constraint(equalToConstant: 150) // Ajustez la largeur
                   ])
                   
                   // Texte après l'image 3
                   let textAfterImage3 = UILabel()
                   // Fetch translations for each section
                   let firstTranslation = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.312")
                   let seconTranslation = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.313")

                   // Combine the translations into the label's text
                   textAfterImage3.text = """
                   • \(firstTranslation)\n• \(seconTranslation)
                   """
                   textAfterImage3.font = UIFont.systemFont(ofSize: 14)
                   textAfterImage3.numberOfLines = 0
                   detailsStack.addArrangedSubview(textAfterImage3)
               }
               
               // Add image and details only for section "8.1"
                       if section.0 == "12.9" {
                           let imageView = UIImageView()
                           imageView.image = UIImage(named: "mumps") // Replace with your image name
                           imageView.contentMode = .scaleAspectFit
                           imageView.translatesAutoresizingMaskIntoConstraints = false
                           detailsStack.addArrangedSubview(imageView)
                           
                           // Constraints for the imageView
                           NSLayoutConstraint.activate([
                            imageView.heightAnchor.constraint(equalToConstant: 130),  // Ajuste la hauteur
                                   imageView.widthAnchor.constraint(equalToConstant: 50)    // Ajuste la largeur
                           ])
                       }
                       
                       // Details label
                       let detailsLabel = UILabel()
                       detailsLabel.text = sectionDetails[index]
                       detailsLabel.font = UIFont.systemFont(ofSize: 14)
                       detailsLabel.numberOfLines = 0
                       detailsStack.addArrangedSubview(detailsLabel)
                       
                 
           }
       }
       
    @objc func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        
        if let detailsStack = view.viewWithTag(200 + section) as? UIStackView {
            detailsStack.isHidden.toggle()
            
            // Toggle the arrow direction
            let arrowIcon = detailsStack.isHidden ? "chevron.down" : "chevron.up"
            sender.setImage(UIImage(systemName: arrowIcon), for: .normal)
           }
       }
   }
