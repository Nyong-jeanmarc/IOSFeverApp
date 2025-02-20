//
//  secondFeverDocViewController.swift
//  FeverApp ios
//
//  Created by Glory Ngassa  on 18/09/2024.
//

import UIKit

class secondFeverDocViewController:UIViewController,UITextFieldDelegate{
    
    @IBOutlet var topView: UIView!
    @IBOutlet weak var documentTitle: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func doneButtonClick(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Get the managed object context
        let context = (appDelegate).persistentContainer.viewContext
        let profileId = appDelegate.fetchProfileId()
        
        // Create a new FeverCrampsEntity object
        let newFeverCrampsEntity = FeverCrampsEntity(context: context)
        
        // Assign values from UI elements
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        if let dateString = dateButton.titleLabel?.text, let date = dateFormatter.date(from: dateString) {
            newFeverCrampsEntity.feverCrampsDate = date
        }
        
        newFeverCrampsEntity.feverCrampsTime = timeButton.titleLabel?.text
        newFeverCrampsEntity.feverCrampsDescription = descriptionTextField.text
        newFeverCrampsEntity.feverCrampsId = Int64.random(in: 1...Int64.max) // Generate a unique ID
        newFeverCrampsEntity.profileId =  profileId ?? 0
        newFeverCrampsEntity.feverCrampsOnlineId = 0 // Default online ID
        newFeverCrampsEntity.isFeverCrampsSynced = 0 // Not synced initially

        // Save the new entity to Core Data
        do {
            try context.save()
            print("New fever cramps record saved successfully.")
        } catch {
            print("Error saving new fever cramps record: \(error)")
        }
        
        // Get a reference to the storyboard
           let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" if your storyboard name is different
           
           // Instantiate the view controller using its storyboard ID
           let newViewController = storyboard.instantiateViewController(withIdentifier: "documentFeverCrampsViewController")
           
           // Add the new view controller's view as a subview
           self.addChild(newViewController) // Notify the parent-child relationship
           newViewController.view.frame = self.view.bounds // Set the frame to match the current view
           self.view.addSubview(newViewController.view) // Add the new view to the current view
           newViewController.didMove(toParent: self) // Notify the child that it has moved to the parent
       }
    
    // Date UI elements
        let dateLabel: UILabel = {
            let label = UILabel()
            label.text = TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.DATE", defaultText: "Date")
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let dateButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("18 Sep, 2024", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
            return button
        }()
        
        let calendarIcon: UIImageView = {
            let imageView = UIImageView(image: UIImage(systemName: "calendar"))
            imageView.tintColor = .gray
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        // Time UI elements
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "OVERVIEW.TIME", defaultText: "Time")
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let timeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("09:59", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(timeButtonTapped), for: .touchUpInside)
            return button
        }()
        
        let clockIcon: UIImageView = {
            let imageView = UIImageView(image: UIImage(systemName: "clock"))
            imageView.tintColor = .gray
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        // Description elements
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = TranslationsViewModel.shared.getTranslation(key: "SEIZURE.SEIZURE-DIALOG.TEXT.5", defaultText: "Description")
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let descriptionTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = TranslationsViewModel.shared.getTranslation(key: "TEXT_INPUT.PLACEHOLDER", defaultText: "Write here…")
            textField.font = UIFont.systemFont(ofSize: 16)
            textField.borderStyle = .roundedRect
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        
        // Explanation Label
        let explanationLabel: UILabel = {
            let label = UILabel()
            label.text = TranslationsViewModel.shared.getTranslation(key: "SEIZURE.SEIZURE-DIALOG.TEXT.6", defaultText: "Please describe the febrile cramp here. You can also edit the time and date by clicking on it. However, once you have finished the febrile cramp documentation with \"Done\", this entry can no longer be edited. Your entry will also not appear in the overview and graphic. If several members of the family experience febrile cramps, we would like to investigate this further. You can contact us via the website.")
         
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .black
            label.numberOfLines = 0

            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let outerView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // Separators
        let separator1: UIView = {
            let separator = UIView()
            separator.backgroundColor = .lightGray
            separator.translatesAutoresizingMaskIntoConstraints = false
            return separator
        }()
        
        let separator2: UIView = {
            let separator = UIView()
            separator.backgroundColor = .lightGray
            separator.translatesAutoresizingMaskIntoConstraints = false
            return separator
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Set the button's title
                doneButton.setTitle(
                    TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done"),
                    for: .normal
                )
            documentTitle.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.FEVER_SEIZURE", defaultText: "Document fever cramps")
            
            topView.layer.cornerRadius = 20
            topView.layer.masksToBounds = true
            
            // Add all elements to the outer view
            view.addSubview(outerView)
            outerView.addSubview(dateLabel)
            outerView.addSubview(calendarIcon)
            outerView.addSubview(dateButton)
            outerView.addSubview(timeLabel)
            outerView.addSubview(clockIcon)
            outerView.addSubview(timeButton)
            outerView.addSubview(descriptionLabel)
            outerView.addSubview(descriptionTextField)
            outerView.addSubview(explanationLabel)
            outerView.addSubview(separator1)
            outerView.addSubview(separator2)
            
            // Set up constraints for all elements
            setupConstraints()
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
    @objc func backButtonTapped() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "documentFeverCrampsViewController")
        viewController?.modalPresentationStyle = .fullScreen
        self.present(viewController!, animated: true, completion: nil)
    }
        
    
    
        func setupConstraints() {
            NSLayoutConstraint.activate([
                // Outer view constraints
                outerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20),
                outerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                outerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                outerView.bottomAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -220),
                
                // Date Label
                dateLabel.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 40),
                dateLabel.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 50),
                
                // Calendar Icon
                calendarIcon.centerYAnchor.constraint(equalTo: dateButton.centerYAnchor),
                calendarIcon.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 20),
                calendarIcon.widthAnchor.constraint(equalToConstant: 24),
                calendarIcon.heightAnchor.constraint(equalToConstant: 24),
                
                // Date Button
                dateButton.leadingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: 50),
                dateButton.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 30),
                dateButton.heightAnchor.constraint(equalToConstant: 40),
                dateButton.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -20),
                dateButton.widthAnchor.constraint(equalToConstant: 150),
                
                // Separator 1 (below date section)
                separator1.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 10),
                separator1.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 20),
                separator1.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -20),
                separator1.heightAnchor.constraint(equalToConstant: 1),
                
                // Time Label
                timeLabel.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 17),
                timeLabel.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 50),
                
                // Clock Icon
                clockIcon.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 97),
                clockIcon.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 20),
                clockIcon.widthAnchor.constraint(equalToConstant: 24),
                clockIcon.heightAnchor.constraint(equalToConstant: 24),
                
                // Time Button
                timeButton.leadingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: 50),
                timeButton.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 20),
                timeButton.heightAnchor.constraint(equalToConstant: 40),
                timeButton.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -20),
                timeButton.widthAnchor.constraint(equalToConstant: 90),
                
                // Separator 2 (below time section)
                separator2.topAnchor.constraint(equalTo: timeButton.bottomAnchor, constant: 10),
                separator2.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 20),
                separator2.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -20),
                separator2.heightAnchor.constraint(equalToConstant: 1),
                
                // Description Label
                descriptionLabel.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 10),
                descriptionLabel.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 20),
                
                // Description TextField
                descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
                descriptionTextField.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 20),
                descriptionTextField.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -20),
                descriptionTextField.heightAnchor.constraint(equalToConstant: 40),
                
                // Explanation Label
                explanationLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
                explanationLabel.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 20),
                explanationLabel.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -20),
                explanationLabel.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -20)
            ])
        }
        
        @objc func dateButtonTapped() {
            let alert = UIAlertController(title: "Select Date", message: nil, preferredStyle: .actionSheet)
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            
            alert.view.addSubview(datePicker)
            
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50),
                datePicker.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            alert.addAction(UIAlertAction(title: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done"), style: .default, handler: { _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM, yyyy"
                self.dateButton.setTitle(formatter.string(from: datePicker.date), for: .normal)
            }))
            
            alert.addAction(UIAlertAction(title: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CANCEL", defaultText: "Cancel") , style: .cancel, handler: nil))
            
            let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400)
            alert.view.addConstraint(height)
            
            present(alert, animated: true, completion: nil)
        }
        
        @objc func timeButtonTapped() {
            let alert = UIAlertController(title: "Select Time", message: nil, preferredStyle: .actionSheet)
            
            let timePicker = UIDatePicker()
            timePicker.datePickerMode = .time
            timePicker.preferredDatePickerStyle = .wheels
            timePicker.translatesAutoresizingMaskIntoConstraints = false
            
            alert.view.addSubview(timePicker)
            
            NSLayoutConstraint.activate([
                timePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor),
                timePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor),
                timePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50),
                timePicker.heightAnchor.constraint(equalToConstant: 200)
            ])
            
            alert.addAction(UIAlertAction(title: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done"), style: .default, handler: { _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                self.timeButton.setTitle(formatter.string(from: timePicker.date), for: .normal)
            }))
            
            alert.addAction(UIAlertAction(title:TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CANCEL", defaultText: "Cancel"), style: .cancel, handler: nil))
            
            let height: NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400)
            alert.view.addConstraint(height)
            
            present(alert, animated: true, completion: nil)
        }
    }

