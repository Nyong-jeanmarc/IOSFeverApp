//
// //
//  PersonalInfoViewController.swift
//  FeverApp ios
//
//  Created by Bar Bie  on 05/09/2024.
//

import UIKit

class PersonalInfoViewController:UIViewController, PersonalInfoDelegate{
    
    func personalInfoDidChange() {
        // Add custom view
        setupCustomView()
    }
    
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBAction func editButtonTapped(_ sender: UIButton) {
        // Instantiate the view controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "editPersonalInfo") as? EditUserProfileViewController
        
        // Set the delegate
        viewController?.delegate = self

        // Push the view controller if embedded in a navigation controller
        if let navigationController = self.navigationController {
            navigationController.pushViewController(viewController!, animated: true)
        } else {
            // Otherwise, present it modally in full screen
            viewController?.modalPresentationStyle = .fullScreen
            present(viewController!, animated: true, completion: nil)
        }
    }

    @IBAction func backButtonTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EditUserProfileViewController {
            destinationViewController.delegate = self
        }
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.PERSONAL.INFO",defaultText: "Personal info")
        editBtn.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.EDIT",defaultText: "Edit"), for: .normal)
           // Round the corners for topView and bottomView
           topView.layer.cornerRadius = 25
           topView.layer.masksToBounds = true
           
           bottomView.layer.cornerRadius = 20
           bottomView.layer.masksToBounds = true
           
           // Add custom view
           setupCustomView()
        setupCustomTabBar()
       }
    
    private func setupCustomTabBar() {
        let customTabBar = CustomTabBarView()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.parentViewController = self // Assign the parent view controller
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        customTabBar.updateTranslations()
        customTabBar.updateTabBarItemColors()
    }
       
       func setupCustomView() {
           // Main container view
           
           let roleTranslations: [String: String] = [
               "Mom": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.MOTHER", defaultText: "Mom"),
               "Dad": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.FATHER", defaultText: "Dad"),
               "Grandpa": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.GRANDPA", defaultText: "Grandpa"),
               "Grandma": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.GRANDMA", defaultText: "Grandma"),
               "Other": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.OTHER", defaultText: "Other"),
               "Not specified": TranslationsViewModel.shared.getTranslation(key: "LOGIN.ROLE.OPTION.NO_ANSWER", defaultText: "Not specified")
           ]
           
           let userPersonalInfo = fetchUserPersonalInfo()
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let (_, familyCode) = appDelegate.fetchUserData()
           
           let containerView = UIView()
           containerView.translatesAutoresizingMaskIntoConstraints = false
           containerView.backgroundColor = .white
           containerView.layer.cornerRadius = 15
           containerView.layer.masksToBounds = true
           view.addSubview(containerView)

           // Title label ("None")
           let titleLabel = UILabel()
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           titleLabel.text =  roleTranslations[userPersonalInfo?.first?.familyRole ?? ""] ?? userPersonalInfo?.first?.familyRole ?? "-"
           titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
           titleLabel.textAlignment = .center
           containerView.addSubview(titleLabel)

           // Subtitle label ("testqrdp")
           let subtitleLabel = UILabel()
           subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
           subtitleLabel.text = familyCode
           subtitleLabel.font = UIFont.systemFont(ofSize: 14)
           subtitleLabel.textAlignment = .center
           containerView.addSubview(subtitleLabel)

           // Bottom left label ("year of birth")
           let yearOfBirthLabel = UILabel()
           yearOfBirthLabel.translatesAutoresizingMaskIntoConstraints = false
           yearOfBirthLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.YEAR.OF.BIRTH",defaultText: "year of birth")
           yearOfBirthLabel.textColor = .lightGray
           yearOfBirthLabel.font = UIFont.systemFont(ofSize: 12)
           containerView.addSubview(yearOfBirthLabel)

           // Bottom right label ("None")
           let valueLabel = UILabel()
           valueLabel.translatesAutoresizingMaskIntoConstraints = false
           valueLabel.text = userPersonalInfo?.first?.userYearOfBirth ??  TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.NONE",defaultText: "None")
           valueLabel.font = UIFont.systemFont(ofSize: 14)
           valueLabel.textAlignment = .right
           containerView.addSubview(valueLabel)

           // Horizontal separator line
           let separatorView = UIView()
           separatorView.translatesAutoresizingMaskIntoConstraints = false
           separatorView.backgroundColor = .lightGray
           containerView.addSubview(separatorView)

           // Add constraints for containerView
           NSLayoutConstraint.activate([
               containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               containerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20), // 10 distance to bottomView
               containerView.heightAnchor.constraint(equalToConstant: 150)
           ])

           // Constraints for titleLabel
           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
               titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
           ])

           // Constraints for subtitleLabel
           NSLayoutConstraint.activate([
               subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
               subtitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
           ])

           // Constraints for yearOfBirthLabel (bottom-left)
           NSLayoutConstraint.activate([
               yearOfBirthLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -8),
               yearOfBirthLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
           ])

           // Constraints for valueLabel (bottom-right)
           NSLayoutConstraint.activate([
               valueLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -8),
               valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
           ])

           // Constraints for separatorView (place it below the labels)
           NSLayoutConstraint.activate([
               separatorView.leadingAnchor.constraint(equalTo: yearOfBirthLabel.leadingAnchor),
               separatorView.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
               separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
               separatorView.heightAnchor.constraint(equalToConstant: 1)
           ])
       }
    
    // Back button action
    @objc private func backButtonTapped() {
        // Perform action for the back button, like dismissing the view controller
        // If you're not using a navigation controller, just dismiss
        self.dismiss(animated: true, completion: nil)
    }
   }
    
   

