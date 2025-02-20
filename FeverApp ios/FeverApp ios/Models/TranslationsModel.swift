//
//  TranslationsModel.swift
//  FeverApp ios
//
//  Created by user on 11/14/24.
//

import Foundation
import CoreData
import CSV

class TranslationsViewModel {
    static let shared = TranslationsViewModel()

    private var translations: [String: String] = [:]
    private var additionalTranslations: [String: String] = [:]
    private var infoLibraryTranslations: [String: String] = [:]

    // Load translations from CSV files
    func loadTranslations(languageCode: String) {
        translations = readTranslations(from: "translations.csv", languageCode: languageCode)
        additionalTranslations = readTranslations(from: "missingTranslations.csv", languageCode: languageCode)
        infoLibraryTranslations = readTranslations(from: "infos.csv", languageCode: languageCode)
    }

    // Helper method to read CSV
    private func readTranslations(from fileName: String, languageCode: String) -> [String: String] {
        var result: [String: String] = [:]
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            print("CSV file not found: \(fileName)")
            return result
        }

        do {
            print("path: \(path)")
            // Initialize CSVReader using the input stream
            let stream = InputStream(fileAtPath: path)!
            let csv = try CSVReader(stream: stream)

            // Read the header row to determine the language index
            let header = csv.next() ?? []
            guard let languageIndex = header.firstIndex(of: languageCode) ?? header.firstIndex(of: "en") else {
                print("Language code not found in CSV header")
                return result
            }

            // Read each row and populate the result dictionary
            while let row = csv.next() {
                // Check if the row has enough columns
                guard row.count > languageIndex else {
                    print("Row does not contain enough columns: \(row)")
                    continue
                }

                let key = row[0]
                let value = row[languageIndex]
                result[key] = value
            }
        } catch {
            print("Error reading CSV file: \(error)")
        }

        return result
    }


    // Get translation by key
    func getTranslation(key: String, defaultText: String) -> String {
        return translations[key] ?? defaultText
    }

    func getAdditionalTranslation(key: String, defaultText: String) -> String {
        return additionalTranslations[key] ?? defaultText
    }

    func getInfoLibraryTranslation(key: String) -> String {
        return infoLibraryTranslations[key] ?? "N/A"
    }
}

