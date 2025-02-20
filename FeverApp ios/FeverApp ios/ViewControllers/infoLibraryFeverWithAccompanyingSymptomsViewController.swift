//
//  infoLibraryFeverWithAccompanyingSymptomsViewController.swift
//  FeverApp ios
//
//  Created by user on 9/15/24.
//
import UIKit


class infoLibraryFeverWithAccompanyingSymptomsViewController: UIViewController{
    
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    
    @IBOutlet var topView: UIView!
    
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
    
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        infoTitle.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
        closeBtn.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close") , for: .normal)
        nextLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next")
        previousLabel.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.1", defaultText: "Previous")
        
        // Create container views and set up constraints
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 15),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
        
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.23")
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.textAlignment = .left
        containerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        ])
        
        let contentViewContainer = UIView()
        contentViewContainer.translatesAutoresizingMaskIntoConstraints = false
        contentViewContainer.backgroundColor = .white
        view.addSubview(contentViewContainer)
        contentViewContainer.layer.cornerRadius = 10
        contentViewContainer.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        NSLayoutConstraint.activate([
            contentViewContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            contentViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            contentViewContainer.heightAnchor.constraint(equalToConstant: 620)
        ])
        
        let scrollableContent = UIScrollView()
        scrollableContent.translatesAutoresizingMaskIntoConstraints = false
        contentViewContainer.addSubview(scrollableContent)
        
        NSLayoutConstraint.activate([
            scrollableContent.topAnchor.constraint(equalTo: contentViewContainer.topAnchor),
            scrollableContent.leadingAnchor.constraint(equalTo: contentViewContainer.leadingAnchor),
            scrollableContent.trailingAnchor.constraint(equalTo: contentViewContainer.trailingAnchor),
            scrollableContent.bottomAnchor.constraint(equalTo: contentViewContainer.bottomAnchor)
        ])
        
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
        
        let illustrationView = UIImageView()
        illustrationView.translatesAutoresizingMaskIntoConstraints = false
        illustrationView.image = UIImage(named: "800")
        illustrationView.contentMode = .scaleAspectFill
        illustrationView.layer.cornerRadius = 8
        illustrationView.layer.masksToBounds = true
        textContentView.addSubview(illustrationView)
        
        let detailsStackView = UIStackView()
        detailsStackView.axis = .vertical
        detailsStackView.spacing = 20
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        textContentView.addSubview(detailsStackView)
        
        NSLayoutConstraint.activate([
            illustrationView.topAnchor.constraint(equalTo: textContentView.topAnchor, constant: 0),
            illustrationView.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor, constant: 15),
            illustrationView.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor, constant: -15),
            illustrationView.heightAnchor.constraint(equalToConstant: 190),
            
            detailsStackView.topAnchor.constraint(equalTo: illustrationView.bottomAnchor, constant: 16),
            detailsStackView.leadingAnchor.constraint(equalTo: textContentView.leadingAnchor, constant: 16),
            detailsStackView.trailingAnchor.constraint(equalTo: textContentView.trailingAnchor, constant: -16),
            detailsStackView.bottomAnchor.constraint(equalTo: textContentView.bottomAnchor, constant: -20)
        ])
        
        addDetailsContent(to: detailsStackView)
    }
    
    func addDetailsContent(to stackView: UIStackView) {
        let sections = [
            ("10.1", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.24")),
            ("10.2", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.25")),
            ("10.3", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.26")),
            ("10.4", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.27")),
            ("10.5", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.27")),
            ("10.6", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.29")),
            ("10.7", TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.30"))
        ]
        
        let sectionDetails = [
            """
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.171"))\n\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.172"))\n\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.173"))\n\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.174"))\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.175"))\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.176"))\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.177"))\n\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.178"))\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.179"))\n\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.180"))\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.181"))\n\n
            """,
            // Other sections...
        ]
        
        for (index, section) in sections.enumerated() {
            let sectionStack = UIStackView()
            sectionStack.axis = .horizontal
            sectionStack.spacing = 8
            sectionStack.alignment = .center
            
            let numberingView = UIView()
            numberingView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            numberingView.layer.cornerRadius = 20
            numberingView.translatesAutoresizingMaskIntoConstraints = false
            numberingView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            numberingView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            let numberLabel = UILabel()
            numberLabel.text = section.0
            numberLabel.font = UIFont.boldSystemFont(ofSize: 14)
            numberLabel.textAlignment = .center
            numberingView.addSubview(numberLabel)
            
            numberLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                numberLabel.centerXAnchor.constraint(equalTo: numberingView.centerXAnchor),
                numberLabel.centerYAnchor.constraint(equalTo: numberingView.centerYAnchor)
            ])
            
            let sectionLabel = UILabel()
            sectionLabel.text = section.1
            sectionLabel.font = UIFont.boldSystemFont(ofSize: 14)
            sectionLabel.numberOfLines = 0
            
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
            
            sectionStack.addArrangedSubview(numberingView)
            sectionStack.addArrangedSubview(sectionLabel)
            sectionStack.addArrangedSubview(arrowButton)
            
            stackView.addArrangedSubview(sectionStack)
            
            let detailsStack = UIStackView()
            detailsStack.axis = .vertical
            detailsStack.spacing = 8
            detailsStack.isHidden = true
            stackView.addArrangedSubview(detailsStack)
            detailsStack.tag = 200 + index
            
            let detailsLabel = UILabel()
            detailsLabel.font = UIFont.systemFont(ofSize: 14)
            detailsLabel.numberOfLines = 0
            
            // Safety check to ensure index is valid
            if index < sectionDetails.count {
                detailsLabel.text = sectionDetails[index]
            } else {
                detailsLabel.text = "Details not available."
            }
            
            if index == 0 { // Special case for the first section
                // Add the long text first
                let detailsLabel = UILabel()
                detailsLabel.font = UIFont.systemFont(ofSize: 14)
                detailsLabel.numberOfLines = 0
                detailsLabel.text = sectionDetails[index]
                detailsStack.addArrangedSubview(detailsLabel)

                // Add the first image (fieberanstieg) under the long text
                let imageView = UIImageView()
                imageView.image = UIImage(named: "fieberanstieg") // Ensure the image exists
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                detailsStack.addArrangedSubview(imageView)

                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalToConstant: 130),
                    imageView.widthAnchor.constraint(equalToConstant: 200)
                ])

                // Add the short text after the image
                let feverDecreaseLabel = UILabel()
                feverDecreaseLabel.font = UIFont.systemFont(ofSize: 14)
                feverDecreaseLabel.numberOfLines = 0
                feverDecreaseLabel.text = """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.182"))\n\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.183"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.184"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.185"))\n
                """
                detailsStack.addArrangedSubview(feverDecreaseLabel)

                // Add the second image (fieberabstieg) under the short text
                let secondImageView = UIImageView()
                secondImageView.image = UIImage(named: "fieberabstieg") // Ensure the image exists
                secondImageView.contentMode = .scaleAspectFit
                secondImageView.translatesAutoresizingMaskIntoConstraints = false
                detailsStack.addArrangedSubview(secondImageView)

                NSLayoutConstraint.activate([
                    secondImageView.heightAnchor.constraint(equalToConstant: 130),
                    secondImageView.widthAnchor.constraint(equalToConstant: 200)
                ])
            }

            if index == 1 { // Special case for the second section
                
                // Add the initial text
                let pulseTextLabel = UILabel()
                pulseTextLabel.font = UIFont.systemFont(ofSize: 14)
                pulseTextLabel.numberOfLines = 0
                pulseTextLabel.text = """
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.186"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.187"))\n
                """
                detailsStack.addArrangedSubview(pulseTextLabel)

                // Create a separate container view to hold the table-like structure
                let tableContainerView = UIView()
                detailsStack.addArrangedSubview(tableContainerView)

                // Use AutoLayout to ensure that the content is spaced properly in the container
                tableContainerView.translatesAutoresizingMaskIntoConstraints = false
                tableContainerView.leadingAnchor.constraint(equalTo: detailsStack.leadingAnchor).isActive = true
                tableContainerView.trailingAnchor.constraint(equalTo: detailsStack.trailingAnchor).isActive = true
                
                // Set up the table as a stack view inside the container
                let tableStackView = UIStackView()
                tableStackView.axis = .vertical
                tableStackView.spacing = 0 // No spacing between rows, we'll use separators
                tableStackView.alignment = .fill
                tableStackView.distribution = .fillProportionally
                tableStackView.translatesAutoresizingMaskIntoConstraints = false
                tableContainerView.addSubview(tableStackView)
                
                // Add constraints for the stack view inside the container
                tableStackView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor).isActive = true
                tableStackView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor).isActive = true
                tableStackView.topAnchor.constraint(equalTo: tableContainerView.topAnchor).isActive = true
                tableStackView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor).isActive = true

                // Add a horizontal line above the header row (top border of the table)
                tableStackView.addArrangedSubview(createSeparatorLine())

                // Header row (Age, Pulse) with separators between the columns and a line below
                let headerRow = createTableRow(age: TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.188"), pulse: TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.189"), isHeader: true)
                tableStackView.addArrangedSubview(headerRow)
                tableStackView.addArrangedSubview(createSeparatorLine()) // Add gray separator line below header
                
                // Data rows with separator lines
                let agePulseData = [
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.190"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.191")),
                    (  TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.192"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.193")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.194"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.195")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.196"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.197")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.198"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.199")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.200"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.201")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.202"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.203"))
                ]
                
                for (age, pulse) in agePulseData {
                    let dataRow = createTableRow(age: age, pulse: pulse, isHeader: false)
                    tableStackView.addArrangedSubview(dataRow)
                    tableStackView.addArrangedSubview(createSeparatorLine()) // Add gray separator line for each row
                }

                // Add a bottom horizontal line to close the table
                tableStackView.addArrangedSubview(createSeparatorLine())
                
                // Add the "Further information" text
                let furtherInfoLabel = UILabel()
                furtherInfoLabel.font = UIFont.systemFont(ofSize: 14)
                furtherInfoLabel.numberOfLines = 0
                furtherInfoLabel.text = """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.204"))\n\n
                *\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.205"))\n
                •\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.206")))\n
                •\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.207")))\n
                """
                detailsStack.addArrangedSubview(furtherInfoLabel)
            }

            // Helper method to create a row for the table with vertical separators
            func createTableRow(age: String, pulse: String, isHeader: Bool) -> UIView {
                let rowView = UIView()
                
                let rowStackView = UIStackView()
                rowStackView.axis = .horizontal
                rowStackView.spacing = 0 // No spacing between columns, we'll use vertical separators
                rowStackView.distribution = .fillEqually
                rowStackView.alignment = .fill
                rowView.addSubview(rowStackView)
                
                // Add constraints for the row stack view inside the row view
                rowStackView.translatesAutoresizingMaskIntoConstraints = false
                rowStackView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor).isActive = true
                rowStackView.trailingAnchor.constraint(equalTo: rowView.trailingAnchor).isActive = true
                rowStackView.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
                rowStackView.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true
                
                // Left vertical line (beginning of the row)
                let leftSeparator = createVerticalSeparatorLine()
                rowView.addSubview(leftSeparator)
                leftSeparator.leadingAnchor.constraint(equalTo: rowView.leadingAnchor).isActive = true
                leftSeparator.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
                leftSeparator.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true
                leftSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                
                // Create labels for age and pulse
                let ageLabel = UILabel()
                ageLabel.font = isHeader ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14)
                ageLabel.textAlignment = .left
                ageLabel.text = age

                let pulseLabel = UILabel()
                pulseLabel.font = isHeader ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14)
                pulseLabel.textAlignment = .left
                pulseLabel.text = pulse

                // Add the labels to the row stack view
                rowStackView.addArrangedSubview(ageLabel)
                
                // Middle vertical separator (between Age and Pulse)
                let middleSeparator = createVerticalSeparatorLine()
                rowStackView.addSubview(middleSeparator)
                middleSeparator.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor).isActive = true
                middleSeparator.topAnchor.constraint(equalTo: rowStackView.topAnchor).isActive = true
                middleSeparator.bottomAnchor.constraint(equalTo: rowStackView.bottomAnchor).isActive = true
                middleSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                
                rowStackView.addArrangedSubview(pulseLabel)
                
                // Right vertical line (end of the row)
                let rightSeparator = createVerticalSeparatorLine()
                rowView.addSubview(rightSeparator)
                rightSeparator.trailingAnchor.constraint(equalTo: rowView.trailingAnchor).isActive = true
                rightSeparator.topAnchor.constraint(equalTo: rowView.topAnchor).isActive = true
                rightSeparator.bottomAnchor.constraint(equalTo: rowView.bottomAnchor).isActive = true
                rightSeparator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                
                return rowView
            }

            // Helper method to create a horizontal separator line
            func createSeparatorLine() -> UIView {
                let separatorView = UIView()
                separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
                separatorView.backgroundColor = UIColor.lightGray
                return separatorView
            }

            // Helper method to create a vertical separator line
            func createVerticalSeparatorLine() -> UIView {
                let verticalSeparator = UIView()
                verticalSeparator.translatesAutoresizingMaskIntoConstraints = false
                verticalSeparator.backgroundColor = UIColor.lightGray
                return verticalSeparator
            }

            if index == 2 { // Third section
                
                // Add the initial text for the third chevron
                let respirationTextLabel = UILabel()
                respirationTextLabel.font = UIFont.systemFont(ofSize: 14)
                respirationTextLabel.numberOfLines = 0
                respirationTextLabel.text = """
                •\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.208")))\n
                •\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.209")))\n
                """
                detailsStack.addArrangedSubview(respirationTextLabel)

                // Create a container for the table-like structure
                let tableContainerView = UIView()
                detailsStack.addArrangedSubview(tableContainerView)

                // Use AutoLayout to ensure content is spaced properly in the container
                tableContainerView.translatesAutoresizingMaskIntoConstraints = false
                tableContainerView.leadingAnchor.constraint(equalTo: detailsStack.leadingAnchor).isActive = true
                tableContainerView.trailingAnchor.constraint(equalTo: detailsStack.trailingAnchor).isActive = true
                
                // Set up the table as a stack view inside the container
                let tableStackView = UIStackView()
                tableStackView.axis = .vertical
                tableStackView.spacing = 0 // No spacing between rows, we'll use separators
                tableStackView.alignment = .fill
                tableStackView.distribution = .fillProportionally
                tableStackView.translatesAutoresizingMaskIntoConstraints = false
                tableContainerView.addSubview(tableStackView)
                
                // Add constraints for the stack view inside the container
                tableStackView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor).isActive = true
                tableStackView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor).isActive = true
                tableStackView.topAnchor.constraint(equalTo: tableContainerView.topAnchor).isActive = true
                tableStackView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor).isActive = true

                // Add a horizontal line above the header row (top border of the table)
                tableStackView.addArrangedSubview(createSeparatorLine())
                
                // Header row (Age, Breaths) with separators between the columns and a line below
                let headerRow = createTableRow(age: TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.210"), pulse: TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.211"), isHeader: true)
                tableStackView.addArrangedSubview(headerRow)
                tableStackView.addArrangedSubview(createSeparatorLine()) // Add gray separator line below header
                
                // Data rows with separator lines
                let ageBreathData = [
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.212"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.213")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.214"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.215")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.216"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.217")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.218"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.219")),
                    (TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.220"), TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.221"))
                ]
                
                for (age, breaths) in ageBreathData {
                    let dataRow = createTableRow(age: age, pulse: breaths, isHeader: false)
                    tableStackView.addArrangedSubview(dataRow)
                    tableStackView.addArrangedSubview(createSeparatorLine()) // Add gray separator line for each row
                }

                // Add a bottom horizontal line to close the table
                tableStackView.addArrangedSubview(createSeparatorLine())
                
                // Add the "Further information" text under the table
                let furtherInfoLabel = UILabel()
                furtherInfoLabel.font = UIFont.systemFont(ofSize: 14)
                furtherInfoLabel.numberOfLines = 0
                furtherInfoLabel.text = """
                    \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.222"))
                """
                detailsStack.addArrangedSubview(furtherInfoLabel)
                
                // Add the underlined link text
                let linkTextLabel = UILabel()
                let linkText = removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.223"))
                let attributedString = NSMutableAttributedString(string: linkText)
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: linkText.count))
                linkTextLabel.attributedText = attributedString
                linkTextLabel.textColor = .blue // Set link color
                linkTextLabel.font = UIFont.systemFont(ofSize: 14)
                detailsStack.addArrangedSubview(linkTextLabel)

                // Add the citation text below the link
                let citationTextLabel = UILabel()
                citationTextLabel.font = UIFont.systemFont(ofSize: 14)
                citationTextLabel.numberOfLines = 0
                citationTextLabel.text = """
                - \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.224")))
                """
                detailsStack.addArrangedSubview(citationTextLabel)
            }

            if index == 3 { // Fourth section
                            
                // Add the initial text
                let symptomsTextLabel = UILabel()
                symptomsTextLabel.font = UIFont.systemFont(ofSize: 14)
                symptomsTextLabel.numberOfLines = 0
                symptomsTextLabel.text = """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.226"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.227"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.228"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.229"))\n

                """
                detailsStack.addArrangedSubview(symptomsTextLabel)
                
                // Add the first image (kniekuss 1)
                let firstImageView = UIImageView()
                firstImageView.image = UIImage(named: "kniekuss 1") // Ensure the image exists
                firstImageView.contentMode = .scaleAspectFit
                firstImageView.translatesAutoresizingMaskIntoConstraints = false
                detailsStack.addArrangedSubview(firstImageView)
                
                NSLayoutConstraint.activate([
                    firstImageView.heightAnchor.constraint(equalToConstant: 130),
                    firstImageView.widthAnchor.constraint(equalToConstant: 200)
                ])

                // Add the explanatory text
                let explanationTextLabel = UILabel()
                explanationTextLabel.font = UIFont.systemFont(ofSize: 14)
                explanationTextLabel.numberOfLines = 0
                explanationTextLabel.text = """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.230"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.231"))\n
                """
                detailsStack.addArrangedSubview(explanationTextLabel)
                
                // Add the second image (unbeweglichkeit)
                let secondImageView = UIImageView()
                secondImageView.image = UIImage(named: "unbeweglichkeit") // Ensure the image exists
                secondImageView.contentMode = .scaleAspectFit
                secondImageView.translatesAutoresizingMaskIntoConstraints = false
                detailsStack.addArrangedSubview(secondImageView)
                
                NSLayoutConstraint.activate([
                    secondImageView.heightAnchor.constraint(equalToConstant: 130),
                    secondImageView.widthAnchor.constraint(equalToConstant: 200)
                ])
            }

            if index == 4 { // Fifth section
                
                // Add the main text for the fifth chevron
                let mainTextLabel = UILabel()
                mainTextLabel.font = UIFont.systemFont(ofSize: 14)
                mainTextLabel.numberOfLines = 0
                mainTextLabel.text = """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.232"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.233"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.234"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.235"))\n\n
                \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.236")))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.237"))\n\n
                \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.238")))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.239"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.240"))\n
                """
                detailsStack.addArrangedSubview(mainTextLabel)
            }

           
            if index == 5 { // Sixth section
                
                // Add the main text for the sixth chevron
                let mainTextLabel = UILabel()
                mainTextLabel.font = UIFont.systemFont(ofSize: 14)
                mainTextLabel.numberOfLines = 0
                mainTextLabel.text = """
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.241"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.242"))\n
                *\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.243"))\n
                *\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.244"))\n
                *\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.245"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.246"))\n\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.247"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.248"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.249"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.250"))\n
                •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.251"))\n
                """
                detailsStack.addArrangedSubview(mainTextLabel)
                
                // Underlined black text (but not a link)
                let underlinedTextLabel = UILabel()
                underlinedTextLabel.font = UIFont.systemFont(ofSize: 14)
                underlinedTextLabel.numberOfLines = 0
                let underlinedText = "                •\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.252")))\n"
                let underlinedAttributedString = NSMutableAttributedString(string: underlinedText)
                underlinedAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: underlinedText.count))
                underlinedTextLabel.attributedText = underlinedAttributedString
                detailsStack.addArrangedSubview(underlinedTextLabel)

                // Add the YouTube link with underlined blue color
                let youtubeLinkLabel = UILabel()
                let youtubeLinkText = ""
                let youtubeAttributedString = NSMutableAttributedString(string: youtubeLinkText)
                youtubeAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: youtubeLinkText.count))
                youtubeAttributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 0, length: youtubeLinkText.count))
                youtubeLinkLabel.attributedText = youtubeAttributedString
                youtubeLinkLabel.font = UIFont.systemFont(ofSize: 14)
                detailsStack.addArrangedSubview(youtubeLinkLabel)
                
                // Add the image "fontanelle"
                let fontanelleImageView = UIImageView()
                fontanelleImageView.image = UIImage(named: "fontanelle") // Make sure the image is added to your assets
                fontanelleImageView.contentMode = .scaleAspectFit
                detailsStack.addArrangedSubview(fontanelleImageView)
                
                // Set constraints for the image if needed
                fontanelleImageView.translatesAutoresizingMaskIntoConstraints = false
                fontanelleImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            }

            if index == 6 { // Seventh (final) section
                
                // Add the image "hautauschlag"
                let rashImageView = UIImageView()
                rashImageView.image = UIImage(named: "hautauschlag") // Ensure the image is in your assets
                rashImageView.contentMode = .scaleAspectFit
                detailsStack.addArrangedSubview(rashImageView)
                
                // Set constraints for the image if needed
                rashImageView.translatesAutoresizingMaskIntoConstraints = false
                rashImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                
                // Add the main text with some bold parts
                let rashTextLabel = UILabel()
                rashTextLabel.font = UIFont.systemFont(ofSize: 15)
                rashTextLabel.numberOfLines = 0
                
                // Creating a mutable attributed string for the bold parts
                let rashText = """
                \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.253")))\n
                \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.254")))\n
                \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.2255")))\n
                """
                
                let attributedText = NSMutableAttributedString(string: rashText)
//                
//                // Bold the necessary parts
//                let boldRanges = [
//                    ("If a skin rash develops after the child has lost his or her fever and he or she is otherwise fine, this is the harmless sign that the disease is over. You do not need to see a doctor then.", UIFont.boldSystemFont(ofSize: 14)),
//                    ("childhood disease,", UIFont.boldSystemFont(ofSize: 14)),
//                    ("rashes and bleeding (\"petechiae\"),", UIFont.boldSystemFont(ofSize: 14))
//                ]
//                
//                for (textToBold, boldFont) in boldRanges {
//                    let range = (rashText as NSString).range(of: textToBold)
//                    attributedText.addAttribute(.font, value: boldFont, range: range)
//                }
                
                rashTextLabel.attributedText = attributedText
                detailsStack.addArrangedSubview(rashTextLabel)
            }

            
        }
    }
    // The method should be defined here
        @objc func toggleSection(_ sender: UIButton) {
            let section = sender.tag

            if let detailsStack = view.viewWithTag(200 + section) as? UIStackView {
                detailsStack.isHidden.toggle()
                
                let arrowIcon = detailsStack.isHidden ? "chevron.down" : "chevron.up"
                sender.setImage(UIImage(systemName: arrowIcon), for: .normal)
            }
        }
}
