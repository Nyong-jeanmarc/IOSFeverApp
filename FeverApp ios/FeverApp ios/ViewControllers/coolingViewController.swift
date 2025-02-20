//
//  coolingViewController.swift
//  FeverApp ios
//
//  Created by NEW on 14/08/2024.
//

import UIKit

class coolingViewController : UIViewController{
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var myLogo: UIImageView!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    var selectedButton: UIButton?

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

       func applyEffects(to button: UIButton) {
           let maskView = UIView()
           maskView.backgroundColor = .clear
           maskView.layer.cornerRadius = 10
           maskView.layer.masksToBounds = true

           button.layer.shadowColor = UIColor.gray.cgColor
              button.layer.shadowOffset = CGSize(width: 0, height: 2) // Adjust the offset as needed
              button.layer.shadowOpacity = 0.7 // Adjust opacity (0 is fully transparent, 1 is fully opaque)
              button.layer.shadowRadius = 4.0 // Adjust blur radius as needed
           var _: UIButton!
       }

       override func viewDidLoad() {
           super.viewDidLoad()
           button1.backgroundColor = .white
                   button2.backgroundColor = .white
           
           setupUI()

           topView.layer.cornerRadius = 25
           topView.layer.masksToBounds = true

           button1.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
           button2.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
           
           applyEffects(to: button1)
           applyEffects(to: button2)
           button1.layer.cornerRadius = 8
           button1.layer.masksToBounds = true
           button2.layer.cornerRadius = 8
           button2.layer.masksToBounds = true
           
       }

       @objc func buttonTapped(_ sender: UIButton) {
           if sender != selectedButton {
               button1.backgroundColor = .white
               button2.backgroundColor = .white
               
               sender.backgroundColor = UIColor(red: 168/255, green: 193/255, blue: 247/255, alpha: 1)
                          
                          // Update the selected button
                          selectedButton = sender
           }
       }

       func setupUI() {
           let topContainerView = CustomRoundedView()
           topContainerView.corners = [.topLeft, .topRight, .bottomRight]
           topContainerView.backgroundColor = .white
           topContainerView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(topContainerView)

           let topLabel = UILabel()
           topLabel.numberOfLines = 0
           topLabel.text = "Which strategy would you like to follow?"
           topLabel.font = .systemFont(ofSize: 15)
           topLabel.translatesAutoresizingMaskIntoConstraints = false
           topContainerView.addSubview(topLabel)
           myLogo.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               topContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 517),
               topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
               topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -150),
               topContainerView.heightAnchor.constraint(equalToConstant: 75),

               topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
               topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
               topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
               topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10),

               myLogo.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
               myLogo.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: -37),
               myLogo.widthAnchor.constraint(equalToConstant: 30),
               myLogo.heightAnchor.constraint(equalToConstant: 30)
           ])
       }
   }

    
    

