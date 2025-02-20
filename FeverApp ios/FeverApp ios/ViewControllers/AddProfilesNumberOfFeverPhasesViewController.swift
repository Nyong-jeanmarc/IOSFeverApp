//
//  FeverPhaseViewController.swift
//  FeverApp ios
//
//  Created by user on 8/13/24.
//

import UIKit

class AddProfilesNumberOfFeverPhasesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var profilesNumberOfFeverPhases: Int16?
    let profileName = AddProfileNameModel.shared.userProfileName ?? "no name"
    
    
    @IBOutlet weak var topView: UIView!
    
    
    @IBOutlet weak var myImage: UIImageView!
    
    
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet var NoAnswerUIButton: UIButton!
    
    
    @IBOutlet var selectFeverPhasesUIButton: UIButton!
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: view)
            if !NoAnswerUIButton.frame.contains(location) {
                NoAnswerUIButton.backgroundColor = .white // Remplacez par la couleur initiale du bouton
            }
        }
    }
    
    
    
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
    var popupContainer: UIView!
    var selectFeverPhasesUITableView: UITableView!
    var selectedNumber: Int?
    var dimView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        selectFeverPhasesUIButton.setTitle("\(TranslationsViewModel.shared.getTranslation(key: "MEDICATION_INPUT.PLACEHOLDER", defaultText: "Select")) \(TranslationsViewModel.shared.getTranslation(key: "EPISODE_COUNT_INPUT.PLACEHOLDER", defaultText: "fever phases"))", for: .normal)
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.3
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 24, height: 24))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = .gray
        // Create a custom UILabel for the title
            let navtitleLabel = UILabel()
            navtitleLabel.text =  TranslationsViewModel.shared.getTranslation(key: "PROFILE.PROFILE-SURVEY.TEXT.3", defaultText:"Add Profile")
            navtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            navtitleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: navtitleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
      
        
        dimView = nil
        // Set corner radius for the views
        
        topView.layer.cornerRadius = 20
       
        
        bottomView.layer.cornerRadius = 20

        
        NoAnswerUIButton.layer.cornerRadius = 8
        NoAnswerUIButton.layer.masksToBounds = true
        
        NoAnswerUIButton.layer.borderWidth = 0.5
        NoAnswerUIButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        selectFeverPhasesUIButton.layer.cornerRadius = 8
        selectFeverPhasesUIButton.layer.masksToBounds = true
        
        
        NoAnswerUIButton.layer.borderWidth = 0.5
        NoAnswerUIButton.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
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
    @IBAction func handleNoAnswerUIButtonClick(_ sender: UIButton) {
        sender.backgroundColor = .lightGray
        handleNavigationToProfilesHighFeverFrequencyScreen()
    }
    
    
    @IBAction func handleSelectFeverPhasesUIButtonClick(_ sender: Any) {
        dimView = UIView()
            dimView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimView?.frame = view.bounds
            view.addSubview(dimView!)
        // Ajouter un tap gesture pour fermer le popup en cliquant n'importe où
        _ = UITapGestureRecognizer(target: self, action: #selector(closePopup))
   
        
        popupContainer = UIView()
        popupContainer.backgroundColor = .white
        popupContainer.layer.cornerRadius = 12
        popupContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popupContainer)
        
        
        // Set constraints for the container
        NSLayoutConstraint.activate([
            popupContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            popupContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            popupContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            popupContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupContainer.heightAnchor.constraint(equalToConstant:200),
            popupContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 2),
            
        ])
        // Create the top bar
        let topBar = UIView()
        topBar.backgroundColor = .white
        topBar.translatesAutoresizingMaskIntoConstraints = false
        popupContainer.addSubview(topBar)
        topBar.layer.cornerRadius = 25
        topBar.clipsToBounds = true // Ensure the corners are clipped
        
        // Set constraints for the top bar
        NSLayoutConstraint.activate([
            topBar.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor),
            topBar.topAnchor.constraint(equalTo: popupContainer.topAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 75)
        ])
        // Create the small horizontal bar
        let smallBar = UIView()
        smallBar.backgroundColor = .lightGray
        smallBar.translatesAutoresizingMaskIntoConstraints = false
        smallBar.layer.cornerRadius = 2
        topBar.addSubview(smallBar)
        // Set constraints for the small bar
        NSLayoutConstraint.activate([
            smallBar.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            smallBar.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 8),
            smallBar.widthAnchor.constraint(equalToConstant: 40),
            smallBar.heightAnchor.constraint(equalToConstant: 4)
        ])
        // Add title label to the top bar
        let titleLabel = UILabel()
        titleLabel.text = "\(TranslationsViewModel.shared.getTranslation(key: "MEDICATION_INPUT.PLACEHOLDER", defaultText: "Select")) \(TranslationsViewModel.shared.getTranslation(key: "EPISODE_COUNT_INPUT.PLACEHOLDER", defaultText: "fever phases"))"

        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(titleLabel)
        
        // Set constraints for the title label
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: topBar.centerYAnchor)
        ])
        // Add close button to the top bar
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.gray, for: .normal)
        closeButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(closeButton)
        
        // Set constraints for the close button
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: topBar.centerYAnchor)
        ])
        // Initialize the table view
        selectFeverPhasesUITableView = UITableView()
        selectFeverPhasesUITableView.delegate = self
        selectFeverPhasesUITableView.dataSource = self
        selectFeverPhasesUITableView.translatesAutoresizingMaskIntoConstraints = false
        popupContainer.addSubview(selectFeverPhasesUITableView)
        selectFeverPhasesUITableView.separatorStyle = .none
        // Set constraints for the table view
        NSLayoutConstraint.activate([
            selectFeverPhasesUITableView.leadingAnchor.constraint(equalTo: popupContainer.leadingAnchor),
            selectFeverPhasesUITableView.trailingAnchor.constraint(equalTo: popupContainer.trailingAnchor),
            selectFeverPhasesUITableView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            selectFeverPhasesUITableView.bottomAnchor.constraint(equalTo: popupContainer.bottomAnchor)
        ])
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimView.frame = view.bounds

        // Register a UITableViewCell
        selectFeverPhasesUITableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    // Close the popup
    @objc func closePopup() {
        popupContainer.removeFromSuperview()
        if let number = selectedNumber {
            selectFeverPhasesUIButton.setTitle("Next \(String(number))", for: .normal)
        }
        dimView?.removeFromSuperview()
            dimView = nil

    }

    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 101
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.textAlignment = .center
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getProfilesNumberOfFeverPhases(indexpath: indexPath)
        giveProfilesNumberOfFeverPhasesToAddProfileNumberOfFeverPhasesModel()
       
        // Stocke le chiffre sélectionné
        selectedNumber = indexPath.row
        closePopup() // Ferme le popup après la sélection
    }

    func getProfilesNumberOfFeverPhases(indexpath: IndexPath){
        profilesNumberOfFeverPhases = Int16(indexpath.row)
    }
    func giveProfilesNumberOfFeverPhasesToAddProfileNumberOfFeverPhasesModel(){
        AddProfileNumberOfFeverPhasesModel.shared.saveProfileNumberOfFeverPhases( profilesNumberOfFeverPhases ?? 0){
            isSavedSuccessfully in
            if isSavedSuccessfully ?? false{
                self.handleNavigationToProfilesHighFeverFrequencyScreen()
            }else{
                // Show alert popup
                       let alertController = UIAlertController(title: "failed to save number of fever phases", message: "An error occurred please try again", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "retry", style: .default)
                       alertController.addAction(retryAction)
                self.present(alertController, animated: true)
            }
        }
    }
    func handleNavigationToProfilesHighFeverFrequencyScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ProfilesHighFeverFrequencyVC = storyboard.instantiateViewController(withIdentifier: "ProfilesHighFever") as? ProfilesHighFeverFrequencyViewController {
            self.navigationController?.pushViewController(ProfilesHighFeverFrequencyVC, animated: true)
        }
    }
    func setupUI() {
        let defaultText = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NO_ANSWER", defaultText: "No answer")
        let skipButtonTitle = NSMutableAttributedString(string: defaultText)

        // Dynamically calculate the ranges based on the text length
        let blackRangeLength = min(defaultText.count, 10) // Ensure range does not exceed text length
        if blackRangeLength > 0 {
            skipButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: blackRangeLength))
        }

        let grayStart = blackRangeLength
        let grayRangeLength = max(0, defaultText.count - grayStart) // Remaining text length
        if grayRangeLength > 0 {
            skipButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: grayStart, length: grayRangeLength))
        }
        NoAnswerUIButton.setAttributedTitle(skipButtonTitle, for: .normal)

        let topContainerView = CustomRoundedView()
        topContainerView.corners = [.topLeft, .topRight, .bottomRight]
        topContainerView.backgroundColor = .white
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)

        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = TranslationsViewModel.shared.getTranslation( key: "PROFILE.EPISODE_CNT-LAST-12-MONTHS.QUESTION",defaultText: "Everyone experiences fever differently. How often in the last 12 months has {{name}} had a feverish illness?").replacingOccurrences(of: "{{name}}", with: profileName)
        topLabel.font = .systemFont(ofSize: 15)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topLabel)
        myImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topContainerView.bottomAnchor.constraint(equalTo: selectFeverPhasesUIButton.topAnchor, constant: -25),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            topContainerView.heightAnchor.constraint(equalToConstant: 100),
            topContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor ,constant: -200),
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
