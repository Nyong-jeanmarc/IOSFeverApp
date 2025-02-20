//
//  feverReminderViews.swift
//  FeverApp ios
//
//  Created by NEW on 04/02/2025.
//

import Foundation
import UIKit
import CoreData

class PopupView: UIView {
    // Represents the 3-month interval for the response
    enum SurveyInterval: String {
        case threeMonths = "THREE_MONTHS"
        case sixMonths = "SIX_MONTHS"
        case nineMonths = "NINE_MONTHS"
        case twelveMonths = "TWELVE_MONTHS"
        // Function to get enum case from tag
            static func fromTag(_ tag: Int) -> SurveyInterval? {
                let allCases = [threeMonths, sixMonths, nineMonths, twelveMonths]
                return tag >= 0 && tag < allCases.count ? allCases[tag] : nil
            }
    }

    // The user’s response to the fever phase question
    enum FeverPhasesReported: String {
        case noneAtAll = "NONE_AT_ALL"
        case allDocumented = "ALL_DOCUMENTED"
        case notAllDocumented = "NOT_ALL_DOCUMENTED"
        case unknown = "UNKNOWN"

        // Function to get enum case from tag
        static func fromTag(_ tag: Int) -> FeverPhasesReported? {
            let allCases = [noneAtAll, allDocumented, notAllDocumented, unknown]
            return tag >= 0 && tag < allCases.count ? allCases[tag] : nil
        }
    }

    // Indicates whether all phases were documented or not
    enum DocumentationStatus: String {
        case allDocumented = "ALL_DOCUMENTED"
        case notAllDocumented = "NOT_ALL_DOCUMENTED"

        // Function to get enum case from tag
        static func fromTag(_ tag: Int) -> DocumentationStatus? {
            let allCases = [allDocumented, notAllDocumented]
            return tag >= 0 && tag < allCases.count ? allCases[tag] : nil
        }
    }

    // Number of fever phases in the last 3 months, if applicable
    var numberOfFeverPhases: Int?
    var surveyInterval: String?
    var feverPhasesReported: String?
    var documentationStatus: String?
    
    
    
    private let darkerView = UIView()
    private let popupView = UIView()

    private let step1View = UIView()
    private let step2View = UIView()
    private let step3View = UIView()
    private var profiles: [Profile] = []
      private var currentProfileIndex: Int = 0

    init(profiles: [Profile], timeIntervalTag: Int) {
        super.init(frame: .zero)
        self.profiles = profiles
        // Get the corresponding SurveyInterval case from the tag
              if let interval = SurveyInterval.fromTag(timeIntervalTag) {
                  self.surveyInterval = interval.rawValue
              } else {
                  // Handle invalid tag case, if needed (e.g., set a default value or log an error)
                  self.surveyInterval = nil
                  print("Invalid timeIntervalTag: \(timeIntervalTag)")
              }
        
        setupDarkerView()
        setupStep1View()
        setupStep2View()
        setupStep3View()
        showStep(step: 1)
    }
    func resetVariables() {
        numberOfFeverPhases = nil
        feverPhasesReported = nil
        documentationStatus = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupDarkerView() {
        if let window = UIApplication.shared.windows.first {
            darkerView.frame = window.bounds
            darkerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            window.addSubview(darkerView)
        }
    }
    let okButton = UIButton(type: .system)
    private func setupStep1View() {
        configurePopupContainer(for: step1View)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.text = TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EVENTS_OCCURRED.QUESTION", defaultText: "Have your child (children) had any fever phases in the last 3 months?")
        titleLabel.numberOfLines = 0
        step1View.addSubview(titleLabel)
       
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.OK", defaultText: "Ok"), for: .normal)
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        okButton.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        okButton.isEnabled = false
        okButton.layer.cornerRadius = 20
        okButton.addTarget(self, action: #selector(handleStep1ButtonTapped(_:)), for: .touchUpInside)
        step1View.addSubview(okButton)
        let buttonTitles = [TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EVENTS_OCCURRED.OPTION.1", defaultText: "No, none at all"), TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EVENTS_OCCURRED.OPTION.2", defaultText: "Yes, all already documented"), TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EVENTS_OCCURRED.OPTION.3", defaultText: "Yes, not all of it documented."), TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EVENTS_OCCURRED.OPTION.4", defaultText: "I don't know.")]
        addButtons(to: step1View, titles: buttonTitles, action: #selector(handleStep1ButtonTapped(_:)), bottomButton: okButton)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: step1View.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: step1View.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: step1View.trailingAnchor, constant: -16),

            okButton.bottomAnchor.constraint(equalTo: step1View.bottomAnchor, constant: -20),
            okButton.trailingAnchor.constraint(equalTo: step1View.trailingAnchor, constant: -16),
            okButton.widthAnchor.constraint(equalToConstant: 80),
            okButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    
       

      
    }
    let textField = UITextField()
    let feverCountTitleLabel = UILabel()
    let finishButton = UIButton(type: .system)
    private func setupStep2View() {
        configurePopupContainer(for: step2View)
        feverCountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        feverCountTitleLabel.textAlignment = .center
        feverCountTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        feverCountTitleLabel.text = TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EPISODE_COUNT.QUESTION", defaultText: "How many fever phases did {{name}} have in the last 3 months?").replacingOccurrences(of: "{{name}}", with: profiles[currentProfileIndex].profileName!)
        feverCountTitleLabel.numberOfLines = 0
        step2View.addSubview(feverCountTitleLabel)

       
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .darkGray

        // Set the background color
        textField.backgroundColor = UIColor(red: 232/255, green: 227/255, blue: 237/255, alpha: 1.0)

        // Round the corners
        textField.layer.cornerRadius = 3
        textField.layer.masksToBounds = true

        // Remove default border style
        textField.borderStyle = .none
        // Add left padding to placeholder & text
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Add a bottom border
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .black
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        textField.addSubview(bottomBorder)
        // Set keyboard type to number pad
        textField.keyboardType = .numberPad

        // Add a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.DONE", defaultText: "Done"), style: .plain, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)

        // Attach toolbar to text field
        textField.inputAccessoryView = toolbar
       
      
        // Constraints for bottom border
        NSLayoutConstraint.activate([
            bottomBorder.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -5),
            bottomBorder.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 5),
            bottomBorder.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1) // Thin black border
        ])


        textField.placeholder = TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EPISODE_COUNT.PLACEHOLDER", defaultText: "Number of fever phases")
        step2View.addSubview(textField)
      
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.FINISH", defaultText: "Finish"), for: .normal)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        finishButton.isEnabled = false
      
        finishButton.setTitleColor(UIColor.white, for: .normal)
        
        finishButton.backgroundColor = UIColor(white: 0.85, alpha: 1)
        finishButton.layer.cornerRadius = 20
        finishButton.addTarget(self, action: #selector(handleStep2ButtonTapped(_:)), for: .touchUpInside)
        step2View.addSubview(finishButton)


        let buttonTitles = [TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EPISODE_COUNT.ALL_EPISODES_REPORTED", defaultText: "All documented"), TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EPISODE_COUNT.NOT_ALL_EPISODES_REPORTED", defaultText: "Not all of it documented")]
        addButtonsToSecondView(to: step2View, titles: buttonTitles, action: #selector(handleStep2ButtonTapped(_:)), bottomButton: finishButton, field: textField)

        NSLayoutConstraint.activate([
            feverCountTitleLabel.topAnchor.constraint(equalTo: step2View.topAnchor, constant: 20),
            feverCountTitleLabel.leadingAnchor.constraint(equalTo: step2View.leadingAnchor, constant: 16),
            feverCountTitleLabel.trailingAnchor.constraint(equalTo: step2View.trailingAnchor, constant: -16),

            textField.topAnchor.constraint(equalTo: feverCountTitleLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: step2View.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: step2View.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 55),
        
            finishButton.bottomAnchor.constraint(equalTo: step2View.bottomAnchor, constant: -20),
            finishButton.trailingAnchor.constraint(equalTo: step2View.trailingAnchor, constant: -16),
            finishButton.widthAnchor.constraint(equalToConstant: 80),
            finishButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    @objc func doneButtonTapped() {
        textField.resignFirstResponder() // Dismiss the keyboard
    }
    private func setupStep3View() {
        configurePopupContainer(for: step3View)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.text = TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EPISODE_COUNT.THANK_YOU", defaultText: "Vielen Dank für Ihre Rückmeldung!")
        titleLabel.numberOfLines = 0
        step3View.addSubview(titleLabel)
        
        let okButton = UIButton(type: .system)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.OK", defaultText: "Ok"), for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        okButton.backgroundColor = .white
        okButton.setTitleColor(.black, for: .normal)
        okButton.layer.cornerRadius = 8
        okButton.addTarget(self, action: #selector(handleStep3ButtonTapped(_:)), for: .touchUpInside)
        step3View.addSubview(okButton)
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        subtitleLabel.text = TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EPISODE_COUNT.PLEASE_REPORT_MISSING_EPISODES", defaultText: "Bitte tragen Sie die fehlenden Fieberphasen nach.")
        subtitleLabel.numberOfLines = 0
        step3View.addSubview(subtitleLabel)

     

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: step3View.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: step3View.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: step3View.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            subtitleLabel.leadingAnchor.constraint(equalTo: step3View.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: step3View.trailingAnchor, constant: -16),
            subtitleLabel.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -20),
            okButton.bottomAnchor.constraint(equalTo: step3View.bottomAnchor, constant: -20),
            okButton.trailingAnchor.constraint(equalTo: step3View.trailingAnchor, constant: -16),
            okButton.widthAnchor.constraint(equalToConstant: 80),
            okButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func configurePopupContainer(for view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.isHidden = true

        if let window = UIApplication.shared.windows.first {
            window.addSubview(view)

            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: darkerView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: darkerView.centerYAnchor),
                view.widthAnchor.constraint(equalTo: darkerView.widthAnchor, multiplier: 0.85)
            ])
        }
    }

    private func addButtons(to view: UIView, titles: [String], action: Selector, bottomButton: UIButton) {
        var previousButton: UIButton? = nil

        for (i, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.backgroundColor = .white
            button.tag = i
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) // Use buttonTapped method
            button.contentHorizontalAlignment = .right
            button.layer.cornerRadius = 5
            button.setTitleColor(.black, for: .normal)
     
            view.addSubview(button)
            let isFirstButton = previousButton == nil
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                button.heightAnchor.constraint(equalToConstant: 40),
                button.topAnchor.constraint(equalTo: previousButton?.bottomAnchor ?? view.subviews.first(where: { $0 is UILabel })!.bottomAnchor, constant: isFirstButton ? 20 : 5 )
            ])

            previousButton = button
        }

        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -20)
            ])
        }
    }
    private var selectedFeverPhaseReportedButton: UIButton? // Keeps track of the currently selected button
    @objc private func buttonTapped(_ sender: UIButton) {
        // Unhighlight the previously selected button
        if let previouslySelectedButton = selectedFeverPhaseReportedButton {
            previouslySelectedButton.backgroundColor = .white
        }
        okButton.backgroundColor = UIColor(red: 168/255, green: 193/255, blue: 247/255, alpha: 1)
        okButton.isEnabled = true
        // Highlight the tapped button
        sender.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        selectedFeverPhaseReportedButton = sender

        // Get the enum case from the button tag
        if let selectedEnum = FeverPhasesReported.fromTag(sender.tag) {
            self.feverPhasesReported = selectedEnum.rawValue
            print("Selected Enum: \(selectedEnum), Raw Value: \(selectedEnum.rawValue)")
        }
    }
    private func addButtonsToSecondView(to view: UIView, titles: [String], action: Selector, bottomButton: UIButton, field: UITextField) {
        var previousButton: UIButton? = nil

        for (i, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.backgroundColor = .white
            button.tag = i
            button.contentHorizontalAlignment = .right
            button.layer.cornerRadius = 5
            button.setTitleColor(.black, for: .normal)
        
            button.addTarget(self, action: #selector(secondViewButtonTapped(_:)), for: .touchUpInside) // Use secondViewButtonTapped
            view.addSubview(button)
            let isFirstButton = previousButton == nil
            NSLayoutConstraint.activate([
                isFirstButton ? field.bottomAnchor.constraint(equalTo: button.topAnchor , constant: -20) :
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                button.heightAnchor.constraint(equalToConstant: 40),
                button.topAnchor.constraint(equalTo: previousButton?.bottomAnchor ?? view.subviews.first(where: { $0 is UILabel })!.bottomAnchor, constant: isFirstButton ? 20 : 5 )
            ])

            previousButton = button
        }

        if let lastButton = previousButton {
            NSLayoutConstraint.activate([
                lastButton.bottomAnchor.constraint(equalTo: bottomButton.topAnchor, constant: -20)
            ])
        }
    }
    private var selectedDocumentationStatus: UIButton? // Keeps track of the currently selected button
    
    @objc private func secondViewButtonTapped(_ sender: UIButton) {
        // Unhighlight the previously selected button
        if let previouslySelectedButton = selectedDocumentationStatus {
            previouslySelectedButton.backgroundColor = .white
        }

        // Highlight the tapped button
        sender.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        finishButton.backgroundColor = UIColor(red: 168/255, green: 193/255, blue: 247/255, alpha: 1)
        finishButton.isEnabled = true
        selectedDocumentationStatus = sender

        // Get the enum case from the button tag
        if let selectedEnum = DocumentationStatus.fromTag(sender.tag) {
            documentationStatus = selectedEnum.rawValue
            print("Selected Enum: \(selectedEnum), Raw Value: \(selectedEnum.rawValue)")
        }
    }
    private func showStep(step: Int) {
        [step1View, step2View, step3View].forEach { $0.isHidden = true }

        switch step {
        case 1:
            step1View.isHidden = false
        case 2:
            step2View.isHidden = false
        case 3:
            step3View.isHidden = false
        default:
            break
        }
    }

    @objc private func handleStep1ButtonTapped(_ sender: UIButton) {
          guard let buttonText = sender.currentTitle else { return }

          showStep(step: 2)
      }

    func updateTitle(to newTitle: String) {
       feverCountTitleLabel.text = newTitle
    }
      @objc private func handleStep2ButtonTapped(_ sender: UIButton) {
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          self.numberOfFeverPhases = Int(textField.text ?? "")
          
          let (userId, _) = appDelegate.fetchUserData()
          print("""
          ----- Data Summary for \(profiles[currentProfileIndex].profileName ?? "no name")-----
          userId: \(String(describing: userId))
          Number of Fever Phases: \(numberOfFeverPhases ?? 0)
          Survey Interval: \(surveyInterval ?? "Not Set")
          Fever Phases Reported: \(feverPhasesReported ?? "Not Set")
          Documentation Status: \(documentationStatus ?? "Not Set")
          ------------------------
          """)
          let currentDate = Date()
          let formattedDate = formatDateToSurveyString(date: currentDate)
          print("Formatted Date: \(formattedDate)")
          feverReminderNetworkManager.shared.saveFeverPhaseSurvey(
            userId: userId!,
            profileId: profiles[currentProfileIndex].onlineProfileId,
              feverPhasesReported: feverPhasesReported,
              numberOfFeverPhases: numberOfFeverPhases,
              documentationStatus: documentationStatus,
              surveyDate: formattedDate,
              surveyInterval: surveyInterval
          ) { result in
              switch result {
              case .success(let data):
                  if let responseString = String(data: data, encoding: .utf8) {
                      print("Response: \(responseString)")
                  }
              case .failure(let error):
                  print("Error: \(error)")
              }
          }

          currentProfileIndex += 1
        
          if currentProfileIndex < profiles.count {
              // Refresh step2View title label for the next profile
              updateTitle(to: TranslationsViewModel.shared.getTranslation(key: "FLASHBACK.FEVER_EPISODE_COUNT.QUESTION", defaultText: "How many fever phases did {{name}} have in the last 3 months?").replacingOccurrences(of: "{{name}}", with: profiles[currentProfileIndex].profileName!))
              showStep(step: 1)
          } else {
              showStep(step: 3)
          }
      }
    func formatDateToSurveyString(date: Date) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withColonSeparatorInTime]
        return dateFormatter.string(from: date)
    }
    @objc private func handleStep3ButtonTapped(_ sender: UIButton) {
        darkerView.removeFromSuperview()
        step1View.removeFromSuperview()
        step2View.removeFromSuperview()
        step3View.removeFromSuperview()
    }
}



class PopupScheduler {

    static let shared = PopupScheduler()
    private var timer: Timer?

    private init() {}

    func startScheduler() {
        let userDefaults = UserDefaults.standard
        // Remove the value for "firstLaunchDate"
       

        // Save the first launch date if it doesn't exist
           if userDefaults.object(forKey: "firstLaunchDate") == nil {
               userDefaults.set(Date(), forKey: "firstLaunchDate")
           }
           
           // Initialize the last popup shown date if it doesn't exist
           if userDefaults.object(forKey: "lastPopupShownDate") == nil {
               userDefaults.set(Date(), forKey: "lastPopupShownDate")
           }

           schedulePopupIfNeeded()
      
       
    }

    @objc private func schedulePopupIfNeeded() {
        let userDefaults = UserDefaults.standard
          
          // Get the first launch date and last popup shown date
          guard let firstLaunchDate = userDefaults.object(forKey: "firstLaunchDate") as? Date,
                let lastPopupShownDate = userDefaults.object(forKey: "lastPopupShownDate") as? Date else {
              return
          }

          let currentDate = Date()
          let elapsedTimeSinceFirstLaunch = currentDate.timeIntervalSince(firstLaunchDate)
          let elapsedTimeSinceLastPopup = currentDate.timeIntervalSince(lastPopupShownDate)

          // Define the interval duration in seconds (3 months = 3 * 30 * 24 * 60 * 60)
          let intervalDuration: TimeInterval = 60 * 3

          // Check if enough time has passed since the last popup was shown
          if elapsedTimeSinceLastPopup >= intervalDuration {
              // Calculate the timeIntervalTag based on elapsed time since first launch
              let timeIntervalTag = Int(elapsedTimeSinceFirstLaunch / intervalDuration)

              DispatchQueue.main.async {
                  if let topController = UIApplication.shared.windows.first?.rootViewController {
                      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

                      let context = appDelegate.persistentContainer.viewContext
                      let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
                      // Add a predicate to filter profiles with non-nil and non-empty profileName
                      fetchRequest.predicate = NSPredicate(format: "profileName != nil AND profileName != ''")
                      do {
                          let profiles = try context.fetch(fetchRequest)
                          if !profiles.isEmpty {
                              let popup = PopupView(profiles: profiles, timeIntervalTag: timeIntervalTag)
                              if let window = UIApplication.shared.windows.first {
                                  window.addSubview(popup)
                              }

                              // Update the last popup shown date
                              userDefaults.set(currentDate, forKey: "lastPopupShownDate")
                          }
                      } catch {
                          print("Failed to fetch profiles: \(error.localizedDescription)")
                      }
                  }
              }
          }
      
        //

    }
}
