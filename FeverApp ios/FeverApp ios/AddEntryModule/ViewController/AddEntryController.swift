//
//  testButtonViewController.swift
//  FeverApp ios
//
//  Created by user on 10/1/24.
//
import UIKit

protocol AddEntryDelegate: AnyObject {
    func didDismissAddEntryController()
}

class AddEntryController: UIViewController, UITextFieldDelegate,UIScrollViewDelegate{
    
    weak var delegate: AddEntryDelegate?
    @IBOutlet var previousButton: UILabel!
    @IBOutlet var nextButton: UILabel!
    @IBOutlet var DoneButton: UIButton!
    @IBOutlet var addRecordLabel: UILabel!
    
    
    @IBOutlet var topView: UIView!
    @IBAction func previousButtonTapped(_ sender: Any) {
        if currentViewIndex == 1 && currentSubviewIndex == 0{
            currentSubviewIndex = 0
            currentViewIndex = 0
        }else if currentSubviewIndex > 0 {
               // Move to the previous subview
               currentSubviewIndex -= 1
           } else {
               // Move to the last subview of the previous main view
               if currentViewIndex > 0 {
                   currentViewIndex -= 1
                   let previousMainView = views[currentViewIndex]
                   currentSubviewIndex = previousMainView.subviews.count - 1
               }
           }
           updateVisibleView()
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        let mainView = views[currentViewIndex]
           let subviews = mainView.subviews
        if currentViewIndex == 0 && currentSubviewIndex == 0{
            currentSubviewIndex += 1
        }
           if currentSubviewIndex < subviews.count - 1 {
               // Move to the next subview
               currentSubviewIndex += 1
           } else {
               // Move to the first subview of the next main view
               currentSubviewIndex = 0
               if currentViewIndex < views.count - 1 {
                   currentViewIndex += 1
               }
           }
           updateVisibleView()
        
        
    }
    
    
    @IBAction func DoneTapped(_ sender: Any) {
        // Notify delegate before dismissing
        delegate?.didDismissAddEntryController()
        self.dismiss(animated: true)
    }
    
    // Function to update the visible view
    func updateVisibleView() {
        // Hide all main views and subviews first
        views.forEach { mainView in
            mainView.isHidden = true
            mainView.subviews.forEach { $0.isHidden = true }
        }

        // Show the current main view and subview
        let mainView = views[currentViewIndex]
        mainView.isHidden = false

        let subviews = mainView.subviews
        if currentSubviewIndex < subviews.count {
            subviews[currentSubviewIndex].isHidden = false
        }else{
            currentViewIndex += 1
            currentSubviewIndex = 0
            updateVisibleView()
        }
        // Reset border color for all buttons except the button for the visible main view
        for button in stackView.arrangedSubviews as! [UIButton] {
            if currentViewIndex == button.tag{
                // Change the button's image to the selected image
                let selectedImageName = buttonImageState[button.tag]?.selectedImage ?? ""
                button.setImage(UIImage(named: selectedImageName), for: .normal)
                // Highlight the selected button with a blue border
                button.layer.borderColor = CGColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
                button.layer.borderWidth = 1
                // Automatically scroll to the next button
                scrollToSelectedButton(sender: button)
            }else{
                button.layer.borderColor = initialBorderColor.cgColor
                button.layer.borderWidth = 0
                // Set the button's image to the normal image
                let imageName = buttonImageState[button.tag]?.normalImage ?? ""
                button.setImage(UIImage(named: imageName), for: .normal)
            }
        }
     
    }
    // SCROLL BUTTONS SETTINGS
    // ScrollView container
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let bar = UIView()
    
    // Configuration properties
    let buttonWidth: CGFloat = 95
    let buttonHeight: CGFloat = 70
    let imageSize: CGFloat = 30
    let textSize: CGFloat = 14
    let containerHeight: CGFloat = 100
    let topPadding: CGFloat = 10
    var initialBorderColor: UIColor = .white // Initial border color for buttons
    
    // Store button image states
    var buttonImageState: [Int: (normalImage: String, selectedImage: String)] = [
        0: ("Blue heart", "Blue heart"),
        1: ("temp", "bluetemperature(1)"),
        2: ("Pain", "Pain1"),
        3: ("liquid", "Liqui"),
        4: ("Diarr", "Blue diarrhea"),
        5: ("Rash", "blueRash"),
        6: ("Symptoms gray", "blueSymptoms"),
        7: ("warning", "warningSignBlue"),
        8: ("Feeling confi", "confident"),
        9: ("Contact", "contactmedecin"),
        10: ("medica", "sarahdrug"),
        11: ("measure", "bluemeasure(2)"),
        12: ("note", "Icon-34")
    ]

    // Views for each button
    var stateOfHealthView :MainView!
    var temperatureView :MainView!
    var painView:MainView!
    var liquidView:MainView!
    var diarrheaView:MainView!
    var rashView:MainView!
    var symptomsView:MainView!
    var warningSignsView:MainView!
    var feelingConfidentView:MainView!
    var contactView:MainView!
    var medicationView:MainView!
    var measuresView:MainView!
    var noteView:MainView!
    // Assume 'views' is an array to store all the views corresponding to each button.
    var views: [UIView] = [] // Array to store all the views
    var currentViewIndex: Int = 0 // Tracks the currently visible view
    var currentSubviewIndex: Int = 0
    // SCROLL BUTTONS SETTINGS END
    
    //STATE OF HEALTH
    let stateOfHealthFirstView = StateOfHealthFirstSubview()
    let stateOfHealthSecondSubview = StateOfHealthSecondSubview()
    var entryOverallDate: Date? {
        didSet {
            // Check if entryOverallDate has a value
            if entryOverallDate != nil {
                removeAllDatePickerViews()
                isDateViewsRemoved = true
            }
        }
    }
    var isDateViewsRemoved = false
    // Function to remove all date picker views from their superviews
    func removeAllDatePickerViews() {
        // List of all date picker views
        let datePickerViews: [UIView] = [
            stateOfHealthSecondSubview,
            temperatureValueDateView,
            liquidDateTimeView,
            diarrheaDateTimeView,
            rashDateTimeView,
            symptomsDateTimeView,
            warningSignsDateTimeView,
            feelingConfidentDateTimeView,
            measureDateTimeView,
            noteDateTime,
            painDateTimeView
        ]
        
        // Iterate through each view and remove it from its superview
        for view in datePickerViews {
            view.removeFromSuperview()
        }
        
        print("All date picker views have been removed.")
    }
    //STATE OF HEALTH END
    //STATE OF HEALTH SUBVIEW
    
   
    //STATE OF HEALTH SUBVIEW
    // Define picker views for each column (date, hours, minutes)
   
   public func setupDatePickerSubview(superView: UIView){
     
       let datePicker = entryDatePickerView()

       superView.addSubview(datePicker)
       // Constraints for the datePicker in the parent view
       NSLayoutConstraint.activate([
           datePicker.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
           datePicker.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
           datePicker.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -95),
           datePicker.heightAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3)
       ])
    }
    //TEMPERATURE VIEW
 // Temperature value view
    // Other pain location view components
    // Other pain location view components
    let temperatureFirstView = TemperatureFirstView()
    let temperatureValueView = textFieldValueView()
    let temperatureValueDateView = TemperatureValueDateView()
    let temperatureLocationView = TemperatureLocationView()
    let TemperatureVaccineView = TemperatureVaccinesView()
    let temperatureVaccinesDateView = TemperatureVaccineDateView()
    let temperatureVaccinesListView = TemperatureVaccineListView()
    //TEMPERATURE VIEW END
    //liquid view

    let liquidFirstView = liquidFirstViews()
    let liquidDateTimeView = liquidDateTimeViews()
    //lliquid view end
    //Diarrhea View
    let diarrheaFirstView = DiarrheaFirstView()
    let diarrheaDateTimeView = DiarrheaDateTimeView()
  
    //Diarrhea View end
    //Rash view
    let rashFirstSubview = RashFirstSubview()
    let rashDateTimeView = RashDateTimeView()
    //Rash view end
    //SYMPTOMS VIEW
    let symptomsFirstView = SymptomsFirstSubview()
    let symptomsDateTimeView = SymptomsDateTimeView()
    let otherSymptompsView = otherSymptompsTextFieldView()
   
    //SYMPTOMS VIEW  END
    // WARNING SIGNS VIEW
    let warningSignsFirstSubview = WarningSignsFirstSubview()
    let warningSignsDateTimeView = WarningSignsDateTimeView()
    // WARNING SIGNS VIEW END
    //FEELING CONFIDENT
    let feelingConfidentFirstView = FeelingConfidentFirstView()
    let feelingConfidentDateTimeView = FeelingConfidentDateTimeView()
    //FEELING CONFIDENT END
    //CONTACT WITH VIEW
    let otherReasonsForContactingDoctorView = otherReasonsForContactingDoctorTextFieldView()
    let otherMedecinePrescribedView = otherMedecinePrescribedByDoctorTextFieldView()
    let doctorPrescriptionView = DoctorPrescriptionView()
    let doctorDiagnosisView = DoctorDiagnosisViews()
    let otherDiagnosisView = OtherDiagnosisView()
    let contactWithDoctorDateTimeView = ContactWithDoctorDateTimeView()
    let otherReasonForContactingDoctorView = OtherReasonsForContactingDoctorView()
    let contactWithDoctorFirstSubview = ContactWithDoctorFirstView()
    let otherMeasuresTakenByDoctor = OtherMeasuresTakenByDoctorView()
    //CONTACT WITH END
    //GET MEDICATION VIEW
    let medicationFirstSubview = MedicationFirstSubview()
    //GET MEDICATION VIEW END
    //MEASURE VIEW
    let measuresFirstSubviews = MeasuresFirstSubview()
    let measuresTakenView = MeasuresTakenView()
    let otherMeasuresView = otherMeasuresTextFieldView()
    let measureDateTimeView = MeasureDateTimeView()
   
    //MEASURE VIEW END
    //NOTE VIEW
    let noteFirstView = NoteFirstView()
    let otherNotesView = OtherNotesView()
    let noteDateTime =  NoteDateTime()
    //NOTE VIEW END
    //TEMPERATURE SUBVIEW
    //TEMPERATURE SUBVIEW END
    //PAIN SUBVIEW
    // Other pain location view components
    let painLocationView = painLocationViews()
    let painStrengthView = PainStrengthView()
    let otherPainLocationView = otherPainLocationViews()
    let painDateTimeView = painDateTimeViews()
    var isVaccinationAnswered = false
    //PAIN SUBVIEW2 END
    func checkIfProfileAnsweredVaccination(){
        isVaccinationAnswered =  vaccinationNetworkManager.shared.checkIfProfileIsVaccinated()
        if isVaccinationAnswered == true{
            TemperatureVaccineView.removeFromSuperview()
            temperatureVaccinesDateView.removeFromSuperview()
            temperatureVaccinesListView.removeFromSuperview()
        }else{
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        previousButton.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.1", defaultText: "Previous")
        nextButton.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-NAVIGATION.TEXT.4", defaultText: "Next")
        addRecordLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.ADD.RECORD", defaultText: "Add record")
        DoneButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done"), for: .normal)
        //MAIN SCROLLVIEW WITH BUTTONS
        setupScrollView() // ScrollView
        setupButtons() // ScrollView
        setupBar() // ScrollView
        setupViews() // Create views for each button
        //MAIN SCROLLVIEW WITH BUTTONS END
        // ALL MAIN VIEWS
        setupAllMainViews()
        // ALL MAIN VIEWS end
        //PAIN SUBVIEW2
       //PAIN SUBVIEW2 END
        //PAIN SUBVIEW
      
        //PAIN SUBVIEW END
        //STATE OF HEALTH SUBVIEW
        setupStateOfHealthFirstView()
        setupStateOfHealthSecondView()
        passIconImage()
        //STATE OF HEALTH SUBVIEW
        //NOTE VIEW
        setupNoteFirstView()
        setupNoteDateTime()
        //NOTE VIEW END
        //MEASURE VIEW
        setupMeasuresFirstSubview()
        setupOtherMeasuresView()
        setupMeasureDateTimeView()
        setupMeasuresTakenView()
        //MEASURE VIEW END
        //GET MEDICATION VIEW
        setupMedicationFirstSubview()
        if let infoMedViewController = storyboard?.instantiateViewController(withIdentifier: "infoMedicationScreen") as? infoMedViewController {
            infoMedViewController.saveMedication = { [weak self] in
                guard let self = self else { return }
                // Update the visible views
              currentSubviewIndex += 3
               updateVisibleView()
            }
            // Present ViewController 2
            self.present(infoMedViewController, animated: true, completion: nil)
        } else {
            print("Failed to instantiate InfoMedViewController")
        }
        //GET MEDICATION VIEW END
        //CONTACT WITH VIEW
       
        setupOtherNotesView()
        setupContactWithDoctorFirstView()
        setupOtherReasonsForContactingDoctorView()
        setupOtherMedecinePrescribedView()
        setupContactWithDoctorDateTimeView()
        setupDoctorDiagnosisView()
        setupOtherDiagnosisView()
        setupOtherReasonForContactingDoctorView()
        setupDoctorPrescriptionView()
        setupOtherMeasuresTakenByDoctor()
        //CONTACT WITH END
        //FEELING CONFIDENT
        setupFeelingConfidentFirstView()
        setupFeelingDateTimeView()
        //FEELING CONFIDENT END
        // WARNING SIGNS VIEW END
        setupWarningSignsFirstView()
        setupWarningSignsDateTimeView()
        // WARNING SIGNS VIEW END
        //SYMPTOMS VIEW
        setupSymptomsFirstView()
        setupOtherSymptomsView()
        setupSymptomsDateTimeView()
        //SYMPTOMS VIEW  END
        //Rash view
        setupRashFirstView()
        setupRashDateTimeView()
        //Rash view end
        // Diarrhea View
        setupDiahreaFirstView()
        setupDiahreaDateTimeView()
        //Diarrhea View end
        //liquid view
       
        setupLiquidFirstView()
        setupLiquidDateTimeView()
     
       
        //liquid view end
        //For pain
      setupPainLocationview()
        setupPainStrengthView()
        setupOtherPainLocationView()
        setupPainDateTimeView()
        //For pain end
        //TEMPERATURE VIEW
        //TEMPERATURE VIEW END
        //STATE OF HEALTH
      
        //STATE OF HEALTH END
        //TEMPERATURE SUBVIEW
        setupTemperatureFirstView()
        setupTemperatureValueView()
        setupTemperatureValueDateView()
        setupTemperatureLocationView()
        setupTemperatureVaccineView()
        setupTemperatureVaccinesListView()
        setupTemperatureVaccineDateView()
        checkIfProfileAnsweredVaccination()
        //TEMPERATURE SUBVIEW END
        updateVisibleView()
    }
    // Beginning of Scroll View Code
    func setupScrollView() {
        // Add ScrollView to view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        // Set constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            scrollView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
        // Add stackView to scrollView
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        // Set constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    func setupButtons() {
        let buttonsConfig = [
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.TITLE", defaultText: "State of health"), 0),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TITLE", defaultText: "Temperature"), 1),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.PAIN.TITLE", defaultText: "Pain"), 2),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.DRINK.TITLE", defaultText: "Liquid"), 3),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARRHEA.TITLE", defaultText: "Diarrhea"), 4),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.RASH.TITLE", defaultText: "Rash"), 5),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.SYMPTOMS.TITLE", defaultText: "Symptoms"), 6),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.WARNING_SIGNS.TITLE", defaultText: "Warning signs"), 7),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.CONFIDENCE.TITLE", defaultText: "Feeling confident"), 8),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.TITLE", defaultText: "Contact with Doctor"), 9),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.MEDICATION.TITLE", defaultText: "Medication"), 10),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.TITLE", defaultText: "Measures"), 11),
            (TranslationsViewModel.shared.getTranslation(key: "DIARY.NOTE.TITLE", defaultText: "Note"), 12)
        ]
        for (title, index) in buttonsConfig {
            let imageName = buttonImageState[index]?.normalImage ?? "" // Use normal image
            let button = createButton(imageName: imageName, title: title)
            button.tag = index // Set button tag to track which view to show
            // Set the initial border color
            button.layer.borderColor = initialBorderColor.cgColor
            
            if index == 0 {
                button.layer.borderColor = CGColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
                button.layer.borderWidth = 2
            } else {
                button.layer.borderWidth = 0
            }
            stackView.addArrangedSubview(button)
        }
    }
    func setupBar() {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .lightGray
        view.addSubview(bar)
        
        NSLayoutConstraint.activate([
            bar.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bar.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    func createButton(imageName: String, title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(scrollButtonTapped(sender:)), for: .touchUpInside)
        
        // Configure button appearance
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        // Use UIButtonConfiguration to manage the layout of the button content
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: imageName)
        config.imagePlacement = .top // Places the image above the title
        config.imagePadding = 5 // Spacing between image and title
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)])) // Set your desired size here
        config.baseForegroundColor = .black // Set title color
        config.titleAlignment = .center
        
        button.configuration = config
        
        return button
    }
    
    // Create views for each button
    func setupViews() {
        stateOfHealthView = MainView(scrollView: scrollView)
              temperatureView = MainView(scrollView: scrollView)
              painView = MainView(scrollView: scrollView)
              liquidView = MainView(scrollView: scrollView)
              diarrheaView = MainView(scrollView: scrollView)
              rashView = MainView(scrollView: scrollView)
              symptomsView = MainView(scrollView: scrollView)
              warningSignsView = MainView(scrollView: scrollView)
              feelingConfidentView = MainView(scrollView: scrollView)
              contactView = MainView(scrollView: scrollView)
              medicationView = MainView(scrollView: scrollView)
              measuresView = MainView(scrollView: scrollView)
              noteView = MainView(scrollView: scrollView)
        views = [stateOfHealthView, temperatureView, painView, liquidView, diarrheaView, rashView, symptomsView, warningSignsView, feelingConfidentView, contactView, medicationView, measuresView, noteView]
        // Initially hide all views except the first one
        for (i, view) in views.enumerated() {
            view.isHidden = true
        }
    }
    @objc func scrollButtonTapped(sender: UIButton) {
        let index = sender.tag // Get the button index
        // Reset border color for all buttons
        for button in stackView.arrangedSubviews as! [UIButton] {
            button.layer.borderColor = initialBorderColor.cgColor
            button.layer.borderWidth = 0
            // Set the button's image to the normal image
            let imageName = buttonImageState[button.tag]?.normalImage ?? ""
            button.setImage(UIImage(named: imageName), for: .normal)
        }
        
        // Change the button's image to the selected image
        let selectedImageName = buttonImageState[sender.tag]?.selectedImage ?? ""
        sender.setImage(UIImage(named: selectedImageName), for: .normal)
        
        currentViewIndex = index // Update the current view index
        currentSubviewIndex = 0
        updateVisibleView()
        
        // Highlight the selected button with a blue border
        sender.layer.borderColor =  CGColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
        sender.layer.borderWidth = 1
        // Automatically scroll to the next button
        scrollToSelectedButton(sender: sender)
    }
    func scrollToSelectedButton(sender: UIButton) {
        // Get the button's frame in the scroll view's coordinate system
        let buttonFrameInScrollView = sender.convert(sender.bounds, to: scrollView)
        
        // Calculate the offset needed to scroll the button into view
        let newOffset = buttonFrameInScrollView.origin.x - (scrollView.frame.width / 2) + (sender.frame.width / 2)
        
        // Ensure we don't scroll beyond the content size
        let maxOffset = scrollView.contentSize.width - scrollView.frame.width
        let finalOffset = min(max(newOffset, 0), maxOffset)
        
        // Scroll to the new offset
        scrollView.setContentOffset(CGPoint(x: finalOffset, y: 0), animated: true)
    }
    //END OF SCROLL VIEW CODE
    // ALL MAIN VIEWS
    // Add Views to the same view hierarchy
    func setupAllMainViews() {
   
        noteView.addSubview(noteFirstView)
        noteView.addSubview(otherNotesView)
        noteView.addSubview(noteDateTime)
        measuresView.addSubview(measuresFirstSubviews)
        measuresView.addSubview(measuresTakenView)
        measuresView.addSubview(otherMeasuresView)
        measuresView.addSubview(measureDateTimeView)
        
        medicationView.addSubview(medicationFirstSubview)
        
        contactView.addSubview(contactWithDoctorFirstSubview)
        contactView.addSubview(contactWithDoctorDateTimeView)
        contactView.addSubview(otherReasonForContactingDoctorView)
        contactView.addSubview(otherReasonsForContactingDoctorView)
        contactView.addSubview(doctorDiagnosisView)
        contactView.addSubview(otherDiagnosisView)
        contactView.addSubview(doctorPrescriptionView)
        contactView.addSubview(otherMedecinePrescribedView)
        contactView.addSubview(otherMeasuresTakenByDoctor)
        feelingConfidentView.addSubview(feelingConfidentFirstView)
        feelingConfidentView.addSubview(feelingConfidentDateTimeView)
        warningSignsView.addSubview(warningSignsFirstSubview)
        warningSignsView.addSubview(warningSignsDateTimeView)
        
        symptomsView.addSubview(symptomsFirstView)
        symptomsView.addSubview(otherSymptompsView)
        symptomsView.addSubview(symptomsDateTimeView)
        rashView.addSubview(rashFirstSubview)
        rashView.addSubview(rashDateTimeView)
        diarrheaView.addSubview(diarrheaFirstView)
        diarrheaView.addSubview(diarrheaDateTimeView)
        liquidView.addSubview(liquidFirstView)
        liquidView.addSubview(liquidDateTimeView)
        temperatureView.addSubview(temperatureFirstView)
        temperatureView.addSubview(temperatureValueDateView)
        temperatureView.addSubview(temperatureValueView)
        temperatureView.addSubview(temperatureLocationView)
        temperatureView.addSubview(TemperatureVaccineView)
        temperatureView.addSubview(temperatureVaccinesListView)
        temperatureView.addSubview(temperatureVaccinesDateView)
        stateOfHealthView.addSubview(stateOfHealthFirstView)
        stateOfHealthView.addSubview(stateOfHealthSecondSubview)

        // SUBVIEWS
       
        painView.addSubview(painLocationView)
        painView.addSubview(otherPainLocationView)
        painView.addSubview(painStrengthView)
        painView.addSubview(painDateTimeView)
        
        // SUBVIEWS END
    }
    // ALL MAIN VIEWS END
    //STATE OF HEALTH VIEW
    func setupStateOfHealthFirstView(){
        stateOfHealthFirstView.translatesAutoresizingMaskIntoConstraints = false
        stateOfHealthFirstView.delegate = stateOfHealthSecondSubview
        // add target for skip button
        stateOfHealthFirstView.skipButtonTapped = {[weak self] in
                self?.currentViewIndex += 1
            self?.currentSubviewIndex = 0
                self?.updateVisibleView()
        }
        //add target for tap on icons
        stateOfHealthFirstView.iconButtonTapped = { [weak self] in
            self?.currentSubviewIndex += 1
            self?.updateVisibleView()
        }
        
       
        stateOfHealthFirstView.displayErrorMessage = {
            let alertController = UIAlertController(title: "Error", message: "Failed to save state of health please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
            NSLayoutConstraint.activate([
                stateOfHealthFirstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stateOfHealthFirstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                stateOfHealthFirstView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
    }
    func passIconImage(){
        stateOfHealthFirstView.passIconImage = {[weak self] iconName in
            guard let self = self else { return }
           stateOfHealthSecondSubview.updateImage(with: iconName)
            
        }
    }
    func setupStateOfHealthSecondView(){
        stateOfHealthSecondSubview.translatesAutoresizingMaskIntoConstraints = false
        //add targets for the confirm button
        stateOfHealthSecondSubview.confirmButtonTap = { [weak self] date in
            self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        // add targets for no answer button
        stateOfHealthSecondSubview.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        stateOfHealthSecondSubview.displayError = {
            let alertController = UIAlertController(title: "Error", message: "Failed to save date please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           
           NSLayoutConstraint.activate([
            stateOfHealthSecondSubview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateOfHealthSecondSubview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateOfHealthSecondSubview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
  
 
    //STATE OF HEALTH SUBVIEW
    //STATE OF HEALTH VIEW END
    //TEMPERATURE VIEW
    
    func setupTemperatureFirstView(){
        temperatureFirstView.translatesAutoresizingMaskIntoConstraints = false
           // add targets for temperatureButtons
        temperatureFirstView.tempButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        temperatureFirstView.displayErrorMessage = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            temperatureFirstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temperatureFirstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            temperatureFirstView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupTemperatureValueView() {
        temperatureValueView.translatesAutoresizingMaskIntoConstraints = false
           // add targets to buttons
        temperatureValueView.handleNextTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        temperatureValueView.handleNoAnswerTap = {
            [weak self] in
                self?.currentSubviewIndex += 2
                self?.updateVisibleView()
        }
        temperatureValueView.displayErrorMessage = { [weak self] message in
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self?.present(alertController, animated: true)
            
        }
           NSLayoutConstraint.activate([
            temperatureValueView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temperatureValueView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            temperatureValueView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupTemperatureValueDateView() {
         temperatureValueDateView.translatesAutoresizingMaskIntoConstraints = false
            // add target for no answer and confirm buttons
        temperatureValueDateView.handleConfirmTap = {
            [weak self] date in
                self?.entryOverallDate = date
            
                self?.currentSubviewIndex += 0
                self?.updateVisibleView()
        }
        temperatureValueDateView.handleNoAnswerTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
           NSLayoutConstraint.activate([
            temperatureValueDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temperatureValueDateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            temperatureValueDateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupTemperatureLocationView(){
           temperatureLocationView.translatesAutoresizingMaskIntoConstraints = false
        // add targets
        temperatureLocationView.handleTempLocationTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        temperatureLocationView.displayErrorMessage = {
            let alertController = UIAlertController(title: "Error", message: "failed to save temperature location please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
               temperatureLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               temperatureLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               temperatureLocationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupTemperatureVaccineView(){
           TemperatureVaccineView.translatesAutoresizingMaskIntoConstraints = false
        // targets
        TemperatureVaccineView.yesButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        TemperatureVaccineView.noButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 3
                self?.updateVisibleView()
        }
        TemperatureVaccineView.skipButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 3
                self?.updateVisibleView()
        }
        TemperatureVaccineView.displayErrorMessage = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            TemperatureVaccineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            TemperatureVaccineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            TemperatureVaccineView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupTemperatureVaccineDateView(){
        temperatureVaccinesDateView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        temperatureVaccinesDateView.confirmTapped = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        temperatureVaccinesDateView.noAnswerTapped = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
           NSLayoutConstraint.activate([
            temperatureVaccinesDateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temperatureVaccinesDateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            temperatureVaccinesDateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupTemperatureVaccinesListView(){
        temperatureVaccinesListView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        temperatureVaccinesListView.doneTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        temperatureVaccinesListView.displayErrorMessage = {
            let alertController = UIAlertController(title: "Error", message: "Failed to save selected vaccine/s please try again!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            temperatureVaccinesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            temperatureVaccinesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            temperatureVaccinesListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    //TEMPERATURE SUBVIEW
    //TEMPERATURE SUBVIEW END
    //TEMPERATURE VIEW END
    //PAIN VIEW
    func setupPainLocationview(){
        painLocationView.translatesAutoresizingMaskIntoConstraints = false
        // add targets
        painLocationView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 4
                self?.updateVisibleView()
        }
        painLocationView.displayErrorMessage = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
        painLocationView.confirmButtonTap = {[weak self] checkedType in
                        guard let self = self else { return }
                        
                        switch checkedType {
                        case "no":
                            currentSubviewIndex += 4
                            updateVisibleView()
                            // Logic for when only the first checkbox is selected
                            print("Checked type is 'no'")
                            // Add your specific actions for "no" here
                            
                        case "yes":
                            currentSubviewIndex += 2
                            updateVisibleView()
                            // Logic for when checkboxes in between are selected
                            print("Checked type is 'yes'")
                            // Add your specific actions for "yes" here
                            
                        case "others":
                            currentSubviewIndex += 1
                            updateVisibleView()
                            // Logic for when the last checkbox or the last checkbox plus others are selected
                            print("Checked type is 'others'")
                            // Add your specific actions for "others" here
                            
                        default:
                            break
                        }
        }
           NSLayoutConstraint.activate([
            painLocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            painLocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            painLocationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupPainStrengthView(){
        painStrengthView.translatesAutoresizingMaskIntoConstraints = false
       // add targets
        painStrengthView.painIconTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        painStrengthView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        painStrengthView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "Failed to save pain strength please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            painStrengthView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            painStrengthView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            painStrengthView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
 
    }
    func setupPainDateTimeView(){
        painDateTimeView.translatesAutoresizingMaskIntoConstraints = false
       // add targets
        painDateTimeView.confirmButtonTap = {
            [weak self] date in
                self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        painDateTimeView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        painDateTimeView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "Failed to save date please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            painDateTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            painDateTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            painDateTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
 
    }
    func setupOtherPainLocationView() {
       otherPainLocationView.translatesAutoresizingMaskIntoConstraints = false
        
        otherPainLocationView.nextButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherPainLocationView.displayErrorMessage = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
               
               NSLayoutConstraint.activate([
                otherPainLocationView.leadingAnchor.constraint(equalTo: contactView.leadingAnchor),
                otherPainLocationView.trailingAnchor.constraint(equalTo: contactView.trailingAnchor),
                otherPainLocationView.bottomAnchor.constraint(equalTo: contactView.bottomAnchor),
                otherPainLocationView.heightAnchor.constraint(equalToConstant: 600)
               ])
    }
   

    //PAIN SUBVIEW
    //PAIN VIEW END
    // LIQUID VIEW
    func setupLiquidFirstView(){
        liquidFirstView.translatesAutoresizingMaskIntoConstraints = false
           // add target
        liquidFirstView.confirmButtonTap = {
            [weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "no":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                // Logic for when only the first checkbox is selected
                                print("Checked type is 'no'")
                                // Add your specific actions for "no" here
                                
                            case "yes":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            default:
                                break
                            }
        }
        liquidFirstView.noAnswerButtonTap = { [weak self] in
            self?.currentSubviewIndex += 1
            self?.updateVisibleView()
        }
        liquidFirstView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            liquidFirstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            liquidFirstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            liquidFirstView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupLiquidDateTimeView() {
        liquidDateTimeView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        liquidDateTimeView.confirmButtonTap = {
            [weak self] date in
                self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        liquidDateTimeView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
           NSLayoutConstraint.activate([
            liquidDateTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            liquidDateTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            liquidDateTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func simulateLiquidButtonTap() {
        // Get the temperature button
        guard let liquidButton = stackView.arrangedSubviews[4] as? UIButton else { return }
        
        // Simulate a tap on the temperature button
        scrollButtonTapped(sender:  liquidButton)
    }
    // LIQUID VIEW END
    //DIAHREA VIE
    func setupDiahreaFirstView(){
        diarrheaFirstView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        diarrheaFirstView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 2
                self?.updateVisibleView()
        }
        diarrheaFirstView.displayError = {  [weak self] message in
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self!.present(alertController, animated: true)
            
        }
        diarrheaFirstView.confirmButtonTap = {
            [weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "no":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                // Logic for when only the first checkbox is selected
                                print("Checked type is 'no'")
                                // Add your specific actions for "no" here
                                
                            case "yes":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            default:
                                break
                            }
        }
           NSLayoutConstraint.activate([
            diarrheaFirstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diarrheaFirstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            diarrheaFirstView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupDiahreaDateTimeView(){
        diarrheaDateTimeView.translatesAutoresizingMaskIntoConstraints = false
           //add targets
        diarrheaDateTimeView.confirmButtonTap = {
            [weak self] date in
                self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        diarrheaDateTimeView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        diarrheaDateTimeView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "failed to save date please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            diarrheaDateTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            diarrheaDateTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            diarrheaDateTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
  // diahreea view
    //RASH VIEW
    func setupRashFirstView(){
        rashFirstSubview.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        rashFirstSubview.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 2
                self?.updateVisibleView()
        }
        rashFirstSubview.confirmButtonTap = {
            [weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "no":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                // Logic for when only the first checkbox is selected
                                print("Checked type is 'no'")
                                // Add your specific actions for "no" here
                                
                            case "yes":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            default:
                                break
                            }
        }
           NSLayoutConstraint.activate([
            rashFirstSubview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rashFirstSubview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rashFirstSubview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupRashDateTimeView(){
      rashDateTimeView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        rashDateTimeView.confirmButtonTap = {
            [weak self] date in
                self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        rashDateTimeView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        rashDateTimeView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "failed to save date please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            rashDateTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rashDateTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rashDateTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    //RASH VIEW END

    //SYMPTOMS VIEW
    func setupSymptomsFirstView(){
       symptomsFirstView.translatesAutoresizingMaskIntoConstraints = false
        // add targets
        symptomsFirstView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 3
                self?.updateVisibleView()
        }
        symptomsFirstView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
        symptomsFirstView.confirmButtonTap = {[weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "no":
                                currentSubviewIndex += 3
                                updateVisibleView()
                                // Logic for when only the first checkbox is selected
                                print("Checked type is 'no'")
                                // Add your specific actions for "no" here
                                
                            case "yes":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                                
                            case "others":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when the last checkbox or the last checkbox plus others are selected
                                print("Checked type is 'others'")
                                // Add your specific actions for "others" here
                                
                            default:
                                break
                            }
            
            
        }
           NSLayoutConstraint.activate([
            symptomsFirstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symptomsFirstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            symptomsFirstView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupOtherSymptomsView() {
        otherSymptompsView.translatesAutoresizingMaskIntoConstraints = false
            // add targets
        otherSymptompsView.nextButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherSymptompsView.confirmButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherSymptompsView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
            NSLayoutConstraint.activate([
                otherSymptompsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                otherSymptompsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                otherSymptompsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
    }
    func setupSymptomsDateTimeView(){
      symptomsDateTimeView.translatesAutoresizingMaskIntoConstraints = false
           //add targets
        symptomsDateTimeView.confirmButtonTap = {
            [weak self] date in
                self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        symptomsDateTimeView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        symptomsDateTimeView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "Failed to save date please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            symptomsDateTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            symptomsDateTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            symptomsDateTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
  
    //SYMPTOMS VIEW  END
    // WARNING SIGNS VIEW
    func setupWarningSignsFirstView(){
      warningSignsFirstSubview.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        warningSignsFirstSubview.confirmButtonTap = {
            [weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "no":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                // Logic for when only the first checkbox is selected
                                print("Checked type is 'no'")
                                // Add your specific actions for "no" here
                                
                            case "yes":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            default:
                                break
                            }
        }
        warningSignsFirstSubview.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 2
                self?.updateVisibleView()
        }
        warningSignsFirstSubview.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            warningSignsFirstSubview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningSignsFirstSubview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            warningSignsFirstSubview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupWarningSignsDateTimeView(){
      warningSignsDateTimeView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        warningSignsDateTimeView.confirmButtonTap = {
            [weak self] date in
                self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        warningSignsDateTimeView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        warningSignsDateTimeView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            warningSignsDateTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            warningSignsDateTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            warningSignsDateTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    // WARNING SIGNS VIEW END
    //FEELING CONFIDENT
    func setupFeelingConfidentFirstView() {
        feelingConfidentFirstView.translatesAutoresizingMaskIntoConstraints = false
           // ADD TARGETS
        feelingConfidentFirstView.checkboxTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        feelingConfidentFirstView.skipButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 2
                self?.updateVisibleView()
        }
        feelingConfidentFirstView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            feelingConfidentFirstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feelingConfidentFirstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feelingConfidentFirstView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupFeelingDateTimeView() {
        feelingConfidentDateTimeView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        feelingConfidentDateTimeView.confirmButtonTap = {
            [weak self] date in
                self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        feelingConfidentDateTimeView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        feelingConfidentDateTimeView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured while saving the date please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            feelingConfidentDateTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feelingConfidentDateTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feelingConfidentDateTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    //FEELING CONFIDENT END

    //CONTACT WITH VIEW
    func setupContactWithDoctorFirstView() {
        contactWithDoctorFirstSubview.translatesAutoresizingMaskIntoConstraints = false
           //add targets
        contactWithDoctorFirstSubview.skipButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 9
                self?.updateVisibleView()
        }
        contactWithDoctorFirstSubview.checkBoxTap = {
            [weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "no":
                                currentSubviewIndex += 9
                                updateVisibleView()
                                
                            case "yes":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            default:
                                break
                            }
        }
        contactWithDoctorFirstSubview.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            contactWithDoctorFirstSubview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactWithDoctorFirstSubview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactWithDoctorFirstSubview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
   
    func setupOtherReasonForContactingDoctorView() {
        otherReasonForContactingDoctorView.translatesAutoresizingMaskIntoConstraints = false
        // add targets
        otherReasonForContactingDoctorView.confirmButtonTap = {
            [weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "yes":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                
                            case "others":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            default:
                                break
                            }
        }
        otherReasonForContactingDoctorView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            otherReasonForContactingDoctorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            otherReasonForContactingDoctorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            otherReasonForContactingDoctorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupOtherMedecinePrescribedView(){
        otherMedecinePrescribedView.translatesAutoresizingMaskIntoConstraints = false
        // add target
        otherMedecinePrescribedView.nextTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherMedecinePrescribedView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
               
               NSLayoutConstraint.activate([
                otherMedecinePrescribedView.leadingAnchor.constraint(equalTo: contactView.leadingAnchor),
                otherMedecinePrescribedView.trailingAnchor.constraint(equalTo: contactView.trailingAnchor),
                otherMedecinePrescribedView.bottomAnchor.constraint(equalTo: contactView.bottomAnchor),
                otherMedecinePrescribedView.heightAnchor.constraint(equalToConstant: 600)
               ])
    }
    func setupOtherReasonsForContactingDoctorView(){
        otherReasonsForContactingDoctorView.translatesAutoresizingMaskIntoConstraints = false
        // add targets
        otherReasonsForContactingDoctorView.handleNextTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherReasonsForContactingDoctorView.handleNoAnswerTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherReasonsForContactingDoctorView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
               NSLayoutConstraint.activate([
                otherReasonsForContactingDoctorView.leadingAnchor.constraint(equalTo: contactView.leadingAnchor),
                otherReasonsForContactingDoctorView.trailingAnchor.constraint(equalTo: contactView.trailingAnchor),
                otherReasonsForContactingDoctorView.bottomAnchor.constraint(equalTo: contactView.bottomAnchor),
                otherReasonsForContactingDoctorView.heightAnchor.constraint(equalToConstant: 600)
               ])
    }
    func setupDoctorDiagnosisView() {
        doctorDiagnosisView.translatesAutoresizingMaskIntoConstraints = false
           // ADD TARGETS
        doctorDiagnosisView.handleNoAnswerTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        doctorDiagnosisView.doneTap = {[weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "yes":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                
                            case "other":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            default:
                                break
                            }
        }
        doctorDiagnosisView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            doctorDiagnosisView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doctorDiagnosisView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doctorDiagnosisView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupOtherDiagnosisView(){
        otherDiagnosisView.translatesAutoresizingMaskIntoConstraints = false
           // ADD TARGETS
        otherDiagnosisView.handleNoAnswerTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherDiagnosisView.handleNextTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherDiagnosisView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            otherDiagnosisView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            otherDiagnosisView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            otherDiagnosisView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])

    }
    func setupDoctorPrescriptionView() {
        doctorPrescriptionView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        doctorPrescriptionView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 2
                self?.updateVisibleView()
        }
        doctorPrescriptionView.confirmButtonTap = {[weak self] checkedType in
                            guard let self = self else { return }
                            
                            switch checkedType {
                            case "no":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                
                            case "yes":
                                currentSubviewIndex += 2
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            case "others":
                                currentSubviewIndex += 1
                                updateVisibleView()
                                // Logic for when checkboxes in between are selected
                                print("Checked type is 'yes'")
                                // Add your specific actions for "yes" here
                            default:
                                break
                            }
        }
        doctorPrescriptionView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            doctorPrescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doctorPrescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doctorPrescriptionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupContactWithDoctorDateTimeView() {
        contactWithDoctorDateTimeView.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        contactWithDoctorDateTimeView.noAnswerTapped = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        contactWithDoctorDateTimeView.confirmTapped = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        contactWithDoctorDateTimeView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            contactWithDoctorDateTimeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactWithDoctorDateTimeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contactWithDoctorDateTimeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }

    func setupOtherMeasuresTakenByDoctor() {
        otherMeasuresTakenByDoctor.translatesAutoresizingMaskIntoConstraints = false
           // add targets
        otherMeasuresTakenByDoctor.handleNextTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherMeasuresTakenByDoctor.handleNoAnswerTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherMeasuresTakenByDoctor.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)

        }
           NSLayoutConstraint.activate([
            otherMeasuresTakenByDoctor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            otherMeasuresTakenByDoctor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            otherMeasuresTakenByDoctor.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }

    //CONTACT WITH END
    //GET MEDICATION VIEW
    func setupMedicationFirstSubview() {
        medicationFirstSubview.translatesAutoresizingMaskIntoConstraints = false
        medicationFirstSubview.noButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 2
                self?.updateVisibleView()
        }
        medicationFirstSubview.yesButtonTap = {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            // Instantiate the navigation controller directly by its Storyboard ID
            if let navigationController = storyboard.instantiateViewController(withIdentifier: "MedicationNavigationController") as? UINavigationController {
                navigationController.modalPresentationStyle = .fullScreen // or .automatic, .overFullScreen, etc.
                self.present(navigationController, animated: true, completion: nil)
            } else {
                print("Error: Could not instantiate navigation controller with identifier 'MedicationNavigationController'")
            }
    
            self.currentSubviewIndex += 2
            self.updateVisibleView()
     
        }
        medicationFirstSubview.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)

        }
           NSLayoutConstraint.activate([
            medicationFirstSubview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            medicationFirstSubview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            medicationFirstSubview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    //GET MEDICATION VIEW END
    //MEASURE VIEW
    func setupMeasuresFirstSubview(){
        measuresFirstSubviews.translatesAutoresizingMaskIntoConstraints = false
        //add targets
        measuresFirstSubviews.yesTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        measuresFirstSubviews.NoTap = {
            [weak self] in
                self?.currentSubviewIndex += 4
                self?.updateVisibleView()
        }
        measuresFirstSubviews.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
               NSLayoutConstraint.activate([
                measuresFirstSubviews.leadingAnchor.constraint(equalTo: symptomsView.leadingAnchor),
                measuresFirstSubviews.trailingAnchor.constraint(equalTo: symptomsView.trailingAnchor),
                measuresFirstSubviews.bottomAnchor.constraint(equalTo: symptomsView.bottomAnchor),
                measuresFirstSubviews.heightAnchor.constraint(equalToConstant: 600)
               ])
    }
    func setupOtherMeasuresView(){
        otherMeasuresView.translatesAutoresizingMaskIntoConstraints = false
        //add targets
        otherMeasuresView.nextTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        otherMeasuresView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
               NSLayoutConstraint.activate([
                otherMeasuresView.leadingAnchor.constraint(equalTo: symptomsView.leadingAnchor),
                otherMeasuresView.trailingAnchor.constraint(equalTo: symptomsView.trailingAnchor),
                otherMeasuresView.bottomAnchor.constraint(equalTo: symptomsView.bottomAnchor),
                otherMeasuresView.heightAnchor.constraint(equalToConstant: 600)
               ])
    }
    func setupMeasureDateTimeView(){
           measureDateTimeView.translatesAutoresizingMaskIntoConstraints = false
        // add targ
        measureDateTimeView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        measureDateTimeView.confirmButtonTap = {
            [weak self] date in
                self?.entryOverallDate = date
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        measureDateTimeView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
               NSLayoutConstraint.activate([
                measureDateTimeView.leadingAnchor.constraint(equalTo: symptomsView.leadingAnchor),
                measureDateTimeView.trailingAnchor.constraint(equalTo: symptomsView.trailingAnchor),
                measureDateTimeView.bottomAnchor.constraint(equalTo: symptomsView.bottomAnchor),
                measureDateTimeView.heightAnchor.constraint(equalToConstant: 600)
               ])
    }
    func setupMeasuresTakenView(){
           measuresTakenView.translatesAutoresizingMaskIntoConstraints = false
        //add targets
        measuresTakenView.noAnswerButtonTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        measuresTakenView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
        measuresTakenView.confirmButtonTap = {[weak self] checkedType in
                                guard let self = self else { return }
                                
                                switch checkedType {
                                case "yes":
                                    currentSubviewIndex += 2
                                    updateVisibleView()
                                    
                                case "others":
                                    currentSubviewIndex += 1
                                    updateVisibleView()
                                    // Logic for when checkboxes in between are selected
                                    print("Checked type is 'yes'")
                                    // Add your specific actions for "yes" here
                                default:
                                    break
                                }
        }
           
           NSLayoutConstraint.activate([
            measuresTakenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            measuresTakenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            measuresTakenView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
  
    //MEASURE VIEW END
    //NOTE VIEW
    func setupNoteFirstView() {
          noteFirstView.translatesAutoresizingMaskIntoConstraints = false
           //
        noteFirstView.handleNoAnswerTap = {
            self.delegate?.didDismissAddEntryController()
            self.dismiss(animated: true)
        }
        noteFirstView.handleNextTap = {
            [weak self] in
                self?.currentSubviewIndex += 1
                self?.updateVisibleView()
        }
        noteFirstView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
           NSLayoutConstraint.activate([
            noteFirstView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteFirstView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteFirstView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    func setupOtherNotesView(){
   otherNotesView.translatesAutoresizingMaskIntoConstraints = false
     //
   otherNotesView.handleNoAnswerTap = {
      [weak self] in
          self?.currentSubviewIndex += 1
          self?.updateVisibleView()
  }
   otherNotesView.handleNextTap = {
       [weak self] in
       if self?.isDateViewsRemoved == true{
           self?.delegate?.didDismissAddEntryController()
           self?.dismiss(animated: true)
       }else{
          
               self?.currentSubviewIndex += 1
               self?.updateVisibleView()
       }
  }
        
        otherNotesView.displayError = {
            let alertController = UIAlertController(title: "Error", message: "An error occured please try again", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "ok", style: .cancel)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }
     NSLayoutConstraint.activate([
        otherNotesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        otherNotesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        otherNotesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
     ])
        
   }
    func setupNoteDateTime() {
          noteDateTime.translatesAutoresizingMaskIntoConstraints = false
        // add targets
        noteDateTime.noAnswerTap = {
            self.delegate?.didDismissAddEntryController()
            self.dismiss(animated: true)
        }
        noteDateTime.confirmTap = {
            [weak self] date in
                self?.entryOverallDate = date
            self?.delegate?.didDismissAddEntryController()
            self?.dismiss(animated: true)
        }
           NSLayoutConstraint.activate([
            noteDateTime.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteDateTime.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteDateTime.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           ])
    }
    //NOTE VIEW END
}
