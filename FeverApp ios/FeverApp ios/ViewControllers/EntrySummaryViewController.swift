//
//  EntrySummaryViewController.swift
//  FeverApp ios
//
//  Created by user on 11/8/24.
//

import Foundation
import UIKit
    class EntrySummaryViewController: UIViewController {

        // MARK: - Properties
        var entryInfo: Entry?
        var profileName: String = "Test"

        // MARK: - UI Components
        private let scrollView = UIScrollView()
        private let contentView = UIStackView()

        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.hidesBackButton = true
            setupNavigationBar()
            setupUI()
            displayEntryDetails()
        }

        // MARK: - Navigation Bar Setup
        private func setupNavigationBar() {
            // Set the title directly
            navigationItem.title = TranslationsViewModel.shared.getTranslation(key: "DIARY.ANALYSIS.ANALYSIS-HEADER.HEADING", defaultText: "Summary")

            // Create and configure the navigation bar appearance
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = nil // Remove the shadow line

            // Title text attributes (left-aligned by default when there's a back button or done button)
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]

            // Round the bottom corners of the navigation bar
            navigationController?.navigationBar.layer.cornerRadius = 12
            navigationController?.navigationBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            navigationController?.navigationBar.layer.masksToBounds = true

            // Set the appearance for the navigation bar
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance

            // Ensure the navigation bar is visible
            navigationController?.isNavigationBarHidden = false

            // Add the Done button on the right side
            let doneButton = UIBarButtonItem(title: TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done"), style: .done, target: self, action: #selector(doneButtonTapped))
            navigationItem.rightBarButtonItem = doneButton
        }


        @objc private func doneButtonTapped() {
            dismiss(animated: true, completion: nil)
        }

        // MARK: - UI Setup
        private func setupUI() {
            // Set the background color
            view.backgroundColor = .systemBackground
            scrollView.backgroundColor = .systemGray6

            // Configure scroll view
            scrollView.contentInsetAdjustmentBehavior = .always
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(scrollView)

            // Configure content view
            contentView.axis = .vertical
            contentView.spacing = 16
            contentView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(contentView)

            // Define padding (margins)
            let horizontalPadding: CGFloat = 26
            let verticalPadding: CGFloat = 32

            // Setup constraints with padding
            NSLayoutConstraint.activate([
                // Scroll view constraints
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                // Content view constraints with padding
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: verticalPadding),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: horizontalPadding),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -horizontalPadding),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -verticalPadding),

                // Content view width constraint to prevent horizontal scrolling
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -(horizontalPadding * 2))
            ])
        }

    
    // MARK: - Display Entry Details
    private func displayEntryDetails() {
        // Fetch the current selected language from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, currentLanguage) = appDelegate.fetchUserLanguage()
            // Add Date and Time Header
            if let entryInfo = entryInfo {
                addDateTimeHeader(entryInfoResponse: entryInfo, languageCode: languageCode!)
            }
            // Add Warning Message
            addWarningMessage()

            // Add Summary Header
            addSummaryHeader()
            //display text under "Summary"
            addSummaryText()
        
//            if let stateOfHealth = entryInfo?.stateOfHealth {
//                addStateOfHealthCard(state: stateOfHealth.stateOfHealth)
//            }
        if let stateOfHealth = entryInfo?.stateOfHealth {
            if !stateOfHealth.stateOfHealth.isEmpty {
                addStateOfHealthCard(state: stateOfHealth.stateOfHealth)
            }
        }
//            if let temperature = entryInfo?.temperature {
//                addTemperatureCard(temperature: temperature)
//            }
        if let temperature = entryInfo?.temperature {
            // Check if at least one relevant field has a value
            let hasValidFields = !(temperature.temperatureComparedToForehead.isEmpty ?? true) ||
                                 !(temperature.temperatureMeasurementLocation.isEmpty ?? true) ||
                                 !(temperature.temperatureMeasurementUnit?.isEmpty ?? true) ||
                                 temperature.temperatureValue != 0 ||
                                 !(temperature.wayOfDealingWithTemperature.isEmpty ?? true)

            if hasValidFields {
                // At least one field is valid, add the temperature card
                addTemperatureCard(temperature: temperature)
            }
        }



//            if let pain = entryInfo?.pains{
//                addPainCard(pain: pain)
//            }
        if let pain = entryInfo?.pains {
            // Check if at least one relevant field has a value
            let hasValidFields = !(pain.otherPlaces.isEmpty ?? true) ||
                                 !(pain.painSeverityScale.isEmpty ?? true) ||
            !(pain.painValue.isEmpty ?? true)
            if hasValidFields {
                // At least one field is valid, add the pain card
                addPainCard(pain: pain)
            }
        }

//            if let liquids = entryInfo?.liquids {
//                addLiquidsCard(liquids: liquids)
//            }
        
        if let liquids = entryInfo?.liquids {
            // Check if at least one relevant field has a value
            let hasValidFields = !(liquids.dehydrationSigns.isEmpty ?? true)

            if hasValidFields {
                // At least one field is valid, add the liquids card
                addLiquidsCard(liquids: liquids)
            }
        }




//            if let diarrhea = entryInfo?.diarrhea{
//                addDiarrheaCard(diarrhea: diarrhea)
//            }
        
        if let diarrhea = entryInfo?.diarrhea {
            // Check if at least one relevant field has a value
            let hasValidFields = !(diarrhea.diarrheaAndOrVomiting.isEmpty ?? true)

            if hasValidFields {
                // At least one field is valid, add the diarrhea card
                addDiarrheaCard(diarrhea: diarrhea)
            }
        }

        
//        if let rash = entryInfo?.rash {
//            addRashCard(rash: rash)
//        }
        
        if let rash = entryInfo?.rash {
            // Check if the relevant field has a value
            let hasValidFields = !(rash.rashes.isEmpty ?? true)

            if hasValidFields {
                // Field is valid, add the rash card
                addRashCard(rash: rash)
            }
        }

        
//        if let symptoms = entryInfo?.symptoms {
//            addSymptomsCard(symptoms: symptoms)
//        }
        
        if let symptoms = entryInfo?.symptoms {
            // Check if at least one relevant field has a value
            let hasValidFields = !(symptoms.symptoms.isEmpty ?? true) ||
                                 !(symptoms.otherSymptoms?.isEmpty ?? true)

            if hasValidFields {
                // At least one field is valid, add the symptoms card
                addSymptomsCard(symptoms: symptoms)
            }
        }

//        if let warningSigns = entryInfo?.warningSigns {
//            addWarningSignsCard(warningSigns: warningSigns)
//        }
        
        if let warningSigns = entryInfo?.warningSigns {
            // Check if the relevant field has a value
            let hasValidFields = !(warningSigns.warningSigns.isEmpty ?? true)

            if hasValidFields {
                // Field is valid, add the warning signs card
                addWarningSignsCard(warningSigns: warningSigns)
            }
        }

//            if let confidenceLevel = entryInfo?.confidenceLevel?.confidenceLevel {
//                addConfidenceCard(confidenceLevel: confidenceLevel)
//            }
        
        if let confidenceLevel = entryInfo?.confidenceLevel?.confidenceLevel {
            // Check if the relevant field has a value
            let hasValidFields = !(confidenceLevel.isEmpty ?? true)

            if hasValidFields {
                // Field is valid, add the confidence card
                addConfidenceCard(confidenceLevel: confidenceLevel)
            }
        }

//            if let contact = entryInfo?.contactWithDoctor {
//                addContactWithDoctorCard(contactInfo: contact, languageCode: languageCode!)
//            }
        
        if let contact = entryInfo?.contactWithDoctor {
            // Check if at least one relevant field has a value
            let hasValidFields = !(contact.doctorDiagnoses.isEmpty ?? true) ||
                                 !(contact.doctorsPrescriptionsIssued.isEmpty ?? true) ||
                                 !(contact.doctorsRecommendationMeasures?.isEmpty ?? true) ||
                                 !(contact.hasHadMedicalContact.isEmpty ?? true) ||
            !(contact.otherDiagnosis.isEmpty ?? true) ||
                                 !(contact.otherPrescriptionsIssued?.isEmpty ?? true) ||
                                 !(contact.otherReasonForContact?.isEmpty ?? true) ||
            !(contact.reasonForContact.isEmpty ?? true)

            if hasValidFields {
                // At least one field is valid, add the contact with doctor card
                addContactWithDoctorCard(contactInfo: contact, languageCode: languageCode!)
            }
        }

//            if let medications = entryInfo?.medications {
//                addMedicationCard(medications: medications)
//            }
        
        if let medications = entryInfo?.medications {
            // Check if at least one relevant field has a value
            let hasValidFields = !(medications.hasTakenMedications?.isEmpty ?? true) ||
                                 !(medications.medicationList?.isEmpty ?? true)

            if hasValidFields {
                // At least one field is valid, add the medication card
                addMedicationCard(medications: medications)
            }
        }

//            if let measures = entryInfo?.measures {
//                addMeasuresCard(measuresInfo: measures)
//            }
        
        if let measures = entryInfo?.measures {
            // Check if at least one relevant field has a value
            let hasValidFields = !(measures.measures.isEmpty ?? true) ||
            !(measures.takeMeasures.isEmpty ?? true) ||
                                 !(measures.otherMeasures?.isEmpty ?? true)

            if hasValidFields {
                // At least one field is valid, add the measures card
                addMeasuresCard(measuresInfo: measures)
            }
        }

//            if let notes = entryInfo?.notes {
//                addNotesCard(notes: notes)
//            }
        if let notes = entryInfo?.notes {
            // Check if at least one relevant field has a value
            let hasValidFields = !(notes.notesContent.isEmpty ?? true) ||
            !(notes.notesOtherContent.isEmpty ?? true)

            if hasValidFields {
                // At least one field is valid, add the notes card
                addNotesCard(notes: notes)
            }
        }

            
            // Add Footer Text
            addFooterText()
        }
        
        // MARK: - Card Creation Methods
        
        private func addStateOfHealthCard(state: String) {
            let cardView = createCardView(title: TranslationsViewModel.shared.getTranslation(
                key: "DIARY.WELLBEING.TITLE",
                defaultText: "State of health"
            ), iconName: getHealthIcon(state: state), iconColor: getHealthColor(state: state))
            let message: String
            let hintText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.HINT.0.TEXT",
                defaultText: "If {{name}} does not feel well, you should seek medical advice."
            ).replacingOccurrences(of: "{{name}}", with: profileName)

            // Determine the message based on the state
            switch state {
            case "VERY_SICK":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.0.TEXT",
                    defaultText: "{{name}} feels very unwell"
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            case "UNWELL":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.1.TEXT",
                    defaultText: "{{name}} feels unwell"
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            case "NEUTRAL":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.2.TEXT",
                    defaultText: "{{name}} feels neither well nor unwell"
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            case "FINE":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.3.TEXT",
                    defaultText: "{{name}} feels fine"
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            case "EXCELLENT":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.4.TEXT",
                    defaultText: "{{name}} feels very well"
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            default:
                message = "\(profileName)'s health status is unknown"
            }

            // Add the main message text
            addText(to: cardView, text: message)

            // Add the hint text (italic style)
            let hintLabel = UILabel()
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.lineSpacing = 4

            let hintAttributedText = NSAttributedString(
                string: hintText,
                attributes: [
                    .font: UIFont.italicSystemFont(ofSize: 13),
                    .foregroundColor: UIColor.gray,
                    .paragraphStyle: paragraphStyle
                ]
            )

            hintLabel.attributedText = hintAttributedText
            hintLabel.numberOfLines = 0
            hintLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the main message text
            addText(to: cardView, text: hintText,  font: UIFont.italicSystemFont(ofSize: 13))

            // Add the card and hint label to the content view
            contentView.addArrangedSubview(cardView)
//            contentView.addArrangedSubview(hintLabel)
        }

        private func getHealthIcon(state: String) -> String {
            switch state {
            case "UNWELL":
                return ("unwell_icon")
            case "FINE":
                return ("fine")
            case "NEUTRAL":
                return ("neutral1")
            case "EXCELLENT":
                return ("excellent")
            case "VERY_SICK":
                return ("sad")
            default:
                return ("fever_app_logo")
            }
            }
        

        private func getHealthColor(state: String) -> UIColor {
            switch state {
            case "EXCELLENT": return UIColor(red: 117/255, green: 166/255, blue: 119/255, alpha: 1.0) // #75A677
            case "FINE": return UIColor(red: 121/255, green: 206/255, blue: 125/255, alpha: 1.0) // #79CE7D
            case "NEUTRAL": return UIColor(red: 241/255, green: 199/255, blue: 137/255, alpha: 1.0) // #F1C789
            case "UNWELL": return UIColor(red: 219/255, green: 153/255, blue: 173/255, alpha: 1.0) // #DB99AD
            case "VERY_SICK": return UIColor(red: 225/255, green: 154/255, blue: 154/255, alpha: 1.0) // #E19A9A
            default: return UIColor.gray
            }
        }

        private func addTemperatureCard(temperature: Temperature) {
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TITLE",
                    defaultText: "Temperature"
                ),
                iconName: "temperature_icon",
                iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
            )

            let temperatureValue = temperature.temperatureValue
            var temperatureText: String
            var extremitiesText: String = ""
            var hintMessage: String = ""
            var locationText: String = ""

            // Temperature analysis
            switch temperatureValue {
            case 36.1...37.2:
                temperatureText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE.ANALYSIS.HINT.1.TEXT",
                    defaultText: "{{name}} has a normal temperature."
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            case 37.3...37.9:
                temperatureText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE.ANALYSIS.HINT.2.TEXT",
                    defaultText: "{{name}} has a raised temperature. Please measure again in 2 hours."
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            case 38.0...38.9:
                temperatureText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE.ANALYSIS.HINT.3.TEXT",
                    defaultText: "{{name}} has a fever. This is mostly a positive defence reaction."
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            case 39.0...40.0:
                temperatureText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE.ANALYSIS.HINT.4.TEXT",
                    defaultText: "{{name}} has a high fever. Stay with your child."
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            case let value where value > 40.0:
                temperatureText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE.ANALYSIS.HINT.5.TEXT",
                    defaultText: "{{name}} has a very high fever. Seek medical advice."
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            default:
                temperatureText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE.ANALYSIS.HINT.UNKNOWN",
                    defaultText: "Temperature information is not available."
                )
            }

            // Extremities analysis
            switch temperature.temperatureComparedToForehead {
            case "EQUALLY_WARM_OR_WARMER_HANDS_AND_FEET":
                extremitiesText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.OPTION.1.DISPLAYLABEL",
                    defaultText: "equally warm or warmer hands and/or feet"
                )
                hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.ANALYSIS.HINT.0.TEXT",
                    defaultText: "Your child's body is not trying to change its temperature or is cooling down by releasing heat through the limbs."
                )

            case "COOLER_HANDS_AND_FEET":
                extremitiesText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.OPTION.2.DISPLAYLABEL",
                    defaultText: "cooler hands and/or cooler feet"
                )
                hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.ANALYSIS.HINT.1.TEXT",
                    defaultText: "{{name}} is probably trying to raise the body temperature further by reducing blood circulation in the hands and feet."
                ).replacingOccurrences(of: "{{name}}", with: profileName)

            default:
                extremitiesText = "?"
                hintMessage = ""
            }

            // Location analysis
            switch temperature.temperatureMeasurementLocation {
            case "IN_THE_RECTUM":
                locationText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.1.LABEL",
                    defaultText: "Place: In the rectum"
                )

            case "IN_THE_EAR":
                locationText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.2.LABEL",
                    defaultText: "Place: In the ear"
                )

            case "IN_THE_MOUTH":
                locationText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.3.LABEL",
                    defaultText: "Place: In the mouth"
                )

            case "ON_THE_FOREHEAD":
                locationText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.4.LABEL",
                    defaultText: "Place: On the forehead"
                )

            case "UNDER_THE_ARM":
                locationText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.5.LABEL",
                    defaultText: "Place: Under the arm"
                )

            default:
                locationText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.UNKNOWN",
                    defaultText: "Place: ?"
                )
            }

            // Add formatted text components to the card
            addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.DISPLAY",
                defaultText: "Limbs: {{value}}"
            ).replacingOccurrences(of: "{{value}}", with: extremitiesText))

            addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 12))
            addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                key: "DIARY.TEMPERATURE.TEMPERATURE.DISPLAY",
                defaultText: "Temperature: {{value}} °C"
            ).replacingOccurrences(of: "{{value}}", with: String(format: "%.1f°C", temperatureValue)))

            addText(to: cardView, text: temperatureText, font: UIFont.italicSystemFont(ofSize: 12))

            addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                key: "DIARY.TEMPERATURE.TEMPERATURE.ANALYSIS.HINT.6.TEXT",
                defaultText: "If your child is not yet 4 months old, check temperatures above 38°C/100.4°F and seek medical advice."
            ), font: UIFont.italicSystemFont(ofSize: 12))

            addText(to: cardView, text: locationText)

            // Add the temperature card to the content view
            contentView.addArrangedSubview(cardView)
        }

        private func addPainCard(pain: Pains) {
            // Determine icon color and severity text based on pain severity scale
            let iconColor: UIColor
            let severityText: String

            switch pain.painSeverityScale {
            case "ONE":
                iconColor = UIColor(red: 75/255, green: 1/255, blue: 1/255, alpha: 1.0) // Dark red
                severityText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.4",
                    defaultText: "Strong pain"
                )
            case "TWO":
                iconColor = UIColor(red: 121/255, green: 0/255, blue: 0/255, alpha: 1.0) // Red
                severityText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.3",
                    defaultText: "Fairly strong pain"
                )
            case "THREE":
                iconColor = UIColor(red: 187/255, green: 4/255, blue: 4/255, alpha: 1.0) // Bright red
                severityText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.2",
                    defaultText: "Moderate pain"
                )
            case "FOUR":
                iconColor = UIColor(red: 238/255, green: 58/255, blue: 58/255, alpha: 1.0) // Light red
                severityText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.1",
                    defaultText: "Fairly light pain"
                )
            case "FIVE":
                iconColor = UIColor(red: 245/255, green: 135/255, blue: 135/255, alpha: 1.0) // Very light red
                severityText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.0",
                    defaultText: "Light pain"
                )
            default:
                iconColor = UIColor.gray
                severityText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN_INTENSITY.UNKNOWN",
                    defaultText: "Unknown pain severity"
                )
            }

            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.TITLE",
                    defaultText: "Pain"
                ),
                iconName: "power_icon",
                iconColor: iconColor
            )

            // Pain value analysis
            let painValue = pain.painValue
            var painAreas = [String]()

            if painValue.contains("NO") {
                painAreas.append(
                    TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.PAIN.PAIN.OPTION.1.DISPLAYLABEL",
                        defaultText: "No pains"
                    )
                )
            } else {
                if painValue.contains("YES_IN_LIMBS") {
                    painAreas.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.PAIN.PAIN.OPTION.2.DISPLAYLABEL",
                            defaultText: "Limb pain"
                        )
                    )
                }
                if painValue.contains("YES_IN_HEAD") {
                    painAreas.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.PAIN.PAIN.OPTION.3.DISPLAYLABEL",
                            defaultText: "Pains in the head"
                        )
                    )
                }
                if painValue.contains("YES_IN_NECK") {
                    painAreas.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.PAIN.PAIN.OPTION.4.DISPLAYLABEL",
                            defaultText: "Pains in the neck"
                        )
                    )
                }
                if painValue.contains("YES_IN_EARS") {
                    painAreas.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.PAIN.PAIN.OPTION.5.DISPLAYLABEL",
                            defaultText: "Pains in the ears"
                        )
                    )
                }
                if painValue.contains("YES_IN_STOMACH") {
                    painAreas.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.PAIN.PAIN.OPTION.6.DISPLAYLABEL",
                            defaultText: "Pains in the stomach"
                        )
                    )
                }
                if painValue.contains("YES_SOMEWHERE_ELSE") {
                    painAreas.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.PAIN.PAIN.OPTION.7.DISPLAYLABEL",
                            defaultText: "Pains somewhere else: {{value}}"
                        ).replacingOccurrences(of: "{{value}}", with: pain.otherPlaces ?? "")
                    )
                }
            }

            // Add pain areas to the card
            if !painAreas.isEmpty {
                addText(to: cardView, text: painAreas.joined(separator: ", "))
            }

            // Hint messages
            if painValue.contains("NO") {
                addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.ANALYSIS.HINT.0.TEXT",
                    defaultText: "{{name}} has no pains."
                ).replacingOccurrences(of: "{{name}}", with: profileName), font: UIFont.italicSystemFont(ofSize: 13))
            }
            if painValue.contains("YES_IN_LIMBS") {
                addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.ANALYSIS.HINT.1.TEXT",
                    defaultText: "If the pain in the limbs persists for 3 days or more, or increases rapidly, seek medical advice."
                ), font: UIFont.italicSystemFont(ofSize: 13))
            }
            if painValue.contains("YES_IN_NECK") {
                addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.ANALYSIS.HINT.2.TEXT",
                    defaultText: "If the sore throat continues for 3 days or more and worsens, seek medical advice."
                ), font: UIFont.italicSystemFont(ofSize: 13))
            }
            if painValue.contains("YES_IN_EARS") {
                addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.ANALYSIS.HINT.3.TEXT",
                    defaultText: "If the earache persists for 3 days or more, seek medical advice."
                ), font: UIFont.italicSystemFont(ofSize: 13))
            }
            if painValue.contains("YES_IN_STOMACH") {
                addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.ANALYSIS.HINT.4.TEXT",
                    defaultText: "If your child has severe abdominal pain and fever, seek medical advice as appendicitis may be present."
                ), font: UIFont.italicSystemFont(ofSize: 13))
            }
            if painValue.contains("YES_SOMEWHERE_ELSE") {
                addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN_OTHER.DISPLAY",
                    defaultText: "Pain in other unspecified areas."
                ), font: UIFont.italicSystemFont(ofSize: 13))
            }

            // Add severity text to the card
            addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                key: "DIARY.PAIN.PAIN_INTENSITY.DISPLAY",
                defaultText: "Strength: {{value}}"
            ).replacingOccurrences(of: "{{value}}", with: severityText))

            // Add the Pain card to the content view
            contentView.addArrangedSubview(cardView)
        }

        
//        private func addLiquidsCard(liquids: Liquids) {
//            // Create the Liquids card view
//            let cardView = createCardView(title: "Liquids", iconName: "dropwater_icon", iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0))
//
//            // Determine dehydration signs
//            let dehydrationSigns = liquids.dehydrationSigns
//            var liquidResponses = [String]()
//
//            if dehydrationSigns.contains("NO") {
//                // No signs of dehydration
//                liquidResponses.append("No signs of dehydration")
//            } else {
//                // Check for specific dehydration signs
//                if dehydrationSigns.contains("YES_DRY_MUCOUS_MEMBRANES") {
//                    liquidResponses.append("dry mucous membranes")
//                }
//                if dehydrationSigns.contains("YES_DRY_SKIN") {
//                    liquidResponses.append("Skin dry and flabby")
//                }
//                if dehydrationSigns.contains("YES_TIRED_APPEARANCE") {
//                    liquidResponses.append("tired")
//                }
//                if dehydrationSigns.contains("YES_SUNKEN_EYE_SOCKETS") {
//                    liquidResponses.append("sunken eye sockets")
//                }
//                if dehydrationSigns.contains("YES_FEWER_WET_DIAPERS") {
//                    liquidResponses.append("fewer wet diapers")
//                }
//                if dehydrationSigns.contains("YES_SUNKEN_FONTANELLE") {
//                    liquidResponses.append("Fontanelle is sunken")
//                }
//            }
//
//            // Display dehydration status text
//            let dehydrationText = liquidResponses.joined(separator: ", ")
//            addText(to: cardView, text: "Dehydration: \(dehydrationText)")
//
//            // Hint message for no signs of dehydration
//            if dehydrationSigns.contains("NO") {
//                let noDehydrationHint = "\(profileName) shows no signs of dehydration. This is a good sign. Continue to provide fluids in frequent small amounts. Warmed fluids are often better accepted."
//                addText(to: cardView, text: noDehydrationHint, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            // Hint message for signs of dehydration
//            if !dehydrationSigns.contains("NO") && !liquidResponses.isEmpty {
//                let dehydrationHint = "\(profileName) shows signs of dehydration. Please try to frequently offer liquids in small quantities. Warmed fluids are often better accepted. Please seek medical advice."
//                addText(to: cardView, text: dehydrationHint, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            // Add the Liquids card to the content view
//            contentView.addArrangedSubview(cardView)
//        }
        
        private func addLiquidsCard(liquids: Liquids) {
            // Create the Liquids card view
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.TITLE",
                    defaultText: "Liquids"
                ),
                iconName: "dropwater_icon",
                iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
            )

            // Determine dehydration signs
            let dehydrationSigns = liquids.dehydrationSigns
            var liquidResponses = [String]()

            if dehydrationSigns.contains("NO") {
                // No signs of dehydration
                liquidResponses.append(
                    TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DRINK.DRINK.OPTION.1.DISPLAYLABEL",
                        defaultText: "No signs of dehydration"
                    )
                )
            } else {
                // Check for specific dehydration signs
                if dehydrationSigns.contains("YES_DRY_MUCOUS_MEMBRANES") {
                    liquidResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.DRINK.DRINK.OPTION.2.DISPLAYLABEL",
                            defaultText: "Dry mucous membranes"
                        )
                    )
                }
                if dehydrationSigns.contains("YES_DRY_SKIN") {
                    liquidResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.DRINK.DRINK.OPTION.3.DISPLAYLABEL",
                            defaultText: "Skin dry and flabby"
                        )
                    )
                }
                if dehydrationSigns.contains("YES_TIRED_APPEARANCE") {
                    liquidResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.DRINK.DRINK.OPTION.4.DISPLAYLABEL",
                            defaultText: "Tired appearance"
                        )
                    )
                }
                if dehydrationSigns.contains("YES_SUNKEN_EYE_SOCKETS") {
                    liquidResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.DRINK.DRINK.OPTION.5.DISPLAYLABEL",
                            defaultText: "Sunken eye sockets"
                        )
                    )
                }
                if dehydrationSigns.contains("YES_FEWER_WET_DIAPERS") {
                    liquidResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.DRINK.DRINK.OPTION.6.DISPLAYLABEL",
                            defaultText: "Fewer wet diapers"
                        )
                    )
                }
                if dehydrationSigns.contains("YES_SUNKEN_FONTANELLE") {
                    liquidResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.DRINK.DRINK.OPTION.7.DISPLAYLABEL",
                            defaultText: "Fontanelle is sunken"
                        )
                    )
                }
            }

            // Display dehydration status text
            let dehydrationText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DRINK.DRINK.DISPLAY",
                defaultText: "Dehydration: {{value}}"
            ).replacingOccurrences(of: "{{value}}", with: liquidResponses.joined(separator: ", "))
            addText(to: cardView, text: dehydrationText)

            // Hint message for no signs of dehydration
            if dehydrationSigns.contains("NO") {
                let noDehydrationHint = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.ANALYSIS.HINT.0.TEXT",
                    defaultText: "{{name}} shows no signs of dehydration. This is a good sign. Continue to provide fluids in frequent small amounts. Warmed fluids are often better accepted."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
                addText(to: cardView, text: noDehydrationHint, font: UIFont.italicSystemFont(ofSize: 13))
            }

            // Hint message for signs of dehydration
            if !dehydrationSigns.contains("NO") && !liquidResponses.isEmpty {
                let dehydrationHint = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.ANALYSIS.HINT.1.TEXT",
                    defaultText: "{{name}} shows signs of dehydration. Please try to frequently offer liquids in small quantities. Warmed fluids are often better accepted. Please seek medical advice."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
                addText(to: cardView, text: dehydrationHint, font: UIFont.italicSystemFont(ofSize: 13))
            }

            // Add the Liquids card to the content view
            contentView.addArrangedSubview(cardView)
        }

//        //Add Diarrhea card
//        private func addDiarrheaCard(diarrhea: Diarrhea) {
//            // Create the Diarrhea card view
//            let cardView = createCardView(title: "Diarrhea", iconName: "stomach_icon", iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0))
//
//            // Determine the diarrhea status
//            let diarrheaValue = diarrhea.diarrheaAndOrVomiting
//            var diarrheaResponse: String
//
//            switch diarrheaValue {
//            case "NO":
//                diarrheaResponse = "No Diarrhea or vomiting"
//            case "YES_DIARRHEA_AND_VOMITING":
//                diarrheaResponse = "Diarrhea and vomiting"
//            case "YES_DIARRHEA":
//                diarrheaResponse = "Diarrhea"
//            case "YES_VOMITING":
//                diarrheaResponse = "Vomiting"
//            default:
//                diarrheaResponse = "Unknown status"
//            }
//
//            // Add the diarrhea status text
//            addText(to: cardView, text: diarrheaResponse)
//
//            // Add hint messages based on the diarrhea status
//            if diarrheaValue == "NO" {
//                let hintMessage = "Diarrhea and vomiting cause the body to lose fluid and this can lead to dehydration. Please seek medical advice if severe vomiting and/or diarrhea occurs."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            } else {
//                let hintMessage = "Diarrhea and vomiting cause the body to lose fluid and this can lead to dehydration. Please seek medical advice if the vomiting and/or diarrhea is severe or includes blood."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            // Add the Diarrhea card to the content view
//            contentView.addArrangedSubview(cardView)
//        }

        private func addDiarrheaCard(diarrhea: Diarrhea) {
            // Create the Diarrhea card view
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DIARRHEA.TITLE",
                    defaultText: "Diarrhea"
                ),
                iconName: "stomach_icon",
                iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
            )

            // Determine the diarrhea status
            let diarrheaValue = diarrhea.diarrheaAndOrVomiting
            let diarrheaResponse: String

            switch diarrheaValue {
            case "NO":
                diarrheaResponse = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DIARRHEA.DIARRHEA.OPTION.1.DISPLAYLABEL",
                    defaultText: "No Diarrhea or vomiting"
                )
            case "YES_DIARRHEA_AND_VOMITING":
                diarrheaResponse = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DIARRHEA.DIARRHEA.OPTION.2.DISPLAYLABEL",
                    defaultText: "Diarrhea and vomiting"
                )
            case "YES_DIARRHEA":
                diarrheaResponse = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DIARRHEA.DIARRHEA.OPTION.3.DISPLAYLABEL",
                    defaultText: "Diarrhea"
                )
            case "YES_VOMITING":
                diarrheaResponse = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DIARRHEA.DIARRHEA.OPTION.4.DISPLAYLABEL",
                    defaultText: "Vomiting"
                )
            default:
                diarrheaResponse = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DIARRHEA.DIARRHEA.UNKNOWN",
                    defaultText: "Unknown status"
                )
            }

            // Add the diarrhea status text
            addText(to: cardView, text: diarrheaResponse)

            // Add hint messages based on the diarrhea status
            if diarrheaValue == "NO" {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DIARRHEA.DIARRHEA.ANALYSIS.HINT.0.TEXT",
                    defaultText: "Diarrhea and vomiting cause the body to lose fluid and this can lead to dehydration. Please seek medical advice if severe vomiting and/or diarrhea occurs."
                )
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            } else {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DIARRHEA.DIARRHEA.ANALYSIS.HINT.1.TEXT",
                    defaultText: "Diarrhea and vomiting cause the body to lose fluid and this can lead to dehydration. Please seek medical advice if the vomiting and/or diarrhea is severe or includes blood."
                )
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            // Add the Diarrhea card to the content view
            contentView.addArrangedSubview(cardView)
        }

//        private func addRashCard(rash: Rash) {
//            // Create the Rash card view
//            let cardView = createCardView(title: "Rash", iconName: "ic_summary", iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0))
//
//            // Determine the rash status
//            let rashValues = rash.rashes
//            var rashResponse: String = "Unknown rash status"
//
//            if rashValues.contains("NO") {
//                rashResponse = "No rash"
//            } else if rashValues.contains("YES_REDNESS_CAN_BE_PUSHED_AWAY") {
//                rashResponse = "Rash can be pushed away"
//            } else if rashValues.contains("YES_REDNESS_CANNOT_BE_PUSHED_AWAY") {
//                rashResponse = "Rash cannot be pushed away"
//            }
//
//            // Add the rash status text
//            addText(to: cardView, text: "Rash: \(rashResponse)")
//
//            // Hint for rash that can be pushed away
//            if rashValues.contains("YES_REDNESS_CAN_BE_PUSHED_AWAY") {
//                let hintMessage = """
//                Rashes that can be pushed away (blanched) are typical for acute infections, especially when children have come into contact with a new pathogen. In many so-called childhood illnesses, the rash occurs before or with fever. With a "Roseola," the rash appears on the third day of fever, immediately after the final disappearance of fever. If the rash has been present for 3 or more days, you should seek medical advice again.
//                """
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            // Hint for rash that cannot be pushed away
//            if rashValues.contains("YES_REDNESS_CANNOT_BE_PUSHED_AWAY") {
//                let hintMessage = """
//                Rashes that cannot be pushed away are a warning sign. You should seek medical advice urgently.
//                """
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            // Add the Rash card to the content view
//            contentView.addArrangedSubview(cardView)
//        }
        
        private func addRashCard(rash: Rash) {
            // Create the Rash card view
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.RASH.TITLE",
                    defaultText: "Rash"
                ),
                iconName: "ic_summary",
                iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
            )

            // Determine the rash status
            let rashValues = rash.rashes
            var rashResponse: String = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.RASH.RASH.UNKNOWN",
                defaultText: "Unknown rash status"
            )

            if rashValues.contains("NO") {
                rashResponse = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.RASH.RASH.OPTION.1.DISPLAYLABEL",
                    defaultText: "No rash"
                )
            } else if rashValues.contains("YES_REDNESS_CAN_BE_PUSHED_AWAY") {
                rashResponse = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.RASH.RASH.OPTION.2.DISPLAYLABEL",
                    defaultText: "Rash can be pushed away"
                )
            } else if rashValues.contains("YES_REDNESS_CANNOT_BE_PUSHED_AWAY") {
                rashResponse = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.RASH.RASH.OPTION.3.DISPLAYLABEL",
                    defaultText: "Rash cannot be pushed away"
                )
            }

            // Add the rash status text
            let rashText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.RASH.RASH.DISPLAY",
                defaultText: "Rash: {{value}}"
            ).replacingOccurrences(of: "{{value}}", with: rashResponse)
            addText(to: cardView, text: rashText)

            // Hint for rash that can be pushed away
            if rashValues.contains("YES_REDNESS_CAN_BE_PUSHED_AWAY") {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.RASH.RASH.ANALYSIS.HINT.0.TEXT",
                    defaultText: """
                    Rashes that can be pushed away (blanched) are typical for acute infections, especially when children have come into contact with a new pathogen. In many so-called childhood illnesses, the rash occurs before or with fever. With a "Roseola," the rash appears on the third day of fever, immediately after the final disappearance of fever. If the rash has been present for 3 or more days, you should seek medical advice again.
                    """
                )
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            // Hint for rash that cannot be pushed away
            if rashValues.contains("YES_REDNESS_CANNOT_BE_PUSHED_AWAY") {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.RASH.RASH.ANALYSIS.HINT.1.TEXT",
                    defaultText: """
                    Rashes that cannot be pushed away are a warning sign. You should seek medical advice urgently.
                    """
                )
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            // Add the Rash card to the content view
            contentView.addArrangedSubview(cardView)
        }

        //symptoms card start
        
//        private func addSymptomsCard(symptoms: Symptoms) {
//            // Create the Symptoms card view
//            let cardView = createCardView(title: "Symptoms", iconName: "vectorunwell", iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0))
//
//            // Determine the symptoms status
//            let symptomValues = symptoms.symptoms
//            var symptomResponses: [String] = []
//
//            if symptomValues.contains("NO") {
//                symptomResponses.append("No symptoms")
//            } else {
//                if symptomValues.contains("COUGH") {
//                    symptomResponses.append("Cough")
//                }
//                if symptomValues.contains("CONSTRAINED_BREATHING") {
//                    symptomResponses.append("Constrained breathing")
//                }
//                if symptomValues.contains("FREEZING_CHILLS") {
//                    symptomResponses.append("Freezing / chills")
//                }
//                if symptomValues.contains("FATIGUE_EXHAUSTION") {
//                    symptomResponses.append("Fatigue, exhaustion")
//                }
//                if symptomValues.contains("SENSE_OF_SMELL_TASTE_DISTURBED") {
//                    symptomResponses.append("Sense of smell/taste disturbed")
//                }
//                if symptomValues.contains("MUCUS") {
//                    symptomResponses.append("Mucus (ear, nose and throat)")
//                }
//                if symptomValues.contains("TONSILLITIS") {
//                    symptomResponses.append("Tonsillitis")
//                }
//                if symptomValues.contains("JOINT_SWELLING") {
//                    symptomResponses.append("Joint swelling")
//                }
//                if symptomValues.contains("TEETHING") {
//                    symptomResponses.append("Teething")
//                }
//                if symptomValues.contains("OTHER") {
//                    symptomResponses.append("Other symptoms")
//                }
//            }
//
//            // Add the symptoms status text
//            addText(to: cardView, text: "Symptoms: \(symptomResponses.joined(separator: ", "))")
//
//            // Hint messages for each symptom
//            if symptomValues.contains("COUGH") {
//                let hintMessage = "\(profileName) is coughing. Cough can last longer after an infection. Contact a doctor if it persists more than two weeks after an infection."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("CONSTRAINED_BREATHING") {
//                let hintMessage = "\(profileName) is breathing hard. You should rule out pneumonia."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("FREEZING_CHILLS") {
//                let hintMessage = "\(profileName) freezes / chills. This is a sign that \(profileName) needs more heat."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("FATIGUE_EXHAUSTION") {
//                let hintMessage = "\(profileName) is tired / exhausted. This is a normal reaction to an infection."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("SENSE_OF_SMELL_TASTE_DISTURBED") {
//                let hintMessage = "\(profileName) has an impaired sense of smell / taste. This can be a sign of a corona infection. As a precaution, contact a doctor."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("MUCUS") {
//                let hintMessage = "\(profileName) is mucilaginous."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("TONSILLITIS") {
//                let hintMessage = "\(profileName) has tonsillitis. Antibiotics were often prescribed in the past, but are almost never necessary. Gargling with sage tea can help."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("JOINT_SWELLING") {
//                let hintMessage = "In case of joint swelling, consult the doctor today."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("TEETHING") {
//                let hintMessage = """
//                \(profileName) is teething. This may be accompanied by fever. Massage, closeness, security, cooled teething rings or a wet washcloth, and teething gel can help.
//                Be cautious with violet roots and amber necklaces due to swallowing hazards.
//                """
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            if symptomValues.contains("OTHER") {
//                let hintMessage = "\(profileName) has other symptoms that we do not evaluate individually."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            // Additional symptoms text if "OTHER" is selected and there are other symptoms provided
//            if let otherSymptoms = symptoms.otherSymptoms, symptomValues.contains("OTHER") {
//                addText(to: cardView, text: "Other Symptoms: \(otherSymptoms.joined(separator: ", "))")
//            }
//
//            // Add the Symptoms card to the content view
//            contentView.addArrangedSubview(cardView)
//        }
        private func addSymptomsCard(symptoms: Symptoms) {
            // Create the Symptoms card view
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.SYMPTOMS.TITLE",
                    defaultText: "Symptoms"
                ),
                iconName: "vectorunwell",
                iconColor: UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
            )

            // Determine the symptoms status
            let symptomValues = symptoms.symptoms
            var symptomResponses: [String] = []

            if symptomValues.contains("NO") {
                symptomResponses.append(
                    TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.1.DISPLAYLABEL",
                        defaultText: "No symptoms"
                    )
                )
            } else {
                if symptomValues.contains("COUGH") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.2.DISPLAYLABEL",
                            defaultText: "Cough"
                        )
                    )
                }
                if symptomValues.contains("CONSTRAINED_BREATHING") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.3.DISPLAYLABEL",
                            defaultText: "Constrained breathing"
                        )
                    )
                }
                if symptomValues.contains("FREEZING_CHILLS") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.4.DISPLAYLABEL",
                            defaultText: "Freezing / chills"
                        )
                    )
                }
                if symptomValues.contains("FATIGUE_EXHAUSTION") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.5.DISPLAYLABEL",
                            defaultText: "Fatigue, exhaustion"
                        )
                    )
                }
                if symptomValues.contains("SENSE_OF_SMELL_TASTE_DISTURBED") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.6.DISPLAYLABEL",
                            defaultText: "Sense of smell/taste disturbed"
                        )
                    )
                }
                if symptomValues.contains("MUCUS") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.7.DISPLAYLABEL",
                            defaultText: "Mucus (ear, nose, and throat)"
                        )
                    )
                }
                if symptomValues.contains("TONSILLITIS") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.8.DISPLAYLABEL",
                            defaultText: "Tonsillitis"
                        )
                    )
                }
                if symptomValues.contains("JOINT_SWELLING") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.9.DISPLAYLABEL",
                            defaultText: "Joint swelling"
                        )
                    )
                }
                if symptomValues.contains("TEETHING") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.11.DISPLAYLABEL",
                            defaultText: "Teething"
                        )
                    )
                }
                if symptomValues.contains("OTHER") {
                    symptomResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.SYMPTOMS.SYMPTOMS.OPTION.10.DISPLAYLABEL",
                            defaultText: "Other symptoms"
                        )
                    )
                }
            }

            // Add the symptoms status text
            let symptomsText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.SYMPTOMS.SYMPTOMS.DISPLAY",
                defaultText: "Symptoms: {{value}}"
            ).replacingOccurrences(of: "{{value}}", with: symptomResponses.joined(separator: ", "))
            addText(to: cardView, text: symptomsText)

            // Hint messages for each symptom
            if symptomValues.contains("COUGH") {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.SYMPTOMS.SYMPTOMS.ANALYSIS.HINT.2.TEXT",
                    defaultText: "{{name}} is coughing. Cough can last longer after an infection. Contact a doctor if it persists more than two weeks after an infection."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            if symptomValues.contains("CONSTRAINED_BREATHING") {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.SYMPTOMS.SYMPTOMS.ANALYSIS.HINT.3.TEXT",
                    defaultText: "{{name}} is breathing hard. You should rule out pneumonia."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            if symptomValues.contains("FREEZING_CHILLS") {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.SYMPTOMS.SYMPTOMS.ANALYSIS.HINT.4.TEXT",
                    defaultText: "{{name}} freezes / chills. This is a sign that {{name}} needs more heat."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            if symptomValues.contains("FATIGUE_EXHAUSTION") {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.SYMPTOMS.SYMPTOMS.ANALYSIS.HINT.5.TEXT",
                    defaultText: "{{name}} is tired / exhausted. This is a normal reaction to an infection."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            if symptomValues.contains("OTHER") {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.SYMPTOMS.SYMPTOMS.ANALYSIS.HINT.10.TEXT",
                    defaultText: "{{name}} has other symptoms that we do not evaluate individually."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            if let otherSymptoms = symptoms.otherSymptoms, symptomValues.contains("OTHER") {
                let otherSymptomsText = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.SYMPTOMS.SYMPTOMS_OTHER.DISPLAY",
                    defaultText: "Other Symptoms: {{value}}"
                ).replacingOccurrences(of: "{{value}}", with: otherSymptoms.joined(separator: ", "))
                addText(to: cardView, text: otherSymptomsText)
            }

            // Add the Symptoms card to the content view
            contentView.addArrangedSubview(cardView)
        }

//        private func addWarningSignsCard(warningSigns: WarningSigns) {
//            // Create the Warning Signs card view
//            let cardView = createCardView(title: "Warning Signs", iconName: "warning_icon", iconColor: .red)
//
//            // Determine the warning signs status
//            let warningSignsValues = warningSigns.warningSigns
//            var warningSignsResponses: [String] = []
//
//            if warningSignsValues.contains("NO") {
//                warningSignsResponses.append("No other warning signs")
//            } else {
//                if warningSignsValues.contains("YES_TOUCH_SENSITIVITY") {
//                    warningSignsResponses.append("Touch sensitivity")
//                }
//                if warningSignsValues.contains("YES_SHRILL_SCREAMING_LIKE_I_VE_NEVER_HEARD_IT_BEFORE") {
//                    warningSignsResponses.append("Shrill screaming")
//                }
//                if warningSignsValues.contains("YES_ACTING_DIFFERENTLY_CLOUDED_CONSCIOUSNESS_APATHY") {
//                    warningSignsResponses.append("Acting differently, clouded consciousness, apathy")
//                }
//                if warningSignsValues.contains("YES_SEEMS_SERIOUSLY_SICK") {
//                    warningSignsResponses.append("Seems seriously sick")
//                }
//            }
//
//            // Add the warning signs status text
//            addText(to: cardView, text: "Warning signs: \(warningSignsResponses.joined(separator: ", "))")
//
//            // Hint message for all warning signs if any warning signs are present
//            if !warningSignsValues.contains("NO") && !warningSignsResponses.isEmpty {
//                let hintMessage = "With warning signs you should seek medical advice urgently."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            // Add the Warning Signs card to the content view
//            contentView.addArrangedSubview(cardView)
//        }

        private func addWarningSignsCard(warningSigns: WarningSigns) {
            // Create the Warning Signs card view
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.WARNING_SIGNS.TITLE",
                    defaultText: "Warning Signs"
                ),
                iconName: "warning_icon",
                iconColor: .red
            )

            // Determine the warning signs status
            let warningSignsValues = warningSigns.warningSigns
            var warningSignsResponses: [String] = []

            if warningSignsValues.contains("NO") {
                warningSignsResponses.append(
                    TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.WARNING_SIGNS.WARNING-SIGNS.OPTION.1.DISPLAYLABEL",
                        defaultText: "No other warning signs"
                    )
                )
            } else {
                if warningSignsValues.contains("YES_TOUCH_SENSITIVITY") {
                    warningSignsResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.WARNING_SIGNS.WARNING-SIGNS.OPTION.2.DISPLAYLABEL",
                            defaultText: "Touch sensitivity"
                        )
                    )
                }
                if warningSignsValues.contains("YES_SHRILL_SCREAMING_LIKE_I_VE_NEVER_HEARD_IT_BEFORE") {
                    warningSignsResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.WARNING_SIGNS.WARNING-SIGNS.OPTION.3.DISPLAYLABEL",
                            defaultText: "Shrill screaming"
                        )
                    )
                }
                if warningSignsValues.contains("YES_ACTING_DIFFERENTLY_CLOUDED_CONSCIOUSNESS_APATHY") {
                    warningSignsResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.WARNING_SIGNS.WARNING-SIGNS.OPTION.4.DISPLAYLABEL",
                            defaultText: "Acting differently, clouded consciousness, apathy"
                        )
                    )
                }
                if warningSignsValues.contains("YES_SEEMS_SERIOUSLY_SICK") {
                    warningSignsResponses.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.WARNING_SIGNS.WARNING-SIGNS.OPTION.5.DISPLAYLABEL",
                            defaultText: "Seems seriously sick"
                        )
                    )
                }
            }

            // Add the warning signs status text
            let warningSignsText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.WARNING_SIGNS.WARNING-SIGNS.DISPLAY",
                defaultText: "Warning signs: {{value}}"
            ).replacingOccurrences(of: "{{value}}", with: warningSignsResponses.joined(separator: ", "))
            addText(to: cardView, text: warningSignsText)

            // Hint message for all warning signs if any warning signs are present
            if !warningSignsValues.contains("NO") && !warningSignsResponses.isEmpty {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.WARNING_SIGNS.WARNING-SIGNS.ANALYSIS.HINT.0.TEXT",
                    defaultText: "With warning signs you should seek medical advice urgently."
                )
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            // Add the Warning Signs card to the content view
            contentView.addArrangedSubview(cardView)
        }

        
//        private func addConfidenceCard(confidenceLevel: String) {
//            // Create the Feeling Confident card view
//            let cardView = createCardView(title: "Feeling Confident", iconName: getConfidenceIcon(level: confidenceLevel))
//
//            // Determine the message to display based on the confidence level
//            let message: String
//            switch confidenceLevel {
//            case "ONE":
//                message = "When \(profileName) has a fever, you feel very insecure."
//            case "TWO":
//                message = "When \(profileName) has a fever, you feel insecure."
//            case "THREE":
//                message = "When \(profileName) has a fever, you feel neither very secure nor very insecure."
//            case "FOUR":
//                message = "When \(profileName) has a fever, you feel secure."
//            case "FIVE":
//                message = "When \(profileName) has a fever, you feel very secure."
//            default:
//                message = "\(profileName)'s confidence level is unknown."
//            }
//
//            // Add the main message text
//            addText(to: cardView, text: message)
//
//            // Hint message for confidence levels ONE or TWO
//            if confidenceLevel == "ONE" || confidenceLevel == "TWO" {
//                let hintMessage = "If you do not feel confident about what to do when \(profileName) has a fever, you should seek medical advice."
//                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
//            }
//
//            // Add the Feeling Confident card to the content view
//            contentView.addArrangedSubview(cardView)
//        }

        private func addConfidenceCard(confidenceLevel: String) {
            // Create the Feeling Confident card view
            let cardTitle = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.CONFIDENCE.TITLE",
                defaultText: "Feeling Confident"
            )
            let iconName = getConfidenceIcon(level: confidenceLevel)
            let cardView = createCardView(title: cardTitle, iconName: iconName)

            // Determine the message to display based on the confidence level
            let message: String
            switch confidenceLevel {
            case "ONE":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.0.TEXT",
                    defaultText: "When {{name}} has a fever, you feel very insecure."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
            case "TWO":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.1.TEXT",
                    defaultText: "When {{name}} has a fever, you feel insecure."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
            case "THREE":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.2.TEXT",
                    defaultText: "When {{name}} has a fever, you feel neither very secure nor very insecure."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
            case "FOUR":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.3.TEXT",
                    defaultText: "When {{name}} has a fever, you feel secure."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
            case "FIVE":
                message = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.4.TEXT",
                    defaultText: "When {{name}} has a fever, you feel very secure."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
            default:
                message = "\(profileName)'s confidence level is unknown."
            }

            // Add the main message text
            addText(to: cardView, text: message)

            // Hint message for confidence levels ONE or TWO
            if confidenceLevel == "ONE" || confidenceLevel == "TWO" {
                let hintMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.HINT.0.TEXT",
                    defaultText: "If you do not feel confident about what to do when {{name}} has a fever, you should seek medical advice."
                ).replacingOccurrences(of: "{{name}}", with: profileName)
                addText(to: cardView, text: hintMessage, font: UIFont.italicSystemFont(ofSize: 13))
            }

            // Add the Feeling Confident card to the content view
            contentView.addArrangedSubview(cardView)
        }

        // Helper function to get the appropriate icon for the confidence level
        private func getConfidenceIcon(level: String) -> String {
            switch level {
            case "ONE": return "feelingconfident_one_checked"
            case "TWO": return "feelingconfident_two_checked"
            case "THREE": return "feelingconfident_three_checked"
            case "FOUR": return "feelingconfident_four_checked"
            case "FIVE": return "feelingconfident_five_checked"
            default: return "feelingconfident_one_checked"
            }
        }

        
//        private func addContactWithDoctorCard(contactInfo: ContactWithDoctor?) {
//                guard let contactInfo = contactInfo else { return }
//
//                // Create the Contact with Doctor card view
//                let cardView = createCardView(title: "Contact with the doctor", iconName: "doctorbag_icon")
//
//                // Determine the contact type
//                let contactMessage: String
//                switch contactInfo.hasHadMedicalContact {
//                case "NO":
//                    contactMessage = "No doctor's visit"
//                case "SPOKE_WITH_OUR_DOCTOR":
//                    contactMessage = "Our doctor"
//                case "SPOKE_WITH_ANOTHER_DOCTOR":
//                    contactMessage = "Substitute doctor"
//                case "WITH_EMERGENCY_SERVICES":
//                    contactMessage = "Emergency services"
//                default:
//                    contactMessage = "Unknown contact type"
//                }
//
//                // Add the contact type text
//                addText(to: cardView, text: "Contact: \(contactMessage)")
//
//                // Display additional information if contact was made
//                if contactInfo.hasHadMedicalContact != "NO" {
//                    // Format the time of contact
//                    let formattedTime = formatDate(contactInfo.dateOfContact)
//
//                    // Time of contact
//                    if let formattedTime = formattedTime {
//                        addText(to: cardView, text: "Time: \(formattedTime)")
//                    }
//
//                    // Reasons for contact
//                    let reasonsForContact = getReasonsForContact(contactInfo.reasonForContact)
//                    if !reasonsForContact.isEmpty {
//                        addText(to: cardView, text: "Reason: \(reasonsForContact.joined(separator: ", "))")
//                    }
//
//                    // Display "Other reasons" if present
//                    if contactInfo.reasonForContact.contains("OTHER"), let otherReason = contactInfo.otherReasonForContact {
//                        addText(to: cardView, text: "Other reasons: \(otherReason)")
//                    }
//
//                    // Doctor's diagnosis
//                    if !contactInfo.doctorDiagnoses.isEmpty {
//                        addText(to: cardView, text: "Diagnosis: \(contactInfo.doctorDiagnoses.joined(separator: ", "))")
//                    }
//
//                    // Doctor's prescription
//                    let doctorPrescriptions = getDoctorPrescriptions(contactInfo.doctorsPrescriptionsIssued)
//                    if !doctorPrescriptions.isEmpty {
//                        addText(to: cardView, text: "Prescription: \(doctorPrescriptions.joined(separator: ", "))")
//                    }
//
//                    // Display "Other medication" if present
//                    if contactInfo.doctorsPrescriptionsIssued.contains("OTHER"), let otherMedication = contactInfo.otherPrescriptionsIssued {
//                        addText(to: cardView, text: "Other medication: \(otherMedication)")
//                    }
//
//                    // Doctor's recommendation measures
//                    if let recommendationMeasures = contactInfo.doctorsRecommendationMeasures {
//                        addText(to: cardView, text: "Measure: \(recommendationMeasures)")
//                    }
//                }
//
//                // Add the Contact with Doctor card to the content view
//                contentView.addArrangedSubview(cardView)
//            }
        private func addContactWithDoctorCard(contactInfo: ContactWithDoctor?, languageCode: String) {
            guard let contactInfo = contactInfo else { return }

            // Create the Contact with Doctor card view
            let cardTitle = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DOCTOR.TITLE",
                defaultText: "Contact with the doctor"
            )
            let cardView = createCardView(title: cardTitle, iconName: "doctorbag_icon")

            // Determine the contact type
            let contactMessage: String
            switch contactInfo.hasHadMedicalContact {
            case "NO":
                contactMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.1.DISPLAYLABEL",
                    defaultText: "No doctor's visit"
                )
            case "SPOKE_WITH_OUR_DOCTOR":
                contactMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.2.DISPLAYLABEL",
                    defaultText: "Our doctor"
                )
            case "SPOKE_WITH_ANOTHER_DOCTOR":
                contactMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.3.DISPLAYLABEL",
                    defaultText: "Substitute doctor"
                )
            case "WITH_EMERGENCY_SERVICES":
                contactMessage = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.4.DISPLAYLABEL",
                    defaultText: "Emergency services"
                )
            default:
                contactMessage = "Unknown contact type"
            }

            // Add the contact type text
            addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DOCTOR.DOCTOR_VISIT.DISPLAY",
                defaultText: "Contact: {{value}}"
            ).replacingOccurrences(of: "{{value}}", with: contactMessage))

            // Display additional information if contact was made
            if contactInfo.hasHadMedicalContact != "NO" {
                // Format the time of contact
                let formattedTime = formatDate(contactInfo.dateOfContact, languageCode: languageCode)
                if let formattedTime = formattedTime {
                    addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_VISIT-DATE.DISPLAY",
                        defaultText: "Time: {{value}}"
                    ).replacingOccurrences(of: "{{value}}", with: formattedTime))
                }

                // Reasons for contact
                let reasonsForContact = getReasonsForContact(contactInfo.reasonForContact).map {
                    TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.\($0).LABEL",
                        defaultText: $0
                    )
                }
                if !reasonsForContact.isEmpty {
                    addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_REASON.DISPLAY",
                        defaultText: "Reason: {{value}}"
                    ).replacingOccurrences(of: "{{value}}", with: reasonsForContact.joined(separator: ", ")))
                }

                // Display "Other reasons" if present
                if contactInfo.reasonForContact.contains("OTHER"), let otherReason = contactInfo.otherReasonForContact {
                    addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_REASON-OTHER.DISPLAY",
                        defaultText: "Other reasons: {{value}}"
                    ).replacingOccurrences(of: "{{value}}", with: otherReason))
                }

                // Doctor's diagnosis
                if !contactInfo.doctorDiagnoses.isEmpty {
                    addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS.DISPLAY",
                        defaultText: "Diagnosis: {{value}}"
                    ).replacingOccurrences(of: "{{value}}", with: contactInfo.doctorDiagnoses.joined(separator: ", ")))
                }

                // Doctor's prescription
                let doctorPrescriptions = getDoctorPrescriptions(contactInfo.doctorsPrescriptionsIssued).map {
                    TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.\($0).DISPLAYLABEL",
                        defaultText: $0
                    )
                }
                if !doctorPrescriptions.isEmpty {
                    addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_MEDICATION.DISPLAY",
                        defaultText: "Prescription: {{value}}"
                    ).replacingOccurrences(of: "{{value}}", with: doctorPrescriptions.joined(separator: ", ")))
                }

                // Display "Other medication" if present
                if contactInfo.doctorsPrescriptionsIssued.contains("OTHER"), let otherMedication = contactInfo.otherPrescriptionsIssued {
                    addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_MEDICATION-OTHER.DISPLAY",
                        defaultText: "Other medication: {{value}}"
                    ).replacingOccurrences(of: "{{value}}", with: otherMedication))
                }

                // Doctor's recommendation measures
                if let recommendationMeasures = contactInfo.doctorsRecommendationMeasures {
                    addText(to: cardView, text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.DOCTOR.DOCTOR_MEASURES.DISPLAY",
                        defaultText: "Measure: {{value}}"
                    ).replacingOccurrences(of: "{{value}}", with: recommendationMeasures))
                }
            }

            // Add the Contact with Doctor card to the content view
            contentView.addArrangedSubview(cardView)
        }

        // Helper function
        private func formatDate(_ dateString: String?, languageCode: String) -> String? {
            guard let dateString = dateString else { return nil }
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Fixed input locale

            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEE MMM dd, yyyy" // You can adjust the output format as needed
            outputFormatter.locale = Locale(identifier: languageCode) // Use the passed language code

            if let date = inputFormatter.date(from: dateString) {
                return outputFormatter.string(from: date)
            }
            return nil
        }


//            private func getReasonsForContact(_ reasons: [String]) -> [String] {
//                var result = [String]()
//                if reasons.contains("WORRY_AND_INSECURITY") {
//                    result.append("Worry and insecurity")
//                }
//                if reasons.contains("HIGH_FEVER") {
//                    result.append("High level of fever")
//                }
//                if reasons.contains("WARNING_SIGNS") {
//                    result.append("Warning signs (as documented in the app)")
//                }
//                if reasons.contains("GET_ATTESTATION") {
//                    result.append("To get an attestation/sick note")
//                }
//                if reasons.contains("OTHER") {
//                    result.append("Other")
//                }
//                return result
//            }
//
//            private func getDoctorPrescriptions(_ prescriptions: [String]) -> [String] {
//                var result = [String]()
//                if prescriptions.contains("IBUPROFEN") {
//                    result.append("Ibuprofen")
//                }
//                if prescriptions.contains("PARACETAMOL") {
//                    result.append("Paracetamol")
//                }
//                if prescriptions.contains("ANTIBIOTIC") {
//                    result.append("Antibiotic")
//                }
//                if prescriptions.contains("OTHER") {
//                    result.append("Other medication")
//                }
//                return result
//            }

        private func getReasonsForContact(_ reasons: [String]) -> [String] {
            var result = [String]()
            if reasons.contains("WORRY_AND_INSECURITY") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.1.LABEL",
                    defaultText: "Worry and insecurity"
                ))
            }
            if reasons.contains("HIGH_FEVER") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.2.LABEL",
                    defaultText: "High level of fever"
                ))
            }
            if reasons.contains("WARNING_SIGNS") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.3.LABEL",
                    defaultText: "Warning signs (as documented in the app)"
                ))
            }
            if reasons.contains("GET_ATTESTATION") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.4.LABEL",
                    defaultText: "To get an attestation/sick note"
                ))
            }
            if reasons.contains("OTHER") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.5.LABEL",
                    defaultText: "Other"
                ))
            }
            return result
        }

        private func getDoctorPrescriptions(_ prescriptions: [String]) -> [String] {
            var result = [String]()
            if prescriptions.contains("IBUPROFEN") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.2.DISPLAYLABEL",
                    defaultText: "Ibuprofen"
                ))
            }
            if prescriptions.contains("PARACETAMOL") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.3.DISPLAYLABEL",
                    defaultText: "Paracetamol"
                ))
            }
            if prescriptions.contains("ANTIBIOTIC") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.4.DISPLAYLABEL",
                    defaultText: "Antibiotic"
                ))
            }
            if prescriptions.contains("OTHER") {
                result.append(TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DOCTOR.DOCTOR_MEDICATION.OPTION.5.DISPLAYLABEL",
                    defaultText: "Other medication"
                ))
            }
            return result
        }

//        private func addMedicationCard(medications: MedicationsModel) {
//            let cardView = createCardView(title: "Medication", iconName: "drug_icon")
//            let message = medications.hasTakenMedications != nil ? "Yes" : "No"
//            addText(to: cardView, text: "Medication: \(message)")
//            if let hasTakenMedications = medications.hasTakenMedications, hasTakenMedications.lowercased() == "yes",
//               let medicationList = medications.medicationList {
//                let details = medicationList.map { medication in
//                    let medicationName = medication.medicationName
//                    let amountAdministered = medication.amountAdministered != nil ? "\(medication.amountAdministered!)" : "not administered"
//                    return "\(medicationName) (\(amountAdministered))"
//                }.joined(separator: ", ")
//                addText(to: cardView, text: details)
//            } else {
//                addText(to: cardView, text: "No medications taken.")
//            }
//            contentView.addArrangedSubview(cardView)
//        }
        
        private func addMedicationCard(medications: MedicationsModel) {
            // Create the Medication card view
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEDICATION.TITLE",
                    defaultText: "Medication"
                ),
                iconName: "drug_icon"
            )

            // Determine the medication status (Yes/No)
            let message = medications.hasTakenMedications?.lowercased() == "yes" ?
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEDICATION.MEDICATION.OPTION.1.LABEL",
                    defaultText: "Yes"
                ) :
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEDICATION.MEDICATION.OPTION.2.LABEL",
                    defaultText: "No"
                )

            addText(
                to: cardView,
                text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEDICATION.MEDICATION.DISPLAY",
                    defaultText: "Medication: {{value}}"
                ).replacingOccurrences(of: "{{value}}", with: message)
            )

            // If medications have been taken, display details
            if let hasTakenMedications = medications.hasTakenMedications,
               hasTakenMedications.lowercased() == "yes",
               let medicationList = medications.medicationList {
                let details = medicationList.map { medication in
                    let medicationName = medication.medicationName
                    let amountAdministered = medication.amountAdministered != nil ?
                        "\(medication.amountAdministered!)" :
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEDICATION.NOT_ADMINISTERED",
                            defaultText: "not administered"
                        )
                    return "\(medicationName) (\(amountAdministered))"
                }.joined(separator: ", ")

                addText(to: cardView, text: details)
            } else {
                addText(
                    to: cardView,
                    text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.MEDICATION.NO_MEDICATION",
                        defaultText: "No medications taken."
                    )
                )
            }

            // Add the Medication card to the content view
            contentView.addArrangedSubview(cardView)
        }

//        private func addMeasuresCard(measuresInfo: Measures?) {
//            guard let measuresInfo = measuresInfo else { return }
//
//            // Determine the value to display based on whether measures were taken
//            let valueToDisplay: String
//            switch measuresInfo.takeMeasures {
//            case "YES":
//                valueToDisplay = "Yes"
//            case "NO":
//                valueToDisplay = "No"
//            default:
//                valueToDisplay = ""
//            }
//
//            // Prepare the list of measures
//            var measuresList: [String] = []
//            if measuresInfo.measures.contains("NO") {
//                measuresList.append("No Measures")
//            } else {
//                if measuresInfo.measures.contains("CALM_THEM_CARESS") {
//                    measuresList.append("Calm them, caress")
//                }
//                if measuresInfo.measures.contains("READING_STORY_TELLING_SINGING") {
//                    measuresList.append("Reading, story telling, singing")
//                }
//                if measuresInfo.measures.contains("LOW_STIMULUS_ENVIRONMENT") {
//                    measuresList.append("Low-stimulus environment")
//                }
//                if measuresInfo.measures.contains("TEA_WITH_HONEY") {
//                    measuresList.append("Tea with honey (elder, lime-tree, chamomile)")
//                }
//                if measuresInfo.measures.contains("SOUP_OR_LIGHT_FOOD") {
//                    measuresList.append("Soup or light food")
//                }
//                if measuresInfo.measures.contains("HOT_WATER_BOTTLE") || measuresInfo.measures.contains("CHERRY_STONE_CUSHIONS") {
//                    measuresList.append("Hot-water bottle, Cherry stone cushions")
//                }
//                if measuresInfo.measures.contains("LEG_COMPRESSES") {
//                    measuresList.append("Leg compresses")
//                }
//                if measuresInfo.measures.contains("CLOTHS_ON_THE_FOREHEAD") {
//                    measuresList.append("Cloths on the forehead")
//                }
//                if measuresInfo.measures.contains("ENEMA") {
//                    measuresList.append("Enema")
//                }
//                if measuresInfo.measures.contains("LEMON_WATER_RUBS") {
//                    measuresList.append("Lemon water rubs")
//                }
//                if measuresInfo.measures.contains("OTHER_MEASURES") {
//                    measuresList.append("Other measures")
//                }
//            }
//
//            // Other measures if specified
//            let otherMeasures = measuresInfo.otherMeasures ?? "?"
//
//            // Create the Measures card view
//            let cardView = createCardView(title: "Measures", iconName: "measure_icon")
//
//            // Display the main measure taken status
//            addText(to: cardView, text: "Measure: \(valueToDisplay)")
//
//            // Display list of measures if "YES"
//            if measuresInfo.takeMeasures == "YES" && !measuresList.isEmpty {
//                addText(to: cardView, text: measuresList.joined(separator: ", "))
//            }
//
//            // Display other measures if included in the list
//            if measuresInfo.measures.contains("OTHER_MEASURES") {
//                addText(to: cardView, text: "Other Measures: \(otherMeasures)")
//            }
//
//            // Add the Measures card to the content view
//            contentView.addArrangedSubview(cardView)
//        }

        private func addMeasuresCard(measuresInfo: Measures?) {
            guard let measuresInfo = measuresInfo else { return }

            // Determine the value to display based on whether measures were taken
            let valueToDisplay: String
            switch measuresInfo.takeMeasures {
            case "YES":
                valueToDisplay = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE.OPTION.1.LABEL",
                    defaultText: "Yes"
                )
            case "NO":
                valueToDisplay = TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE.OPTION.2.LABEL",
                    defaultText: "No"
                )
            default:
                valueToDisplay = ""
            }

            // Prepare the list of measures
            var measuresList: [String] = []
            if measuresInfo.measures.contains("NO") {
                measuresList.append(
                    TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.1.LABEL",
                        defaultText: "No Measures"
                    )
                )
            } else {
                if measuresInfo.measures.contains("CALM_THEM_CARESS") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.5.LABEL",
                            defaultText: "Calm them, caress"
                        )
                    )
                }
                if measuresInfo.measures.contains("READING_STORY_TELLING_SINGING") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.6.LABEL",
                            defaultText: "Reading, story telling, singing"
                        )
                    )
                }
                if measuresInfo.measures.contains("LOW_STIMULUS_ENVIRONMENT") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.7.LABEL",
                            defaultText: "Low-stimulus environment"
                        )
                    )
                }
                if measuresInfo.measures.contains("TEA_WITH_HONEY") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.8.LABEL",
                            defaultText: "Tea with honey (elder, lime-tree, chamomile)"
                        )
                    )
                }
                if measuresInfo.measures.contains("SOUP_OR_LIGHT_FOOD") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.9.LABEL",
                            defaultText: "Soup or light food"
                        )
                    )
                }
                if measuresInfo.measures.contains("HOT_WATER_BOTTLE") || measuresInfo.measures.contains("CHERRY_STONE_CUSHIONS") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.1.LABEL",
                            defaultText: "Hot-water bottle, Cherry stone cushions"
                        )
                    )
                }
                if measuresInfo.measures.contains("LEG_COMPRESSES") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.2.LABEL",
                            defaultText: "Leg compresses"
                        )
                    )
                }
                if measuresInfo.measures.contains("CLOTHS_ON_THE_FOREHEAD") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.3.LABEL",
                            defaultText: "Cloths on the forehead"
                        )
                    )
                }
                if measuresInfo.measures.contains("ENEMA") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.10.LABEL",
                            defaultText: "Enema"
                        )
                    )
                }
                if measuresInfo.measures.contains("LEMON_WATER_RUBS") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.11.LABEL",
                            defaultText: "Lemon water rubs"
                        )
                    )
                }
                if measuresInfo.measures.contains("OTHER_MEASURES") {
                    measuresList.append(
                        TranslationsViewModel.shared.getTranslation(
                            key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.4.LABEL",
                            defaultText: "Other measures"
                        )
                    )
                }
            }

            // Other measures if specified
            let otherMeasures = measuresInfo.otherMeasures ?? "?"

            // Create the Measures card view
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.TITLE",
                    defaultText: "Measures"
                ),
                iconName: "measure_icon"
            )

            // Display the main measure taken status
            addText(
                to: cardView,
                text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_KIND.DISPLAY",
                    defaultText: "Measure: {{value}}"
                ).replacingOccurrences(of: "{{value}}", with: valueToDisplay)
            )

            // Display list of measures if "YES"
            if measuresInfo.takeMeasures == "YES" && !measuresList.isEmpty {
                addText(to: cardView, text: measuresList.joined(separator: ", "))
            }

            // Display other measures if included in the list
            if measuresInfo.measures.contains("OTHER_MEASURES") {
                addText(
                    to: cardView,
                    text: TranslationsViewModel.shared.getTranslation(
                        key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.OTHER.DISPLAY",
                        defaultText: "Other Measures: {{value}}"
                    ).replacingOccurrences(of: "{{value}}", with: otherMeasures)
                )
            }

            // Add the Measures card to the content view
            contentView.addArrangedSubview(cardView)
        }

//        private func addNotesCard(notes: Notes?) {
//            guard let notesInfo = notes else { return }
//
//            // Extract the content for the notes
//            let firstContent = notesInfo.notesContent ?? "?"
//            let otherContent = notesInfo.notesOtherContent ?? "?"
//
//            // Create the Note card view
//            let cardView = createCardView(title: "Note", iconName: "note_icon")
//
//            // Display the first content of the note
//            addText(to: cardView, text: "Note: \(firstContent)")
//
//            // Display the other content of the note if available
//            if !otherContent.isEmpty && otherContent != "?" {
//                addText(to: cardView, text: otherContent)
//            }
//
//            // Add the Note card to the content view
//            contentView.addArrangedSubview(cardView)
//        }

        private func addNotesCard(notes: Notes?) {
            guard let notesInfo = notes else { return }

            // Extract the content for the notes
            let firstContent = notesInfo.notesContent ?? "?"
            let otherContent = notesInfo.notesOtherContent ?? "?"

            // Create the Note card view
            let cardView = createCardView(
                title: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.NOTE.TITLE",
                    defaultText: "Note"
                ),
                iconName: "note_icon"
            )

            // Display the first content of the note
            addText(
                to: cardView,
                text: TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.NOTE.NOTE.DISPLAY",
                    defaultText: "Note: {{value}}"
                ).replacingOccurrences(of: "{{value}}", with: firstContent)
            )

            // Display the other content of the note if available
            if !otherContent.isEmpty && otherContent != "?" {
                addText(to: cardView, text: otherContent)
            }

            // Add the Note card to the content view
            contentView.addArrangedSubview(cardView)
        }

        
        // MARK: - Helper Methods
        
        // MARK: - Card Creation Methods
        private func createCardView(title: String, iconName: String, iconColor: UIColor? = nil) -> UIView {
            let cardView = UIView()
            cardView.backgroundColor = .systemBackground
            cardView.layer.cornerRadius = 12
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.05 // Reduced shadow opacity
            cardView.layer.shadowOffset = CGSize(width: 0, height: 1) // Smaller offset
            cardView.layer.shadowRadius = 2 // Reduced shadow radius
            cardView.translatesAutoresizingMaskIntoConstraints = false

            // Title Label
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            // Icon Image View
            let iconImageView = UIImageView(image: UIImage(named: iconName)?.withRenderingMode(.alwaysOriginal))
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            iconImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            // Apply optional icon color if provided
            if let color = iconColor {
                iconImageView.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = color
            }

            // Horizontal Stack View (Title on the left, Icon on the right)
            let containerStackView = UIStackView(arrangedSubviews: [titleLabel, iconImageView])
            containerStackView.axis = .horizontal
            containerStackView.spacing = 8
            containerStackView.alignment = .center
            containerStackView.distribution = .equalSpacing // Ensures the title and icon are spaced apart
            containerStackView.translatesAutoresizingMaskIntoConstraints = false

            // Main Stack View
            let mainStackView = UIStackView(arrangedSubviews: [containerStackView])
            mainStackView.axis = .vertical
            mainStackView.spacing = 12
            mainStackView.translatesAutoresizingMaskIntoConstraints = false

            // Add mainStackView to cardView
            cardView.addSubview(mainStackView)

            // Constraints
            NSLayoutConstraint.activate([
                mainStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
                mainStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
                mainStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
                mainStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
            ])

            return cardView
        }


        private func addText(to cardView: UIView, text: String, font: UIFont? = nil) {
            guard let mainStackView = cardView.subviews.first(where: { $0 is UIStackView }) as? UIStackView else {
                return
            }

            let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.font = font ?? UIFont.systemFont(ofSize: 14)
            label.textAlignment = .left // Align text to the left
            label.translatesAutoresizingMaskIntoConstraints = false

            mainStackView.addArrangedSubview(label)
        }
//        private func addDateTimeHeader() {
//            let headerStackView = UIStackView()
//            headerStackView.axis = .horizontal
//            headerStackView.alignment = .center
//            headerStackView.spacing = 8
//            headerStackView.translatesAutoresizingMaskIntoConstraints = false
//
//            let dateLabel = UILabel()
//            dateLabel.text = "Thu Nov 07, 2024" // Example date, replace with dynamic date if available
//            dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
//            dateLabel.textColor = .black
//
//            let timeLabel = UILabel()
//            timeLabel.text = "12:32 PM" // Example time, replace with dynamic time if available
//            timeLabel.font = UIFont.systemFont(ofSize: 13)
//            timeLabel.textColor = .gray
//
//            headerStackView.addArrangedSubview(dateLabel)
//            headerStackView.addArrangedSubview(timeLabel)
//
//            contentView.addArrangedSubview(headerStackView)
//        }
        
        private func addDateTimeHeader(entryInfoResponse: Entry, languageCode: String) {
            let headerStackView = UIStackView()
            headerStackView.axis = .horizontal
            headerStackView.alignment = .center
            headerStackView.spacing = 8
            headerStackView.translatesAutoresizingMaskIntoConstraints = false

            // Extract date and time from the entryInfoResponse
            let dateTimeString = entryInfoResponse.entryDate
            var formattedDate = "?"
            var formattedTime = "?"

//            // Format the date and time if available
//            if !dateTimeString.isEmpty {
//                let inputFormatter = DateFormatter()
//                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
//
//                let outputDateFormatter = DateFormatter()
//                outputDateFormatter.dateFormat = "EEE MMM dd, yyyy"
//
//                let outputTimeFormatter = DateFormatter()
//                outputTimeFormatter.dateFormat = "h:mm a"
//
//                if let date = inputFormatter.date(from: dateTimeString) {
//                    formattedDate = outputDateFormatter.string(from: date)
//                    formattedTime = outputTimeFormatter.string(from: date)
//                }
//            }

            // Format the date and time if available
            if !dateTimeString.isEmpty {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
                inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure parsing consistency

                let outputDateFormatter = DateFormatter()
                outputDateFormatter.dateFormat = "EEE MMM dd, yyyy"
                outputDateFormatter.locale = Locale(identifier: languageCode) // Set locale based on languageCode

                let outputTimeFormatter = DateFormatter()
                outputTimeFormatter.dateFormat = "h:mm a"
                outputTimeFormatter.locale = Locale(identifier: languageCode) // Set locale based on languageCode

                if let date = inputFormatter.date(from: dateTimeString) {
                    formattedDate = outputDateFormatter.string(from: date)
                    formattedTime = outputTimeFormatter.string(from: date)
                }
            }
            // Create and configure date label
            let dateLabel = UILabel()
            dateLabel.text = formattedDate
            dateLabel.font = UIFont.boldSystemFont(ofSize: 15)
            dateLabel.textColor = .black

            // Create and configure time label
            let timeLabel = UILabel()
            timeLabel.text = formattedTime
            timeLabel.font = UIFont.systemFont(ofSize: 13)
            timeLabel.textColor = .gray

            // Add labels to the stack view
            headerStackView.addArrangedSubview(dateLabel)
            headerStackView.addArrangedSubview(timeLabel)

            // Add the header stack view to the content view
            contentView.addArrangedSubview(headerStackView)
        }

        private func addSummaryText() {
            let summaryLabel = UILabel()
            summaryLabel.numberOfLines = 0
            summaryLabel.translatesAutoresizingMaskIntoConstraints = false

            // Define the summary text
            let summaryText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.ANALYSIS.ANALYSIS-HEADER.TEXT.2",
                defaultText: "Based on the information you have entered, we can extract the following information from the info library for you. Please refer to the info library for detailed information."
            )

            // Create a paragraph style with justified alignment and line spacing
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.lineSpacing = 4 // Adjust line spacing as needed

            // Create an attributed string with the paragraph style
            let attributedText = NSAttributedString(
                string: summaryText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
            )

            // Set the attributed text to the label
            summaryLabel.attributedText = attributedText

            // Add the label to the content view
            contentView.addArrangedSubview(summaryLabel)
        }

        private func addWarningMessage() {
            let warningStackView = UIStackView()
            warningStackView.axis = .horizontal
            warningStackView.alignment = .top // Align the icon at the top
            warningStackView.spacing = 8
            warningStackView.translatesAutoresizingMaskIntoConstraints = false

            let warningIcon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
            warningIcon.tintColor = .red
            warningIcon.translatesAutoresizingMaskIntoConstraints = false
            warningIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
            warningIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
            warningIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

            // Create the warning label
            let warningLabel = UILabel()
            warningLabel.numberOfLines = 0
            warningLabel.translatesAutoresizingMaskIntoConstraints = false

            // Create the semi-bold and justified attributed text
            let warningText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.ANALYSIS.ANALYSIS-HEADER.TEXT.1",
                defaultText: "Seek medical advice if {{name}} does not feel well, warning signs are present or the fever lasts longer than 3 days."
            ).replacingOccurrences(of: "{{name}}", with: profileName)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.lineSpacing = 4

            let attributedText = NSAttributedString(
                string: warningText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13, weight: .semibold), // Semi-bold font
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
            )

            // Set the attributed text to the label
            warningLabel.attributedText = attributedText

            // Add subviews to the stack view
            warningStackView.addArrangedSubview(warningIcon)
            warningStackView.addArrangedSubview(warningLabel)

            // Ensure the icon stays aligned at the top by setting vertical hugging priority
            warningIcon.setContentHuggingPriority(.required, for: .vertical)
            warningLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

            // Add the stack view to the content view
            contentView.addArrangedSubview(warningStackView)
        }

        private func addSummaryHeader() {
            let summaryLabel = UILabel()
            summaryLabel.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.ANALYSIS.ANALYSIS-HEADER.HEADING", defaultText: "Summary")
            summaryLabel.font = UIFont.boldSystemFont(ofSize: 15)
            summaryLabel.textColor = .black
            summaryLabel.translatesAutoresizingMaskIntoConstraints = false

            contentView.addArrangedSubview(summaryLabel)
        }
        private func addFooterText() {
            let footerLabel = UILabel()
            footerLabel.numberOfLines = 0
            footerLabel.translatesAutoresizingMaskIntoConstraints = false

            // Define the footer text
            let footerText = TranslationsViewModel.shared.getTranslation(key: "DIARY.ANALYSIS.ANALYSIS-FOOTER.TEXT.6-INFOS", defaultText: "To find out more, you are welcome to browse through the info library. There you will find a summarizing video and also information about what the doctor might ask.")

            // Create a paragraph style with justified alignment
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.lineSpacing = 4 // Adjust line spacing as needed

            // Create an attributed string with the paragraph style
            let attributedText = NSAttributedString(
                string: footerText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 13),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: paragraphStyle
                ]
            )

            // Set the attributed text to the label
            footerLabel.attributedText = attributedText

            // Add the label to the content view
            contentView.addArrangedSubview(footerLabel)
        }


    }

