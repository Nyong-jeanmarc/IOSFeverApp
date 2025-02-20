//
//  ExportPDFViewModel.swift
//  FeverApp ios
//
//  Created by user on 11/11/24.
//

//import Foundation
//import SwiftUI
//import PDFKit
//import Combine
//
//class ExportPDFViewModel: ObservableObject {
//    @Published var filteredFeverPhases: [FeverPhaseGraph] = []
//
//    // Mock Data - Replace with your actual data fetching
//    func getFilteredFeverPhases(profileId: Int64, selectedFeverPhaseIds: [Int64]) {
//        // Here you would fetch the data from your local or remote repository
//        let mockData = [
//            FeverPhaseGraph(feverPhaseId: 1, profileId: profileId, feverPhaseStartDate: "2024-01-01", feverPhaseEndDate: "2024-01-05", feverPhaseEntries: []),
//            FeverPhaseGraph(feverPhaseId: 2, profileId: profileId, feverPhaseStartDate: "2024-02-10", feverPhaseEndDate: "2024-02-15", feverPhaseEntries: [])
//        ]
//        filteredFeverPhases = mockData.filter { phase in
//            if let feverPhaseId = phase.feverPhaseId {
//                return selectedFeverPhaseIds.contains(feverPhaseId)
//            }
//            return false
//        }
//    }
//
//    func generateAndSavePdf(profile: ProfilePdfData, context: UIViewController, dismiss: @escaping () -> Void) {
//        // Generate PDF content
//        let pdfData = createPdfData(profile: profile, feverPhases: filteredFeverPhases)
//
//        // Save PDF to the Documents directory
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
//        let formattedDate = dateFormatter.string(from: Date())
//        let fileName = "fever_documentation_\(formattedDate).pdf"
//        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
//
//        do {
//            try pdfData.write(to: filePath)
//            print("PDF saved at: \(filePath)")
//
//            // Dismiss the bottom sheet first
//            dismiss()
//
//            // Present the PDF preview after dismissal
//            DispatchQueue.main.async {
//                self.openPdf(filePath: filePath, context: context)
//            }
//        } catch {
//            print("Error saving PDF: \(error.localizedDescription)")
//        }
//    }
//
//
//    private func createPdfData(profile: ProfilePdfData, feverPhases: [FeverPhaseGraph]) -> Data {
//        let pdfMetaData = [
//            kCGPDFContextCreator: "FeverApp",
//            kCGPDFContextAuthor: profile.profileName
//        ]
//        let format = UIGraphicsPDFRendererFormat()
//        format.documentInfo = pdfMetaData as [String: Any]
//
//        let pageWidth = 8.5 * 72.0
//        let pageHeight = 11 * 72.0
//        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)
//
//        let data = pdfRenderer.pdfData { context in
//            context.beginPage()
//
//            // Title
//            let title = "Fever Phase Report"
//            title.draw(at: CGPoint(x: 20, y: 20), withAttributes: [.font: UIFont.boldSystemFont(ofSize: 20)])
//
//            // Profile Information
//            let profileInfo = "Name: \(profile.profileName)\nGender: \(profile.profileGender)\nDOB: \(profile.profileDateOfBirth)"
//            profileInfo.draw(at: CGPoint(x: 20, y: 60), withAttributes: [.font: UIFont.systemFont(ofSize: 14)])
//
//            // Fever Phases
//            var yPosition = 120.0
//            for phase in feverPhases {
//                let phaseInfo = "Phase ID: \(String(describing: phase.feverPhaseId))\nStart Date: \(String(describing: phase.feverPhaseStartDate))\nEnd Date: \(String(describing: phase.feverPhaseEndDate))"
//                phaseInfo.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: [.font: UIFont.systemFont(ofSize: 12)])
//                yPosition += 60
//            }
//        }
//
//        return data
//    }
//
//    private func openPdf(filePath: URL, context: UIViewController) {
//        let documentController = UIDocumentInteractionController(url: filePath)
//        documentController.delegate = context as? UIDocumentInteractionControllerDelegate
//
//        guard documentController.delegate != nil else {
//            print("Error: UIDocumentInteractionController delegate is not set.")
//            return
//        }
//
//        // Present the PDF preview
//        documentController.presentPreview(animated: true)
//    }
//
//
//}

import Foundation
import SwiftUI
import PDFKit
import UIKit

class ExportPDFViewModel: ObservableObject {
    private var documentController: UIDocumentInteractionController?


    @Published var filteredFeverPhases: [FeverPhaseGraph] = []

    func generateAndSavePdf(profile: ProfilePdfData, feverPhases: [FeverPhaseGraph], context: UIViewController, dismiss: @escaping () -> Void) {
        let pdfData = createPdfData(profile: profile, feverPhases: feverPhases)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let fileName = "fever_documentation_\(dateFormatter.string(from: Date())).pdf"
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)

        do {
            try pdfData.write(to: filePath)
            dismiss()
            DispatchQueue.main.async {
                self.openPdf(filePath: filePath, context: context)
            }
        } catch {
            print("Error saving PDF: \(error.localizedDescription)")
        }
    }

    private func createPdfData(profile: ProfilePdfData, feverPhases: [FeverPhaseGraph]) -> Data {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, currentLanguage) = appDelegate.fetchUserLanguage()
        
        let pdfMetaData = [
            kCGPDFContextCreator: "FeverApp",
            kCGPDFContextAuthor: profile.profileName
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), format: format)

        let data = pdfRenderer.pdfData { context in
            // First page - profile information
            context.beginPage()
            drawFirstPage(profile: profile, context: context)
            
            // Date formatter for parsing and displaying dates
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust this based on your input date format
            
            let displayDateFormatter = DateFormatter()
            displayDateFormatter.dateFormat = "EEEE dd.MM.yyyy" // Format as 'Monday 11.11.2024'
            displayDateFormatter.locale = Locale(identifier: languageCode!)
            
            // Iterate through each fever phase
            for feverPhase in feverPhases {
                // Parse and format the start and end date for the fever phase
                let startDateString = feverPhase.feverPhaseStartDate ?? "Unknown Start Date"
                let endDateString = feverPhase.feverPhaseEndDate ?? "Unknown End Date"
                
                let startDate = inputDateFormatter.date(from: startDateString).flatMap { displayDateFormatter.string(from: $0) } ?? "Unknown Start Date"
                let endDate = inputDateFormatter.date(from: endDateString).flatMap { displayDateFormatter.string(from: $0) } ?? "Unknown End Date"
                
                let feverPhaseInfoText = "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARY-CHART.TEXT.1", defaultText: "fever phase")) \(startDate) - \(endDate)"
                
                // Draw the fever phase header
                context.beginPage()
                drawFeverPhaseHeader(feverPhase: feverPhase, context: context)
                
                // Flag to track if we are on the first entry of the fever phase
                var isFirstEntry = true
                
                // Iterate through each entry within the fever phase
                for entry in feverPhase.feverPhaseEntries ?? [] {
                    if !isFirstEntry {
                        // Start a new page for each subsequent entry
                        context.beginPage()
                    }
                    
                    // Draw entry date header and details for the current entry
                    drawEntryDateHeader(entry: entry, context: context)
                    drawFeverPhaseEntry(entry: entry, context: context, profile:profile)
                    
                    // Add footer for each entry page
                    let entryFooter = FooterContent(userFamilyCode: profile.familyCode, feverPhaseInfo: feverPhaseInfoText, profileName: profile.profileName)
                    drawFooterContent(context: context, footerContent: entryFooter)
                    
                    // After the first entry, subsequent entries will start on a new page
                    isFirstEntry = false
                }
                
                // Extract the graph data for the current fever phase
                let (yData, xData, dateLabels, iconsData) = getGraphData(from: feverPhase.feverPhaseEntries ?? [])

//                let xDataS: [Float] = [ 3,  5]
//                let yDataS: [Float] = [ 39.0, 40.0]
//                let dateLabels = ["01.01", "06.01"]
                
                
                // Ensure there is data to draw
                if !xData.isEmpty && !yData.isEmpty {
                    print("Debug: dateLabels = \(dateLabels)")
                    print("Debug: xData = \(xData)")
                    print("Debug: yData = \(yData)")
                    context.beginPage()

                    // Define the page dimensions
                    let pageWidth: CGFloat = 600
                    let pageHeight: CGFloat = 800

                    // Define the height of the header section
                    let headerHeight: CGFloat = 80.0

                    // Draw the header first
                    if let lastEntry = feverPhase.feverPhaseEntries?.last {
                        drawGraphDateHeader(entry: lastEntry, context: context)
                    } else {
                        // Handle the case where the array is nil or empty
                        print("feverPhaseEntries array is nil or empty")
                    }

                    // Check and draw the background image starting after the header
                    if let backgroundImage = UIImage(named: "graph_bg") {
                        let bgWidth: CGFloat = pageWidth * 0.6
                        let bgOffsetX: CGFloat = (pageWidth - bgWidth) / 2
                        let bgStartY: CGFloat = headerHeight + 10.0 // Start the image slightly below the header
                        let bgHeight: CGFloat = pageHeight - bgStartY - 40.0 // Leave space at the bottom for the footer
                        let bgRect = CGRect(x: bgOffsetX, y: bgStartY, width: bgWidth, height: bgHeight)
                        backgroundImage.draw(in: bgRect)
                    }

                    // Draw the graph, starting after the header and below the background image
                    let graphStartY: CGFloat = headerHeight + 20.0
                    drawGraph(
                        context: context,
                        xData: xData,
                        yData: yData,
                        pageWidth: pageWidth,
                        pageHeight: pageHeight,
                        startY: graphStartY,
                        dateLabels: dateLabels,
                        iconsDataList: iconsData,
                        backgroundImage: UIImage(named: "graph_bg") ?? UIImage()
                    )

                    // Add footer content for the graph page
                    let graphFooter = FooterContent(userFamilyCode: profile.familyCode, feverPhaseInfo: feverPhaseInfoText, profileName: profile.profileName)
                    drawFooterContent(context: context, footerContent: graphFooter)
                }

            }}
        return data
    }

    private func drawFirstPage(profile: ProfilePdfData, context: UIGraphicsPDFRendererContext) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, _) = appDelegate.fetchUserLanguage()
        
        var  genderValue: String = ""
        
        // Title
        let title = "\(TranslationsViewModel.shared.getTranslation(key: "PDF_EXPORT.FEVER_DOCUMENTATION", defaultText: "Fever documentation")) \(profile.profileName)"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .paragraphStyle: centeredParagraphStyle()
        ]
        title.draw(in: CGRect(x: 0, y: 50, width: context.pdfContextBounds.width, height: 30), withAttributes: titleAttributes)
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX") // Specify the locale for input date parsing

        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateStyle = .medium // Customize the date style
        displayDateFormatter.timeStyle = .short // Customize the time style
        displayDateFormatter.locale = Locale(identifier: languageCode!) // Specify the target locale for display

        let dobString = profile.profileDateOfBirth

        // Format the start and end dates
        let formattedDob = inputDateFormatter.date(from: dobString).flatMap { displayDateFormatter.string(from: $0) } ?? "Unknown"

        // Date of birth and Gender
        let dobLabel = "\(TranslationsViewModel.shared.getTranslation(key: "PDF_EXPORT.DATE_OF_BIRTH", defaultText: "Date of birth")):"
        let dobValue = formattedDob
        let genderLabel = "\(TranslationsViewModel.shared.getTranslation(key: "PDF_EXPORT.GENDER", defaultText: "Gender")):"
       
        if (profile.profileGender == "MALE") {
            genderValue = TranslationsViewModel.shared.getTranslation(key: "PROFILE.GENDER.OPTION.1.LABEL", defaultText: "Male")
        } else if (profile.profileGender == "FEMALE") {
            genderValue = TranslationsViewModel.shared.getTranslation(key: "PROFILE.GENDER.OPTION.2.LABEL", defaultText: "Female")
        } else if (profile.profileGender == "VARIOUS") {
            genderValue = TranslationsViewModel.shared.getTranslation(key: "PROFILE.GENDER.OPTION.3.LABEL", defaultText: "Various")
        }

        let labelAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
//        let valueAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]

        // Create a right-aligned paragraph style
        let rightAlignedStyle = NSMutableParagraphStyle()
        rightAlignedStyle.alignment = .right

        // Update value attributes to include the right-aligned style
        let rightAlignedValueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .paragraphStyle: rightAlignedStyle
        ]

        // New horizontal margin for improved centering
        let labelXPosition = 120.0
        let valueXPosition = context.pdfContextBounds.width - 200.0

        dobLabel.draw(at: CGPoint(x: labelXPosition, y: 150), withAttributes: labelAttributes)
        dobValue.draw(at: CGPoint(x: valueXPosition, y: 150), withAttributes: rightAlignedValueAttributes)

        genderLabel.draw(at: CGPoint(x: labelXPosition, y: 180), withAttributes: labelAttributes)
        genderValue.draw(at: CGPoint(x: valueXPosition, y: 180), withAttributes: rightAlignedValueAttributes)


        // Logo and App Name
        if let logoImage = UIImage(named: "fever_app_logo") {
            // Position the logo on the left
            let logoRect = CGRect(x: (context.pdfContextBounds.width - 200) / 2 - 40, y: 305, width: 60, height: 60)
            logoImage.draw(in: logoRect)
        }

        // Updated app name with increased size
        let appName = "FeverApp"
        let appNameAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 40),  // Increased font size
            .paragraphStyle: centeredParagraphStyle()
        ]

        // Draw the app name text next to the logo
        let appNameXPosition = (context.pdfContextBounds.width - 180) / 2 + 10
        appName.draw(in: CGRect(x: appNameXPosition, y: 310, width: 200, height: 50), withAttributes: appNameAttributes)

        // Updated website link with increased spacing
        let website = "www.feverapp.de"
        let websiteAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),  // Increased font size
            .paragraphStyle: centeredParagraphStyle()
        ]
        website.draw(in: CGRect(x: 0, y: 370, width: context.pdfContextBounds.width, height: 30), withAttributes: websiteAttributes)


        // Footer
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: languageCode!) // Set your desired locale (e.g., French)

        let localizedDateString = dateFormatter.string(from: Date())
        print(localizedDateString)
        
        let effectiveDate = "\(TranslationsViewModel.shared.getTranslation(key: "PDF_EXPORT.EFFECTIVE", defaultText: "Effective")) \(localizedDateString)"
        let footerAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .paragraphStyle: rightAlignedParagraphStyle()
        ]
        effectiveDate.draw(in: CGRect(x: 0, y: context.pdfContextBounds.height - 40, width: context.pdfContextBounds.width - 20, height: 20), withAttributes: footerAttributes)
    }

    private func drawFeverPhaseHeader(feverPhase: FeverPhaseGraph, context: UIGraphicsPDFRendererContext) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, currentLanguage) = appDelegate.fetchUserLanguage()
        
        // Date formatter setup
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Matches the input format

        
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "EEEE dd.MM.yyyy" // Desired output format
        displayDateFormatter.locale = Locale(identifier: languageCode!)

        // Parse and format start and end dates
        let startDateString = feverPhase.feverPhaseStartDate ?? "Unknown"
        let endDateString = feverPhase.feverPhaseEndDate ?? "Unknown"
        let startDate = inputDateFormatter.date(from: startDateString).flatMap { displayDateFormatter.string(from: $0) } ?? "Unknown"
        let endDate = inputDateFormatter.date(from: endDateString).flatMap { displayDateFormatter.string(from: $0) } ?? "Unknown"
        
        // Header text with formatted dates
        let headerText = "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARY-CHART.TEXT.1", defaultText: "fever phase ")) \(startDate) - \(endDate)"
        
        // Center-aligned text attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .paragraphStyle: paragraphStyle
        ]
        
        // Draw the centered fever phase header
        headerText.draw(in: CGRect(x: 0, y: 50, width: context.pdfContextBounds.width, height: 30), withAttributes: attributes)
    }

    private func drawEntryDateHeader(entry: FeverPhaseEntry, context: UIGraphicsPDFRendererContext) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, currentLanguage) = appDelegate.fetchUserLanguage()
        
        // Date formatter setup
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" // Matches the input format

        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "EEEE dd.MM.yyyy" // Desired output format
        displayDateFormatter.locale = Locale(identifier: languageCode!)
        

        // Parse and format entry date
        let entryDateString = entry.entryDate ?? "Unknown Date"
        let entryDate = inputDateFormatter.date(from: entryDateString).flatMap { displayDateFormatter.string(from: $0) } ?? "Unknown Date"
        
        // Center-aligned text attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle
        ]
        
        // Draw the centered entry date header
        entryDate.draw(in: CGRect(x: 0, y: 80, width: context.pdfContextBounds.width, height: 20), withAttributes: dateAttributes)
    }

    private func drawGraphDateHeader(entry: FeverPhaseEntry, context: UIGraphicsPDFRendererContext) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, currentLanguage) = appDelegate.fetchUserLanguage()
        
        // Date formatter setup
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" // Matches the input format

        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "EEEE dd.MM.yyyy" // Desired output format
        displayDateFormatter.locale = Locale(identifier: languageCode!)
        

        // Parse and format entry date
        let entryDateString = entry.entryDate ?? "Unknown Date"
        let entryDate = inputDateFormatter.date(from: entryDateString).flatMap { displayDateFormatter.string(from: $0) } ?? "Unknown Date"
        
        // Center-aligned text attributes
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle
        ]
        
        // Draw the centered entry date header
        entryDate.draw(in: CGRect(x: 0, y: 40, width: context.pdfContextBounds.width, height: 20), withAttributes: dateAttributes)
    }
    private func drawFeverPhaseEntry(entry: FeverPhaseEntry, context: UIGraphicsPDFRendererContext, profile: ProfilePdfData) {
        var yPosition = 120.0
        let bottomMargin = 50.0
        let rightMargin = 20.0
        let pageWidth = context.pdfContextBounds.width

        func drawEntry(iconName: String, title: String, value: String) {
            // Ensure we do not overlap with the footer
            if yPosition > context.pdfContextBounds.height - bottomMargin {
                context.beginPage() // Start a new page if yPosition exceeds page height
                yPosition = 120.0 // Reset yPosition for the new page
            }

            if let iconImage = UIImage(named: iconName) {
                let iconRect = CGRect(x: 40, y: yPosition, width: 20, height: 20)
                iconImage.draw(in: iconRect)
            }

            let titleX = 80.0
            let valueX = 250.0 // Increased valueX to create more space between the title and the value
            let valueMaxWidth = pageWidth - valueX - rightMargin

            let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
            title.draw(at: CGPoint(x: titleX, y: yPosition), withAttributes: titleAttributes)

            let valueAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
            let valueRect = CGRect(x: valueX, y: yPosition, width: valueMaxWidth, height: .greatestFiniteMagnitude)
            value.draw(with: valueRect, options: .usesLineFragmentOrigin, attributes: valueAttributes, context: nil)

            yPosition += 80 // Adjust the spacing between entries if needed
        }


        // State of Health
        if let stateOfHealth = entry.stateOfHealth?.stateOfHealth {
            let icon = getStateOfHealthIcon(stateOfHealth: stateOfHealth)
            let value = getStateOfHealthText(stateOfHealth: stateOfHealth, profileName: profile.profileName)
            drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.TITLE", defaultText: "State of health")):", value: value)
        }
        // Temperature
        if let temperature = entry.temperature {
            let icon = "thermomether"
            var value = ""

            if let tempValue = temperature.temperatureValue {
                value += "\(tempValue)°C\n"
            }
            if let extremitiesComparison = temperature.temperatureComparedToForehead {
                let extremitiesText = getTemperatureExtremitiesText(temperatureComparison: extremitiesComparison)
                value += "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.DISPLAY", defaultText: "Extremitäten: {{value}}").replacingOccurrences(of: "{{value}}", with: extremitiesText))\n"
            }
            if let location = temperature.temperatureMeasurementLocation {
                let locationText = getTemperatureLocationText(locationDescription: location)
                value += "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.DISPLAY", defaultText: "Place: {{value}}").replacingOccurrences(of: "{{value}}", with: locationText))"
            }

            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TITLE", defaultText: "Temperature")):", value: value)
            }
        }

        // Pain
        if let pain = entry.pains {
            let icon = getPainIcon(painSeverity: pain.painSeverityScale)
            var value = ""

            if let painSeverity = pain.painSeverityScale {
                let severityText = getPainSeverityText(painSeverityScale: painSeverity)
                value += "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.PAIN.PAIN_INTENSITY.DISPLAY", defaultText: "Strength: {{value}}").replacingOccurrences(of: "{{value}}", with: severityText))\n"
            }
            if let painLocations = pain.painValue {
                let painResponses = getPainResponses(painValue: painLocations, otherPlaces: pain.otherPlaces ?? "").joined(separator: ", ")
                value += "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.DISPLAY", defaultText: "Place: {{value}}").replacingOccurrences(of: "{{value}}", with: painResponses))"
            }

            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.PAIN.TITLE", defaultText: "Pain")):", value: value)
            }
        }

        // Liquids (Dehydration)
        if let liquids = entry.liquids, let dehydrationSigns = liquids.dehydrationSigns {
            let icon = "liquids_one"
            let value = getLiquidResponses(liquidValue: dehydrationSigns).joined(separator: ", ")
            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DRINK.TITLE", defaultText: "Liquids")):", value: value)
            }
        }

        // Diarrhea
        if let diarrhea = entry.diarrhea, let diarrheaValue = diarrhea.diarrheaAndOrVomiting {
            let icon = "ic_diaarhea_graph"
            let value = getDiarrheaResponse(diarrheaValue: diarrheaValue)
            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARRHEA.TITLE", defaultText: "Diarrhea")):", value: value)
            }
        }

        // Symptoms
        if let symptoms = entry.symptoms, let symptomValues = symptoms.symptoms {
            let icon = "clipboard"
            let symptomResponses = getSymptomResponses(symptomValues: symptomValues).joined(separator: ", ")
            if !symptomResponses.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.SYMPTOMS.TITLE", defaultText: "Symptoms")):", value: symptomResponses)
            }
        }

        // Rash
        if let rash = entry.rash, let rashValues = rash.rashes {
            let icon = "rash"
            let value = getRashResponse(rashValue: rashValues)
            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.RASH.TITLE", defaultText: "Rash")):", value: value)
            }
        }

        // Warning Signs
        if let warningSigns = entry.warningSigns, let signs = warningSigns.warningSigns {
            let icon = "warning_new"
            let value = getWarningSignsResponses(warningSignsValues: signs).joined(separator: ", ")
            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.WARNING_SIGNS.TITLE", defaultText: "Warning signs")):", value: value)
            }
        }

        // Confidence Level
        if let confidenceLevel = entry.confidenceLevel?.confidenceLevel {
            let icon = getConfidenceLevelIcon(confidenceLevel: confidenceLevel)
            let value = getConfidenceLevelText(confidenceLevel: confidenceLevel, profileName: profile.profileName)
            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.CONFIDENCE.TITLE", defaultText: "Feeling confident")):", value: value)
            }
        }

        // Measures
        if let measures = entry.measures {
            let icon = "hand"
            var value = ""

            if let takeMeasures = measures.takeMeasures {
                value += getInjectionOptionText(injectionOption: takeMeasures) + "\n"
            }
            if let measuresList = measures.measures {
                value += getMeasures(measuresInfo: measuresList).joined(separator: ", ")
            }

            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.MEASURE.TITLE", defaultText: "Measures")):", value: value)
            }
        }

        // Notes
        if let notes = entry.notes?.notesContent {
            let icon = "notes"
            if !notes.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.NOTE.TITLE", defaultText: "Notes")):", value: notes)
            }
        }

        // Medications
        if let medications = entry.medications, let hasTakenMedication = medications.hasTakenMedication {
            let icon = "pills"
            let value = getInjectionOptionText(injectionOption: hasTakenMedication)
            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "MEDICATION_INPUT.VALUE_LABEL_PLURAL", defaultText: "Medications")):", value: value)
            }
        }

        // Contact with Doctor
        if let contact = entry.contactWithDoctor {
            let icon = "doctorbag_icon"
            var value = ""

            let contactText = getDoctorContactedText(hasHadMedicalContact: contact.hasHadMedicalContact)
                value += contactText + "\n"
            
            if let reasonForContact = contact.reasonForContact {
                value += "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_REASON.DISPLAY", defaultText: "Reason: {{value}}").replacingOccurrences(of: "{{value}}", with: getReasonsForContact(reasonsForContactValue: reasonForContact).joined(separator: ", ")))\n"
            }
            if let diagnosis = contact.doctorDiagnoses?.joined(separator: ", ") {
                value += "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DOCTOR.DOCTOR_DIAGNOSIS.DISPLAY", defaultText: "Diagnosis: {{value}}").replacingOccurrences(of: "{{value}}", with: diagnosis))\n"
            }

            if !value.isEmpty {
                drawEntry(iconName: icon, title: "\(TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.6", defaultText: "Doctor's contact")):", value: value)
            }
        }

    }

    private func drawFooterContent(context: UIGraphicsPDFRendererContext, footerContent: FooterContent) {
        let footerFamilyCode = footerContent.userFamilyCode
        let footerPhaseInfo = footerContent.feverPhaseInfo
        let footerProfileName = footerContent.profileName

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .paragraphStyle: paragraphStyle
        ]

        // Define larger rectangles for each footer section to accommodate longer text
        let leftRect = CGRect(x: 20, y: context.pdfContextBounds.height - 50, width: 170, height: 40)
        let centerRect = CGRect(x: (context.pdfContextBounds.width / 2) - 75, y: context.pdfContextBounds.height - 50, width: 170, height: 40)
        let rightRect = CGRect(x: context.pdfContextBounds.width - 170, y: context.pdfContextBounds.height - 50, width: 170, height: 40)

        // Draw each footer element centered and wrapped within its rectangle
        footerFamilyCode.draw(in: leftRect, withAttributes: attributes)
        footerPhaseInfo.draw(in: centerRect, withAttributes: attributes)
        footerProfileName.draw(in: rightRect, withAttributes: attributes)
    }



    private func drawGraphImage(image: UIImage, context: UIGraphicsPDFRendererContext) {
        let imageRect = CGRect(x: 20, y: 20, width: 500, height: 300)
        image.draw(in: imageRect)
    }

    private func centeredParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return paragraphStyle
    }

    private func rightAlignedParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        return paragraphStyle
    }

    // PDF graph implementation begins
    private func getGraphData(from entries: [FeverPhaseEntry]) -> ([Float], [Float], [String], [[String]]) {
        var yData: [Float] = []
        var xData: [Float] = []
        var dateLabels: [String] = []
        var iconsDataList: [[String]] = [] // List of icon lists for each entry

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "dd.MM"

        var currentXValue: Float = 0

        // Extract the xData (time in float), yData (temperature value), and determine the icons for each entry
        for entry in entries {
            var iconsData: [String] = [] // Icons for the current entry

            // Extract temperature value
            if let temperatureValue = entry.temperature?.temperatureValue {
                let tempValue = Float(temperatureValue)
                yData.append(tempValue)
            }

            // Extract date label
            if let dateTime = entry.entryDate,
               let date = dateFormatter.date(from: dateTime) {
                let formattedDate = displayDateFormatter.string(from: date)
                dateLabels.append(formattedDate)
                xData.append(currentXValue)
                currentXValue += 1.0
            }

            // Determine the icons based on entry attributes (add all matching icons)
            if entry.stateOfHealth != nil {
                iconsData.append("ic_state_new")
            }
            if entry.pains != nil {
                iconsData.append("ic_pain_graph")
            }
            if entry.liquids != nil {
                iconsData.append("ic_liquid_graph")
            }
            if entry.diarrhea != nil {
                iconsData.append("ic_diaarhea_graph")
            }
            if entry.warningSigns != nil {
                iconsData.append("ic_warning_new")
            }
            if entry.measures != nil {
                iconsData.append("ic_measure_new")
            }
            if let confidenceLevel = entry.confidenceLevel?.confidenceLevel {
                    iconsData.append("ic_confident_new")
            }
            if entry.contactWithDoctor != nil {
                iconsData.append("ic_doctor_new")
            }
            // If no icons were added, append a default icon
            if iconsData.isEmpty {
                iconsData.append("default_icon")
            }

            // Add the current entry's icons to the icons list
            iconsDataList.append(iconsData)
        }

        return (yData, xData, dateLabels, iconsDataList)
    }


//    private func getGraphData(from entries: [FeverPhaseEntry]) -> ([Float], [Float], [String]) {
//        var yData: [Float] = []
//        var xData: [Float] = []
//        var dateLabels: [String] = []
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//
//        let displayDateFormatter = DateFormatter()
//        displayDateFormatter.dateFormat = "dd.MM"
//
//        var currentXValue: Float = 0
//
//        // Extract the xData (time in float) and yData (temperature value)
//        for entry in entries {
//            if let temperatureValue = entry.temperature?.temperatureValue {
//                let tempValue = Float(temperatureValue)
//                yData.append(tempValue)
//            }
//
//            if let dateTime = entry.temperature?.temperatureDateTime,
//               let date = dateFormatter.date(from: dateTime) {
//                let formattedDate = displayDateFormatter.string(from: date)
//                dateLabels.append(formattedDate)
//                xData.append(currentXValue)
//                currentXValue += 1.0 // Increment x value for each new entry
//            }
//        }
//
//        return (yData, xData, dateLabels)
//    }

    private func formatDate(_ dateTime: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensures proper parsing
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if let date = dateFormatter.date(from: dateTime) {
            dateFormatter.dateFormat = "dd.MM"
            return dateFormatter.string(from: date)
        }

        return ""
    }
 
    private func drawGraph(
        context: UIGraphicsPDFRendererContext,
        xData: [Float],
        yData: [Float],
        pageWidth: CGFloat,
        pageHeight: CGFloat,
        startY: CGFloat,
        dateLabels: [String],
        iconsDataList: [[String]],
        backgroundImage: UIImage
    ) {
        guard !xData.isEmpty, !yData.isEmpty else { return }

        // Define reduced width for the background image
        let bgWidth = pageWidth * 0.6
        let bgOffsetX = (pageWidth - bgWidth) / 2
        let bgOffsetY = pageHeight - 300

        let bgRect = CGRect(
            x: bgOffsetX ,
            y: bgOffsetY,
            width: bgWidth,
            height: pageHeight - 500
        )
        backgroundImage.draw(in: bgRect)

        // graph width
        let reducedWidth = pageWidth * 0.8
        let horizontalOffset = (pageWidth - reducedWidth) / 2

        // Graph area settings
        let horizontalPadding: CGFloat = 20.0
        let graphHeight: CGFloat = 350.0
        let graphWidth: CGFloat = reducedWidth - 2 * horizontalPadding
        let graphStartY: CGFloat = startY + 20.0

        // Define margin for plot points (10% of the graph width on each side)
        let plotMargin: CGFloat = graphWidth * 0.1
        let xScale = (graphWidth - 2 * plotMargin) / CGFloat(max(1, xData.count - 1))

        // Adjust the starting X position to include plot margin
        let graphStartX: CGFloat = horizontalOffset + horizontalPadding + plotMargin

        // Y-Axis range from 35 to 42
        let minY: CGFloat = 35.0
        let maxY: CGFloat = 42.0
        let yScale = graphHeight / (maxY - minY)

        // Increase the thickness of the Y-axis line
        let yAxisLineWidth: CGFloat = 3.0

        // Draw the vertical Y-axis line with gradient color
        let gradientColors = [
            UIColor.blue.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor,
            UIColor.red.cgColor
        ]
        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: gradientColors as CFArray,
            locations: [0.0, 0.25, 0.5, 0.75, 1.0]
        )

        context.cgContext.saveGState()
        let linePath = CGMutablePath()
        linePath.move(to: CGPoint(x: graphStartX - 45, y: graphStartY))
        linePath.addLine(to: CGPoint(x: graphStartX - 45, y: graphStartY + graphHeight))

        context.cgContext.setLineWidth(yAxisLineWidth)
        context.cgContext.addPath(linePath)
        context.cgContext.replacePathWithStrokedPath()
        context.cgContext.clip()

        let yAxisStart = CGPoint(x: graphStartX - 10, y: graphStartY)
        let yAxisEnd = CGPoint(x: graphStartX - 10, y: graphStartY + graphHeight)
        context.cgContext.drawLinearGradient(gradient!, start: yAxisStart, end: yAxisEnd, options: [])
        context.cgContext.restoreGState()

        // Draw the X-axis line
        context.cgContext.setStrokeColor(UIColor.gray.cgColor)
        context.cgContext.setLineWidth(2.0)
        context.cgContext.move(to: CGPoint(x: graphStartX - plotMargin, y: graphStartY + graphHeight))
        context.cgContext.addLine(to: CGPoint(x: graphStartX + graphWidth - plotMargin, y: graphStartY + graphHeight))
        context.cgContext.strokePath()

        // Draw the temperature points with adjusted margins
        for (index, temperature) in yData.enumerated() {
            let xPosition: CGFloat
            if yData.count == 1 {
                // Center the single point in the graph area
                xPosition = graphStartX + (graphWidth - 2 * plotMargin) / 2
            } else {
                // Calculate the xPosition with plot margin
                xPosition = graphStartX + CGFloat(index) * xScale
            }

            let yPosition = graphStartY + graphHeight - ((CGFloat(temperature) - minY) * yScale)

            // Draw the larger blue circle
            let pointRadius: CGFloat = 12.0
            let smallerCircleRadius: CGFloat = 6.0

            let pointRect = CGRect(
                x: xPosition - pointRadius,
                y: yPosition - pointRadius,
                width: pointRadius * 2,
                height: pointRadius * 2
            )

            let pointColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
            context.cgContext.setFillColor(pointColor.cgColor)
            context.cgContext.fillEllipse(in: pointRect)

            // Draw the smaller white circle
            let smallerCircleRect = CGRect(
                x: xPosition - smallerCircleRadius,
                y: yPosition - smallerCircleRadius,
                width: smallerCircleRadius * 2,
                height: smallerCircleRadius * 2
            )
            context.cgContext.setFillColor(UIColor.white.cgColor)
            context.cgContext.fillEllipse(in: smallerCircleRect)

            // Draw the temperature value above the circle
            let temperatureText = "\(temperature)°C" as NSString
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.black
            ]
            let textSize = temperatureText.size(withAttributes: textAttributes)
            temperatureText.draw(
                at: CGPoint(x: xPosition - textSize.width / 2, y: yPosition - pointRadius - textSize.height - 2),
                withAttributes: textAttributes
            )
        }

        // Draw Y-axis labels (without displaying 35 and 42)
        for i in stride(from: minY + 1.0, to: maxY, by: 1.0) {
            let yPosition = graphStartY + graphHeight - ((i - minY) * yScale)
            let label = "\(Int(i))°C" as NSString
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 10),
                .foregroundColor: UIColor.black
            ]
            label.draw(at: CGPoint(x: graphStartX - 80, y: yPosition - 7), withAttributes: attributes)
        }
        // Draw X-axis labels (dates) and multiple icons below the X-axis
           let iconSize: CGFloat = 30.0
        for (index, dateLabel) in dateLabels.enumerated() {
//            let xPosition = graphStartX + CGFloat(index) * xScale
            let xPosition: CGFloat
            if xData.count == 1 {
                // Center the single date label and icons in the graph area
                xPosition = graphStartX + (graphWidth - 2 * plotMargin) / 2
            } else {
                // Calculate the xPosition with plot margin for multiple points
                xPosition = graphStartX + CGFloat(index) * xScale
            }
            
            // Draw the date label
            let dateText = dateLabel as NSString
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.black
            ]
            let dateSize = dateText.size(withAttributes: dateAttributes)
            dateText.draw(at: CGPoint(x: xPosition - dateSize.width / 2, y: graphStartY + graphHeight + 5), withAttributes: dateAttributes)
            
            // Draw the icons below the date label
            if index < iconsDataList.count {
                let icons = iconsDataList[index]
                var iconOffsetY: CGFloat = graphStartY + graphHeight + dateSize.height + 10
                
                for iconName in icons {
                    if let iconImage = UIImage(named: iconName) {
                        let iconRect = CGRect(
                            x: xPosition - iconSize / 2,
                            y: iconOffsetY,
                            width: iconSize,
                            height: iconSize
                        )
                        iconImage.draw(in: iconRect)
                        iconOffsetY += iconSize + 5.0 // Move the next icon down
                    }
                }
            }
        }
    }

    
//    private func openPdf(filePath: URL, context: UIViewController) {
//        let documentController = UIDocumentInteractionController(url: filePath)
//        documentController.delegate = context as? UIDocumentInteractionControllerDelegate
//
//        if documentController.delegate != nil {
//            documentController.presentPreview(animated: true)
//        } else {
//            print("Error: UIDocumentInteractionController delegate is not set.")
//        }
//    }
    private func openPdf(filePath: URL, context: UIViewController) {
        let documentController = UIDocumentInteractionController(url: filePath)
        documentController.delegate = context as? UIDocumentInteractionControllerDelegate

        if documentController.delegate != nil {
            documentController.presentPreview(animated: true)
        } else {
            print("Error: UIDocumentInteractionController delegate is not set.")
        }
    }

}

// Helper functions to get the text responses based on the provided values

func getStateOfHealthText(stateOfHealth: String?, profileName: String) -> String {
    switch stateOfHealth {
    case "VERY_SICK":
        return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.0.TEXT", defaultText: "{{name}} feels very unwell").replacingOccurrences(of: "{{name}}", with: profileName)
    case "UNWELL":
        return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.1.TEXT", defaultText: "{{name}} feels unwell").replacingOccurrences(of: "{{name}}", with: profileName)
    case "NEUTRAL":
        return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.2.TEXT", defaultText: "{{name}} feels neither well nor unwell").replacingOccurrences(of: "{{name}}", with: profileName)
    case "FINE":
        return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.3.TEXT", defaultText: "{{name}} feels fine").replacingOccurrences(of: "{{name}}", with: profileName)
    case "EXCELLENT":
        return TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.4.TEXT", defaultText: "{{name}} feels very well").replacingOccurrences(of: "{{name}}", with: profileName)
    default:
        return "\("\(profileName)'s" + " " + TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.TITLE", defaultText: "State of health"))"
    }
}

func getTemperatureExtremitiesText(temperatureComparison: String?) -> String {
    switch temperatureComparison {
    case "EQUALLY_WARM_OR_WARMER_HANDS_AND_FEET":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.OPTION.1.DISPLAYLABEL",
            defaultText: "equally warm or warmer hands and/or feet"
        )
    case "COOLER_HANDS_AND_FEET":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TEMPERATURE_EXTREMITIES.OPTION.2.DISPLAYLABEL",
            defaultText: "cooler hands and/or cooler feet"
        )
    default:
        return ""
    }
}

func getTemperatureLocationText(locationDescription: String?) -> String {
    switch locationDescription {
    case "IN_THE_RECTUM":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.1.LABEL",
            defaultText: "In the rectum"
        )

    case "IN_THE_EAR":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.2.LABEL",
            defaultText: "In the ear"
        )

    case "IN_THE_MOUTH":
        return  TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.3.LABEL",
            defaultText: "In the mouth"
        )

    case "ON_THE_FOREHEAD":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.4.LABEL",
            defaultText: "On the forehead"
        )

    case "UNDER_THE_ARM":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.OPTION.5.LABEL",
            defaultText: "Under the arm"
        )

    default:
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.UNKNOWN",
            defaultText: "?"
        )
    }
}

func getPainSeverityText(painSeverityScale: String?) -> String {
    switch painSeverityScale {
    case "ONE":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.4",
            defaultText: "Strong pain"
        )
    case "TWO":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.3",
            defaultText: "Fairly strong pain"
        )
    case "THREE":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.2",
            defaultText: "Moderate pain"
        )
    case "FOUR":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.1",
            defaultText: "Fairly light pain"
        )
    case "FIVE":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.PAIN.PAIN_INTENSITY.LABEL.0",
            defaultText: "Light pain"
        )
    default:
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.PAIN.PAIN_INTENSITY.UNKNOWN",
            defaultText: "Unknown pain severity"
        )
    }
}

func getPainResponses(painValue: [String], otherPlaces: String) -> [String] {
    var painAreas: [String] = []

    if painValue.contains("NO") {
        painAreas.append(TranslationsViewModel.shared.getTranslation(
            key: "DIARY.PAIN.PAIN.OPTION.1.DISPLAYLABEL",
            defaultText: "No pains"
        ))
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
                ).replacingOccurrences(of: "{{value}}", with: otherPlaces)
            )
        }
    }

    return painAreas
}

func getLiquidResponses(liquidValue: [String]) -> [String] {
    var liquidResponses: [String] = []

    if liquidValue.contains("NO") {
        // No signs of dehydration
        liquidResponses.append(
            TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DRINK.DRINK.OPTION.1.DISPLAYLABEL",
                defaultText: "No signs of dehydration"
            )
        )
    } else {
        // Check for specific dehydration signs
        if liquidValue.contains("YES_DRY_MUCOUS_MEMBRANES") {
            liquidResponses.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.2.DISPLAYLABEL",
                    defaultText: "Dry mucous membranes"
                )
            )
        }
        if liquidValue.contains("YES_DRY_SKIN") {
            liquidResponses.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.3.DISPLAYLABEL",
                    defaultText: "Skin dry and flabby"
                )
            )
        }
        if liquidValue.contains("YES_TIRED_APPEARANCE") {
            liquidResponses.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.4.DISPLAYLABEL",
                    defaultText: "Tired appearance"
                )
            )
        }
        if liquidValue.contains("YES_SUNKEN_EYE_SOCKETS") {
            liquidResponses.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.5.DISPLAYLABEL",
                    defaultText: "Sunken eye sockets"
                )
            )
        }
        if liquidValue.contains("YES_FEWER_WET_DIAPERS") {
            liquidResponses.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.6.DISPLAYLABEL",
                    defaultText: "Fewer wet diapers"
                )
            )
        }
        if liquidValue.contains("YES_SUNKEN_FONTANELLE") {
            liquidResponses.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.7.DISPLAYLABEL",
                    defaultText: "Fontanelle is sunken"
                )
            )
        }
    }

    return liquidResponses
}

func getDiarrheaResponse(diarrheaValue: String?) -> String {
    switch diarrheaValue {
    case "NO":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DIARRHEA.DIARRHEA.OPTION.1.DISPLAYLABEL",
            defaultText: "No Diarrhea or vomiting"
        )
    case "YES_DIARRHEA_AND_VOMITING":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DIARRHEA.DIARRHEA.OPTION.2.DISPLAYLABEL",
            defaultText: "Diarrhea and vomiting"
        )
    case "YES_DIARRHEA":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DIARRHEA.DIARRHEA.OPTION.3.DISPLAYLABEL",
            defaultText: "Diarrhea"
        )
    case "YES_VOMITING":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DIARRHEA.DIARRHEA.OPTION.4.DISPLAYLABEL",
            defaultText: "Vomiting"
        )
    default:
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DIARRHEA.DIARRHEA.UNKNOWN",
            defaultText: "Unknown status"
        )
    }
}

func getSymptomResponses(symptomValues: [String]) -> [String] {
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

    return symptomResponses
}

func getRashResponse(rashValue: [String]) -> String {
    if rashValue.contains("NO") {
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.RASH.RASH.OPTION.1.DISPLAYLABEL",
            defaultText: "No rash"
        )
    } else if rashValue.contains("YES_REDNESS_CAN_BE_PUSHED_AWAY") {
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.RASH.RASH.OPTION.2.DISPLAYLABEL",
            defaultText: "Rash can be pushed away"
        )
    } else if rashValue.contains("YES_REDNESS_CANNOT_BE_PUSHED_AWAY") {
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.RASH.RASH.OPTION.3.DISPLAYLABEL",
            defaultText: "Rash cannot be pushed away"
        )
    } else {
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.RASH.RASH.UNKNOWN",
            defaultText: "Unknown rash status"
        )
    }
}

func getConfidenceLevelText(confidenceLevel: String?, profileName: String) -> String {
    switch confidenceLevel {
    case "ONE":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.0.TEXT",
            defaultText: "When {{name}} has a fever, you feel very insecure."
        ).replacingOccurrences(of: "{{name}}", with: profileName)
    case "TWO":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.1.TEXT",
            defaultText: "When {{name}} has a fever, you feel insecure."
        ).replacingOccurrences(of: "{{name}}", with: profileName)
    case "THREE":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.2.TEXT",
            defaultText: "When {{name}} has a fever, you feel neither very secure nor very insecure."
        ).replacingOccurrences(of: "{{name}}", with: profileName)
    case "FOUR":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.3.TEXT",
            defaultText: "When {{name}} has a fever, you feel secure."
        ).replacingOccurrences(of: "{{name}}", with: profileName)
    case "FIVE":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.CONFIDENCE.CONFIDENCE_PARENT.ANALYSIS.TEXT.4.TEXT",
            defaultText: "When {{name}} has a fever, you feel very secure."
        ).replacingOccurrences(of: "{{name}}", with: profileName)
    default:
        return "\(profileName)'s confidence level is unknown."
    }
}

func getDoctorContactedText(hasHadMedicalContact: String?) -> String {
    switch hasHadMedicalContact {
    case "NO":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.1.DISPLAYLABEL",
            defaultText: "No doctor's visit"
        )
    case "SPOKE_WITH_OUR_DOCTOR":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.2.DISPLAYLABEL",
            defaultText: "Our doctor"
        )
    case "SPOKE_WITH_ANOTHER_DOCTOR":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.3.DISPLAYLABEL",
            defaultText: "Substitute doctor"
        )
    case "WITH_EMERGENCY_SERVICES":
        return TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_VISIT.OPTION.4.DISPLAYLABEL",
            defaultText: "Emergency services"
        )
    default:
        return ""
    }
}

func getReasonsForContact(reasonsForContactValue: [String]) -> [String] {
    var result = [String]()

    if reasonsForContactValue.contains("WORRY_AND_INSECURITY") {
        result.append(TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.1.LABEL",
            defaultText: "Worry and insecurity"
        ))
    }
    if reasonsForContactValue.contains("HIGH_FEVER") {
        result.append(TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.2.LABEL",
            defaultText: "High level of fever"
        ))
    }
    if reasonsForContactValue.contains("WARNING_SIGNS") {
        result.append(TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.3.LABEL",
            defaultText: "Warning signs (as documented in the app)"
        ))
    }
    if reasonsForContactValue.contains("GET_ATTESTATION") {
        result.append(TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.4.LABEL",
            defaultText: "To get an attestation/sick note"
        ))
    }
    if reasonsForContactValue.contains("OTHER") {
        result.append(TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DOCTOR.DOCTOR_REASON.OPTION.5.LABEL",
            defaultText: "Other"
        ))
    }

    return result
}

func getMeasures(measuresInfo: [String]) -> [String] {
    var measuresList = [String]()

    if measuresInfo.contains("NO") {
        measuresList.append(
            TranslationsViewModel.shared.getTranslation(
                key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.1.LABEL",
                defaultText: "No Measures"
            )
        )
    } else {
        if measuresInfo.contains("CALM_THEM_CARESS") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.5.LABEL",
                    defaultText: "Calm them, caress"
                )
            )
        }
        if measuresInfo.contains("READING_STORY_TELLING_SINGING") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.6.LABEL",
                    defaultText: "Reading, story telling, singing"
                )
            )
        }
        if measuresInfo.contains("LOW_STIMULUS_ENVIRONMENT") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.7.LABEL",
                    defaultText: "Low-stimulus environment"
                )
            )
        }
        if measuresInfo.contains("TEA_WITH_HONEY") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.8.LABEL",
                    defaultText: "Tea with honey (elder, lime-tree, chamomile)"
                )
            )
        }
        if measuresInfo.contains("SOUP_OR_LIGHT_FOOD") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.9.LABEL",
                    defaultText: "Soup or light food"
                )
            )
        }
        if measuresInfo.contains("HOT_WATER_BOTTLE") || measuresInfo.contains("CHERRY_STONE_CUSHIONS") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.1.LABEL",
                    defaultText: "Hot-water bottle, Cherry stone cushions"
                )
            )
        }
        if measuresInfo.contains("LEG_COMPRESSES") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.2.LABEL",
                    defaultText: "Leg compresses"
                )
            )
        }
        if measuresInfo.contains("CLOTHS_ON_THE_FOREHEAD") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.3.LABEL",
                    defaultText: "Cloths on the forehead"
                )
            )
        }
        if measuresInfo.contains("ENEMA") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.10.LABEL",
                    defaultText: "Enema"
                )
            )
        }
        if measuresInfo.contains("LEMON_WATER_RUBS") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.11.LABEL",
                    defaultText: "Lemon water rubs"
                )
            )
        }
        if measuresInfo.contains("OTHER_MEASURES") {
            measuresList.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.MEASURE.MEASURE_2-KIND.OPTION.4.LABEL",
                    defaultText: "Other measures"
                )
            )
        }
    }
    return measuresList
}
func getInjectionOptionText(injectionOption: String) -> String {
    switch injectionOption {
    case "YES":
        return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.INJECTION.OPTION.1.LABEL", defaultText: "Yes")
    case "NO":
        return TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.INJECTION.OPTION.2.LABEL", defaultText: "No")
    default:
        return "Unknown option"
    }
}
func getWarningSignsResponses(warningSignsValues: [String]) -> [String] {
    var warningSignsResponses = [String]()

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


    return warningSignsResponses
}

// Function to get the icon for State of Health
func getStateOfHealthIcon(stateOfHealth: String?) -> String {
    switch stateOfHealth {
    case "VERY_SICK":
        return "smiley_one"
    case "UNWELL":
        return "smiley_two"
    case "NEUTRAL":
        return "smiley_three"
    case "FINE":
        return "smiley_four"
    case "EXCELLENT":
        return "smiley_five"
    default:
        return "smiley_three" // Default icon for unknown state
    }
}

// Function to get the icon for Pain Severity
func getPainIcon(painSeverity: String?) -> String {
    switch painSeverity {
    case "ONE":
        return "pain_five"
    case "TWO":
        return "pain_four"
    case "THREE":
        return "pain_three"
    case "FOUR":
        return "pain_two"
    case "FIVE":
        return "pain_one"
    default:
        return "pain_five" // Default icon for unknown severity
    }
}

// Function to get the icon for Confidence Level
func getConfidenceLevelIcon(confidenceLevel: String?) -> String {
    switch confidenceLevel {
    case "ONE":
        return "feelingconfident_one_checked"
    case "TWO":
        return "feelingconfident_two_checked"
    case "THREE":
        return "feelingconfident_three_checked"
    case "FOUR":
        return "feelingconfident_four_checked"
    case "FIVE":
        return "feelingconfident_five_checked"
    default:
        return "feelingconfident_one_checked" // Default icon for unknown confidence level
    }
}
