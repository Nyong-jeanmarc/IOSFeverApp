//
//  FindYourPediatricianViewController.swift
//  FeverApp ios
//
//  Created by user on 8/9/24.
//

import UIKit
class PediatricianTableViewCell: UITableViewCell {

    @IBOutlet var firstName: UILabel!
    
    @IBOutlet var lastName: UILabel!
    
    @IBOutlet var street: UILabel!
    
    
    @IBOutlet var zip: UILabel!
    
    @IBOutlet var city: UILabel!
    
    @IBOutlet var chevronButton: UIButton!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Add corner radius to the contentView of the cell
             contentView.layer.cornerRadius = 17
             contentView.layer.masksToBounds = true // Ensure content is clipped to the rounded corners
      
           // Add chevron button
           chevronButton.translatesAutoresizingMaskIntoConstraints = false
           chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
           chevronButton.tintColor = .gray
           contentView.addSubview(chevronButton)
           
         
       }
    
    required init?(coder: NSCoder) {
               super.init(coder: coder)
    }
    
    
}
class CustomUserPediatricianCell: UITableViewCell {
    
    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let streetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let zipCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trashButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "trash_can_icon")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
        }
        button.tintColor = UIColor(red: 165/255, green: 189/255, blue: 242/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let chevronIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none // Disable selection for this cell
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        selectionStyle = .none // Disable selection for this cell
        setupViews()
    }
    
    private func setupViews() {
        // Add components to the cell's content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(streetLabel)
        contentView.addSubview(zipCityLabel)
        contentView.addSubview(trashButton)
        contentView.addSubview(chevronIcon)
        
        trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        
        // Add constraints
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor, constant: -20),
            
            // Street label constraints
            streetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            streetLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            streetLabel.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor, constant: -20),
            
            // ZIP and City label constraints
            zipCityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            zipCityLabel.topAnchor.constraint(equalTo: streetLabel.bottomAnchor, constant: 4),
            zipCityLabel.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor, constant: -20),
            zipCityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Trash icon constraints
            trashButton.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -16),
            trashButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trashButton.widthAnchor.constraint(equalToConstant: 24),
            trashButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Chevron icon constraints
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronIcon.widthAnchor.constraint(equalToConstant: 16),
            chevronIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    var trashButtonAction: (() -> Void)?
    @objc private func trashButtonTapped() {
        trashButtonAction?()
    }
    
    // Configure the cell with data
    func configure(firstName: String, lastName: String, street: String, zip: Int64, city: String) {
        titleLabel.text = "\(firstName) \(lastName)"
        streetLabel.text = street
        zipCityLabel.text = "\(zip) \(city)"
    }
}
class FindYourPediatricianViewController: UIViewController, UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource {
    private var searchWorkItem: DispatchWorkItem?
    var selectedPediatrician: Pediatrician!
    var pediatricians: [Pediatrician] = [
       
    ]
    
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var myView1: UIView!
    
    
    @IBOutlet weak var myView2: UIView!
    
    
    @IBOutlet weak var myView3: UIView!
    
    
    @IBOutlet var searchPediatricianUITableView: UITableView!
    
    
    @IBOutlet var searchPediatricianUITextField: UITextField!
    
    @IBOutlet weak var uiDescription: UITextView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var addPediatricianBtn: UIButton!
    
    var userPediatricianTableView = UITableView()
    var usersPediatricians : [User_pediatricians] = []
    var selectedUserPediatrcian : User_pediatricians?
    func fetchUserPediatricians(){
        AddUserPediatricianNetworkManager.shared.fetchAllUserPediatricians(){ [self] pediatricians in
            usersPediatricians = pediatricians ?? []
        }
    }
    override func viewDidLayoutSubviews() {
        setupUserPediatricianTable()
    }
    override func viewDidAppear(_ animated: Bool) {
        userPediatricianTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserPediatricians()
    
        searchPediatricianUITextField.placeholder = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.PEDIATRICIAN.INPUT", defaultText: "Search pediatrician")
        uiDescription.text = TranslationsViewModel.shared.getTranslation(key: "DOCTOR_PICKER.INFO", defaultText: "Here you can search for your doctor above or select a previously selected one below.\\n\\nPlease enter the name of your paediatrician using the search bar below")
        // Adjust the UITextView's height
        uiDescription.frame.size.height = 20 // Add padding if needed

        addPediatricianBtn.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.PEDIATRICIAN.BUTTON", defaultText: "Add pediatrician"), for: .normal)
        self.view.bringSubviewToFront(myView2)
        // Configure the loading indicator
        loadingIndicator.color = .gray
        loadingIndicator.hidesWhenStopped = true

        // Center it in the table view
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        searchPediatricianUITableView.addSubview(loadingIndicator)
        
        // Center the indicator in the table view
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: searchPediatricianUITableView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: searchPediatricianUITableView.centerYAnchor)
        ])
        // Create a toolbar with a "Done" button
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(updateSearchPediatricianUITextFieldsIsFirstResponderPropertyToFalse))
            toolbar.items = [doneButton]
            
            // Add the toolbar to the text field's input accessory view
            searchPediatricianUITextField.inputAccessoryView = toolbar
        searchPediatricianUITextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
           // Set up the delegate and data source
        searchPediatricianUITableView.delegate = self
        searchPediatricianUITableView.dataSource = self
        searchPediatricianUITableView.isUserInteractionEnabled = true
     
        // Assuming your table view is called `tableView`
        searchPediatricianUITableView.layer.shadowColor = UIColor.lightGray.cgColor
        searchPediatricianUITableView.layer.shadowOpacity = 0.5 // Adjust the opacity (0 is invisible, 1 is fully visible)
        searchPediatricianUITableView.layer.shadowOffset = CGSize(width: 0, height: 2) // Adjust the offset for the shadow position
        searchPediatricianUITableView.layer.shadowRadius = 3// Adjust the radius for the blurriness of the shadow
        searchPediatricianUITableView.layer.masksToBounds = false // Ensure that the shadow is not clipped by bounds
        searchPediatricianUITableView.layer.cornerRadius = 17 // Adjust the radius as per your design
        searchPediatricianUITableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
       
       
       
        searchPediatricianUITextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        myView1.layer.cornerRadius = 25
        myView1.layer.masksToBounds = true
        
        myView2.layer.cornerRadius = 10
        // Shadow
        myView2.layer.shadowColor = UIColor.lightGray.cgColor
        myView2.layer.shadowOpacity = 0.3
        myView2.layer.shadowRadius = 5
        myView2.layer.shadowOffset = CGSize(width: 0, height: 2)
        myView2.layer.masksToBounds = false
        
        // Shadow
        myView1.layer.shadowColor = UIColor.lightGray.cgColor
        myView1.layer.shadowOpacity = 0.3
        myView1.layer.shadowRadius = 5
        myView1.layer.shadowOffset = CGSize(width: 0, height: 2)
        myView1.layer.masksToBounds = false
        
        myView3.layer.cornerRadius = 25
        myView3.layer.masksToBounds = true
        
        searchPediatricianUITextField.layer.cornerRadius = 10 // Radius souhaité
        searchPediatricianUITextField.layer.borderWidth = 0.5 // Largeur de la bordure
        searchPediatricianUITextField.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: searchPediatricianUITextField.frame.height))
        searchPediatricianUITextField.leftView = paddingView
        searchPediatricianUITextField.leftViewMode = .always
        
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 24, height: 24))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = .gray
        // Create a custom UILabel for the title
            let navtitleLabel = UILabel()
        navtitleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.PEDIATRICIAN.TITLE", defaultText: "Find your pediatrician")
            navtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            navtitleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: navtitleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
    }
    func setupUserPediatricianTable(){
        if usersPediatricians.isEmpty {
            userPediatricianTableView.isHidden = true
        }else{
            userPediatricianTableView.isHidden = false
        }
        // Set up the table view
        userPediatricianTableView.delegate = self
        userPediatricianTableView.dataSource = self
        userPediatricianTableView.backgroundColor = .white
        userPediatricianTableView.layer.cornerRadius = 10
        userPediatricianTableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // Bottom-left and bottom-right corners
        userPediatricianTableView.layer.shadowColor = UIColor.lightGray.cgColor
        userPediatricianTableView.layer.shadowOpacity = 0.3
        userPediatricianTableView.layer.shadowRadius = 5
        userPediatricianTableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        userPediatricianTableView.layer.masksToBounds = false
        userPediatricianTableView.clipsToBounds = true
        userPediatricianTableView.isUserInteractionEnabled = true
        userPediatricianTableView.register(CustomUserPediatricianCell.self, forCellReuseIdentifier: "userPedCell")
        
        // Add the table view to the view controller
      view.addSubview(userPediatricianTableView)
       var tableHeight = usersPediatricians.count * 75
        if tableHeight > 375{
            tableHeight = 376
        }
        // Set up constraints
        userPediatricianTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userPediatricianTableView.topAnchor.constraint(equalTo: myView2.bottomAnchor,constant: -10),
            userPediatricianTableView.leadingAnchor.constraint(equalTo: myView2.leadingAnchor),
            userPediatricianTableView.heightAnchor.constraint(equalToConstant: CGFloat(tableHeight)),
            
            userPediatricianTableView.trailingAnchor.constraint(equalTo: myView2.trailingAnchor)
        ])
     
       view.bringSubviewToFront(userPediatricianTableView)
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
    
    
    
    
    // MARK: - TableView DataSource methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == userPediatricianTableView{
                return usersPediatricians.count
            }else {
                return pediatricians.count
            }
      
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if tableView == userPediatricianTableView{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "userPedCell", for: indexPath) as? CustomUserPediatricianCell else {
                      fatalError("Unable to dequeue CustomMedicationTableViewCell")
                  }

                  // Sample data for demonstration
                  let pediatrician = usersPediatricians[indexPath.row] // Assuming `people` is an array of data objects
                  let firstName = pediatrician.firstName ?? ""
                  let lastName = pediatrician.lastName ?? ""
                  let street = pediatrician.streetAndHouseNumber ?? ""
                let zip = pediatrician.postalCode
                  let city = pediatrician.city ?? ""

                  // Configure the cell
                  cell.configure(firstName: firstName, lastName: lastName, street: street, zip: zip, city: city)

                  // Handle trash button action
                  cell.trashButtonAction = {
                      deleteUserPediatricianNetworkManager.shared.deleteUserPediatrician(pediatricianId: Int(pediatrician.pediatricianId)){isDeleted in
                          if isDeleted{
                              deleteUserPediatricianNetworkManager.shared.deleteUserPediatricianFromCoreData(pediatricianId: Int64(pediatrician.pediatricianId)){isDeleted in
                                  if isDeleted{
                                      // Remove the object from the array
                                                                self.usersPediatricians.remove(at: indexPath.row)
                                      DispatchQueue.main.async{
                                          // Reload the table view to reflect the change
                                          tableView.deleteRows(at: [indexPath], with: .automatic)
                                      }
                                                 
                                  }else{
                                      
                                  }
                                  
                              }
                          }else{
                              
                          }
                          
                      }
                      print("Trash button tapped for: \(firstName) \(lastName)")
                      // Add code to handle deletion of this cell's data
                     
                  }

                  return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PediatricianCell", for: indexPath) as! PediatricianTableViewCell
                cell.selectionStyle = .default
                let pediatrician = pediatricians[indexPath.row]
                cell.firstName.text = pediatrician.firstName
                cell.lastName.text = pediatrician.lastName
                cell.street.text = pediatrician.street
                cell.zip.text = String(pediatrician.zip)
                cell.city.text = pediatrician.city
                cell.isUserInteractionEnabled = true
                return cell
            }
        }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == userPediatricianTableView{
            print("tAppEd!!!!!!!")
            self.selectedUserPediatrcian = usersPediatricians[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let profileId = appDelegate.fetchProfileId()!
            AddProfilePediatricianModel.shared.saveUserPediatricianToProfile(localProfileId: profileId, id: selectedUserPediatrcian!.pediatricianId)
            self.handleNavigationToProfileHasChronicDiseaseOrNotScreen()
        }else {
            getProfilePediatrician(index: indexPath)
            print("pediatrician id is \(String(describing: self.selectedPediatrician))")
            giveProfilesPediatricianToAddProfilePediatricianModel(selectedPediatrician: selectedPediatrician)
        }
    }
        // (Optional) Adjust row height dynamically based on content
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    @objc func updateSearchPediatricianUITextFieldsIsFirstResponderPropertyToFalse(){
        searchPediatricianUITextField.resignFirstResponder()
    }
    
    // MARK: - TextField Delegate Method

     @objc func textFieldDidChange(_ textField: UITextField) {
         // Check if the text has 4 or more characters
               guard let text = textField.text, text.count >= 4   else {
                   // Cancel the previous work item if there are less than 4 characters
                   searchWorkItem?.cancel()
                   updateSearchPediatricianUITableViewIsHiddenPropertyToTrue()
                   self.loadingIndicator.stopAnimating()
                   return
               }
         
               // Cancel any existing work item to reset the delay
               searchWorkItem?.cancel()
updateSearchPediatricianUITableViewIsHiddenPropertyToFalse()
       
         // Show the loading indicator before starting the search
            DispatchQueue.main.async {
                self.loadingIndicator.startAnimating()
            }
               // Create a new work item to execute the server request after a delay
               searchWorkItem = DispatchWorkItem {
                   searchPediatricianNetworkManager.shared.getPediatricianRequest(searchKey: text){
                       result in
                       switch result{
                       case .success(let pediatricians):
                           self.pediatricians = pediatricians
                         
                           DispatchQueue.main.sync{
                               self.loadingIndicator.stopAnimating()

                               self.updateSearchPediatricianUITableViewIsHiddenPropertyToFalse()
                               self.updateSearchPediatricianUITableViewWithPediatricians()
                           }
                       case .failure(let error):
                           print(error)
                           DispatchQueue.main.sync{
                               self.loadingIndicator.stopAnimating()
                           }
                       }
                   }
               }

               // Execute the work item after a 2-second delay
               if let workItem = searchWorkItem {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: workItem)
               }
        
     }
    
    func updateSearchPediatricianUITableViewIsHiddenPropertyToFalse(){
        searchPediatricianUITableView.isHidden = false
        userPediatricianTableView.isHidden = true
    }
    func updateSearchPediatricianUITableViewIsHiddenPropertyToTrue(){
        searchPediatricianUITableView.isHidden = true
        userPediatricianTableView.isHidden = false
    }
    func updateSearchPediatricianUITableViewWithPediatricians(){
        searchPediatricianUITableView.reloadData()
    }
    func handleNavigationToProfileHasChronicDiseaseOrNotScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let chronicDieseaseVC = storyboard.instantiateViewController(withIdentifier: "Chronicdisease") as? AnswerIfProfileHasChronicDiseasesOrNotViewController {
            self.navigationController?.pushViewController(chronicDieseaseVC, animated: true)
        }
    }
    func getProfilePediatrician(index: IndexPath){
        let selectedPediatrician = Pediatrician(
            id: pediatricians[index.row].id,
            practiceId: pediatricians[index.row].practiceId,
            doctorId: pediatricians[index.row].doctorId,
            title: pediatricians[index.row].title,
             firstName: pediatricians[index.row].firstName,
             lastName: pediatricians[index.row].lastName,
             street: pediatricians[index.row].street,
             zip: pediatricians[index.row].zip,
             city: pediatricians[index.row].city,
             countryCode: pediatricians[index.row].countryCode,
             phone: pediatricians[index.row].phone,
             email: pediatricians[index.row].email,
            visible: pediatricians[index.row].visible,
             reference: pediatricians[index.row].reference
            )
        self.selectedPediatrician = selectedPediatrician
          
    }
    func giveProfilesPediatricianToAddProfilePediatricianModel(selectedPediatrician: Pediatrician){
        print(selectedPediatrician.zip)
        
        // Attempt to convert the postal code string (zip) to Int16
           if let zipValue = Int64(selectedPediatrician.zip) {
               AddProfilePediatricianModel.shared.saveProfilePediatricianId(
                   id: selectedPediatrician.id,
                   firstName: selectedPediatrician.firstName,
                   lastName: selectedPediatrician.lastName,
                   streetAndHouseNumber: selectedPediatrician.street,
                   postalCode: zipValue, // Now safely converted to Int16
                   city: selectedPediatrician.city,
                   country: selectedPediatrician.countryCode,
                   phoneNumber: selectedPediatrician.phone,
                   email: selectedPediatrician.email,
                   reference: selectedPediatrician.reference
               ) { isSavedSuccessfully in
                   if isSavedSuccessfully ?? false {
                       self.handleNavigationToProfileHasChronicDiseaseOrNotScreen()
                   } else {
                       let alertController = UIAlertController(
                           title: "Failed to Save Pediatrician",
                           message: "An error occurred. Please try again.",
                           preferredStyle: .alert
                       )
                       let retryAction = UIAlertAction(title: "Retry", style: .default)
                       alertController.addAction(retryAction)
                       self.present(alertController, animated: true, completion: nil)
                   }
               }
           } else {
               // Handle the case where the postal code is invalid (not convertible to Int16)
               let alertController = UIAlertController(
                   title: "Invalid Postal Code",
                   message: "The provided postal code  is invalid. Please try again.",
                   preferredStyle: .alert
               )
               let retryAction = UIAlertAction(title: "Retry", style: .default)
               alertController.addAction(retryAction)
               self.present(alertController, animated: true, completion: nil)
           }
    }
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        // Mettre les borders en bold et noir
        searchPediatricianUITextField.layer.borderWidth = 2
        searchPediatricianUITextField.layer.borderColor = UIColor.black.cgColor
    }

    // Fonction appelée lorsque le champ de texte n'est plus sélectionné
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        // Remettre les borders en light gray
        searchPediatricianUITextField.layer.borderWidth = 0.5
        searchPediatricianUITextField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func searchButtonTapped() {
        // Simuler la sélection du champ de texte
        searchPediatricianUITextField.becomeFirstResponder()
        searchPediatricianUITextField.layer.borderWidth = 2
        searchPediatricianUITextField.layer.borderColor = UIColor.black.cgColor
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard when the "Done" key is clicked
            textField.resignFirstResponder()
            return true
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Vérifier si la touch n'est pas dans le champ de texte
        guard let touch = touches.first, !searchPediatricianUITextField.frame.contains(touch.location(in: view)) else { return }
        
        // Remettre les borders en light gray
        searchPediatricianUITextField.layer.borderWidth = 0.5
        searchPediatricianUITextField.layer.borderColor = UIColor.lightGray.cgColor
        
        // Faire descendre le clavier si nécessaire
        view.endEditing(true)
    }
}
