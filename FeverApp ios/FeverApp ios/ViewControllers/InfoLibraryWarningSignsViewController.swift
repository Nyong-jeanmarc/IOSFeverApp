//
//  InfoLibraryWarningSignsViewController.swift
//  FeverApp ios
//
//  Created by user on 9/11/24.
//
import UIKit


class InfoLibraryWarningSignsViewController: UIViewController{
    
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
    
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "certificateFortheEmployer")

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
            let imageView = UIImageView(image: UIImage(named: "Rectangle. 2"))
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)

            // Add the label for the text under the image
            let label1 = UILabel()
        let text82 = removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.82"))
        let text83 = removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.83"))
        let text84 = removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.84"))



            label1.text = """
            \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.65")))\n\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.66"))\n\n
            \(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.67"))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.68")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.69")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.70")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.71")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.72")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.73")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.74")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.75")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.76")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.77")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.78")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.79")))\n
            *\(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.80")))\n\n
            \(removeHTMLTags(TranslationsViewModel.shared.getInfoLibraryTranslation(key: "INFOS.TEXT.81")))\n
            •\(text82)\n
            •\(text83)\n
            •\(text84)\n
            """
        
        
            label1.font = UIFont.systemFont(ofSize: 14)
            label1.textColor = .black
            label1.numberOfLines = 0

            scrollView.addSubview(label1)

            // Set constraints for imageView and label1 inside the scrollView
            imageView.translatesAutoresizingMaskIntoConstraints = false
            label1.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
                imageView.heightAnchor.constraint(equalToConstant: 150), // Adjust based on image size

                label1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
                label1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
                label1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
                label1.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20) // To allow scrolling
            ])

            // Add newView and mainView to the view controller's view
            view.addSubview(newView)
            view.addSubview(mainView)

            // Set constraints for newView (header view)
            newView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                newView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                newView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
                newView.heightAnchor.constraint(equalToConstant: 60) // Height of newView
            ])

            // Set constraints for mainView
            mainView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                mainView.topAnchor.constraint(equalTo: newView.bottomAnchor, constant: 0),
                mainView.heightAnchor.constraint(equalToConstant: 610) // Keep the height of mainView
            ])
        }
    
    }
func removeHTMLTags(_ htmlString: String) -> String {
    return htmlString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
}
