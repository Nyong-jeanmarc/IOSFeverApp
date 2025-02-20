//
//  AppUtils.swift
//  FeverApp ios
//
//  Created by user on 11/14/24.
//

import Foundation
import UIKit

struct LanguageDirection: Codable {
    let languageName: String
    let languageCode: String
    let direction: String
}

class AppUtils {

    static var supportedLanguages: [LanguageDirection] = []

    // Load supported languages from the JSON file
    static func loadSupportedLanguages() {
        guard let url = Bundle.main.url(forResource: "supported_languages", withExtension: "json") else {
            print("supported_languages.json not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            supportedLanguages = try JSONDecoder().decode([LanguageDirection].self, from: data)
            print("Supported languages loaded successfully.")
        } catch {
            print("Failed to load supported languages: \(error.localizedDescription)")
        }
    }

    // Get the direction for a given language
    static func getLanguageDirection(languageName: String) -> String? {
        return supportedLanguages.first { $0.languageName == languageName }?.direction
    }

    // Update the layout direction based on the language direction
    static func updateLayoutDirection(for languageName: String, in view: UIView) {
        guard let direction = getLanguageDirection(languageName: languageName) else {
            print("Language not found: \(languageName)")
            return
        }

        let layoutDirection: UISemanticContentAttribute = direction == "rtl" ? .forceRightToLeft : .forceLeftToRight
        view.semanticContentAttribute = layoutDirection
        print("Layout direction set to \(direction) for language \(languageName)")
    }

    // Check if the language is LTR
    static func isDirectionLtr(languageName: String) -> Bool {
        return getLanguageDirection(languageName: languageName) == "ltr"
    }
}
