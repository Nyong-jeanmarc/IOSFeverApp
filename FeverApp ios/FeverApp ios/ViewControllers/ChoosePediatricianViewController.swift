//
//  CoosePediatricianViewController.swift
//  FeverApp ios
//
//  Created by user on 8/8/24.
//
//
//  AddGenderViewController.swift
//  FeverApp ios
//
//  Created by user on 8/7/24.
//


import UIKit

class ChoosepediatricianViewController: UIViewController {
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var myTopView: UIView!
    
    @IBOutlet weak var myBottomView: UIView!
    @IBOutlet var NextUIButton: UIButton!
    
    @IBAction func handleNextUIButtonClick(_ sender: Any) {
        handleNavigationToFindYourPediatricianScreen()
    }
    func  handleNavigationToFindYourPediatricianScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let FindYourPediatricianVC = storyboard.instantiateViewController(withIdentifier: "findPediatrician") as? FindYourPediatricianViewController {
            self.navigationController?.pushViewController(FindYourPediatricianVC , animated: true)
        }
    }
    
    class CustomRoundedView: UIView {
        override func layoutSubviews() {
            super.layoutSubviews()
            applyRoundedCornersAndShadow()
        }
        
        private func applyRoundedCornersAndShadow() {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight, .bottomRight],
                                    cornerRadii: CGSize(width: 10, height: 10))
            
            // Rounded corners
            layer.cornerRadius = 10
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            layer.backgroundColor = UIColor.white.cgColor
            layer.masksToBounds = true
            
            // Shadow
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 5
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowPath = path.cgPath
            layer.masksToBounds = false
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        NextUIButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        
        myTopView.layer.cornerRadius = 25
        myTopView.layer.masksToBounds = true
        
        myBottomView.layer.cornerRadius = 20
        myBottomView.layer.masksToBounds = true
        
        // Shadow on top view
        myTopView.layer.shadowColor = UIColor.lightGray.cgColor
        myTopView.layer.shadowOpacity = 0.5
        myTopView.layer.shadowRadius = 5
        myTopView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myTopView.layer.masksToBounds = false
        // Shadow on bottom view
        myBottomView.layer.shadowColor = UIColor.lightGray.cgColor
        myBottomView.layer.shadowOpacity = 0.5
        myBottomView.layer.shadowRadius = 5
        myBottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        myBottomView.layer.masksToBounds = false
        
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 24, height: 24))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = .gray
        // Create a custom UILabel for the title
            let navtitleLabel = UILabel()
            navtitleLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.PROFILE-SURVEY.TEXT.3", defaultText:"Add Profile")
            navtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            navtitleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: navtitleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
        
    }
    
    func resizeImage(image: UIImage, to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    @objc func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
      }
    
    
    func setupUI() {
        let topContainerView = CustomRoundedView()
      
        topContainerView.backgroundColor = .white
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)

        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.DOCTOR.QUESTION", defaultText: "What is the name of your pediatrician?")
        topLabel.font = .systemFont(ofSize: 15)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topLabel)
        myImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topContainerView.bottomAnchor.constraint(equalTo: NextUIButton.topAnchor, constant: -30),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            topContainerView.heightAnchor.constraint(equalToConstant: 75),

            topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
            topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
            topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10),

            myImage.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            myImage.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: -37),
            myImage.widthAnchor.constraint(equalToConstant: 30),
            myImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    
}
