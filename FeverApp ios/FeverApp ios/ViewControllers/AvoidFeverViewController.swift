//
//  AvoidFeverViewController.swift
//  FeverApp ios
//
//  Created by user on 9/16/24.
//

import UIKit
class AvoidFeverViewController: UIViewController{


    @IBOutlet weak var topView: UIView!
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
        let viewController = storyboard.instantiateViewController(withIdentifier: "frequentFeverViewController")

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
        let viewController = storyboard.instantiateViewController(withIdentifier: "whatIsFeverViewController")

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

    
    let Label = UILabel()
    Label.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.66")
    Label.font = UIFont.boldSystemFont(ofSize: 16)
    Label.textColor = .black
    Label.textAlignment = .left
    Label.numberOfLines = 0

    newView.addSubview(Label)
    Label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        Label.leadingAnchor.constraint(equalTo: newView.leadingAnchor, constant: 10),
        Label.trailingAnchor.constraint(equalTo: newView.trailingAnchor, constant: -10),
        Label.centerYAnchor.constraint(equalTo: newView.centerYAnchor)
    ])

    // Add scrollView for the main content inside mainView
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = true
    containerView.addSubview(scrollView)

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])

    
    let imageView = UIImageView(image: UIImage(named: "HAPPY-KIDS"))
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 20 // Rayon des coins arrondis
    imageView.layer.masksToBounds = true // Coupure des bords dépassants
    imageView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(imageView)

    NSLayoutConstraint.activate([
        imageView.heightAnchor.constraint(equalToConstant: 200),
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    ])
    
    
    
    
    // Créer le texte
    let textView = UILabel()
    textView.text = """
\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.728"))

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.729"))

\(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.730"))\n
"""
   
   
    
    textView.font = UIFont.systemFont(ofSize: 14)
    textView.textColor = .black
    textView.numberOfLines = 0

    scrollView.addSubview(textView)

    // Set constraints for imageView and label1 inside the scrollView
    imageView.translatesAutoresizingMaskIntoConstraints = false
    textView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
        imageView.heightAnchor.constraint(equalToConstant: 150), // Adjust based on image size

        textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
        textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
        textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
        textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20) // To allow scrolling
    ])


    view.addSubview(newView)
    view.addSubview(containerView)

  
    newView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        newView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        newView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        newView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
        newView.heightAnchor.constraint(equalToConstant: 60) // Height of newView
    ])

 
    containerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        containerView.topAnchor.constraint(equalTo: newView.bottomAnchor, constant: 0),
        containerView.heightAnchor.constraint(equalToConstant: 440) // Keep the height of mainView
    ])
}

}
