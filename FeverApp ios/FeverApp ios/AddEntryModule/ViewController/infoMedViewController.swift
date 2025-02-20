//
//  infoMedViewController.swift
//  FeverApp ios
//
//  Created by NEW on 19/11/2024.
//

import UIKit
class infoMedViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    // outlets
    @IBOutlet var topView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var reasonTextField: UITextField!
    @IBOutlet var decisionTextField: UITextField!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var timeButton: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var otherMedicationButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    var timeOfAdministration : Date?
    var dateOfAdministration : Date?
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var amountTextFieldLabel: UILabel!
    
    @IBOutlet var reasonTextFieldLabel: UILabel!
 
    @IBOutlet var basisOfDecision: UILabel!
    
    
    
    
    //
    let diagnosisvaccinesTableView = UITableView()
    var medicationInfo: String? // Property to hold the text

    let basisOfDecisionTableView = UITableView()
    let diagnosis = [
        "Prescription",
        "Current height of fever",
        "Fear that the fever could rise further",
        "Quicker recovery",
        "Quiet night",
        "To make the child drink",
    ]
    let decisions = [
        "Own decision",
        "Doctor's recommendation",
        "Pharmacist's recommendation",
        "Recommendation of another therapist",
        "Other recommendations"
    ]
    var selectedDecisions: String = ""
    var selectedDecisionTag: Int?
  var selectedReason: String = ""
    var selectedReasonTag : Int?
    @objc func doneTapped() {
        if selectedReason.count > 25 {
            // Trim the string to the first 27 characters and add ".."
            let trimmedDiagnosis = String(selectedReason.prefix(25)) + ".."
            reasonTextField.text = trimmedDiagnosis
        } else {
            // Use the full string if it's within the limit
            reasonTextField.text = selectedReason
        }
        if selectedDecisions.count > 20 {
            // Trim the string to the first 27 characters and add ".."
            let trimmedDecision = String(selectedDecisions.prefix(20)) + ".."
            decisionTextField.text = trimmedDecision
        } else {
            // Use the full string if it's within the limit
            decisionTextField.text = selectedDecisions
        }
        decisionTextField.text = selectedDecisions
        diagnosisvaccinesTableView.isHidden = true
        basisOfDecisionTableView.isHidden = true
      
    }
    let   shadowWrapperView = UIView()
    // actions
    enum ReasonForAdministration: String {
        case one = "PRESCRIPTION"
        case two = "CURRENT_HEIGHT_OF_FEVER"
        case three = "FEAR_THAT_THE_FEVER_COULD_RISE_FURTHER"
        case four = "QUICKER_RECOVERY"
        case five = "PAIN"
        case six = "DISCOMFORT"
        case seven = "QUIET_NIGHT"
        case eight = "TO_MAKE_THE_CHILD_DRINK"
        case nine = "OTHER_REASONS"
     
        
        static func fromTag(_ tag: Int) -> ReasonForAdministration? {
               switch tag {
               case 0:
                   return .one
               case 1:
                   return .two
               case 2:
                   return .three
               case 3:
                   return .four
               case 4:
                   return .five
               case 5:
                   return .six
               case 6:
                   return .seven
               case 7:
                   return .eight
               case 8:
                   return .nine
               default:
                   return nil
               }
           }
    }
    //
    enum BasisOfDecision: String {
        case ownDecision = "OWN_DECISION"
        case doctorRecommendation = "DOCTOR_RECOMMENDATION"
        case pharmacistRecommendation = "PHARMACIST_RECOMMENDATION"
        case anotherTherapistRecommendation = "ANOTHER_THERAPIST_RECOMMENDATION"
        case otherRecommendations = "OTHER_RECOMMENDATIONS"

        // Map tags to enum cases
            static func fromTag(_ tag: Int) -> BasisOfDecision? {
                switch tag {
                case 0:
                    return .ownDecision
                case 1:
                    return .doctorRecommendation
                case 2:
                    return .pharmacistRecommendation
                case 3:
                    return .anotherTherapistRecommendation
                case 4:
                    return .otherRecommendations
                default:
                    return nil
                }
            }
        
     
    }

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var infoText: UITextView!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    var saveMedication: (()->Void)?
    @IBAction func saveButtonTapped(_ sender: Any) {
        let entryMedicationId = EntryMedicationsModel.shared.medicationEntryId!
        // save entry medication data through the network manager
      let amountText = amountTextField.text ?? "0"
          let amountValue = Double(amountText)
        // Declare variables outside the conditional scope
        var reasonEnumValue: ReasonForAdministration?
        var decisionEnumValue: BasisOfDecision?

        if let selectedReasonTag = selectedReasonTag { // Ensure the tag is not nil
            if let reason = ReasonForAdministration.fromTag(selectedReasonTag) {
                reasonEnumValue = reason
            } else {
                print("Invalid reason tag")
            }
        } else {
            print("No tag selected")
        }


        if let selectedTag = selectedDecisionTag, // Unwrap the optional
           let decision = BasisOfDecision.fromTag(selectedTag) { // Pass the unwrapped value
            decisionEnumValue = decision
        } else {
            print("Invalid decision")
        }

        
        EntryMedicationsModel.shared.updateEntryMedication(with:entryMedicationId , amountAdministered: amountValue ?? 0, basisOfDecision: decisionEnumValue?.rawValue ?? "" , reasonForAdministration: reasonEnumValue?.rawValue ?? "", dateOfAdministration: self.dateOfAdministration ?? Date(), timeOfAdministration: self.timeOfAdministration ?? Date()){isSaved in
            if isSaved {
                self.saveMedication?()
                self.navigationController?.dismiss(animated: true)
            }else{
                let alertController = UIAlertController(title: TranslationsViewModel.shared.getTranslation(key: "LOGIN.ERROR.INTERNAL_ERROR.ALERT.HEADER", defaultText: "Internal error!"), message: TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.FAILED.TO.SAVE.MEDICATION", defaultText: "Failed to save medication"), preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.OK", defaultText: "Ok"), style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
            
        }
      
      
    }
    func timeStringToDate(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24-hour format
        formatter.timeZone = TimeZone.current // Use local timezone if needed

        // Convert the time string to a Date object
        if let date = formatter.date(from: timeString) {
            return date
        } else {
            print("Invalid time string format: \(timeString)")
            return nil
        }
    }
    @IBAction func showTimePicker(_ sender: Any) {
        // setup darker background view
        let darkerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        darkerView.translatesAutoresizingMaskIntoConstraints = false
        darkerView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        view.addSubview(darkerView)
        let timePicker = CustomTimePickerView()
               timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.cancelTap = {
                timePicker.removeFromSuperview()
                darkerView.removeFromSuperview()
        }
               timePicker.onTimeSelected = { [weak self] selectedTime in
                   print("selected time is \(selectedTime)")
                   self?.timeOfAdministration = self?.timeStringToDate(selectedTime)
                   self?.timeButton.setTitle(selectedTime, for: .normal)
                   timePicker.removeFromSuperview()
                   darkerView.removeFromSuperview()
               }

               view.addSubview(timePicker)
        view.bringSubviewToFront(darkerView)
        view.bringSubviewToFront(timePicker)
               NSLayoutConstraint.activate([
                   timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
                   timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
                   timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   timePicker.heightAnchor.constraint(equalToConstant: 450)
               ])
    }
    func dateStringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Format of the input date string
        formatter.timeZone = TimeZone.current // Use the current timezone if needed
        formatter.locale = Locale.current    // Use the current locale

        // Convert the date string to a Date object
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            print("Invalid date string format: \(dateString)")
            return nil
        }
    }
    @IBAction func showDatePicker(_ sender: Any) {
        let darkerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
           darkerView.translatesAutoresizingMaskIntoConstraints = false
           darkerView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
           darkerView.isUserInteractionEnabled = false // Prevent interaction blocking
           view.addSubview(darkerView)
           
           let datePicker = customDatePickerView()
           datePicker.okButtonTap = {
               print("OK button tapped") // Debugging
               darkerView.removeFromSuperview()
               datePicker.removeFromSuperview()
           }
           datePicker.cancelButtonTap = {
               print("Cancel button tapped") // Debugging
               darkerView.removeFromSuperview()
               datePicker.removeFromSuperview()
           }
        datePicker.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
           datePicker.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(datePicker)
           view.bringSubviewToFront(datePicker)
           
           NSLayoutConstraint.activate([
               darkerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               darkerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               darkerView.topAnchor.constraint(equalTo: view.topAnchor),
               darkerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               
               datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
               datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
               datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               datePicker.heightAnchor.constraint(equalToConstant: 450)
           ])
    }
    
    @IBAction func reasonDropDown(_ sender: Any) {
        diagnosisvaccinesTableView.isHidden = false
        basisOfDecisionTableView.isHidden = true
    }
    
    
    @IBAction func decisionDropDown(_ sender: UIButton) {
        basisOfDecisionTableView.isHidden = false
        diagnosisvaccinesTableView.isHidden = true
    }
    
    
    func setupUi(){
        titleLabel.text = medicationInfo ?? ""
        closeButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CLOSE", defaultText: "Close"), for: .normal)
      
        amountTextFieldLabel.text = TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.TYPE_VALUE_LABEL", defaultText: "Amount")
        reasonTextFieldLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "REASON.SELECT.TEXT", defaultText: "Select reason")
        basisOfDecision.text = TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.RECOMMENDATION", defaultText: "Basis of decision")
        dateLabel.text = TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.DATE", defaultText: "Date")
        timeLabel.text = TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.TIME", defaultText: "Time")
        otherMedicationButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.MORE", defaultText: "Other medication"), for: .normal)
        saveButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.SAVE", defaultText: "Save"), for: .normal)
      
        amountTextField.placeholder = TranslationsViewModel.shared.getAdditionalTranslation(key: "AMOUNT.ENTER.TEXT", defaultText: "Enter amount")
        reasonTextField.placeholder = TranslationsViewModel.shared.getAdditionalTranslation(key: "REASON.SELECT.TEXT", defaultText: "Select reason")
        decisionTextField.placeholder = TranslationsViewModel.shared.getAdditionalTranslation(key: "DECISION.BASIS.SELECT.TEXT", defaultText: "Select basis of decision")
        infoText.text = TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.SUB_NOTE", defaultText: """
                                                                    Please fill in the above fields correctly again. If you had already made an entry for one of your medications, these fields are pre-filled to help you be faster when administering the same medication repeatedly. However, you can edit and adjust any of the above pre-filled fields by clicking on them.<br>If you have administered other medicines, click on ""Other medicine"" to return to your medicine list. There you can scan or search for the additional medicine and select its administration form and time.
                                                                    """)
        saveButton.layer.cornerRadius = 8
        otherMedicationButton.layer.cornerRadius = 8
        otherMedicationButton.layer.borderWidth = 2
        otherMedicationButton.layer.borderColor = UIColor.lightGray.cgColor
        // Add padding to the text field
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: amountTextField.frame.height))
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: amountTextField.frame.height))
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: amountTextField.frame.height))
         amountTextField.leftView = paddingView
         amountTextField.leftViewMode = .always
       reasonTextField.leftView = paddingView2
        reasonTextField.leftViewMode = .always
        reasonTextField.isEnabled = false
        decisionTextField.isEnabled = false
       decisionTextField.leftView = paddingView3
        decisionTextField.leftViewMode = .always
        amountTextField.keyboardType = .numberPad
        
        // Create a toolbar with a "Done" button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
        let doneButton = UIBarButtonItem(title: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done"), style: .done, target: self, action: #selector(dismissKeyboard))
           toolbar.setItems([doneButton], animated: false)
        // Set the toolbar as the inputAccessoryView for the painTextField
        amountTextField.inputAccessoryView = toolbar
        for field in [amountTextField,reasonTextField,decisionTextField] {
            field?.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        field?.layer.cornerRadius = 8
            field?.layer.borderWidth = 2
        }
        topView.translatesAutoresizingMaskIntoConstraints = false
      
        
        topView.layer.masksToBounds = false
        containerView.layer.masksToBounds = true
        

        // setup the topView
        topView.layer.cornerRadius = 20
        topView.layer.shadowColor = UIColor(white: 0.8, alpha: 1).cgColor
        topView.layer.shadowOpacity = 1
        topView.layer.shadowRadius = 4
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        //container view
        containerView.layer.cornerRadius = 9
        
        //scroll view
     
        //
        shadowWrapperView.layer.masksToBounds = false
        shadowWrapperView.translatesAutoresizingMaskIntoConstraints = false
        shadowWrapperView.backgroundColor = .white
        shadowWrapperView.layer.shadowColor = UIColor.gray.cgColor
        shadowWrapperView.layer.shadowOpacity = 0.9
        shadowWrapperView.layer.shadowRadius = 4
        shadowWrapperView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowWrapperView.layer.cornerRadius = 8 // Optional: If you want rounded corners

        // Add the shadow wrapper to the parent view
        view.addSubview(shadowWrapperView)
        // Set constraints for the shadow wrapper and scroll view
        NSLayoutConstraint.activate([
            // Shadow wrapper constraints
            shadowWrapperView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            shadowWrapperView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            shadowWrapperView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            shadowWrapperView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        
            
        ])
        view.bringSubviewToFront(scrollView)
    }
    // setup 1st tableView
    func setupTableView() {
        diagnosisvaccinesTableView.translatesAutoresizingMaskIntoConstraints = false
        diagnosisvaccinesTableView.delegate = self
        diagnosisvaccinesTableView.dataSource = self
        diagnosisvaccinesTableView.isHidden = true
    
        diagnosisvaccinesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "vaccineCell")
        
        // Add rounded corners to the table view
        diagnosisvaccinesTableView.layer.cornerRadius = 15
        diagnosisvaccinesTableView.clipsToBounds = true
        view.addSubview(diagnosisvaccinesTableView)
        
        NSLayoutConstraint.activate([
            diagnosisvaccinesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diagnosisvaccinesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            diagnosisvaccinesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            diagnosisvaccinesTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        // Create table view header
        let diagnosistableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 90))
        diagnosistableViewHeader.backgroundColor = .white
        
        let diagnosisgrayBar = UIView()
        diagnosisgrayBar.translatesAutoresizingMaskIntoConstraints = false
        diagnosisgrayBar.backgroundColor = UIColor.lightGray
        diagnosisgrayBar.layer.cornerRadius = 2
        diagnosistableViewHeader.addSubview(diagnosisgrayBar)
        
        NSLayoutConstraint.activate([
            diagnosisgrayBar.centerXAnchor.constraint(equalTo: diagnosistableViewHeader.centerXAnchor),
            diagnosisgrayBar.topAnchor.constraint(equalTo: diagnosistableViewHeader.topAnchor, constant: 16),
            diagnosisgrayBar.widthAnchor.constraint(equalTo: diagnosistableViewHeader.widthAnchor, multiplier: 0.12),
            diagnosisgrayBar.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        let chooseVaccinesLabel = UILabel()
        chooseVaccinesLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseVaccinesLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.REASON", defaultText: "What is your reason?")
        chooseVaccinesLabel.font = UIFont.boldSystemFont(ofSize: 17)
        diagnosistableViewHeader.addSubview(chooseVaccinesLabel)
        
        NSLayoutConstraint.activate([
            chooseVaccinesLabel.leadingAnchor.constraint(equalTo: diagnosistableViewHeader.leadingAnchor, constant: 15),
            chooseVaccinesLabel.bottomAnchor.constraint(equalTo: diagnosistableViewHeader.bottomAnchor, constant: -15),
            chooseVaccinesLabel.topAnchor.constraint(equalTo:  diagnosisgrayBar.topAnchor, constant: 35)
        ])
        
        let diagnosisdoneLabel = UILabel()
        diagnosisdoneLabel.translatesAutoresizingMaskIntoConstraints = false
        diagnosisdoneLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done")
        diagnosisdoneLabel.font = UIFont.systemFont(ofSize: 17)
        diagnosisdoneLabel.textColor =  UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
        diagnosistableViewHeader.addSubview(diagnosisdoneLabel)
        
        NSLayoutConstraint.activate([
            diagnosisdoneLabel.trailingAnchor.constraint(equalTo: diagnosistableViewHeader.trailingAnchor, constant: -15),
            diagnosisdoneLabel.bottomAnchor.constraint(equalTo: diagnosistableViewHeader.bottomAnchor, constant: -15)
        ])
        
        let diagnosisdoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(doneTapped))
        diagnosisdoneLabel.isUserInteractionEnabled = true
        diagnosisdoneLabel.addGestureRecognizer(diagnosisdoneTapGesture)
        
        diagnosisvaccinesTableView.tableHeaderView = diagnosistableViewHeader
        diagnosisvaccinesTableView.isHidden = true
    }
    func setupDecisionTableView() {
      basisOfDecisionTableView.translatesAutoresizingMaskIntoConstraints = false
        basisOfDecisionTableView.delegate = self
        basisOfDecisionTableView.dataSource = self
        basisOfDecisionTableView.isHidden = true
        basisOfDecisionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "vaccineCell")
        
        // Add rounded corners to the table view
        basisOfDecisionTableView.layer.cornerRadius = 15
        basisOfDecisionTableView.clipsToBounds = true
        view.addSubview(basisOfDecisionTableView)
        
        NSLayoutConstraint.activate([
            basisOfDecisionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basisOfDecisionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            basisOfDecisionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            basisOfDecisionTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
        
        // Create table view header
        let diagnosistableViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 90))
        diagnosistableViewHeader.backgroundColor = .white
        
        let diagnosisgrayBar = UIView()
        diagnosisgrayBar.translatesAutoresizingMaskIntoConstraints = false
        diagnosisgrayBar.backgroundColor = UIColor.lightGray
        diagnosisgrayBar.layer.cornerRadius = 2
        diagnosistableViewHeader.addSubview(diagnosisgrayBar)
        
        NSLayoutConstraint.activate([
            diagnosisgrayBar.centerXAnchor.constraint(equalTo: diagnosistableViewHeader.centerXAnchor),
            diagnosisgrayBar.topAnchor.constraint(equalTo: diagnosistableViewHeader.topAnchor, constant: 16),
            diagnosisgrayBar.widthAnchor.constraint(equalTo: diagnosistableViewHeader.widthAnchor, multiplier: 0.12),
            diagnosisgrayBar.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        let chooseVaccinesLabel = UILabel()
        chooseVaccinesLabel.translatesAutoresizingMaskIntoConstraints = false
        chooseVaccinesLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ADD.PROFILE.DECISION.BASIS", defaultText: "What is your basis of decision?")
        chooseVaccinesLabel.font = UIFont.boldSystemFont(ofSize: 17)
        diagnosistableViewHeader.addSubview(chooseVaccinesLabel)
        
        NSLayoutConstraint.activate([
            chooseVaccinesLabel.leadingAnchor.constraint(equalTo: diagnosistableViewHeader.leadingAnchor, constant: 15),
            chooseVaccinesLabel.bottomAnchor.constraint(equalTo: diagnosistableViewHeader.bottomAnchor, constant: -15),
            chooseVaccinesLabel.topAnchor.constraint(equalTo:  diagnosisgrayBar.topAnchor, constant: 35)
        ])
        
        let diagnosisdoneLabel = UILabel()
        diagnosisdoneLabel.translatesAutoresizingMaskIntoConstraints = false
        diagnosisdoneLabel.text = TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done")
        diagnosisdoneLabel.font = UIFont.systemFont(ofSize: 17)
        diagnosisdoneLabel.textColor =  UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
        diagnosistableViewHeader.addSubview(diagnosisdoneLabel)
        
        NSLayoutConstraint.activate([
            diagnosisdoneLabel.trailingAnchor.constraint(equalTo: diagnosistableViewHeader.trailingAnchor, constant: -15),
            diagnosisdoneLabel.bottomAnchor.constraint(equalTo: diagnosistableViewHeader.bottomAnchor, constant: -15)
        ])
        
        let diagnosisdoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(doneTapped))
        diagnosisdoneLabel.isUserInteractionEnabled = true
        diagnosisdoneLabel.addGestureRecognizer(diagnosisdoneTapGesture)
        
        basisOfDecisionTableView.tableHeaderView = diagnosistableViewHeader
        basisOfDecisionTableView.isHidden = true
    }
    
    // TableView DataSource and Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == diagnosisvaccinesTableView{
            return diagnosis.count
        }else{
            return decisions.count
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaccineCell", for: indexPath)
        
        if tableView == diagnosisvaccinesTableView{
        
            let diagnosisText = diagnosis[indexPath.row]
            cell.textLabel?.text = diagnosisText
            
            let checkmarkImageView = UIImageView()
            checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
            checkmarkImageView.contentMode = .scaleAspectFit
            // Check if the vaccineText is in the selectedVaccines array
            let isSelected = selectedReason == diagnosisText
            checkmarkImageView.image = UIImage(named: isSelected ? "Property 1=on.png" : "Property 1=off.png")
            
            cell.contentView.addSubview(checkmarkImageView)
            NSLayoutConstraint.activate([
                checkmarkImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                checkmarkImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
                checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
            
       
        }else{
          
            
            let diagnosisText = decisions[indexPath.row]
            cell.textLabel?.text = diagnosisText
            
            let checkmarkImageView = UIImageView()
            checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
            checkmarkImageView.contentMode = .scaleAspectFit
            // Check if the vaccineText is in the selectedVaccines array
            let isSelected = selectedDecisions == diagnosisText
            checkmarkImageView.image = UIImage(named: isSelected ? "Property 1=on.png" : "Property 1=off.png")
            
            cell.contentView.addSubview(checkmarkImageView)
            NSLayoutConstraint.activate([
                checkmarkImageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
                checkmarkImageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
                checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
            
        }
       return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == diagnosisvaccinesTableView{
            let Diagnosis = diagnosis[indexPath.row]
            
            selectedReason = Diagnosis
            selectedReasonTag = indexPath.row
            
            tableView.reloadData()
        }else{
            let decision = decisions[indexPath.row]
            selectedDecisionTag = indexPath.row
          selectedDecisions = decision
           
            
            tableView.reloadData()
        }
     
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

       setupUi()
        setupTableView()
        setupDecisionTableView()
    }
    // objc functions
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current // Use the current timezone if needed
        dateFormatter.locale = Locale.current
          let pickedDate = dateFormatter.string(from: sender.date)
        
        self.dateOfAdministration = self.dateStringToDate(pickedDate)
          print("picked date \(pickedDate)")
          
          // Use setTitle instead of accessing titleLabel directly
          dateButton.setTitle(pickedDate, for: .normal)
          dateButton.setTitleColor(.black, for: .normal)
    }
    @objc func dismissKeyboard(){
        amountTextField.resignFirstResponder()
    }
}
