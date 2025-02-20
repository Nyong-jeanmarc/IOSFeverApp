//
//  disclaimerOfLiaViewController.swift
//  FeverApp ios
//
//  Created by NEW on 14/09/2024.
//
 import UIKit

class DisclaimerOfLiaViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var disclaimerTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.layer.cornerRadius = 25
        topView.layer.masksToBounds = true
        
        disclaimerTitle.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.DISCLAIMER", defaultText: "Disclaimer of liability")
        
        // Set up the label
        let containerView = UIView()
               containerView.translatesAutoresizingMaskIntoConstraints = false
               containerView.layer.cornerRadius = 10
               containerView.backgroundColor = .white
               
               // Set up the label
               let disclaimerLabel = UILabel()
               disclaimerLabel.numberOfLines = 0 // Allows multiple lines
        disclaimerLabel.text =  TranslationsViewModel.shared.getTranslation(key: "WARNING.TEXT", defaultText: "You are responsible for the use of the FeverApp. The FeverApp serves to support the doctor-patient relationship, the app does not give individual advice. The app and the corresponding websites only give general recommendations. These reflect the current state of science. However, medical knowledge is subject to constant change. If you have any medical questions, please contact a doctor. Especially if your child has a chronic illness or other conditions that are detrimental to the child's fever, you should consult your doctor before using this app.")
               disclaimerLabel.textAlignment = .left
               disclaimerLabel.font = UIFont.systemFont(ofSize: 16)
               disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
               
               // Add the label to the container view
               containerView.addSubview(disclaimerLabel)

               // Add the container view to the main view
               view.addSubview(containerView)

               // Set up constraints for the container view
               NSLayoutConstraint.activate([
                   containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                   containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                   containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
                   containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
               ])

               // Set up constraints for the label within the container view
               NSLayoutConstraint.activate([
                   disclaimerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                   disclaimerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                   disclaimerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                   disclaimerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
               ])

               // Set background color for the main view
               
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
      }

      @objc func backButtonTapped() {
          let viewController = self.storyboard?.instantiateViewController(withIdentifier: "rhfyjf")
          viewController?.modalPresentationStyle = .fullScreen
          self.present(viewController!, animated: true, completion: nil)
      }
    
    
    
       }
