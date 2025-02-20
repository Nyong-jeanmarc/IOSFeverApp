//
//  contactUsViewController.swift
//  FeverApp ios
//
//  Created by Glory Ngassa  on 16/09/2024.
//


import UIKit

class contactUsViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var contactUsTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactUsTitle.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.CONTACT.TITLE.1", defaultText: "Contact us")
      
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
    
                // Create Scroll View
                let scrollView = UIScrollView()
                scrollView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(scrollView)

                // Create Content View for the scroll view
                let contentView = UIView()
                contentView.translatesAutoresizingMaskIntoConstraints = false
                contentView.backgroundColor = .white
                contentView.layer.cornerRadius = 15
                contentView.layer.masksToBounds = true
                scrollView.addSubview(contentView)

                // Create and configure labels, images, and buttons
        let contactDetailsLabel = createLabel(
            text: TranslationsViewModel.shared.getTranslation(key: "SHELL.CONTACT.HEADING.1", defaultText: "Contact details"),
            fontSize: 18,
            weight: .bold
        )

                let responsibleLabel = createLabel(
                    text: TranslationsViewModel.shared.getTranslation(key: "SHELL.CONTACT.HEADING.2", defaultText: "Responsible for the app"),
                    fontSize: 16,
                    weight: .bold)
        
                let serviceLabel = createLabel(
                    text: TranslationsViewModel.shared.getTranslation(key: "SHELL.CONTACT.HEADING.3", defaultText: "Service"),
                    fontSize: 18,
                    weight: .bold)
        
                let helpLabel = createLabel(
                    text: TranslationsViewModel.shared.getTranslation(key: "SHELL.CONTACT.HEADING.4", defaultText: "Help"),
                    fontSize: 18,
                    weight: .bold)
        

        // Individual sections of the text
        let responsibleDetailsText1 = TranslationsViewModel.shared.getTranslation(
            key: "SHELL.CONTACT.TEXT.4",
            defaultText: "Prof. Dr. med. David Martin"
        ).replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)

        let responsibleDetailsText2 = TranslationsViewModel.shared.getTranslation(
            key: "SHELL.CONTACT.TEXT.5",
            defaultText: "University of Witten/Herdecke"
        )

        let responsibleDetailsText3 = TranslationsViewModel.shared.getTranslation(
            key: "SHELL.CONTACT.TEXT.6",
            defaultText: """
        Faculty of Health / Department of Human Medicine/ Institute for Integrative Medicine
        Community Hospital
        """
        )

        let responsibleDetailsText4 = """
        Gerhard-Kienle-Weg 4
        """
        
        let responsibleDetailsText5 = """
        D-58313 Herdecke
        """
        // Combine all sections into a single string with spacing
        let combinedResponsibleDetailsText = """
        \(responsibleDetailsText1)
        
        \(responsibleDetailsText2)
        
        \(responsibleDetailsText3)
        
        \(responsibleDetailsText4)
        
        \(responsibleDetailsText5)
        """

        // Create an attributed string to apply styles
        let attributedText = NSMutableAttributedString(string: combinedResponsibleDetailsText)
        // Apply boldness to specific sections
        if let range1 = combinedResponsibleDetailsText.range(of: responsibleDetailsText1) {
            let nsRange = NSRange(range1, in: combinedResponsibleDetailsText)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: nsRange)
        }

        // Style "Gerhard-Kienle-Weg 4" to be blue and underlined
        if let range = combinedResponsibleDetailsText.range(of: responsibleDetailsText4) {
            let nsRange = NSRange(range, in: combinedResponsibleDetailsText)
            attributedText.addAttributes([
                .foregroundColor: UIColor.systemBlue,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }

        // Add line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5 // Adjust line spacing as needed
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))

        // Create UILabel and assign the attributed text
        let responsibleDetailsLabel = UILabel()
        responsibleDetailsLabel.attributedText = attributedText
        responsibleDetailsLabel.numberOfLines = 0
        responsibleDetailsLabel.translatesAutoresizingMaskIntoConstraints = false


        let serviceDetailsLabel = createLabel(
            text: TranslationsViewModel.shared.getTranslation(key: "SHELL.CONTACT.TEXT.9", defaultText: "Do you have any questions about the use of the app or technical problems? Please contact a member of the FeverApp team. We look forward to helping you! You can reach us by phone Monday to Friday from 10 a.m. to 12 p.m. at +49 2302 926 38080 or by e-mail at info@feverapp.de. If you call us at other times, we will call you back within 24 hours on weekdays.").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression), fontSize: 14, weight: .regular)

        // Define custom paragraph style for line spacing
        let customParagraphStyle = NSMutableParagraphStyle()
        customParagraphStyle.lineSpacing = 5 // Adjust the value as needed

        // Create the attributed string with the serviceDetailsLabel text
        let attributedString = NSMutableAttributedString(string: serviceDetailsLabel.text ?? "")
        attributedString.addAttribute(.paragraphStyle, value: customParagraphStyle, range: NSRange(location: 0, length: attributedString.length))

        // Define the phone number and email to apply the styles
        _ = "info@feverapp.de"

        // Apply the blue and underline styling to email address
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        // Use regular expressions to find and apply styles to the email address
        if let text = serviceDetailsLabel.text {
            // Regular expression for phone numbers: This matches common phone formats
            let phonePattern = "(\\+?[0-9]{1,4}[-\\s]?\\(?[0-9]{1,4}\\)?[-\\s]?[0-9]+[-\\s]?[0-9]+)" // Matches phone numbers like +49 2302 926 38080, 123 456 7890, (123) 456-7890
            let phoneRegex = try! NSRegularExpression(pattern: phonePattern, options: [])
            
            let phoneMatches = phoneRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            for match in phoneMatches {
                attributedString.addAttributes(attributes, range: match.range)
            }
            
            // Regular expression for email address (this will work with various email formats)
            let emailPattern = "(\\S+@feverapp\\.de)" // Match email format like info@feverapp.de
            let emailRegex = try! NSRegularExpression(pattern: emailPattern, options: [])
            
            let emailMatches = emailRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            for match in emailMatches {
                attributedString.addAttributes(attributes, range: match.range)
            }
        }

        // Set the attributed text to the label
        serviceDetailsLabel.attributedText = attributedString
        serviceDetailsLabel.numberOfLines = 0



        
        // Create the label with translation
        let helpDetailsLabel = createLabel(
            text: TranslationsViewModel.shared.getTranslation(
                key: "SHELL.CONTACT.TEXT.10",
                defaultText: "Important questions are answered here. A first guide on how to use the app can also be found here."
            ).replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression),
            fontSize: 14,
            weight: .regular
        )

        helpDetailsLabel.numberOfLines = 0

        // Only create the paragraph style once
        let helpDetailsLabelStyle = NSMutableParagraphStyle()
        helpDetailsLabelStyle.lineSpacing = 5 // Adjust the value for desired spacing

        // Create the attributed string
        let helpDetailsLabelattributedString = NSMutableAttributedString(string: helpDetailsLabel.text ?? "")

        // Define the blue and underline attributes
        let blueUnderlineAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        // Split the text into sentences by full stop
        let sentences = helpDetailsLabel.text?.components(separatedBy: ".") ?? []

        // Loop through sentences and apply the style to the last word before a full stop
        var currentLocation = 0
        for sentence in sentences {
            let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedSentence.isEmpty {
                // Find the last word in the sentence
                let words = trimmedSentence.split(separator: " ")
                if let lastWord = words.last {
                    // Get the range of the last word and apply blue and underline style
                    let lastWordRange = (trimmedSentence as NSString).range(of: String(lastWord))
                    
                    // Apply the style correctly by adjusting the range
                    let adjustedRange = NSRange(location: currentLocation + lastWordRange.location, length: lastWordRange.length)
                    helpDetailsLabelattributedString.addAttributes(blueUnderlineAttributes, range: adjustedRange)
                }
            }
            
            // Update the location for the next sentence
            currentLocation += trimmedSentence.count + 1 // +1 for the full stop
        }

        // Apply the paragraph style for line spacing
        helpDetailsLabelattributedString.addAttribute(.paragraphStyle, value: helpDetailsLabelStyle, range: NSRange(location: 0, length: helpDetailsLabelattributedString.length))

        // Set the final attributed text with line spacing applied
        helpDetailsLabel.attributedText = helpDetailsLabelattributedString

        


                // Create underlined link buttons
                let linkButton1 = createLinkButton(title: "https://www.feverapp.de")
                let phoneButton = createLinkButton(title: "+49 230 292 638 080")
                let emailButton = createLinkButton(title: "info@feverapp.de")

                let linkIcon = createImageView(imageName: "link")
                let phoneIcon = createImageView(imageName: "phonecall")
                let emailIcon = createImageView(imageName: "envelope")

                // Stack views to group icons and links/buttons
                let contactStack = UIStackView(arrangedSubviews: [linkIcon, linkButton1])
                contactStack.axis = .horizontal
                contactStack.spacing = 8

                let phoneStack = UIStackView(arrangedSubviews: [phoneIcon, phoneButton])
                phoneStack.axis = .horizontal
                phoneStack.spacing = 8

                let emailStack = UIStackView(arrangedSubviews: [emailIcon, emailButton])
                emailStack.axis = .horizontal
                emailStack.spacing = 8

                // StackView to organize the elements
                let stackView = UIStackView(arrangedSubviews: [
                    contactDetailsLabel, contactStack, phoneStack, emailStack,
                    responsibleLabel, responsibleDetailsLabel,
                    serviceLabel, serviceDetailsLabel,
                    helpLabel, helpDetailsLabel
                ])
                stackView.axis = .vertical
                stackView.spacing = 16
                stackView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(stackView)

                // Set up constraints for scrollView and contentView
                NSLayoutConstraint.activate([
                    // ScrollView constraints to scroll under topView
                    scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20), // Starts below topView
                    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                    scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                    // ContentView constraints
                    contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                    contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

                    // StackView constraints
                    stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
                ])
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
      }

      @objc func backButtonTapped() {
          let viewController = self.storyboard?.instantiateViewController(withIdentifier: "rhfyjf")
          viewController?.modalPresentationStyle = .fullScreen
          self.present(viewController!, animated: true, completion: nil)
      }
    
    
    
    

            // Helper function to create a label
            func createLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
                let label = UILabel()
                label.text = text
                label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
                label.textColor = .black
                label.numberOfLines = 0
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }

            // Helper function to create a link-style button
            func createLinkButton(title: String) -> UIButton {
                let button = UIButton(type: .system)
                button.setTitle(title, for: .normal)
                button.setTitleColor(.systemBlue, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                button.titleLabel?.textAlignment = .left
                button.contentHorizontalAlignment = .leading
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }

            // Helper function to create image views
            func createImageView(imageName: String) -> UIImageView {
                let imageView = UIImageView()
                imageView.image = UIImage(named: imageName)
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
                return imageView
            }
        }
//
//  contactUsViewController.swift
//  FeverApp ios
//
//  Created by NEW on 16/09/2024.
//

import Foundation
