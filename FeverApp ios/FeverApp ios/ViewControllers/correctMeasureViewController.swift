//
//  correctMeasureViewController.swift
//  FeverApp ios
//
//  Created by user on 9/15/24.
//

import UIKit

class correctMeasureViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    
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
        let viewController = storyboard.instantiateViewController(withIdentifier: "measureInfoViewController")

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
        let viewController = storyboard.instantiateViewController(withIdentifier: "feverAndVaccinationViewController")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: false)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
    }
    
    let descriptionView = UIView()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           self.navigationItem.hidesBackButton = true
           
           infoTitle.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
           closeBtn.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close") , for: .normal)
           nextLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next")
           previousLabel.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.1", defaultText: "Previous")
           
           topView.layer.cornerRadius = 20
           topView.layer.masksToBounds = true
           
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
           illustrationView.image = UIImage(named: "bbpediatric_720")
           illustrationView.contentMode = .scaleAspectFill
           illustrationView.layer.cornerRadius = 10
           illustrationView.layer.masksToBounds = true
           illustrationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
           textContentView.addSubview(illustrationView)
           
           
           
           let textView = UILabel()
           textView.text = """
           \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.139"))\n\n
           \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.140"))\n\n
           \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.141")))\n\n
           \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.142"))\n\n
           """

           let attributedText = NSMutableAttributedString(string: textView.text!)
           let linkRange = attributedText.mutableString.range(of: "")
           attributedText.addAttribute(.link, value: "", range: linkRange)
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
               textView.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor, constant: -16)
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
               detailsStackView.topAnchor.constraint(equalTo: illustrationView.bottomAnchor, constant: 270),
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
           headerLabel.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.12")
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
               ("8.1", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.13")),
               ("8.2", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.14")),
               ("8.3", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.15")),
               ("8.4", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.16")),
               ("8.5", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.17")),
               ("8.6", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.18")),
               ("8.7", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.19"))
               
           ]
           
           let sectionDetails = [
            
               """
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.143"))\n
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.144"))\n
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.145"))\n
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.146"))\n
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.147"))\n
               """,
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.148"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.149"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.150"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.151"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.152"))\n
""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.153"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.154"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.155"))\n
""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.156"))\n
""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.157"))\n

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.158"))\n
""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.159"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.160"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.161"))\n
""",
               
               """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.162"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.163"))\n
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.164"))\n
"""
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
                       
               // Add image and details only for section "8.1"
                       if section.0 == "8.1" {
                           let imageView = UIImageView()
                           imageView.image = UIImage(named: "fiebermessung_po") // Replace with your image name
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

