//
//  medicationListViewController.swift
//  FeverApp ios
//
//  Created by NEW on 12/11/2024.
//

import Foundation
import UIKit
import CoreData
class CustomMedicationTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trashButton: UIButton = {
          let button = UIButton()
          button.setImage(UIImage(systemName: "trash"), for: .normal)
          button.tintColor = .gray
          button.translatesAutoresizingMaskIntoConstraints = false
          return button
      }()
    
    let chevronIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right") // System chevron icon
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
        contentView.addSubview(trashButton)
        contentView.addSubview(chevronIcon)
        trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        // Add constraints
        NSLayoutConstraint.activate([
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trashButton.leadingAnchor, constant: 20),
            // Trash icon constraints
            trashButton.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -16),
                      trashButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                      trashButton.widthAnchor.constraint(equalToConstant: 24),
                      trashButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Chevron icon constraints
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronIcon.widthAnchor.constraint(equalToConstant: 16),
            chevronIcon.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    var trashButtonAction: (() -> Void)?
    @objc private func trashButtonTapped() {
        trashButtonAction?()
      }
}
class MedicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    // MARK: - UI Components
       let tableView: UITableView = {
           let tableView = UITableView()
           tableView.translatesAutoresizingMaskIntoConstraints = false
           return tableView
       }()
       
    var data : [String] = []
    var dataId : [Int64] = []
    var userMedications : [User_medications] = []
       
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            //
    userMedications = userMedicationNetworkManager.shared.fetchMedications()
            for userMedication in userMedications {
                data.append(userMedication.medicationName ?? "")
                dataId.append(userMedication.medicationId)
            }
            // Hide the default back button
            self.navigationItem.hidesBackButton = true
            // Configure the custom top view with the title label and back button
            setupTopView()
            
            // Create a container view for the instructions
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = .white
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 10
            view.addSubview(containerView)
            
            // Create the instruction label
            let instructionLabel = UILabel()
            instructionLabel.translatesAutoresizingMaskIntoConstraints = false
            instructionLabel.numberOfLines = 0
            instructionLabel.textAlignment = .left
            instructionLabel.text = TranslationsViewModel.shared.getTranslation(key: "MEDIATION_LIST.INTRO" ,defaultText: "Please select your medication from the list below. If the drug is not listed there, select “New Selection” and add it to the list.")
            instructionLabel.font = UIFont.systemFont(ofSize: 16)
            instructionLabel.textColor = .black
            containerView.addSubview(instructionLabel)
            
            // Set constraints for the label
            NSLayoutConstraint.activate([
                instructionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
                instructionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                instructionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                instructionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])

            // Ensure the container view adjusts its height to fit the label
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 25), // Example width adjustment
            ])
            
            // Create a bottom view for the "New Selection" button
            let bottomView = UIView()
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            bottomView.backgroundColor = .white
            bottomView.layer.cornerRadius = 12
            bottomView.layer.masksToBounds = true
            view.addSubview(bottomView)
            
            // Create the "New Selection" button and add it to bottomView
            let newSelectionButton = UIButton(type: .system)
            newSelectionButton.translatesAutoresizingMaskIntoConstraints = false
            newSelectionButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "MEDIATION_LIST.NEW",defaultText: "New selection"), for: .normal)
            newSelectionButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
            newSelectionButton.setTitleColor(.white, for: .normal)
            newSelectionButton.layer.cornerRadius = 10
            newSelectionButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            bottomView.addSubview(newSelectionButton)
            newSelectionButton.addTarget(self, action: #selector(selectionButtonTapped), for: .touchDown)
            // Constraints for containerView
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
                containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                containerView.heightAnchor.constraint(equalToConstant: 210)
            ])
            
            // Constraints for instructionLabel
            NSLayoutConstraint.activate([
                instructionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                instructionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                instructionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                instructionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            ])
            
            // Constraints for bottomView
            NSLayoutConstraint.activate([
                bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                bottomView.heightAnchor.constraint(equalToConstant: 110)
            ])
            
            // Constraints for newSelectionButton within bottomView
            NSLayoutConstraint.activate([
                newSelectionButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
                newSelectionButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
                newSelectionButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
                newSelectionButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
                newSelectionButton.heightAnchor.constraint(equalToConstant: 50)
            ])
            // Table view setup
                   view.addSubview(tableView)
                   tableView.delegate = self
                   tableView.dataSource = self
                   tableView.register(CustomMedicationTableViewCell.self, forCellReuseIdentifier: "CustomMedicationCell")
            tableView.separatorColor = UIColor.darkGray // Use a darker color
            tableView.layer.cornerRadius = 10

           
                   
                   // Table view constraints
                   NSLayoutConstraint.activate([
                       tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
                       tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                       tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                       tableView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
                   ])
        }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           print("MedicationViewController view did appear!")
           
           // Add your reload logic here
           reloadData()
       }
        func reloadData() {
            userMedications = userMedicationNetworkManager.shared.fetchMedications()
            data = []
            dataId = []
                    for userMedication in userMedications {
                        data.append(userMedication.medicationName ?? "")
                        dataId.append(userMedication.medicationId)
                    }
            tableView.reloadData()
            print("Reloading data in MedicationViewController...")
            // Implement your reload logic, like refreshing data or UI
        }
    @objc func selectionButtonTapped(){
        // present the scan medication view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let VideoVC = storyboard.instantiateViewController(withIdentifier: "ScanMedicationViewController") as? ScanMedicationViewController {
            // Assign the callback
            VideoVC.onDismiss = { [weak self] in
                       self?.reloadData()
                   }
            self.navigationController?.pushViewController(VideoVC, animated: true)
            
        }
        
    }
    // MARK: - UITableViewDataSource
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return data.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMedicationCell", for: indexPath) as? CustomMedicationTableViewCell else {
            
              return UITableViewCell()
          }
          let medId = dataId[indexPath.row]
          // Configure trash button action
          // Set the trash button action
              cell.trashButtonAction = { [weak self] in
                  deleteUserMedicationNetworkManager.shared.deleteUserMedication(medicationId: Int(medId)){isDeleted in
                      if isDeleted{
                          deleteUserMedicationNetworkManager.shared.deleteUserMedicationFromCoreData(medicationId: medId){isDeleted in
                              if isDeleted{
                                  // Remove the object from the array
                                  self?.data.remove(at: indexPath.row)
                                  self?.dataId.remove(at: indexPath.row)
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
              }
        
          cell.titleLabel.text = data[indexPath.row]
          return cell
      }
    // MARK: - Delete Row
      
      
      // MARK: - UITableViewDelegate
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          var infoMedicationTitleLabel : String?
          infoMedicationTitleLabel = TranslationsViewModel.shared.getAdditionalTranslation(key: "INFO.ABOUT.VALUE.TEXT", defaultText: "Info about {{value}}").replacingOccurrences(of: "{{value}}", with: data[indexPath.row])
          // present the scan medication view controller
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let VideoVC = storyboard.instantiateViewController(withIdentifier: "infoMedicationScreen") as? infoMedViewController {
              // Pass the data to the destination view controller
                     VideoVC.medicationInfo = infoMedicationTitleLabel
              if EntryMedicationsModel.shared.checkAssociatedEntryMedication(userId: dataId[indexPath.row]){
                  EntryMedicationsModel.shared.setEditingState(isEditing: true)
                  // dont do anything because if an entry medication object exist the function already updated the model with its id
              }else{
                  EntryMedicationsModel.shared.setEditingState(isEditing: false)
                  EntryMedicationsModel.shared.createAndUpdateEntryMedication(with: dataId[indexPath.row], medicationName: userMedications[indexPath.row].medicationName!, typeOfMedication: userMedications[indexPath.row].typeOfMedication ?? "TAB"){isCreated in
                      if isCreated{
                          print("entry medication created successfully")
                      }else{
                          print("failed to create entry medication")
                      }
                  }
              }
              
              self.navigationController?.pushViewController(VideoVC, animated: true)
          }
          print("Selected: \(data[indexPath.row])")
      }
        // Setup Custom Top View with Rounded Corners, Title Label, and Back Button
        private func setupTopView() {
            // Create the top white view
            let topView = UIView()
            topView.translatesAutoresizingMaskIntoConstraints = false
            topView.backgroundColor = .white
            topView.layer.cornerRadius = 20
            topView.layer.masksToBounds = true
            view.addSubview(topView)
            
            // Create the back button
            let backButton = UIButton(type: .system)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            backButton.tintColor = .gray
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            let configuration = UIImage.SymbolConfiguration(weight: .bold) // Choose .ultraLight, .thin, .regular, .medium, .bold, or .heavy as needed
            backButton.setImage(UIImage(systemName: "chevron.backward", withConfiguration: configuration), for: .normal)
            
            topView.addSubview(backButton)
            
            // Create the title label
            let titleLabel = UILabel()
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = TranslationsViewModel.shared.getTranslation( key: "MEDIATION_LIST.TITLE",defaultText: "Your list of medicines")
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            titleLabel.textColor = .black
            topView.addSubview(titleLabel)
            
            // Constraints for topView
            NSLayoutConstraint.activate([
                topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
                topView.heightAnchor.constraint(equalToConstant: 100)
            ])
            
            // Constraints for backButton
            NSLayoutConstraint.activate([
                backButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 40),
                backButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 60)
            ])
            
            // Constraints for titleLabel
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: backButton.leadingAnchor, constant: 30),
                titleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 60)
            ])
        }
        
        // Back button action
        @objc private func backButtonTapped() {
            // Perform action for the back button, like dismissing the view controller
            // If you're not using a navigation controller, just dismiss
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
