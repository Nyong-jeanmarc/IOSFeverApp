//
//  whatIsFeverViewController.swift
//  FeverApp ios
//
//  Created by NEW on 12/09/2024.
//



import UIKit

class whatIsFeverViewController:UIViewController{
    let chevronButton = UIButton()
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    
    @IBAction func backBtnTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    
    // Back button action
    @objc private func backButtonTapped() {
        // Perform action for the back button, like dismissing the view controller
        // If you're not using a navigation controller, just dismiss
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InfoLibraryWarningSignsViewController")

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
        imageView.image = UIImage(named: "Rectangle40") // Add your image asset here
        imageView.contentMode = .scaleAspectFit
        staticView.addSubview(imageView)
        
        // Description Label
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.1"))\n\n\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.2"))"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        staticView.addSubview(descriptionLabel)
        
        // Temperature Classification Table
        let table = createTemperatureTable()
        table.translatesAutoresizingMaskIntoConstraints = false
        staticView.addSubview(table)
        
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
            
            // Description Label constraints
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: staticView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: staticView.trailingAnchor, constant: -16),
            
            // Table constraints
            table.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            table.leadingAnchor.constraint(equalTo: staticView.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: staticView.trailingAnchor, constant: -16),
            
            // Content StackView constraints
            contentStackView.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: staticView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: staticView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: staticView.bottomAnchor, constant: -20)
        ])
        
        // Set the content size of the scroll view
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: staticView.bounds.height)
        
        
        
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
        label.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.1")
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        newView.addSubview(label)
        
        // Add constraints to the label
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: newView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 10)
        ])
    }
    // ... rest of your code remains the same
    
    // Create a table for temperature classification
    func createTemperatureTable() -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 4
        
        // Create rows for the table
        let rows = [
            ("\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.3"))", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.4"))"),
            ("\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.5"))", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.6"))"),
            ("\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.7"))", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.8"))"),
            ("\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.9"))", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.10"))"),
            ("\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.11"))", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.12"))")
        ]
        
        for row in rows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            
            let label1 = UILabel()
            label1.text = row.0
            label1.numberOfLines = 0
            label1.font = UIFont.systemFont(ofSize: 14)
            
            let label2 = UILabel()
            label2.text = row.1
            label2.numberOfLines = 0
            label2.font = UIFont.systemFont(ofSize: 14)
            label2.textAlignment = .right
            
            rowStackView.addArrangedSubview(label1)
            rowStackView.addArrangedSubview(label2)
            
            // Add a horizontal separator view
            let separatorView = UIView()
            separatorView.backgroundColor = .lightGray
            separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            stackView.addArrangedSubview(rowStackView)
            stackView.addArrangedSubview(separatorView)
        }
        
        return stackView
    }
    
    // Add content from the second view controller
    func addContent(to stackView: UIStackView) {
        // Subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.13"))"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .black
        subtitleLabel.numberOfLines = 0
        stackView.addArrangedSubview(subtitleLabel)
        
        // Content items
        let items = [
            ("1.1", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.2"))"),
            ("1.2", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.3"))"),
            ("1.3", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.4"))"),
            ("1.4", "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.5"))")
        ]
        // Additional details for each section
        let text49 = getAttributedString(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.49"))
        let additionalDetails = [
        "•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.14"))\n•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.15"))\n•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.16"))\n•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.17"))",
        
            """
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.18"))\n•
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.19"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.20"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.21"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.22"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.23"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.24"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.25"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.26"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.27"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.28"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.29"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.30"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.31"))\n
•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.32"))\n
""",
        
        """
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.33"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.34"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.35"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.36"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.37"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.38"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.39"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.40"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.41"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.42"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.43"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.44"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.45"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.46"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.47"))\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.48"))\n
        •\(text49)\n
        •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.49_2"))\n
        """,
        
        
            """
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.50"))\n
              \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.51"))\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.52"))\n
              \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.53"))\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.54"))\n
              \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.55"))\n
              \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.56"))\n
            •\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.57"))\n
              \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.58"))\n
              \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.59"))\n
            """
        ]

        
        for (index, item) in items.enumerated() {
            let itemStackView = UIStackView()
            itemStackView.axis = .horizontal
            itemStackView.spacing = 8
            itemStackView.alignment = .center
            
            // Circle view for the numbering
            let numberCircleView = UIView()
            numberCircleView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            numberCircleView.layer.cornerRadius = 20 // Make it a circle
            numberCircleView.translatesAutoresizingMaskIntoConstraints = false
            numberCircleView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            numberCircleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            // Label inside the circle
            let numberLabel = UILabel()
            numberLabel.text = item.0
            numberLabel.font = UIFont.boldSystemFont(ofSize: 16)
            numberLabel.textAlignment = .left
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
            descriptionLabel.font = UIFont.systemFont(ofSize: 16)
            descriptionLabel.numberOfLines = 0
            
            // Chevron button
            let chevronButton = UIButton(type: .system)
            chevronButton.tintColor = .lightGray
            chevronButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            chevronButton.tag = index
            chevronButton.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
            chevronButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chevronButton.widthAnchor.constraint(equalToConstant: 30),   // Set fixed width
                chevronButton.heightAnchor.constraint(equalToConstant: 30)   // Set fixed height
            ])

            // Add views to itemStackView
            itemStackView.addArrangedSubview(numberCircleView)
            itemStackView.addArrangedSubview(descriptionLabel)
            itemStackView.addArrangedSubview(chevronButton)
            
            // Add the itemStackView to the stackView
            stackView.addArrangedSubview(itemStackView)
            
            // Detail label (hidden initially)
            // Add additional detail label (each section has unique details)
                       let detailLabel = UILabel()
                       detailLabel.text = additionalDetails[index] // Set unique additional details here
                       detailLabel.font = UIFont.systemFont(ofSize: 14)
                       detailLabel.numberOfLines = 0
                       detailLabel.isHidden = true
                       detailLabel.tag = index + 100 // Ensure this tag allows easy lookup later
                       stackView.addArrangedSubview(detailLabel)
                   }
        // Further information section
        let furtherInfoLabel = UILabel()
        furtherInfoLabel.text = "\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.60"))"
        furtherInfoLabel.font = UIFont.systemFont(ofSize: 16)
        stackView.addArrangedSubview(furtherInfoLabel)
        
        let scientificLabel = UILabel()
        scientificLabel.attributedText = getAttributedString("\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.61"))")
        scientificLabel.font = UIFont.systemFont(ofSize: 16)
        scientificLabel.textColor = .black
        stackView.addArrangedSubview(scientificLabel)
        
        // Links
        let link1Label = UILabel()
        link1Label.attributedText = getAttributedString("•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.62"))")
        link1Label.font = UIFont.systemFont(ofSize: 16)
        link1Label.numberOfLines = 2
        let attributedText1 = NSMutableAttributedString(string: link1Label.text!)
        attributedText1.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: link1Label.text!.count))
        link1Label.attributedText = attributedText1
        stackView.addArrangedSubview(link1Label)
        
        let link2Label = UILabel()
        link2Label.attributedText = getAttributedString("•\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.63"))")
        link2Label.font = UIFont.systemFont(ofSize: 16)
        link2Label.numberOfLines = 3
        let attributedText2 = NSMutableAttributedString(string: link2Label.text!)
        attributedText2.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: link2Label.text!.count))
        link2Label.attributedText = attributedText2
        stackView.addArrangedSubview(link2Label)
        
        let citationLabel = UILabel()
        citationLabel.text = "• \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.64"))"
        citationLabel.font = UIFont.systemFont(ofSize: 16)
        citationLabel.numberOfLines = 0
        stackView.addArrangedSubview(citationLabel)
    }
    
    
    @objc func toggleSection(_ sender: UIButton) {
        // Your toggleSection implementation
        guard let stackView = sender.superview?.superview as? UIStackView else {
            return
        }
        
        let detailLabel = stackView.arrangedSubviews.first(where: { $0.tag == sender.tag + 100 }) as? UILabel
        let isHidden = detailLabel?.isHidden ?? true
        
        UIView.animate(withDuration: 0.3) {
            detailLabel?.isHidden = !isHidden
            let chevronImage = isHidden ? "chevron.up" : "chevron.down"
            sender.setImage(UIImage(systemName: chevronImage), for: .normal)
        }
    }
    
    
    
    
}
