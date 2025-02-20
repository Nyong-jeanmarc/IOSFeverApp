//
//  ProfileList.swift
//  FeverApp ios
//
//  Created by user on 12/1/24.
//

import Foundation
import UIKit
import CoreData

protocol ProfileListDelegate: AnyObject {
    func didDismissProfileList()
}


class ProfileListViewController: UIViewController, CardComponentDelegate {
    
    weak var delegate: ProfileListDelegate?
    
    func didTapCard(profileId: Int64, profileName: String?, profileGender: String?, profileDob: String?, profileOnlineId: Int64?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // Save data to Core Data
        if let profileName = profileName {
            appDelegate.saveProfileName(profileName: profileName)
        }
        if let profileGender = profileGender {
            appDelegate.saveProfileGender(profileGender: profileGender)
        }
        if let profileDob = profileDob {
            appDelegate.saveProfileDateOfBirth(profileDateOfBirth: profileDob)
        }
        if let profileOnlineId = profileOnlineId {
            appDelegate.saveProfileOnlineId(profileOnlineId: profileOnlineId)
        }
        appDelegate.saveProfileId(profileId: profileId)

        print("Saved profile data to Core Data for profileId: \(profileId)")
        LocalNotificationManager.shared.checkAndScheduleNotificationsForUnlinkedEntries()
        // Navigate to the overview screen
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let AddProfileNameVC = storyboard.instantiateViewController(withIdentifier: "overview") as? overviewViewController {
//            let navigationController = UINavigationController(rootViewController: AddProfileNameVC)
//            navigationController.modalPresentationStyle = .fullScreen
//            self.present(navigationController, animated: true, completion: nil)
//        }
        
        // Notify delegate before dismissing
        delegate?.didDismissProfileList()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        overviewLabel.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.DIARY.LABEL", defaultText: "Overview")
        
        setupCustomTabBar()
        setupCustomTabBar()
        if let previousCard = setupCardComponents() {
            setupAddNewProfileCard(previousCard: previousCard)
        }
        
        // Make the background of the scrollView and contentView transparent
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
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
    
    private func setupCardComponents() -> UIView? {
        //fetch profiles
        let profiles = fetchAllLocalProfiles() ?? [] // Use an empty array as a fallback if fetch fails
        
        print("Fetched \(profiles.count) profiles")
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 2),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
            

            // ContentView Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Important for horizontal scrolling
//            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 2),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2),
////            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
//            
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
////            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
        
        var previousCard: UIView?
        
        profiles.enumerated().forEach { index, profile in
            let cardComponent = CardComponent()
            cardComponent.configureCardComponent(
                profileId: profile.profileId, profileName: profile.profileName, profileRole: profile.profileRole, profileGender: profile.profileGender, profileDob: profile.profileDob, profileOnlineId: profile.onlineProfileId)
            
            // Set the delegate
            cardComponent.delegate = self
            
            contentView.addSubview(cardComponent)
            cardComponent.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                cardComponent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                cardComponent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                cardComponent.heightAnchor.constraint(equalToConstant: 90),
            ])
            
            if let previousCard = previousCard {
                NSLayoutConstraint.activate([
                    cardComponent.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: -20)
                ])
            } else {
                NSLayoutConstraint.activate([
                    cardComponent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -2)
                ])
            }
            
            previousCard = cardComponent
            
        }
//        return previousCard
        // Ensure the last card's bottom is anchored to the contentView's bottom
        if let previousCard = previousCard {
            NSLayoutConstraint.activate([
                previousCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
            ])
            
        }
        return previousCard
    }
    
    private func setupAddNewProfileCard(previousCard: UIView?) {
        let addNewProfileCard = UIView()
        addNewProfileCard.backgroundColor = .white
        addNewProfileCard.layer.cornerRadius = 10
        addNewProfileCard.layer.shadowColor = UIColor.gray.cgColor
        addNewProfileCard.layer.shadowOpacity = 0.5
        addNewProfileCard.layer.shadowRadius = 5
        addNewProfileCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        addNewProfileCard.isUserInteractionEnabled = true

        
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addNewProfileButtonTapped))
//        addNewProfileCard.addGestureRecognizer(tapGestureRecognizer)
        
        let userIcon = UIImageView()
        userIcon.image = UIImage(systemName: "person")
        userIcon.tintColor = .gray
        
        let addNewProfileLabel = UILabel()
        addNewProfileLabel.text = TranslationsViewModel.shared.getTranslation(key: "PROFILE.PROFILE-LIST.TEXT.1", defaultText: "Add new profile")
        addNewProfileLabel.font = .systemFont(ofSize: 16)
        
        let plusButton = UIButton()
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.tintColor = .systemBlue
        plusButton.isUserInteractionEnabled = true
        plusButton.isEnabled = true
//        plusButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        addNewProfileCard.bringSubviewToFront(plusButton)

        
        contentView.addSubview(addNewProfileCard)
        addNewProfileCard.translatesAutoresizingMaskIntoConstraints = false
        
        addNewProfileCard.addSubview(userIcon)
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        
        addNewProfileCard.addSubview(addNewProfileLabel)
        addNewProfileLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addNewProfileCard.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addNewProfileCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addNewProfileCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addNewProfileCard.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        if let previousCard = previousCard {
            NSLayoutConstraint.activate([
                addNewProfileCard.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: -6)
            ])
        } else {
            NSLayoutConstraint.activate([
                addNewProfileCard.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
            ])
        }
        
        NSLayoutConstraint.activate([
            userIcon.leadingAnchor.constraint(equalTo: addNewProfileCard.leadingAnchor, constant: 16),
            userIcon.centerYAnchor.constraint(equalTo: addNewProfileCard.centerYAnchor),
            userIcon.widthAnchor.constraint(equalToConstant: 24),
            userIcon.heightAnchor.constraint(equalToConstant: 24),
            
            addNewProfileLabel.leadingAnchor.constraint(equalTo: userIcon.trailingAnchor, constant: 16),
            addNewProfileLabel.centerYAnchor.constraint(equalTo: addNewProfileCard.centerYAnchor),
            
            plusButton.trailingAnchor.constraint(equalTo: addNewProfileCard.trailingAnchor, constant: -16),
            plusButton.centerYAnchor.constraint(equalTo: addNewProfileCard.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 24),
            plusButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        contentView.layoutIfNeeded()

    }

    @objc func buttonTapped(_ sender: UIButton) {
        print("Add new profile button tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let AddProfileNameVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? AddProfileNameViewController {
            let navigationController = UINavigationController(rootViewController: AddProfileNameVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }

    func fetchAllLocalProfiles() -> [ProfileList]? {
        // Get the managed context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the Profile entity
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        
        do {
            // Fetch all profiles
            let profiles = try managedContext.fetch(fetchRequest)
            
            // Convert Profile objects to ProfileList objects
            let profileLists = profiles.compactMap { profile -> ProfileList? in
                guard let profileName = profile.profileName, !profileName.isEmpty else { return nil }
                
                return ProfileList(
                    profileId: profile.profileId,
                    profileName: profileName,
                    onlineProfileId: profile.onlineProfileId,
                    profileDob: profile.profileDateOfBirth?.description,
                    profileGender: profile.profileGender
                )
            }
            
            return profileLists
        } catch let error as NSError {
            print("Could not fetch profiles. \(error), \(error.userInfo)")
            return nil
        }
    }

}


struct ProfileList {
    let profileId: Int64
    let profileName: String
    let profileRole: String
    let onlineProfileId: Int64?
    let profileDob: String?
    let profileGender: String?
    
    init(profileId: Int64, profileName: String, onlineProfileId: Int64? = 0, profileDob: String? = "", profileGender: String? = "") {
        self.profileId = profileId
        self.profileName = profileName
        self.profileRole = "child"
        self.onlineProfileId = onlineProfileId
        self.profileDob = profileDob
        self.profileGender = profileGender
    }
}

protocol CardComponentDelegate: AnyObject {
    func didTapCard(profileId: Int64, profileName: String?, profileGender: String?, profileDob: String?, profileOnlineId: Int64?)
}

// CardComponent.swift

class CardComponent: UIView {
    
    weak var delegate: CardComponentDelegate?
    
    // Properties
    var profileId: Int64?
    var profileName: String?
    var profileRole: String?
    var profileGender: String?
    var profileDob: String?
    var profileOnlineId: Int64?
    var stateOfHealth: String?
    
    // UI Components
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    let profileInitialLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    let stateOfHealthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let pencilButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // Setup UI
    private func setupUI() {
        addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(profileInitialLabel)
        profileInitialLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(profileNameLabel)
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(stateOfHealthLabel)
        stateOfHealthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(pencilButton)
        pencilButton.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            profileInitialLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            profileInitialLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            profileInitialLabel.widthAnchor.constraint(equalToConstant: 40),
            profileInitialLabel.heightAnchor.constraint(equalToConstant: 40),
            
            profileNameLabel.leadingAnchor.constraint(equalTo: profileInitialLabel.trailingAnchor, constant: 16),
            profileNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            profileNameLabel.trailingAnchor.constraint(equalTo: pencilButton.leadingAnchor, constant: -16),
            
            stateOfHealthLabel.leadingAnchor.constraint(equalTo: profileInitialLabel.trailingAnchor, constant: 16),
            stateOfHealthLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 4),
            stateOfHealthLabel.trailingAnchor.constraint(equalTo: pencilButton.leadingAnchor, constant: -16),
            
            pencilButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -8),
            pencilButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            pencilButton.widthAnchor.constraint(equalToConstant: 24),
            pencilButton.heightAnchor.constraint(equalToConstant: 24),
            
            deleteButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            deleteButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            deleteButton.widthAnchor.constraint(equalToConstant: 24),
            deleteButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        cardView.addGestureRecognizer(tapGesture)
        cardView.isUserInteractionEnabled = true
    }
    
    // Handle the tap
    @objc private func handleCardTap() {
        // Notify the delegate about the card tap
        delegate?.didTapCard(
            profileId: profileId ?? 0,
            profileName: profileName,
            profileGender: profileGender,
            profileDob: profileDob,
            profileOnlineId: profileOnlineId
        )
    }
    
    // Configure the card component
    func configureCardComponent(
        profileId: Int64,
        profileName: String,
        profileRole: String,
        profileGender: String?,
        profileDob: String?,
        profileOnlineId: Int64?
    ) {
        self.profileId = profileId
        self.profileName = profileName
        self.profileRole = profileRole
        self.profileGender = profileGender
        self.profileDob = profileDob
        self.profileOnlineId = profileOnlineId
        
        profileInitialLabel.text = String(profileName.first ?? " ")
        profileNameLabel.text = profileName
        stateOfHealthLabel.text = profileRole
    }
    
    
    
    
    
    
    
    


}
