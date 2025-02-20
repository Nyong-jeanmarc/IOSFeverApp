//
//  scanMedicationViewController.swift
//  FeverApp ios
//
//  Created by NEW on 12/11/2024.
//

import Foundation
import AVFoundation

import UIKit
class MedicationTableViewCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.white.cgColor
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add the containerView to the cell's content view
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add labels to the containerView
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Container View Constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Name Label Constraints
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 19),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            // Description Label Constraints
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 19),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        // Set background color of the cell to clear
        backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configure cell with data
    func configure(name: String, description: String) {
        nameLabel.text = name
        descriptionLabel.text = description
    }
}
class ScanMedicationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate{
    let containerView = UIView()
    let tableView = UITableView()
    let scanView = UIView()
    let searchButton = UIButton(type: .system)
    let permissionButton = UIButton(type: .system)
    let scanButton = UIButton()
    let closeButton = UIButton(type: .system)
    let textField = UITextField()
    // Permission Label
    var captureSession: AVCaptureSession?
    let permissionLabel = UILabel()
    let drugs : [String:String] = [
        "Paracetamol AL comp":"Tab 20 ST 222444544",
        "Ibuprofen":"Tab 20 ST 222444544",
        "dopamine":"Tab 20 ST 222444544",
        "Efferalgan":"Tab 20 ST 222444544",
    ]
    var drugNames: [String] {
            return Array(drugs.keys)
        }
    var medications : [searchedMedications] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Hide the default back button
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .systemGray6
        setupUI()
        checkCameraPermission()
        setupScanView()
        permissionButton.addTarget(self, action: #selector(requestCameraPermission), for: .touchUpInside)
         scanButton.addTarget(self, action: #selector(requestCameraPermission), for: .touchUpInside)
        setupMedicationTable()
    }
    func setupMedicationTable(){
        
        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
      tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none // Remove separator lines
        tableView.register(MedicationTableViewCell.self, forCellReuseIdentifier: "MedicationCell")
        
        // Add the table view to the view controller
        view.addSubview(tableView)
        
        // Set up constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 100),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        tableView.isHidden = true
    }
    
    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medications.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        // Get the selected item from your data source
        let selectedMedication = medications[indexPath.row]
        userMedicationNetworkManager.shared.createUserMedication(typeOfMedication: selectedMedication.dosageForm, medicationName: selectedMedication.productName){isCreated in
            if isCreated{
            }else{
                let alertController = UIAlertController(title: "failed to add medication please try again", message: "", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
            
        }
        // Perform an action with the selected item (e.g., navigate to a detail screen)
        print("Selected Medication: \(selectedMedication.productName), Dosage Form: \(selectedMedication.dosageForm)")
        self.onDismiss?()
        self.navigationController?.popViewController(animated: true)
       
    }
    var onDismiss: (() -> Void)? // Define the callback property
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell", for: indexPath) as! MedicationTableViewCell
 
               // Get the drug name and description for the current row
            let drugName = medications[indexPath.row].productName
        let drugDescription = medications[indexPath.row].dosageForm + " | " + "\(medications[indexPath.row].quantity)" + " " + medications[indexPath.row].unit + " | " + "\(medications[indexPath.row].pzn)"

               // Configure the cell with the drug's name and description
               cell.configure(name: drugName, description: drugDescription)
               
               return cell
    }

    // Optional: Adjust row height if needed
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Adjust this value as needed
    }
    func setupUI() {
        // Top White Container View
        let topContainerView = UIView()
        topContainerView.backgroundColor = .white
        topContainerView.layer.cornerRadius = 20
        topContainerView.isUserInteractionEnabled = true
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        topContainerView.addGestureRecognizer(tapGesture)

        view.addSubview(topContainerView)
        
        // Back Button
        let backButton = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(weight: .bold)
        backButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
       
        let backIcon = UIImage(systemName: "chevron.backward", withConfiguration: symbolConfig)
        backButton.setImage(backIcon, for: .normal)
        backButton.tintColor = UIColor.gray
        backButton.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(backButton)
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "MEDICINE.SEARCH.TEXT", defaultText: "Search medicine")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(titleLabel)
        
        // Close Button
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "close"), for: .normal)


        topContainerView.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
     
       
        
        // Container View for the rest of the elements
 
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 5
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // White View
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(whiteView)
        
        // New View
        let newView = UIView()
        newView.backgroundColor = .clear
        newView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(newView)
        // Divider Lines
                let dividerLine1 = UIView()
                dividerLine1.backgroundColor = .lightGray
                dividerLine1.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(dividerLine1)
                
                let dividerLine2 = UIView()
                dividerLine2.backgroundColor = .lightGray
                dividerLine2.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(dividerLine2)
                
                // Or Label
                let orLabel = UILabel()
        orLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "LOGIC.OR", defaultText: "Orp")
                orLabel.textColor = .black
                orLabel.font = UIFont.systemFont(ofSize: 14)
                orLabel.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(orLabel)
                
                // Description Label
                let descriptionLabel = UILabel()
        descriptionLabel.text = TranslationsViewModel.shared.getTranslation(key: "MEDICATION_PICKER.EMPTY", defaultText: "Please scan the barcode of the medicine or search using the search bar.")
                descriptionLabel.font = UIFont.systemFont(ofSize: 14)
                descriptionLabel.textColor = .black
                descriptionLabel.numberOfLines = 0
                descriptionLabel.textAlignment = .left
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(descriptionLabel)
                
         
        permissionLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.CAMERA.PERMISSION", defaultText: "Camera permission is required to scan the barcode.")
                permissionLabel.font = UIFont.systemFont(ofSize: 14)
                permissionLabel.textColor = .black
                permissionLabel.textAlignment = .center
                permissionLabel.numberOfLines = 0
                permissionLabel.translatesAutoresizingMaskIntoConstraints = false
                containerView.addSubview(permissionLabel)
                
                // Grant Permission Button
              
        permissionButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.GRANT.PERMISSION", defaultText: "Grant Permission"), for: .normal)
                permissionButton.setTitleColor(.black, for: .normal)
                permissionButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
                permissionButton.layer.cornerRadius = 25
                permissionButton.translatesAutoresizingMaskIntoConstraints = false
        // Add this line to handle permission button tap
         
                containerView.addSubview(permissionButton)
                
                // Outer container view for the black frame
                let outerContainerView = UIView()
                outerContainerView.layer.cornerRadius = 8
                outerContainerView.layer.borderWidth = 1
                outerContainerView.layer.borderColor = UIColor.black.cgColor
                outerContainerView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(outerContainerView)
                
                // Inner container view for the pink background
                let searchContainerView = UIView()
                searchContainerView.layer.cornerRadius = 4
                searchContainerView.translatesAutoresizingMaskIntoConstraints = false
                searchContainerView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.1)
                outerContainerView.addSubview(searchContainerView)
                
                // Blue Label
                let nameLabel = UILabel()
        nameLabel.text = TranslationsViewModel.shared.getTranslation(key: "MEDICATION_FORM.NAME", defaultText: "Name of the medicine")
                nameLabel.font = UIFont.systemFont(ofSize: 14)
                nameLabel.textColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                searchContainerView.addSubview(nameLabel)
                
                // Text Field
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChangeSelection), for: .editingChanged)
                textField.placeholder = TranslationsViewModel.shared.getTranslation(key: "MEDICATION_FORM.NAME", defaultText: "Name of the medicine")
                textField.font = UIFont.systemFont(ofSize: 18)
                textField.textColor = UIColor.darkGray
                textField.backgroundColor = UIColor.clear
                textField.borderStyle = .none
                textField.translatesAutoresizingMaskIntoConstraints = false
                searchContainerView.addSubview(textField)
                
                // Search Button
              
                let searchImage = UIImage(systemName: "magnifyingglass")
                searchButton.setImage(searchImage, for: .normal)
                searchButton.tintColor = UIColor.gray
                searchButton.translatesAutoresizingMaskIntoConstraints = false
                searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
                searchContainerView.addSubview(searchButton)
                
                // Bottom Blue Border
                let bottomBorder = UIView()
                bottomBorder.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
                bottomBorder.translatesAutoresizingMaskIntoConstraints = false
                searchContainerView.addSubview(bottomBorder)
                
                // Constraints
                NSLayoutConstraint.activate([
                    // Top Container View Constraints
                    topContainerView.topAnchor.constraint(equalTo: view.topAnchor),
                    topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    topContainerView.heightAnchor.constraint(equalToConstant: 100),
                    
                    // Back Button
                    backButton.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 20),
                    backButton.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 60),
                    
                    // Title Label
                    titleLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 50),
                    titleLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 60),
                    
                    // Close Button
                    closeButton.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -20),
                    closeButton.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 50),
                    closeButton.widthAnchor.constraint(equalToConstant: 80),
                    closeButton.heightAnchor.constraint(equalToConstant: 40),
                    
                    // Container View
                    containerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 20),
                    containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
                    containerView.heightAnchor.constraint(equalToConstant: 350),
                    
                    // White View
                    whiteView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                    whiteView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                    whiteView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                    whiteView.heightAnchor.constraint(equalToConstant: 70),
                    
                    // New View
                    newView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                    newView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
                    newView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
                    newView.heightAnchor.constraint(equalToConstant: 70),
                    
                    // Divider Lines
                    dividerLine1.topAnchor.constraint(equalTo: newView.bottomAnchor, constant: 20),
                    dividerLine1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                    dividerLine1.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
                    dividerLine1.heightAnchor.constraint(equalToConstant: 1),
                    
                    dividerLine2.topAnchor.constraint(equalTo: dividerLine1.topAnchor),
                    dividerLine2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                    dividerLine2.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
                    dividerLine2.heightAnchor.constraint(equalToConstant: 1),
                    
                    // Or Label
                    orLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    orLabel.centerYAnchor.constraint(equalTo: dividerLine1.centerYAnchor),
                    
                    // Description Label
                    descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                    descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                    descriptionLabel.topAnchor.constraint(equalTo: dividerLine1.bottomAnchor, constant: 20),
                    
                    // Permission Label
                    permissionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
                    permissionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                    permissionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                    
                    // Grant Permission Button
                    permissionButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    permissionButton.topAnchor.constraint(equalTo: permissionLabel.bottomAnchor, constant: 20),
                    permissionButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
                    permissionButton.heightAnchor.constraint(equalToConstant: 50),
                    
                    // Outer Container View Constraints
                    outerContainerView.topAnchor.constraint(equalTo: newView.topAnchor),
                    outerContainerView.leadingAnchor.constraint(equalTo: newView.leadingAnchor),
                    outerContainerView.trailingAnchor.constraint(equalTo: newView.trailingAnchor),
                    outerContainerView.bottomAnchor.constraint(equalTo: newView.bottomAnchor),
                    
                    // Search Container View
                    searchContainerView.leadingAnchor.constraint(equalTo: outerContainerView.leadingAnchor, constant: 10),
                    searchContainerView.trailingAnchor.constraint(equalTo: outerContainerView.trailingAnchor, constant: -10),
                    searchContainerView.topAnchor.constraint(equalTo: outerContainerView.topAnchor, constant: 10),
                    searchContainerView.bottomAnchor.constraint(equalTo: outerContainerView.bottomAnchor, constant: -10),
                    
                    // Blue Label
                    nameLabel.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 12),
                    nameLabel.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 5),
                    
                    // Text Field
                    textField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
                    textField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -40),
                    textField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
                    textField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -5),
                    
                    // Search Button
                    searchButton.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -12),
                    searchButton.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
                    searchButton.widthAnchor.constraint(equalToConstant: 24),
                    searchButton.heightAnchor.constraint(equalToConstant: 24),
                    
                    // Bottom Border
                    bottomBorder.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor),
                    bottomBorder.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor),
                    bottomBorder.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor),
                    bottomBorder.heightAnchor.constraint(equalToConstant: 2)
                ])
            }
    @objc func closeButtonTapped(){
        print("Back button tapped")
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTap() {
        print("Top container tapped")
    }
    func setupScanButton() {
   
        // Deactivate any existing constraints
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        scanButton.backgroundColor = .clear
        containerView.addSubview(scanButton)
        // Set the button size (adjust as needed)
        let buttonSize: CGFloat = 50
        scanButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        scanButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        scanButton.setTitle("", for: .normal)
        // Clear background color
        let backgroundImage = UIImage(named: "scan")
        scanButton.setImage(backgroundImage, for: .normal)

        // Set the background image for all states
     //   let backgroundImage = UIImage(named: "scan")
       // permissionButton.setBackgroundImage(backgroundImage, for: .normal)
        NSLayoutConstraint.activate([
            // Grant Permission Button
            scanButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            scanButton.topAnchor.constraint(equalTo: permissionLabel.bottomAnchor, constant: 20),
        ])
       
    }
    func checkCameraPermission(){
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.permissionLabel.isHidden = true
                    self?.permissionButton.isHidden = true
                    self?.setupScanButton()
                    self?.scanButton.isHidden = false
                } else {
                    self?.scanButton.isHidden = true
                    self?.permissionLabel.isHidden = false
                    self?.permissionButton.isHidden = false
                }
            }
        }
    }
    @objc func requestCameraPermission() {
        scanView.isHidden = false
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.permissionButton.isHidden = true
                    self?.scanButton.isHidden = true
                    self?.openCamera()
                } else {
                    // Handle permission denial, e.g., show an alert
                    let alert = UIAlertController(title: TranslationsViewModel.shared.getAdditionalTranslation(key: "ACCESS.CAMERA.NEEDED", defaultText: "Camera Access Needed"),
                                                  message: TranslationsViewModel.shared.getAdditionalTranslation(key: "ACCESS.CAMERA.GRANT", defaultText: "Please grant camera access to use this feature."),
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.OK", defaultText: "Ok"), style: .default, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    func setupScanView(){
 
        scanView.backgroundColor = .clear
        scanView.layer.borderWidth = 3
        scanView.layer.cornerRadius = 17
        scanView.layer.borderColor = UIColor.blue.cgColor
        scanView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(scanView)
        NSLayoutConstraint.activate([
            scanView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            scanView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            scanView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40),
            scanView.heightAnchor.constraint(equalToConstant: 90),
        ])
        scanView.isHidden = true
    }
    func openCamera() {
        captureSession = AVCaptureSession()
               
               guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
                     let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
                     let captureSession = captureSession else { return }
               
               if captureSession.canAddInput(videoInput) {
                   captureSession.addInput(videoInput)
               } else {
                   return
               }
               
               // Metadata output for barcode scanning
               let metadataOutput = AVCaptureMetadataOutput()
               if captureSession.canAddOutput(metadataOutput) {
                   captureSession.addOutput(metadataOutput)
                   
                   metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                   metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr] // Add other types as needed
               } else {
                   return
               }
               
               // Camera preview setup
               let cameraView = UIView(frame: self.scanView.bounds)
               cameraView.layer.cornerRadius = 17
               cameraView.translatesAutoresizingMaskIntoConstraints = false
               cameraView.backgroundColor = .black
               scanView.addSubview(cameraView)
               
               let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
               previewLayer.frame = cameraView.layer.bounds
               previewLayer.cornerRadius = 17
               previewLayer.videoGravity = .resizeAspectFill
               cameraView.layer.addSublayer(previewLayer)
               
               DispatchQueue.global(qos: .userInitiated).async {
                   captureSession.startRunning()
               }
    }
    // Delegate method to process barcode data
       func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           captureSession?.stopRunning()
           
           if let metadataObject = metadataObjects.first {
               guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                     let stringValue = readableObject.stringValue else { return }
               
               // Print or process the scanned code
               print("Scanned code: \(stringValue)")
               
               // Convert the scanned code (stringValue) to Int
                     if let pzn = Int(stringValue) {
                         searchMedicationNetworkManager.shared.fetchMedicationsByPzn(pzn: pzn) { result in
                             switch result {
                             case .success(let medications):
                                 if medications == [] {
                                     DispatchQueue.main.async{
                                         let alertController = UIAlertController(title: TranslationsViewModel.shared.getAdditionalTranslation(key: "ERROR.NO_MEDICATION_FOUND", defaultText: "No medication with the following barcode was found"), message: "", preferredStyle: .alert)
                                         let cancelAction = UIAlertAction(title: TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.OK", defaultText: "Ok"), style: .cancel)
                                         alertController.addAction(cancelAction)
                                         self.present(alertController, animated: true)
                                     }
                                 }else{
                                     // Update your UI with the fetched medications
                                     self.medications = medications
                                     DispatchQueue.main.async{
                                         self.tableView.reloadData()
                                         self.tableView.isHidden = false
                                     }
                                     print("Fetched Medications: \(medications)")
                                 }
                                
                             case .failure(let error):
                                 print("Error: \(error.localizedDescription)")
                             }
                         }
                     } else {
                         print("Invalid PZN: Unable to convert scanned code to an integer.")
                     }
           }
           
           // Optionally, restart scanning after a delay
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
               DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                   self?.captureSession?.startRunning()
               }
           }
       }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    var typingTimer: Timer? // Timer to track the typing delay
    var activityIndicator: UIActivityIndicatorView? // Activity indicator to show loading state

    @objc func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
             
             // Hide the table view if the text count is less than 4
             if text.count < 4 {
                 tableView.isHidden = true
                 activityIndicator?.removeFromSuperview() // Ensure activity indicator is removed
                 return
             }
             
             // Show the table view when the text is 4 or more characters
             tableView.isHidden = false
             
             // Invalidate the previous timer if the user is typing
             typingTimer?.invalidate()
             
             // Set a new timer to fire after 2 seconds of inactivity
             typingTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fetchMedications), userInfo: textField.text, repeats: false)
        
    }
    @objc func fetchMedications() {
          guard let searchTerm = typingTimer?.userInfo as? String else { return }
        // Show the activity indicator
           showLoadingIndicator()
          // Call the function to fetch medications with the given search term
        searchMedicationNetworkManager.shared.fetchMedications(searchTerm: searchTerm) { result in
            DispatchQueue.main.async{
                // Hide the activity indicator
                          self.hideLoadingIndicator()
            }
              switch result {
              case .success(let medications):
                  // Update your UI with the fetched medications
                  self.medications = medications
                  DispatchQueue.main.async{
                      self.tableView.reloadData()
                  }
                  print("Fetched Medications: \(medications)")
              case .failure(let error):
                  print("Error fetching medications: \(error.localizedDescription)")
              }
          }
     
      }
    // Function to show the loading indicator
    func showLoadingIndicator() {
        // Check if an indicator is already present to avoid duplicates
        if activityIndicator == nil {
            // Create and configure the activity indicator
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.color = .gray
            indicator.center = tableView.center
            indicator.hidesWhenStopped = true
            
            // Add it to the main view and bring it to the front
            self.view.addSubview(indicator)
            self.view.bringSubviewToFront(indicator)
            indicator.startAnimating()
            
            activityIndicator = indicator
        }
    }

    // Function to hide the loading indicator
    func hideLoadingIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
            @objc func searchButtonTapped() {
                tableView.isHidden = !tableView.isHidden
            }
            
            @objc func textFieldTapped() {
                print("Text field tapped")
            }
        }
