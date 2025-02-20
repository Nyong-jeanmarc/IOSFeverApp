//
//  CompareTemperatureViewController.swift
//  FeverApp ios
//
//  Created by NEW on 22/08/2024.
//
import UIKit

class CompareTemperatureViewController: UIViewController {
    @IBOutlet var Buttons: [UIButton]!
 
    @IBOutlet weak var tempButton: UIButton!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet var messageViews: [UIView]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for message in messageViews {
            message.layer.cornerRadius = 11
            message.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
            message.layer.shadowColor = UIColor.lightGray.cgColor
            message.layer.shadowOpacity = 1
            message.layer.shadowOffset = CGSize(width: 0, height: 1)
            message.layer.shadowRadius = 2
        }
        tempButton.layer.borderWidth = 2
        tempButton.layer.borderColor = UIColor.blue.cgColor
        messageView.layer.cornerRadius = 15
        messageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        messageView.layer.shadowColor = UIColor.lightGray.cgColor
        messageView.layer.shadowOpacity = 0.8
        messageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        messageView.layer.shadowRadius = 2
        //give all buttons shadows
        for button in Buttons {
            button.layer.shadowColor = UIColor.lightGray.cgColor
            button.layer.shadowOpacity = 0.8
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowRadius = 2
        }
        for button in Buttons {
            button.titleLabel?.font = UIFont(name: "Arial-BoldMT", size: 4)
            button.setTitle(button.title(for: .normal), for: .normal)
    
        }
        // Configure scrollView
       
        scrollView.showsHorizontalScrollIndicator = false

        // Configure buttonStackView
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
                buttonStackView.tintColor = .gray
       
    

        // Add buttonStackView to scrollView
        scrollView.addSubview(buttonStackView)

        // Add scrollView to view
        view.addSubview(scrollView)

        // Configure constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            buttonStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 7),
            buttonStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 7),
            buttonStackView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }

    @objc func buttonTapped(_ sender: UIButton) {
        print("Button tapped: \(sender.title(for: .normal) ?? "")")
    }
}


