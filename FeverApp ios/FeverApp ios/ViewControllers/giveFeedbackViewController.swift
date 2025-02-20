//
//  giveFeedbackViewController.swift
//  FeverApp ios
//
//  Created by Glory Ngassa  on 16/09/2024.
//

import UIKit

class giveFeedbackViewController: UIViewController {
    
    @IBOutlet var topview: UIView!
    
    @IBOutlet var bottomView: UIView!
    @IBOutlet weak var giveFeedbackTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            topview.layer.cornerRadius = 20
            topview.layer.masksToBounds = true
        bottomView.layer.cornerRadius = 20
        bottomView.layer.masksToBounds = true
            // Set up the background color
        giveFeedbackTitle.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.FEEDBACK", defaultText: "Give feedback")

                // Create the white background view for the label
                let whiteView = UIView()
                whiteView.backgroundColor = .white
                whiteView.layer.cornerRadius = 10
                whiteView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(whiteView)

                // Create the feedback description label with attributed text inside the white view
                let descriptionLabel = UILabel()
                descriptionLabel.numberOfLines = 0
                descriptionLabel.attributedText = getAttributedDescription()
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
                whiteView.addSubview(descriptionLabel)

                // Create the feedback button
                let feedbackButton = UIButton(type: .system)
        feedbackButton.setTitle( TranslationsViewModel.shared.getTranslation(key: "SHELL.FEEDBACK.TEXT.2", defaultText: "Start Feedback Questionnaire"), for: .normal)
                feedbackButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                feedbackButton.setTitleColor(.white, for: .normal)
                feedbackButton.backgroundColor = UIColor(hex: "#A5BDF2")
                feedbackButton.layer.cornerRadius = 10
                feedbackButton.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(feedbackButton)
        
        
        // Add tap gestures to each card using tags
        addTapGesture(to: feedbackButton,tag: 1)
        
        
        
                // Setup constraints with respect to topView
                NSLayoutConstraint.activate([
                    // White view constraints below the titleLabel
                    whiteView.topAnchor.constraint(equalTo: topview.bottomAnchor, constant: 16),
                    whiteView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    whiteView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
                    // Description label constraints inside whiteView
                    descriptionLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 16),
                    descriptionLabel.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 16),
                    descriptionLabel.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -16),
                    descriptionLabel.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -16),
                    
                    // Feedback button constraints with respect to the bottom of the view
                    feedbackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    feedbackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    feedbackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
                    feedbackButton.heightAnchor.constraint(equalToConstant: 50)
                ])
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
       }
    
    @objc func backButtonTapped() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "rhfyjf")
        viewController?.modalPresentationStyle = .fullScreen
        self.present(viewController!, animated: true, completion: nil)
    }
    
    
    
    
    // Helper function to add a tap gesture recognizer
    private func addTapGesture(to view: UIView, tag: Int) {
        view.tag = tag
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    @objc func handleCardTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        switch tappedView.tag {
        case 1:
            navigateToViewController(withIdentifier: "FeedbackQuestionaireViewController")
       
        default:
            break
        }
    }
    var moveToOverView : (()->Void)?
    // Helper function to navigate to a view controller
    private func navigateToViewController(withIdentifier identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        // Check if the instantiated view controller is of the type that has a callback
            if let viewController = viewController as? FeedbackQuestionaireViewController {
                // Assign the callback
                viewController.moveToMenu = {
                    self.dismiss(animated: false)
                    self.moveToOverView?()
                       }
                }
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    

            // Function to create the attributed string with blue, underlined links
            private func getAttributedDescription() -> NSAttributedString {
                let fullText = TranslationsViewModel.shared.getTranslation(
                    key: "SHELL.FEEDBACK.TEXT.1",
                    defaultText: "With a click on the button you can start a feedback questionnaire about the app. You can fill this out once. If you have any further feedback afterwards, you can always send us an e-mail to info@feverapp.de or call us at +49 2302 926 38080."
                ).replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)

                let attributedString = NSMutableAttributedString(string: fullText)

                // Define paragraph style for line spacing
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 5 // Adjust spacing value
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

                // Define attributes for blue and underlined text
                let blueUnderlineAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.systemBlue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]

                // Regular expression to find phone numbers
                let phonePattern = "(\\+?[0-9]{1,4}[-\\s]?\\(?[0-9]{1,4}\\)?[-\\s]?[0-9]+[-\\s]?[0-9]+)"

                do {
                    let regex = try NSRegularExpression(pattern: phonePattern, options: [])
                    let matches = regex.matches(in: fullText, options: [], range: NSRange(location: 0, length: fullText.utf16.count))
                    
                    // Apply blue and underline attributes to each match
                    for match in matches {
                        attributedString.addAttributes(blueUnderlineAttributes, range: match.range)
                    }
                } catch {
                    print("Error creating regex: \(error)")
                }

                // Apply the attributed string to a UILabel or similar
                let label = UILabel()
                label.numberOfLines = 0
                label.attributedText = attributedString



                // Define the attributes for the links (blue and underlined)
                let linkAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.systemBlue,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]

                // Add attributes for the email link
                if let emailRange = fullText.range(of: "info@feverapp.de") {
                    let nsRange = NSRange(emailRange, in: fullText)
                    attributedString.addAttributes(linkAttributes, range: nsRange)
                }

                // Add attributes for the phone link
                if let phoneRange = fullText.range(of: "+49 2302 926 38080") {
                    let nsRange = NSRange(phoneRange, in: fullText)
                    attributedString.addAttributes(linkAttributes, range: nsRange)
                }

                return attributedString
            }
        }
//
//  giveFeedbackViewController.swift
//  FeverApp ios
//
//  Created by NEW on 16/09/2024.
//

import Foundation
