//
//  InfoLibraryWhyDoseTheBodyRaisTheTemperatureViewController.swift
//  FeverApp ios
//
//  Created by user on 9/12/24.
//

import UIKit


class InfoLibraryWhyDoseTheBodyRaisTheTemperatureViewController: UIViewController{
    
    
    
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
        let viewController = storyboard.instantiateViewController(withIdentifier: "doctorQuestions")

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
        let viewController = storyboard.instantiateViewController(withIdentifier: "bodyTemperatureAndFeverViewController")

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
        
        infoLabel.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
        closeLabel.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close") , for: .normal)
        nextLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next")
        prevLabel.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.1", defaultText: "Previous")
            
            // Create the main view with white background
            let mainView = UIView()
            mainView.backgroundColor = .white
            mainView.layer.cornerRadius = 15
            mainView.layer.masksToBounds = true
            mainView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            // Add shadow to mainView
            mainView.layer.shadowColor = UIColor.black.cgColor
            mainView.layer.shadowOpacity = 0.1
            mainView.layer.shadowOffset = CGSize(width: 0, height: 2)
            mainView.layer.shadowRadius = 4
            
            // Add the 'newView' (the header view with the label)
            let newView = UIView()
            newView.backgroundColor = .white
            newView.layer.cornerRadius = 15
            newView.layer.masksToBounds = true
            newView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            // Create label for the newView
            let newLabel = UILabel()
            newLabel.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.6")
            newLabel.font = UIFont.boldSystemFont(ofSize: 16)
            newLabel.textColor = .black
            newLabel.textAlignment = .left
            newLabel.numberOfLines = 0
            
            newView.addSubview(newLabel)
            newLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newLabel.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 10),
                newLabel.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: -10),
                newLabel.centerYAnchor.constraint(equalTo: newView.centerYAnchor)
            ])
            
            // Add scrollView for the main content inside mainView
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = true
            mainView.addSubview(scrollView)
            
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
                scrollView.topAnchor.constraint(equalTo: mainView.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
            ])
            
            // Add imageView for the "Rectangle. 2" image
            let imageView1 = UIImageView(image: UIImage(named: "Rectangle drugs"))
            imageView1.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView1)
            
            // Add second imageView for another "Rectangle. 2" image below the first one
            let imageView2 = UIImageView(image: UIImage(named: "fieber"))
            imageView2.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView2)
            
            // Add the label with attributed text for the content under the images
            let label1 = UILabel()
            label1.numberOfLines = 0
            
            let text = """
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.112"))\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.113"))\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.114"))\n
            
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.115"))\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.116").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)))\n
            """
            
            let url1Text = "*https://www.kindergesundheit info.de/themen/krankes-kind/krankheitszeichen/fieber/"
            let url2Text = "*https://www.dgkj.de/eltern/dgkj-elterninformationen/elterninfo-fieber/"
            
            // Create the full attributed string
            let attributedString = NSMutableAttributedString(string: text)
            
            // Create a paragraph style for spacing between links
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 10 // Adds space between paragraphs
            
            // Add some spacing between the URLs and the text
            let fullText = NSMutableAttributedString(string: "\n\n")
            
            // First URL with blue color and underline
            let url1 = NSMutableAttributedString(string: url1Text)
            url1.addAttributes([
                .foregroundColor: UIColor.blue, // Explicit blue color
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .paragraphStyle: paragraphStyle
            ], range: NSRange(location: 0, length: url1.length))
            fullText.append(url1)
            
            // Add spacing between the URLs
            let spacer = NSAttributedString(string: "\n\n") // Two newlines for spacing
            fullText.append(spacer)
            
            // Second URL with blue color and underline
            let url2 = NSMutableAttributedString(string: url2Text)
            url2.addAttributes([
                .foregroundColor: UIColor.blue, // Explicit blue color
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .paragraphStyle: paragraphStyle
            ], range: NSRange(location: 0, length: url2.length))
            fullText.append(url2)
            
            attributedString.append(fullText)
            
            label1.attributedText = attributedString
            
            // Customize the label
            label1.font = UIFont.systemFont(ofSize: 14)
            label1.textColor = .black
            
            scrollView.addSubview(label1)
            
            // Set constraints for both imageViews and label1 inside the scrollView
            imageView1.translatesAutoresizingMaskIntoConstraints = false
            imageView2.translatesAutoresizingMaskIntoConstraints = false
            label1.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                imageView1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
                imageView1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
                
                imageView1.heightAnchor.constraint(equalToConstant: 160), // Adjust based on image size
                
                imageView2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                imageView2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
                imageView2.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 40), // Top distance of 20 to the existing image
                imageView2.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
                imageView2.heightAnchor.constraint(equalToConstant: 150), // Adjust based on image size
                
                label1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                label1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
                label1.topAnchor.constraint(equalTo: imageView2.bottomAnchor, constant: 40),
                label1.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20) // To allow scrolling
            ])
            
            // Add newView and mainView to the view controller's view
            view.addSubview(newView)
            view.addSubview(mainView)
            
            // Set constraints for newView (header view)
            newView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                newView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                newView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
                newView.heightAnchor.constraint(equalToConstant: 60) // Height of newView
            ])
            
            // Set constraints for mainView
            mainView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
                mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
                mainView.topAnchor.constraint(equalTo: newView.bottomAnchor, constant: 0),
                mainView.heightAnchor.constraint(equalToConstant: 610) // Keep the height of mainView
            ])
        }
    }
