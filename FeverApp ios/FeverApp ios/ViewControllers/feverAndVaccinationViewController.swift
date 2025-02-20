//
//  feverAndVaccinationViewController.swift
//  FeverApp ios
//
//  Created by user on 9/13/24.
//

import UIKit

class feverAndVaccinationViewController:UIViewController{
    let chevronButton = UIButton()
    
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    
    @IBOutlet var topView: UIView!
    
    let staticView = UIView()
    
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
        let viewController = storyboard.instantiateViewController(withIdentifier: "correctMeasureViewController")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: false)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
    }
    
    
    @IBOutlet weak var nextlabel: UILabel!
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "feverWithAccompanyingSymptomsViewContoller")

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController, animated: false)
        } else {
            // Otherwise, present it modally in full screen
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
    }
    // Action for the tap gesture
    @objc func nextLabelTapped() {
        nextLabelTapAction()
    }
    
    // The existing button action logic
        func nextLabelTapAction() {
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
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.hidesBackButton = true
            
            infoTitle.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
            closeBtn.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close") , for: .normal)
            nextLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next")
            previousLabel.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.1", defaultText: "Previous")
            
            // Enable user interaction for the label
            nextlabel.isUserInteractionEnabled = true

            // Add tap gesture recognizer to the label
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextLabelTapped))
            nextlabel.addGestureRecognizer(tapGesture)
            topView.layer.cornerRadius = 20
            topView.layer.masksToBounds = true
            
            // Create a new view
            let newView = UIView()
            newView.translatesAutoresizingMaskIntoConstraints = false
            newView.backgroundColor = .white
            newView.layer.cornerRadius = 10
            newView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.addSubview(newView)
            
            // Create a new view with border radius and height 400
            let contentView = UIView()
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.layer.cornerRadius = 10
            contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            contentView.backgroundColor = .white
            view.addSubview(contentView)
            
            // Add constraints to pin the content view to the top view and the leading/trailing edges
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: newView.bottomAnchor, constant: 0),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                contentView.heightAnchor.constraint(equalToConstant: 620)
            ])
            
            // Create a scroll view and add it to the content view
            let scrollView = UIScrollView()
                    scrollView.translatesAutoresizingMaskIntoConstraints = false
                    contentView.addSubview(scrollView)
                    
                    // Add constraints to pin the scroll view to the content view
                    NSLayoutConstraint.activate([
                        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
                        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                    ])
            
            // Create a static view and add it to the scroll view
            let staticView = UIView()
            staticView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(staticView)
            
            // Add constraints to pin the static view to the scroll view
            NSLayoutConstraint.activate([
                staticView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                staticView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                staticView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                staticView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                staticView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
            
            
            // Heading Label
            let headingLabel = UILabel()
            headingLabel.translatesAutoresizingMaskIntoConstraints = false
            headingLabel.text = ""
            headingLabel.font = UIFont.boldSystemFont(ofSize: 24)
            staticView.addSubview(headingLabel)
            
            // Image View
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "Rectangle44") // Add your image asset here
            imageView.contentMode = .scaleAspectFit
            staticView.addSubview(imageView)
            
            // Add second content (from second view controller)
            let contentStackView = UIStackView()
            contentStackView.axis = .vertical
            contentStackView.spacing = 20
            contentStackView.translatesAutoresizingMaskIntoConstraints = false
            staticView.addSubview(contentStackView)
            
            // Adding second content
            addContent(to: contentStackView)
            
            // Add constraints
            NSLayoutConstraint.activate([
                // Heading Label constraints
                headingLabel.topAnchor.constraint(equalTo: staticView.topAnchor, constant: 16),
                headingLabel.leadingAnchor.constraint(equalTo: staticView.leadingAnchor, constant: 16),
                headingLabel.trailingAnchor.constraint(equalTo: staticView.trailingAnchor, constant: -16),
                
                // ImageView constraints
                imageView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 16),
                imageView.leadingAnchor.constraint(equalTo: staticView.leadingAnchor, constant: 10),
                imageView.trailingAnchor.constraint(equalTo: staticView.trailingAnchor, constant: -10),
                imageView.heightAnchor.constraint(equalToConstant: 200),
                
                // Content StackView constraints
                contentStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                contentStackView.leadingAnchor.constraint(equalTo: staticView.leadingAnchor, constant: 16),
                contentStackView.trailingAnchor.constraint(equalTo: staticView.trailingAnchor, constant: -16),
                contentStackView.bottomAnchor.constraint(equalTo: staticView.bottomAnchor, constant: -20)
            ])
            
            // Add constraints
            NSLayoutConstraint.activate([
                newView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15),
                newView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                newView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                newView.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            // Add a bold text label to the new view
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.20")
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .left
            newView.addSubview(label)
            
            // Add constraints to the label
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: newView.topAnchor, constant: 10),
                label.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 10)
            ])
        }
        
        // Create a table for temperature classification
        func addContent(to stackView: UIStackView) {
            // Subtitle label
            
            // Content items
            let items = [
                ("9.1", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.21")),
                ("9.2", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.22"))
            ]
            
            // Additional details for each section
            let additionalDetails = [
                "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.165"))\n\n\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.166"))\n",
                "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.167"))\n"
            ]
            
            for (index, item) in items.enumerated() {
                let itemStackView = UIStackView()
                itemStackView.axis = .horizontal
                itemStackView.spacing = 8
                itemStackView.alignment = .center
                
                // Circle view for the numbering
                let numberCircleView = UIView()
                numberCircleView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
                numberCircleView.layer.cornerRadius = 20
                numberCircleView.translatesAutoresizingMaskIntoConstraints = false
                numberCircleView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                numberCircleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
                
                // Label inside the circle
                let numberLabel = UILabel()
                numberLabel.text = item.0
                numberLabel.font = UIFont.boldSystemFont(ofSize: 16)
                numberLabel.textAlignment = .center
                numberCircleView.addSubview(numberLabel)
                
                // Center the label inside the circle
                numberLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    numberLabel.centerXAnchor.constraint(equalTo: numberCircleView.centerXAnchor),
                    numberLabel.centerYAnchor.constraint(equalTo: numberCircleView.centerYAnchor)
                ])
                
                // Description label
                let descriptionLabel = UILabel()
                descriptionLabel.text = item.1
                descriptionLabel.font = UIFont.boldSystemFont(ofSize: 18)
                descriptionLabel.numberOfLines = 0
                
                // Chevron button
                let chevronButton = UIButton(type: .system)
                chevronButton.tintColor = .lightGray
                chevronButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                chevronButton.tag = index
                chevronButton.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
                chevronButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    chevronButton.widthAnchor.constraint(equalToConstant: 30),
                    chevronButton.heightAnchor.constraint(equalToConstant: 30)
                ])
                
                // Add views to itemStackView
                itemStackView.addArrangedSubview(numberCircleView)
                itemStackView.addArrangedSubview(descriptionLabel)
                itemStackView.addArrangedSubview(chevronButton)
                
                // Add the itemStackView to the stackView
                stackView.addArrangedSubview(itemStackView)
                // Create a label for the additional details (collapsed by default)
                           let detailsLabel = UILabel()
                           detailsLabel.text = additionalDetails[index]
                           detailsLabel.font = UIFont.systemFont(ofSize: 14)
                           detailsLabel.numberOfLines = 0
                           detailsLabel.isHidden = true  // Initially hidden
                           stackView.addArrangedSubview(detailsLabel)
                           
                           // Tagging the label to find it later when toggling
                           detailsLabel.tag = 100 + index
                       }
                       
                       // Adding the citation label below "9.2 Fever after vaccination"
                       let citationStackView = UIStackView()
                       citationStackView.axis = .vertical
                       citationStackView.spacing = 5
                       
                       // "Further information:" label
                       let furtherInfoLabel = UILabel()
                       furtherInfoLabel.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.168")
                       furtherInfoLabel.font = UIFont.systemFont(ofSize: 14)
                       furtherInfoLabel.textColor = .black
                       citationStackView.addArrangedSubview(furtherInfoLabel)
                       
                       // "(see also 'Scientific Literature')" label
                       let scientificLiteratureLabel = UILabel()
                       scientificLiteratureLabel.text = "\n\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.169")))\n•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.170"))\n"
                       scientificLiteratureLabel.font = UIFont.systemFont(ofSize: 16)
                       scientificLiteratureLabel.numberOfLines = 10
                       scientificLiteratureLabel.textColor = .black
                       citationStackView.addArrangedSubview(scientificLiteratureLabel)
                       
                       // Add the citation stack view below the last section ("9.2 Fever after vaccination")
                       stackView.addArrangedSubview(citationStackView)
                   }
                   
                   @objc func toggleSection(_ sender: UIButton) {
                       let section = sender.tag
                       
                       // Find the corresponding details label by its tag
                       if let detailsLabel = view.viewWithTag(100 + section) as? UILabel {
                           // Toggle the visibility of the details label
                           detailsLabel.isHidden.toggle()
                           
                           // Update the chevron direction
                           let chevronImage = detailsLabel.isHidden ? "chevron.down" : "chevron.up"
                           sender.setImage(UIImage(systemName: chevronImage), for: .normal)
                       }
                   }
               }
