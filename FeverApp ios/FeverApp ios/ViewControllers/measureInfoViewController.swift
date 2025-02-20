//
//  measureInfoViewController.swift
//  FeverApp ios
//
//  Created by user on 9/12/24.
//

import UIKit


class measureInfoViewController: UIViewController{
    
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
    
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        infoTitle.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
        closeBtn.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close") , for: .normal)
        nextLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next")
        previousLabel.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.1", defaultText: "Previous")
        
        topView.layer.cornerRadius = 25
        topView.layer.masksToBounds = true
        
        
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
        Label.text = TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.HEADING.11")
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

        
        let imageView = UIImageView(image: UIImage(named: "redgirl_720"))
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)

        
        let textView = UILabel()
        textView.text = """
                  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.129"))\n\n
                  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.130"))\n\n
                  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.131"))\n\n
                  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.132"))\n\n
                  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.133"))\n\n
                  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.134"))\n\n
                  \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.135"))\n
                  •\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.136")))\n
                  •\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.137")))\n
                  •\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.138")))\n
                  
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
                      containerView.heightAnchor.constraint(equalToConstant: 610) // Keep the height of mainView
                  ])
        
        
    }
}
