//
//  aboutFeverAppViewController.swift
//  FeverApp ios
//
//  Created by NEW on 16/09/2024.
//


import UIKit


class aboutFeverAppViewController:UIViewController{
    
    @IBOutlet var topView: UIView!
    @IBOutlet weak var aboutFeverAppTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var contentView: UIView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            topView.layer.cornerRadius = 20
            topView.layer.masksToBounds = true
            aboutFeverAppTitle.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.ABOUT", defaultText: "About FeverApp")

                    // Content View (Static)
                    contentView = UIView()
                    contentView.translatesAutoresizingMaskIntoConstraints = false
                    contentView.backgroundColor = .white // White background
                    contentView.layer.cornerRadius = 20 // Rounded corners
                    contentView.layer.masksToBounds = true
                    view.addSubview(contentView)

                    // Scroll View (Inside contentView)
                    let scrollView = UIScrollView()
                    scrollView.translatesAutoresizingMaskIntoConstraints = false
                    contentView.addSubview(scrollView)

                    // Inner Content View for scrollable content
                    let innerContentView = UIView()
                    innerContentView.translatesAutoresizingMaskIntoConstraints = false
                    scrollView.addSubview(innerContentView)

                    // Constraints for the static contentView
                    NSLayoutConstraint.activate([
                        contentView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20), // Fixed position below topView
                        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
                        
                        // ScrollView constraints within contentView
                        scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
                        scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        
                        // Inner content view constraints within the scroll view
                        innerContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                        innerContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                        innerContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                        innerContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                        innerContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
                    ])

                    // Label for main body text
            let bodyText = TranslationsViewModel.shared.getTranslation(key: "SHELL.ABOUT.TEXT.1", defaultText: "The FeverApp is the only German app on the subject of fever that is supported and recommended by the associations of pediatricians and adolescent physicians.")
                    let bodyLabel = createLabel(withText: bodyText)
                    innerContentView.addSubview(bodyLabel)

                    // Add the three images
                    let image1 = createImageView(named: "Iconic_wave")
                    let image2 = createImageView(named: "Frame 48361")
                    let image3 = createImageView(named: "Image")
                    innerContentView.addSubview(image1)
                    innerContentView.addSubview(image2)
                    innerContentView.addSubview(image3)
            // Label for supported text
            let supportedText = TranslationsViewModel.shared.getTranslation(
                key: "SHELL.ABOUT.TEXT.2",
                defaultText: "Supported by the Federal Ministry of Education and Research (BMBF), the app was developed under the direction of the pediatrician Prof. Dr. med. David Martin of the University Witten/Herdecke in cooperation with the Professional Association of Pediatricians and Adolescent Physicians (BVKJ)."
            ).replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)

            // Phrases to style (original untranslated phrases)
            let phrasesToStyle = [
                "Federal Ministry of Education and Research (BMBF)",
                "University Witten/Herdecke",
                "Professional Association of Pediatricians and Adolescent Physicians (BVKJ)"
            ]

            // Function to create an attributed label
            func createAttributedLabel(withText text: String, originalPhrases: [String]) -> UILabel {
                let attributedString = NSMutableAttributedString(string: text)
                
                // Define styles
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 16),
                    .foregroundColor: UIColor.systemBlue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                
                for originalPhrase in originalPhrases {
                    let rangeOptions: NSString.CompareOptions = [.caseInsensitive, .diacriticInsensitive]

                    // Dynamically search for matches of the original phrases
                    if let range = text.range(of: originalPhrase, options: rangeOptions) {
                        let nsRange = NSRange(range, in: text)
                        attributedString.addAttributes(attributes, range: nsRange)
                    } else {
                        print("Warning: Could not find phrase '\(originalPhrase)' in translated text.")
                    }
                }
                
                let label = UILabel()
                label.attributedText = attributedString
                label.numberOfLines = 0 // Multiline support
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }

            // Create the styled label
            let supportedLabel = createAttributedLabel(withText: supportedText, originalPhrases: phrasesToStyle)
            innerContentView.addSubview(supportedLabel)
                   

                    // Additional text
                    let additionalText1 = TranslationsViewModel.shared.getTranslation(key: "SHELL.ABOUT.TEXT.3", defaultText: "The app helps parents to examine their child's fever closely and provides scientifically substantiated information on how to deal with it.")
            let additionalText2 = TranslationsViewModel.shared.getTranslation(key: "SHELL.ABOUT.TEXT.4", defaultText: "Conflict of Interest: FeverApp and its employees refuse any financial support from the pharmaceutical industry that may be in any way related to the contents of FeverApp. When product names are mentioned, it is only because they are scientifically proven or frequently used by parents.")
            let additionalText3 = TranslationsViewModel.shared.getTranslation(key: "SHELL.ABOUT.TEXT.5", defaultText: "Translation: This translation was carried out in March, 2020 by the FeverApp team. FeverApp is currently available in German, English, French, Dutch, Russian, Turkish, Arabic, Persian, Italian, Polish, Spanish, Portuguese, Ukrainian and Georgian. Please notify us, in case of language errors. Change of language is possible via the menu.").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)
            
            // Combine the additional texts into one string
            let combinedText = "\(additionalText1)\n\n\(additionalText2)\n\n\(additionalText3)"

            // Pass the combined text to createLabel
            let additionalLabel = createLabel(withText: combinedText)
            innerContentView.addSubview(additionalLabel)


                    // Apply constraints for all elements inside the scrollable area
                    NSLayoutConstraint.activate([
                        bodyLabel.topAnchor.constraint(equalTo: innerContentView.topAnchor, constant: 20),
                        bodyLabel.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor, constant: 20),
                        bodyLabel.trailingAnchor.constraint(equalTo: innerContentView.trailingAnchor, constant: -20),
                        
                        image1.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 20),
                        image1.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor, constant: 20),
                        image1.widthAnchor.constraint(equalToConstant: 100),
                        image1.heightAnchor.constraint(equalToConstant: 100),
                        
                        image2.topAnchor.constraint(equalTo: image1.topAnchor),
                        image2.leadingAnchor.constraint(equalTo: image1.trailingAnchor, constant: 20),
                        image2.widthAnchor.constraint(equalToConstant: 100),
                        image2.heightAnchor.constraint(equalToConstant: 100),
                        
                        image3.topAnchor.constraint(equalTo: image1.topAnchor),
                        image3.leadingAnchor.constraint(equalTo: image2.trailingAnchor, constant: 20),
                        image3.widthAnchor.constraint(equalToConstant: 100),
                        image3.heightAnchor.constraint(equalToConstant: 100),
                        
                        supportedLabel.topAnchor.constraint(equalTo: image1.bottomAnchor, constant: 20),
                        supportedLabel.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor, constant: 20),
                        supportedLabel.trailingAnchor.constraint(equalTo: innerContentView.trailingAnchor, constant: -20),
                        
                        additionalLabel.topAnchor.constraint(equalTo: supportedLabel.bottomAnchor, constant: 20),
                        additionalLabel.leadingAnchor.constraint(equalTo: innerContentView.leadingAnchor, constant: 20),
                        additionalLabel.trailingAnchor.constraint(equalTo: innerContentView.trailingAnchor, constant: -20),
                        additionalLabel.bottomAnchor.constraint(equalTo: innerContentView.bottomAnchor, constant: -20)
                    ])
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
         }

         @objc func backButtonTapped() {
             let viewController = self.storyboard?.instantiateViewController(withIdentifier: "rhfyjf")
             viewController?.modalPresentationStyle = .fullScreen
             self.present(viewController!, animated: true, completion: nil)
         }
    
    
    
    

                // Helper function to create a label
                func createLabel(withText text: String) -> UILabel {
                    let label = UILabel()
                    label.text = text
                    label.numberOfLines = 0
                    label.translatesAutoresizingMaskIntoConstraints = false
                    return label
                }

                // Helper function to create an image view
                func createImageView(named imageName: String) -> UIImageView {
                    let imageView = UIImageView(image: UIImage(named: imageName))
                    imageView.contentMode = .scaleAspectFit
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    return imageView
                }

                // Helper function to create an attributed label with blue underlined text
                func createAttributedLabel(withText text: String, boldText: [String], blueUnderlinedText: [String]) -> UILabel {
                    let label = UILabel()
                    label.numberOfLines = 0
                    label.font = UIFont.systemFont(ofSize: 16)
                    
                    let attributedString = NSMutableAttributedString(string: text)
                    
                    // Apply blue and underlined style to the specified parts
                    for bluePart in blueUnderlinedText {
                        if let blueRange = text.range(of: bluePart) {
                            attributedString.addAttributes([
                                .foregroundColor: UIColor.blue,
                                .underlineStyle: NSUnderlineStyle.single.rawValue
                            ], range: NSRange(blueRange, in: text))
                        }
                    }

                    // Apply the attributed string to the label
                    label.attributedText = attributedString
                    label.translatesAutoresizingMaskIntoConstraints = false
                    return label
                }
            }

