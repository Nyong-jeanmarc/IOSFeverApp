//
//  StateOfHealthViewController.swift
//  FeverApp ios
//
//  Created by user on 8/22/24.
//

import UIKit
class stateOfHealthViewController: UIViewController{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var headView:UIView!
    @IBOutlet weak var bottomView:UIView!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet weak var noskipButton: UIButton!
    
    var selectedButton: UIButton?

       override func viewDidLoad() {
           super.viewDidLoad()
           configureScrollView()
           addShadowToButtons()
           noskipButton.layer.borderColor = UIColor.lightGray.cgColor
           noskipButton.layer.borderWidth = 1.0
           noskipButton.layer.cornerRadius = 10

           let attributedString = NSMutableAttributedString(string: "No answer Skip")
           attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 9))
           attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 10, length: 4))
           noskipButton.setAttributedTitle(attributedString, for: .normal)

           headView.layer.cornerRadius = 18
           bottomView.layer.cornerRadius = 20
         

           // Create a new view with shadow and border radius
           let myView = UIView()
           myView.backgroundColor = .white
           myView.translatesAutoresizingMaskIntoConstraints = false

           // Add shadow
           myView.layer.shadowColor = UIColor.black.cgColor
           myView.layer.shadowOpacity = 0.5
           myView.layer.shadowRadius = 4
           myView.layer.shadowOffset = CGSize(width: 0, height: 2)

           // Add border radius
           myView.layer.cornerRadius = 10
           myView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

           // Add to view hierarchy
           view.addSubview(myView)

           // Add constraints
           NSLayoutConstraint.activate([
               myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  50),
               myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -50),
               myView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -15),
               myView.heightAnchor.constraint(equalToConstant: 40)
           ])
           
           
           // Create a label
           let label = UILabel()
           label.text = "How does <name> feel?"
           label.font = .systemFont(ofSize: 13)
           label.textAlignment = .left
           label.translatesAutoresizingMaskIntoConstraints = false

           // Add label to view
           myView.addSubview(label)

           // Add constraints to label
           NSLayoutConstraint.activate([
               label.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 10),
               label.centerYAnchor.constraint(equalTo: myView.centerYAnchor)
           ])
           
           
           
           
       }

       func configureScrollView() {
           scrollView.showsHorizontalScrollIndicator = false
           buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
           scrollView.contentSize = CGSize(width: 1300, height: scrollView.frame.height)
           NSLayoutConstraint.activate([
               buttonContainerView.widthAnchor.constraint(equalToConstant: 1300),
               buttonContainerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
               scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
           ])
       }

      

       // New function to add dark shadow to buttons
       func addShadowToButtons() {
           for button in buttonContainerView.subviews where button is UIButton {
               let btn = button as! UIButton
               btn.layer.shadowColor = UIColor.black.cgColor
               btn.layer.shadowOpacity = 0.5
               btn.layer.shadowRadius = 4
               btn.layer.shadowOffset = CGSize(width: 0, height: 2)

               // Make shadow visible around border
               btn.layer.masksToBounds = false
               btn.layer.borderWidth = 1.0
               btn.layer.borderColor = UIColor.clear.cgColor
           }
       }
   }

