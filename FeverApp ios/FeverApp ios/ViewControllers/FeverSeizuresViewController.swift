//
//  FeverSeizuresViewController.swift
//  FeverApp ios
//
//  Created by user on 8/14/24.
//

import UIKit

class FeverSeizuresViewController: UIViewController{
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    
    
    
    
    class CustomRoundedView: UIView {
        var corners: UIRectCorner = []
        
        override func layoutSubviews() {
            super.layoutSubviews()
            applyCornerRadius()
        }

        private func applyCornerRadius() {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: 10, height: 10))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true

    
        // Apply shadow to yesButton
                yesButton.layer.shadowColor = UIColor.black.cgColor
                yesButton.layer.shadowOffset = CGSize(width: 0, height: 2)
                yesButton.layer.shadowOpacity = 0.2
                yesButton.layer.shadowRadius = 3
                
                // Apply shadow to noButton
                noButton.layer.shadowColor = UIColor.black.cgColor
                noButton.layer.shadowOffset = CGSize(width: 0, height: 2)
                noButton.layer.shadowOpacity = 0.2
                noButton.layer.shadowRadius = 3
        
        

        noButton.layer.cornerRadius = 8
        yesButton.layer.cornerRadius = 8
      
        
        
        initialYesButtonColor = yesButton.backgroundColor
        initialNoButtonColor = noButton.backgroundColor

        
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
    }
                                   
  
    
    var initialYesButtonColor: UIColor?
    var initialNoButtonColor: UIColor?
    var initialMyButtonColor: UIColor?
    var initialKnowButtonColor: UIColor?
    
    
    func resetButtonColors() {
        yesButton.backgroundColor = initialYesButtonColor
        noButton.backgroundColor = initialNoButtonColor
      
    }
   

    
    
    @objc func noButtonTapped() {
        resetButtonColors()
        yesButton.backgroundColor = initialYesButtonColor
        noButton.backgroundColor =
        UIColor(hexString: "#A5BDF2")
    }
    
  
    
    @objc func yesButtonTapped() {
        resetButtonColors()
        noButton.backgroundColor = initialNoButtonColor
        yesButton.backgroundColor =
        UIColor(hexString: "#A5BDF2")
    }
    
    
    
    
    func setupUI() {
        let topContainerView = CustomRoundedView()
        topContainerView.corners = [.topLeft, .topRight, .bottomRight]
        topContainerView.backgroundColor = .white
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)

        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = "Are you willing to take part in this study?"
        topLabel.font = .systemFont(ofSize: 13)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topLabel)
        myImage.translatesAutoresizingMaskIntoConstraints = false

        let bottomContainerView = CustomRoundedView()
        bottomContainerView.corners = [.topLeft, .topRight, .bottomRight]
        bottomContainerView.backgroundColor = .white
        bottomContainerView.layer.borderColor = UIColor.black.cgColor
        bottomContainerView.layer.shadowColor = UIColor.black.cgColor
        bottomContainerView.layer.shadowOpacity = 0.5
        bottomContainerView.layer.shadowRadius = 5
        bottomContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bottomContainerView.clipsToBounds = false
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomContainerView)
        
        let bottomLabel = UILabel()
        bottomLabel.numberOfLines = 0
        bottomLabel.textColor = .black
        bottomLabel.text = "We are investigating two ways of dealing with fever seizures.One mothod involves keeping the child cool and suppressing the fever, while the alternative approach entails keeping the child warm to support the fever."
        bottomLabel.font = .systemFont(ofSize: 13)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.addSubview(bottomLabel)

        NSLayoutConstraint.activate([
            bottomContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 365),
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 170),
            
            bottomLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 10),
            bottomLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
            bottomLabel.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
            bottomLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -10),
            
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 565),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
            topContainerView.heightAnchor.constraint(equalToConstant: 60),

            topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
            topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
            topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10),

            // Adjusted constraints for `myImage` now that it's a subview of `topContainerView`
            myImage.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            myImage.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: -37),
            myImage.widthAnchor.constraint(equalToConstant: 30),
            myImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    
    
    
}
