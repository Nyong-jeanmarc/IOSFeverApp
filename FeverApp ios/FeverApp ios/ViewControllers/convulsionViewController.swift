//
//  convulsionViewController.swift
//  FeverApp ios
//
//  Created by user on 8/15/24.
//

import UIKit

class convulsionViewController: UIViewController{
    
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBOutlet weak var yesButton: UIButton!
    
    @IBOutlet weak var noButton: UIButton!
    
    @IBOutlet weak var myButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    
    
    
    
    
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
        self.navigationItem.hidesBackButton = true
        setupUI()
        
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        
        bottomView.layer.cornerRadius = 20
        bottomView.layer.masksToBounds = true
        
        
        
     
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
        
                
        
        // Apply shadow to noButton
        myButton.layer.shadowColor = UIColor.black.cgColor
        myButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        myButton.layer.shadowOpacity = 0.2
        myButton.layer.shadowRadius = 4
        myButton.layer.borderWidth = 0.5
        myButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        myButton.layer.cornerRadius = 8
        noButton.layer.cornerRadius = 8
        yesButton.layer.cornerRadius = 8
        
        
        initialYesButtonColor = yesButton.backgroundColor
        initialNoButtonColor = noButton.backgroundColor
        initialMyButtonColor = myButton.backgroundColor
       
        
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        myButton.addTarget(self, action: #selector(myButtonTapped), for: .touchUpInside)
       
    }
                                   
  
    
    var initialYesButtonColor: UIColor?
    var initialNoButtonColor: UIColor?
    var initialMyButtonColor: UIColor?
    var initialKnowButtonColor: UIColor?
    
    
    func resetButtonColors() {
        yesButton.backgroundColor = initialYesButtonColor
        noButton.backgroundColor = initialNoButtonColor
        
    }
   
    @objc func myButtonTapped() {
        resetButtonColors()
        myButton.backgroundColor = .lightGray
      
    }
    
    
    @objc func noButtonTapped() {
        resetButtonColors()
        myButton.backgroundColor = initialMyButtonColor
        noButton.backgroundColor =
        UIColor(hexString: "#A5BDF2")
    }
    
    
    
    @objc func yesButtonTapped() {
        resetButtonColors()
        myButton.backgroundColor = initialMyButtonColor
        yesButton.backgroundColor =
        UIColor(hexString: "#A5BDF2")
    }
    
    
    
    
    func setupUI() {
        
            // ...

            let myButtonTitle = NSMutableAttributedString(string: "No answer Skip")
            myButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 10))
            myButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
            myButton.setAttributedTitle(myButtonTitle, for: .normal)

            // ...
    
        
        
        let topContainerView = CustomRoundedView()
        topContainerView.corners = [.topLeft, .topRight, .bottomRight]
        topContainerView.backgroundColor = .white
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)

        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = "Has <name> had febrile convulsion?"
        topLabel.font = .systemFont(ofSize: 13)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topLabel)
        myImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 475),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 58),
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

    
    
    
    
    

