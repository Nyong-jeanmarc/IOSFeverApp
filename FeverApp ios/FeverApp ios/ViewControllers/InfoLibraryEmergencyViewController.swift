//
//  //
//  //
//  InfoLibraryWarningSignsViewController.swift
//  FeverApp ios
//
//  Created by user on 9/11/24.
//
import UIKit


class InfoLibraryEmergencyViewController: UIViewController{
    
    
    
    @IBOutlet var topView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var prevLabel: UILabel!
    @IBOutlet weak var closeLabel: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    
    
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
    
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "holisticSupportViewController")

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
            
            topView.layer.cornerRadius = 25
            topView.layer.masksToBounds = true
        
        infoLabel.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
        closeLabel.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close") , for: .normal)
        nextLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next")
        prevLabel.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.1", defaultText: "Previous")
            
            let containerView = UIView()
            containerView.backgroundColor = .white
            containerView.layer.cornerRadius = 15
            containerView.layer.masksToBounds = true
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOpacity = 0.1
            containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
            containerView.layer.shadowRadius = 4
            
            let newView = UIView()
            newView.backgroundColor = .white
            newView.layer.cornerRadius = 15
            newView.layer.masksToBounds = true
            newView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            let label = UILabel()
        label.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.47")
            label.font = UIFont.boldSystemFont(ofSize: 19)
            label.textColor = .black
            label.textAlignment = .left
            label.numberOfLines = 0
            
            newView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: -10),
                label.centerYAnchor.constraint(equalTo: newView.centerYAnchor)
            ])
            
            // Add scrollView for the main content inside containerView
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            containerView.addSubview(scrollView)
            
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            let imageView = UIImageView(image: UIImage(named: "950"))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 8
            imageView.layer.masksToBounds = true
            scrollView.addSubview(imageView)
            
            let textView = UILabel()
            
            // Full text content
            let fullText = """
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.541"))\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.542"))\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.543"))\n
                        \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.544")) \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.545"))\n
            
             \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.546").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.547"))\n
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.548").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.549").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.550").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.551").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.552").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.553").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.554").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.555").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.556").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.557").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.558").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.559").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.560").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.561").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
                \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.562").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            
               \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.563").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.564"))\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.565").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression))\n
            """
            
        
        
            // Create NSMutableAttributedString from the full text
            let attributedString = NSMutableAttributedString(string: fullText)
            
            // Define the ranges for the specific texts to style
            let wwwRange = (fullText as NSString).range(of: "www.116117.de")
            let statesRange = (fullText as NSString).range(of: """
             Baden-Württemberg
            
             Bayern
            
             Berlin
            
             Brandenburg
            
             Bremen
            
             Hamburg
            
             Hessen
            
             Mecklenburg-Vorpommern
            
             Niedersachsen
            
             Nordrhein-Westfalen
            
             Rheinland-Pfalz
            
             Sachsen-Anhalt
            
             Sachsen
            
             Schleswig-Holstein
            
             Thüringen
            """)
        let linkRange = (fullText as NSString).range(of: "https://www.kindergesundheit-info.de/themen\n/sicher-aufwachsen/notfall-infos\n/giftinformationszentralen-giftnotruf/")
                
        // Create UIColor from hex #6495ED (Cornflower Blue)
                let visibleColor = UIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1.0)
                
        // Define attributes for the custom color and underline
        let customUnderlineAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: visibleColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue

                ]
                
                // Apply the attributes to the specific ranges
                attributedString.addAttributes(customUnderlineAttributes, range: wwwRange)
                attributedString.addAttributes(customUnderlineAttributes, range: statesRange)
                attributedString.addAttributes(customUnderlineAttributes, range: linkRange)
                
            
            // Set the attributed string to the UILabel
            textView.attributedText = attributedString
            textView.numberOfLines = 0
            textView.font = UIFont.systemFont(ofSize: 16)
            
            scrollView.addSubview(textView)
            
            // Set constraints for imageView and textView inside the scrollView
            imageView.translatesAutoresizingMaskIntoConstraints = false
            textView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
                imageView.heightAnchor.constraint(equalToConstant: 200), // Adjust based on image size
                
                textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
                textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
                textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20) // To allow scrolling
            ])
            
            view.addSubview(newView)
            view.addSubview(containerView)
            
            newView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                newView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                newView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
                newView.heightAnchor.constraint(equalToConstant: 60) // Height of newView
            ])
            
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                containerView.topAnchor.constraint(equalTo: newView.bottomAnchor, constant: 0),
                containerView.heightAnchor.constraint(equalToConstant: 610) // Keep the height of mainView
            ])
        }
    }

