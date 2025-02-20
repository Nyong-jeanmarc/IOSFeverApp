//
//  feverAppAlarmViews.swift
//  FeverApp ios
//
//  Created by NEW on 24/01/2025.
//

import Foundation
import UIKit


class CustomAlarmBottomSheetViewController: UIViewController {
    // Alarm data
    var selectedDate : Date? = Date()
    var SelectedTime : Date?
    var SelectedStartTime : Date?
    var SelectedEndTime : Date?
    var selectedFrequency : String?
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.1", defaultText: "Reminder")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()

    private let reminderSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(hex: "A8C1F7") // Custom switch color
        return toggle
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.2", defaultText: "Date")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let dateIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "calendar"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let dateButton: UIButton = {
        let button = UIButton(type: .system)
      
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 6
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.darkText, for: .normal) // Set dark font color here
        button.contentHorizontalAlignment = .center
        button.addTarget(nil, action: #selector(dateButtonTapped), for: .touchUpInside) // Add target action
        button.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 button.widthAnchor.constraint(equalToConstant: 135), // Set desired width
                 button.heightAnchor.constraint(equalToConstant: 40)  // Set desired height
             ])
        return button
    }()
    @objc func dateButtonTapped() {
        guard let window = UIApplication.shared.windows.first else { return }

        // Create a dark background view
        let darkerView = UIView(frame: window.bounds)
        darkerView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        darkerView.isUserInteractionEnabled = true // Allow tap gestures if needed
        window.addSubview(darkerView)

        // Add a gesture recognizer to dismiss the darker view if tapped outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissDarkBackground))
   
        darkerView.tag = 999 // Tag for identification and removal later

        // Configure the date picker view
        let datePicker = customDatePickerView()
        datePicker.okButtonTap = {
            print("OK button tapped")
            self.removeDarkBackground()
            datePicker.removeFromSuperview()
        }
        datePicker.cancelButtonTap = {
            print("Cancel button tapped")
            self.removeDarkBackground()
            datePicker.removeFromSuperview()
        }
        datePicker.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(datePicker)

        // Constraints for the date picker
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 30),
            datePicker.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -30),
            datePicker.centerYAnchor.constraint(equalTo: window.centerYAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 450)
        ])
    }

    @objc private func dismissDarkBackground() {
        removeDarkBackground()
    }

    private func removeDarkBackground() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.viewWithTag(999)?.removeFromSuperview() // Remove darker view using its tag
    }

    // objc functions
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        // Fetch the user's selected language
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English

        // Configure the date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy" // Desired format
        dateFormatter.timeZone = TimeZone.current // Use current timezone
        dateFormatter.locale = Locale(identifier: userLanguageCode) // Set locale dynamically
        self.selectedDate = sender.date
        // Format the picked date
        let pickedDate = dateFormatter.string(from: sender.date)
        
        // Update the button title with the formatted date
        dateButton.setTitle(pickedDate, for: .normal)
        dateButton.setTitleColor(.black, for: .normal)
    }

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.3", defaultText: "Time")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private let repeatDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.4", defaultText: "Automatic repeat")
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray // Set the font color to gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let notifDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.21", defaultText: "Notification period")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray // Set the font color to gray
        return label
    }()
    private let timeIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "notification_icon"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let timeButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.darkText, for: .normal) // Set dark font color here
        button.contentHorizontalAlignment = .center
        button.addTarget(nil, action: #selector(showTimePikcer), for: .touchUpInside) // Add target action
        button.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 button.widthAnchor.constraint(equalToConstant: 105), // Set desired width
                 button.heightAnchor.constraint(equalToConstant: 50)  // Set desired height
             ])
        return button
    }()
    @objc func showTimePikcer(_ Sender : UIButton){
       guard let window = UIApplication.shared.windows.first else { return }

          // Dark background
          let darkerView = UIView(frame: window.bounds)
          darkerView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
          window.addSubview(darkerView)

          // Custom Time Picker
          let timePicker = CustomAlarmTimePickerView()
          timePicker.okButtonTap = {date, hour, minute, isAM in
              switch Sender {
              case self.timeButton: self.SelectedTime = date
              case self.notificationStartButton: self.SelectedStartTime = date
              case self.endButton: self.SelectedEndTime = date
              default:
                  break
              }
              self.SelectedTime = date
              print("Time selected: \(hour):\(String(format: "%02d", minute)) \(isAM ? "AM" : "PM")")
              Sender.setTitle("\(hour):\(String(format: "%02d", minute)) \(isAM ? "AM" : "PM")", for: .normal)
              darkerView.removeFromSuperview()
              timePicker.removeFromSuperview()
          }
          timePicker.cancelButtonTap = {
              print("Picker dismissed")
              darkerView.removeFromSuperview()
              timePicker.removeFromSuperview()
          }
          timePicker.translatesAutoresizingMaskIntoConstraints = false
          window.addSubview(timePicker)

          // Layout Constraints
          NSLayoutConstraint.activate([
              timePicker.centerXAnchor.constraint(equalTo: window.centerXAnchor),
              timePicker.centerYAnchor.constraint(equalTo: window.centerYAnchor),
              timePicker.widthAnchor.constraint(equalTo: window.widthAnchor, multiplier: 0.8),
              timePicker.heightAnchor.constraint(equalToConstant: 350)
          ])
    }
    @objc private func dismissTimePicker(_ sender: UIButton) {
          sender.superview?.superview?.removeFromSuperview() // Removes the container view
      }
      
      @objc private func confirmTimeSelection(_ sender: UIButton) {
          // Logic for handling the selected time
          print("OK tapped")
          sender.superview?.superview?.removeFromSuperview() // Removes the container view
      }
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.5", defaultText: "Repeat")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let repeatIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "reload"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let repeatSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(hex: "A8C1F7") // Custom switch color
        return toggle
    }()

   

   

    private let frequencyLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.6", defaultText: "Frequency")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let frequencyIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "restart")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()


    private let frequencyButton: UIButton = {
        let button = UIButton(type: .system)
        // Button appearance
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.0)
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .center
        button.addTarget(nil, action: #selector(showFrequencyPikcer), for: .touchUpInside) // Add target action
        button.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 button.widthAnchor.constraint(equalToConstant: 130), // Set desired width
                 button.heightAnchor.constraint(equalToConstant: 40)  // Set desired height
             ])
        
        return button
    }()
    @objc func showFrequencyPikcer(){
        guard let window = UIApplication.shared.windows.first else { return }

        // Dark background
        let darkerView = UIView(frame: window.bounds)
        darkerView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        window.addSubview(darkerView)

        // Custom Frequency Picker
        let frequencyPicker = CustomFrequencyPickerView()
        frequencyPicker.okButtonTap = { selectedFrequency , index in
            print("Selected Frequency: \(selectedFrequency)")
            // Use the `fromTag` method to get the corresponding enum case
            if let selectedOption = FrequencyOption.fromTag(index) {
                // Save the raw value of the enum case into the variable
                self.selectedFrequency = selectedOption.rawValue
                
                // Print the selected value
                print("Selected Index: \(index)") // Output: "every 2 hours"
            } else {
                print("Invalid index")
            }
            // Create a new attributed string for the updated title
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ]
            let attributedTitle = NSMutableAttributedString(string: selectedFrequency, attributes: titleAttributes)
            
            // Chevron icon as an attachment
            let chevronIcon = NSTextAttachment()
            chevronIcon.image = UIImage(systemName: "chevron.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            chevronIcon.bounds = CGRect(x: 0, y: -2, width: 12, height: 12) // Adjust the size and position of the icon
            let iconString = NSAttributedString(attachment: chevronIcon)
            
            // Combine text and icon
            attributedTitle.append(NSAttributedString(string: " ")) // Add space between text and icon
            attributedTitle.append(iconString)
            
            // Update the button's attributed title
            self.frequencyButton.setAttributedTitle(attributedTitle, for: .normal)
            
            // Remove views
            darkerView.removeFromSuperview()
            frequencyPicker.removeFromSuperview()
        }
        frequencyPicker.cancelButtonTap = {
            print("Picker dismissed")
            darkerView.removeFromSuperview()
            frequencyPicker.removeFromSuperview()
        }
        frequencyPicker.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(frequencyPicker)

        // Layout Constraints
        NSLayoutConstraint.activate([
            frequencyPicker.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            frequencyPicker.centerYAnchor.constraint(equalTo: window.centerYAnchor),
            frequencyPicker.widthAnchor.constraint(equalTo: window.widthAnchor, multiplier: 0.8),
            frequencyPicker.heightAnchor.constraint(equalToConstant: 300)
        ])

    }
    private let notificationPeriodLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.21", defaultText: "Notification period")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let notificationIcon: UIImageView = {
        let imageView =  UIImageView(image: UIImage(systemName: "bell"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let notificationStartButton: UIButton = {
        let button = UIButton(type: .system)
    
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.darkText, for: .normal)
        button.contentHorizontalAlignment = .center
        button.addTarget(nil, action: #selector(showTimePikcer), for: .touchUpInside) // Add target action
        button.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 button.widthAnchor.constraint(equalToConstant: 105), // Set desired width
                 button.heightAnchor.constraint(equalToConstant: 40)  // Set desired height
             ])
        return button
    }()

    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.23", defaultText: "End")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let endIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bell.slash"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let endButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("7:00 PM", for: .normal)
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.darkText, for: .normal)
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(showTimePikcer), for: .touchUpInside) // Add target action
             NSLayoutConstraint.activate([
                 button.widthAnchor.constraint(equalToConstant: 105), // Set desired width
                 button.heightAnchor.constraint(equalToConstant: 40)  // Set desired height
             ])
        return button
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.SAVE", defaultText: "Save"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(hex: "#A8C1F7")
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(saveAlarmData), for: .touchUpInside) // Add target action
        // Add Auto Layout constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40) // Set desired height here
        ])
        return button
    }()
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    func setRepeatOptionsToNil(){
        self.selectedFrequency = nil
        self.SelectedStartTime = nil
        self.SelectedEndTime = nil
    }
    @objc func saveAlarmData(){
        if repeatSwitch.isOn == false{
            setRepeatOptionsToNil()
        }
        print("""
          Saving Alarm Data:
          Reminder Enabled: \(reminderSwitch.isOn)
          Date: \(formattedDate(self.selectedDate))
          Time: \(formattedDate(self.SelectedTime))
          Repeat Enabled: \(repeatSwitch.isOn)
          Frequency: \(self.selectedFrequency)
          Notification Period: \(formattedDate(self.SelectedStartTime))
          End Time: \(formattedDate(self.SelectedEndTime))
          """)
        
        AlarmDataModel.shared.saveAlarmData(
            isReminderEnabled: reminderSwitch.isOn,
            date: self.selectedDate,
            time: self.SelectedTime,
            isRepeatEnabled: repeatSwitch.isOn,
            frequency: self.selectedFrequency,
            notificationPeriod: self.SelectedStartTime,
            endTime: self.SelectedEndTime
        )
        self.dismiss(animated: true)
    }
    private let recommendationLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.24", defaultText: "It is recommended that you measure your child's fever at least three times a day!").replacingOccurrences(of: "<small>", with: "").replacingOccurrences(of: "</small>", with: "")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
  
    private let dividerColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAlarmBottomSheet()
        setupSwitchActions()
    }
    func setAlarmBottomSheet(){
        AlarmDataModel.shared.fetchLocalAlarmData()
        reminderSwitch.isOn = AlarmDataModel.shared.isReminderEnabled ?? true
        repeatSwitch.isOn = AlarmDataModel.shared.isRepeatEnabled ?? true
        reminderSwitchToggled()
        repeatSwitchToggled()
        // Fetch the user's selected language
              let appDelegate = UIApplication.shared.delegate as? AppDelegate
              let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English
        //setup date button
              // Format the current date
              let formatter1 = DateFormatter()
              formatter1.locale = Locale(identifier: userLanguageCode)
              formatter1.dateFormat = "dd MMM, yyyy"
        let currentDate = formatter1.string(from: AlarmDataModel.shared.date ?? Date())

            dateButton.setTitle(currentDate, for: .normal)
        self.selectedDate = AlarmDataModel.shared.date ?? Date()
// setup Time Button
              // Format the current time
              let formatter2 = DateFormatter()
              formatter2.locale = Locale(identifier: userLanguageCode)
              formatter2.dateFormat = "h:mm a"
       
        let currentTime = formatter2.string(from: AlarmDataModel.shared.time ?? Date())
            
             timeButton.setTitle(currentTime, for: .normal)
        self.SelectedTime = AlarmDataModel.shared.date ?? Date()
        // Get the current date
        let calendar = Calendar.current
        let today = Date()
 //setup start time button
        // Set the start time to 7:00 AM
        var startComponents = calendar.dateComponents([.year, .month, .day], from: today)
        startComponents.hour = 7
        startComponents.minute = 0
        let defaultStartTime = calendar.date(from: startComponents)
        // Format the current time
        let formatter3 = DateFormatter()
        formatter3.locale = Locale(identifier: userLanguageCode)
        formatter3.dateFormat = "h:mm a"
 
        let currentStartTime = formatter3.string(from: (AlarmDataModel.shared.notificationPeriod ?? defaultStartTime) ?? Date())
      
       notificationStartButton.setTitle(currentStartTime, for: .normal)
        self.SelectedStartTime = AlarmDataModel.shared.notificationPeriod ?? defaultStartTime
        // Set the end time to 7:00 PM
        var endComponents = calendar.dateComponents([.year, .month, .day], from: today)
        endComponents.hour = 19
        endComponents.minute = 0
        let defaultEndTime = calendar.date(from: endComponents)
        // Format the current time
        let formatter4 = DateFormatter()
        formatter4.locale = Locale(identifier: userLanguageCode)
        formatter4.dateFormat = "h:mm a"
        let currentEndTime = formatter4.string(from: (AlarmDataModel.shared.endTime ?? defaultEndTime) ?? Date())
       endButton.setTitle(currentEndTime, for: .normal)
        self.SelectedEndTime = AlarmDataModel.shared.endTime ?? defaultEndTime
        // setup frequency button
        // Text attributes
        let title = AlarmDataModel.shared.frequency ?? TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.7", defaultText: "Hourly")
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.black.cgColor
        ]
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleAttributes)
        
        // Chevron icon as an attachment
        let chevronIcon = NSTextAttachment()
        chevronIcon.image = UIImage(systemName: "chevron.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        chevronIcon.bounds = CGRect(x: 0, y: -2, width: 12, height: 12) // Adjust the size and position of the icon
        let iconString = NSAttributedString(attachment: chevronIcon)
        
        // Combine text and icon
        attributedTitle.append(NSAttributedString(string: " ")) // Add space between text and icon
        attributedTitle.append(iconString)
        
        // Set the attributed title
     frequencyButton.setAttributedTitle(attributedTitle, for: .normal)
        self.selectedFrequency = title
        
    }
    // Variables to manage sheet detents
       private var bottomSheetDetent: CGFloat = 0.85
    private func setupSwitchActions() {
            reminderSwitch.addTarget(self, action: #selector(reminderSwitchToggled), for: .valueChanged)
            repeatSwitch.addTarget(self, action: #selector(repeatSwitchToggled), for: .valueChanged)
        }
    // MARK: - Switch Actions
       @objc private func reminderSwitchToggled() {
           if !reminderSwitch.isOn {
               repeatSwitch.isOn = false // Turn off repeat if reminder is off
               repeatSwitch.isEnabled = false // Disable repeat switch
               updateBottomSheetDetent(isSmall: true)
               updateUIVisibility(showAll: false, showSaveOnly: false)
               saveAlarmData()
           } else {
               repeatSwitch.isEnabled = true // Enable repeat switch
               updateBottomSheetDetent(isSmall: !repeatSwitch.isOn)
               updateUIVisibility(showAll: false, showSaveOnly: true)
           }
       }

       @objc private func repeatSwitchToggled() {
           if repeatSwitch.isOn && reminderSwitch.isOn{
               updateBottomSheetDetent(isSmall: false)
               updateUIVisibility(showAll: true, showSaveOnly: false)
           } else {
               updateBottomSheetDetent(isSmall: true)
               setRepeatOptionsToNil()
               if reminderSwitch.isOn{
                   updateUIVisibility(showAll: false, showSaveOnly: true)
               }
           }
       }
    // MARK: - UI Visibility Updates
  
    private func updateUIVisibility(showAll: Bool, showSaveOnly: Bool) {
        guard let frequencyStack = frequencyLabel.superview,
              let notificationPeriodStack = notificationPeriodLabel.superview,
              let endStack = endLabel.superview,
              let endNotificationStack = endLabel.superview else { return }

        // Hide/Show individual description labels
        repeatDescriptionLabel.isHidden = !showAll
        notifDescriptionLabel.isHidden = !showAll

        // Hide/Show entire stack views
        let shouldShowSave = showAll || showSaveOnly
        frequencyStack.isHidden = !showAll
        notificationPeriodStack.isHidden = !showAll
        endNotificationStack.isHidden = !showAll
        saveButton.isHidden = !shouldShowSave
        recommendationLabel.isHidden = !showAll
        // Hide all dividers except the first one
        for (index, divider) in dividers.enumerated() {
            divider.isHidden = !(showAll || index == 0) // Keep the first one visible
        }
     
    }
    // MARK: - Bottom Sheet Management
    private func updateBottomSheetDetent(isSmall: Bool) {
        let screenHeight = UIScreen.main.bounds.height
        let isSmallScreen = screenHeight <= 700 // iPhone SE (3rd gen) screen height

        let newDetent: CGFloat = isSmall
            ? (isSmallScreen ? 0.6 : 0.45)
            : (isSmallScreen ? 0.98 : 0.85)
        scrollView.isScrollEnabled = isSmall ? false : true
        if newDetent != bottomSheetDetent {
            bottomSheetDetent = newDetent
            if let sheet = self.sheetPresentationController {
                let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * newDetent
                }
                sheet.detents = [customDetent]
                sheet.prefersGrabberVisible = true
            }
        }
    }
   

    // MARK: - Scroll View Integration
      private let scrollView: UIScrollView = {
          let scrollView = UIScrollView()
          scrollView.translatesAutoresizingMaskIntoConstraints = false
          return scrollView
      }()

      private let contentView: UIView = {
          let view = UIView()
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()

    private func setupUI() {
       
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addSubview(scrollView)
              scrollView.addSubview(contentView)


        let stackView = UIStackView(arrangedSubviews: [
            createHorizontalStack(label: titleLabel, rightElement: reminderSwitch, isTopSpacing: true),
            createHorizontalStack(label: dateLabel, rightElement: dateButton, icon: dateIcon),
            createDivider(),
            createHorizontalStack(label: timeLabel, rightElement: timeButton, icon: timeIcon),
           
            createHorizontalStack(label: repeatLabel, rightElement: repeatSwitch, icon: repeatIcon),
            createDivider(),
            createHorizontalStack(label: frequencyLabel, rightElement: frequencyButton, icon: frequencyIcon),
          
            createHorizontalStack(label: notificationPeriodLabel, rightElement: notificationStartButton, icon: notificationIcon),
            createDivider(),
            createHorizontalStack(label: endLabel, rightElement: endButton, icon: endIcon),
            saveButton,
            recommendationLabel
        ])
        let screenHeight = UIScreen.main.bounds.height
        let isSmallScreen = screenHeight <= 700 // iPhone SE (3rd gen) screen height
        stackView.axis = .vertical
        stackView.spacing = isSmallScreen ? 17 : 22
        stackView.alignment = .fill

        contentView.addSubview(stackView)
        contentView.addSubview(repeatDescriptionLabel)
        contentView.addSubview(notifDescriptionLabel)
      
        stackView.translatesAutoresizingMaskIntoConstraints = false
   

        let stackViewTopConstraint: NSLayoutConstraint
        let stackViewBottomConstraint: NSLayoutConstraint
        if isSmallScreen {
            stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30) // Adjusted for small screens
            stackViewBottomConstraint = stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        } else {
            stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60) // Default for larger screens
            stackViewBottomConstraint = stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        }

        NSLayoutConstraint.activate([
            // ScrollView constraints
                       scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                       scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                       scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                       scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                       // ContentView constraints
                       contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                       contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                       contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                       contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                       contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                       contentView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.85),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                       stackViewTopConstraint,
                       stackViewBottomConstraint,
            repeatDescriptionLabel.bottomAnchor.constraint(equalTo: repeatLabel.topAnchor , constant: -5),
            repeatDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor , constant: 16),
            notifDescriptionLabel.bottomAnchor.constraint(equalTo:  notificationPeriodLabel.topAnchor , constant: -5),
            notifDescriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor , constant: 16)
        ])
    }
  
    private func createHorizontalStack(label: UILabel, rightElement: UIView, icon: UIView? = nil, isTopSpacing: Bool = false) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8

        if let icon = icon {
            stack.addArrangedSubview(icon)
            icon.widthAnchor.constraint(equalToConstant: 24).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 24).isActive = true
          rightElement.heightAnchor.constraint(equalToConstant: 40).isActive = true
          stack.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
        }

        stack.addArrangedSubview(label)
        stack.addArrangedSubview(rightElement)

        return stack
    }
    // Store dividers except for the first one
    private var dividers: [UIView] = []
    private func createDivider() -> UIView {
        let divider = UIView()
        dividers.append(divider)
        divider.backgroundColor = dividerColor
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
      
        return divider
    }
}


class CustomAlarmTimePickerView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // Callbacks for OK and Cancel buttons
    var okButtonTap: ((_ selectedDate: Date?,_ selectedHour: Int, _ selectedMinute: Int, _ isAM: Bool) -> Void)?
    var cancelButtonTap: (() -> Void)?
  
    // Internal state
    private var selectedHour: Int = 1
    private var selectedMinute: Int = 0
    private var isAM: Bool = true

    // UI Components
    private let timeLabel = UILabel()
    private let hourTableView = UITableView()
    private let minuteTableView = UITableView()
    private let amButton = UIButton()
    private let pmButton = UIButton()
    private let okButton = UIButton()
    private let cancelButton = UIButton()

    // Custom Colors
    private let highlightColor = UIColor(hex: "#A8C1F7")
    private let normalColor = UIColor.gray

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Time Label
        timeLabel.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.3", defaultText: "Time")
        timeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        timeLabel.textColor = .black
        addSubview(timeLabel)

        // AM/PM Buttons
        amButton.setTitle("AM", for: .normal)
        amButton.setTitleColor(highlightColor, for: .selected)
        amButton.setTitleColor(normalColor, for: .normal)
        amButton.isSelected = true
        amButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        amButton.addTarget(self, action: #selector(amButtonTapped), for: .touchUpInside)

        pmButton.setTitle("PM", for: .normal)
        pmButton.setTitleColor(highlightColor, for: .selected)
        pmButton.setTitleColor(normalColor, for: .normal)
        pmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        pmButton.addTarget(self, action: #selector(pmButtonTapped), for: .touchUpInside)

        let periodStack = UIStackView(arrangedSubviews: [amButton, pmButton])
        periodStack.axis = .vertical
        periodStack.spacing = 10
        periodStack.alignment = .center
        addSubview(periodStack)

        // Hour Table View
        hourTableView.delegate = self
        hourTableView.dataSource = self
        hourTableView.tag = 0
        hourTableView.separatorStyle = .none
        hourTableView.showsVerticalScrollIndicator = false
        hourTableView.register(UITableViewCell.self, forCellReuseIdentifier: "hourCell")
        addSubview(hourTableView)

        // Minute Table View
        minuteTableView.delegate = self
        minuteTableView.dataSource = self
        minuteTableView.tag = 1
        minuteTableView.separatorStyle = .none
        minuteTableView.showsVerticalScrollIndicator = false
        minuteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "minuteCell")
        addSubview(minuteTableView)

        // OK Button
        okButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.OK", defaultText: "Ok"), for: .normal)
        okButton.setTitleColor(highlightColor, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        addSubview(okButton)

        // Cancel Button
        cancelButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CANCEL", defaultText: "Cancel"), for: .normal)
        cancelButton.setTitleColor(highlightColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addSubview(cancelButton)

        // Layout
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        periodStack.translatesAutoresizingMaskIntoConstraints = false
        hourTableView.translatesAutoresizingMaskIntoConstraints = false
        minuteTableView.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Time Label
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),

            // Hour Table View
            hourTableView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -80),
            hourTableView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            hourTableView.widthAnchor.constraint(equalToConstant: 80),
            hourTableView.heightAnchor.constraint(equalToConstant: 135),

            // Minute Table View
            minuteTableView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 40),
            minuteTableView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            minuteTableView.widthAnchor.constraint(equalToConstant: 80),
            minuteTableView.heightAnchor.constraint(equalToConstant: 135),

            // AM/PM Buttons
            periodStack.centerYAnchor.constraint(equalTo: hourTableView.centerYAnchor),
            periodStack.leadingAnchor.constraint(equalTo: minuteTableView.trailingAnchor, constant: 20),

            // OK Button
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            okButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),

            // Cancel Button
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            cancelButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -10)
        ])
    }

    // MARK: - Button Actions
    @objc private func amButtonTapped() {
        isAM = true
        amButton.isSelected = true
        pmButton.isSelected = false
        updateAMPMHighlight()
    }

    @objc private func pmButtonTapped() {
        isAM = false
        amButton.isSelected = false
        pmButton.isSelected = true
        updateAMPMHighlight()
    }

    private func updateAMPMHighlight() {
        amButton.setTitleColor(isAM ? highlightColor : normalColor, for: .normal)
        pmButton.setTitleColor(isAM ? normalColor : highlightColor, for: .normal)
    }

    @objc private func okButtonTapped() {
        // Create a DateComponents instance with the provided data
        // Set the start time to 7:00 AM
   
        let today = Date()
        // Use the current calendar to create the Date object
        let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: today)
            components.hour = isAM ? selectedHour % 12 : (selectedHour % 12) + 12 // Convert to 24-hour format
            components.minute = selectedMinute
            
          
            let date = calendar.date(from: components) ?? Date() // Use current date as fallback
            
            // Pass the created Date object and other values to the callback
            okButtonTap?(date, selectedHour, selectedMinute, isAM)
    }

    @objc private func cancelButtonTapped() {
        cancelButtonTap?()
    }

    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? 12 : 60 // Hours: 1-12, Minutes: 0-59
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableView.tag == 0 ? "hourCell" : "minuteCell", for: indexPath)
        let value = tableView.tag == 0 ? (indexPath.row + 1) : indexPath.row
        cell.textLabel?.text = String(format: "%02d", value)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textColor = (tableView.tag == 0 && indexPath.row + 1 == selectedHour) || (tableView.tag == 1 && indexPath.row == selectedMinute) ? highlightColor : .black
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            selectedHour = indexPath.row + 1
        } else {
            selectedMinute = indexPath.row
        }
        tableView.reloadData()
    }

    // MARK: - Scrolling Behavior
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestRow(tableView: scrollView as! UITableView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestRow(tableView: scrollView as! UITableView)
    }

    private func scrollToNearestRow(tableView: UITableView) {
        let visibleRows = tableView.indexPathsForVisibleRows?.sorted(by: { $0.row < $1.row }) ?? []
        if visibleRows.isEmpty { return }

        let targetRow = visibleRows[0].row // Always highlight the first visible row
        tableView.scrollToRow(at: IndexPath(row: targetRow, section: 0), at: .top, animated: true)

        if tableView.tag == 0 {
            selectedHour = targetRow + 1
        } else {
            selectedMinute = targetRow
        }
        tableView.reloadData()
    }
}

enum FrequencyOption: String, CaseIterable {
    case everyMinute = "Every minute"
    case hourly = "Hourly"
    case every2Hours = "every 2 hours"
    case every3Hours = "every 3 hours"
    case every4Hours = "every 4 hours"
    case every5Hours = "every 5 hours"
    case every6Hours = "every 6 hours"
    case every7Hours = "every 7 hours"
    case every8Hours = "every 8 hours"
    case every9Hours = "every 9 hours"
    case every10Hours = "every 10 hours"
    case every11Hours = "every 11 hours"
    case every12Hours = "every 12 hours"
    case every24Hours = "every 24 hours"
    case every48Hours = "every 48 hours"
    
    /// Returns the `FrequencyOption` based on the provided integer index.
    static func fromTag(_ index: Int) -> FrequencyOption? {
        let allCases = FrequencyOption.allCases
        guard index >= 0 && index < allCases.count else { return nil }
        return allCases[index]
    }
}


class CustomFrequencyPickerView: UIView, UITableViewDelegate, UITableViewDataSource {

    // Callbacks for actions
    var okButtonTap: ((String, Int) -> Void)?
    var cancelButtonTap: (() -> Void)?
    
    // Data for the frequency options
    private let frequencyOptions = [
        TranslationsViewModel.shared.getAdditionalTranslation(key: "TIME.EVERY.MINUTE", defaultText: "Every minute"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.7", defaultText: "Hourly"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.8", defaultText: "every 2 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.9", defaultText: "every 3 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.10", defaultText: "every 4 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.11", defaultText: "every 5 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.12", defaultText: "every 6 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.13", defaultText: "every 7 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.14", defaultText: "every 8 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.15", defaultText: "every 9 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.16", defaultText: "every 10 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.17", defaultText: "every 11 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.18", defaultText: "every 12 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.19", defaultText: "every 24 hours"),
        TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.20", defaultText: "every 48 hours")
    ]
    private var selectedFrequencyIndex: Int?

    // UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "ALARM.ALARM-SETTINGS.TEXT.6", defaultText: "Frequency")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.CANCEL", defaultText: "Cancel"), for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.OK", defaultText: "Ok"), for: .normal)
        button.setTitleColor(UIColor(hex: "#A8C1F7"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(cancelButton)
        addSubview(okButton)
        
        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FrequencyTableViewCell.self, forCellReuseIdentifier: "FrequencyTableViewCell")
        
        // Layout constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        // Button actions
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    @objc private func cancelTapped() {
        cancelButtonTap?()
    }
    
    @objc private func okTapped() {
        if let selectedFrequencyIndex = selectedFrequencyIndex ,
        let selectedFrequency = selectedFrequency {
            okButtonTap?(selectedFrequency,selectedFrequencyIndex)
        }
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frequencyOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrequencyTableViewCell", for: indexPath) as! FrequencyTableViewCell
        let optionIndex = indexPath.row
        let isSelected = optionIndex == selectedFrequencyIndex
        let optionText = frequencyOptions[indexPath.row]
        cell.configure(with: optionText, isSelected: isSelected)
        return cell
    }
    var selectedFrequency : String?
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFrequencyIndex = indexPath.row
        selectedFrequency = frequencyOptions[indexPath.row]
        tableView.reloadData() // Update selection
    }
}

// MARK: - FrequencyTableViewCell
class FrequencyTableViewCell: UITableViewCell {
    private let label = UILabel()
    private let tickImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        contentView.addSubview(label)
        
        tickImageView.image = UIImage(systemName: "checkmark")
        tickImageView.tintColor = UIColor(hex: "#A8C1F7")
        tickImageView.isHidden = true
        contentView.addSubview(tickImageView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        tickImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            tickImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tickImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, isSelected: Bool) {
        label.text = text
        label.textColor = isSelected ? UIColor(hex: "#A8C1F7") : .black
        tickImageView.isHidden = !isSelected
    }
}

