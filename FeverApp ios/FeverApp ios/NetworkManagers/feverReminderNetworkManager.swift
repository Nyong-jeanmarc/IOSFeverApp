//
//  feverReminderNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 07/02/2025.
//

import Foundation
class feverReminderNetworkManager {
    static let shared = feverReminderNetworkManager()
    func saveFeverPhaseSurvey(
        userId: Int64,
        profileId: Int64,
        feverPhasesReported: String?,
        numberOfFeverPhases: Int?,
        documentationStatus: String?,
        surveyDate: String?,
        surveyInterval: String?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        // API Endpoint
        let urlString = "http://159.89.102.239:8080/api/survey/response"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create JSON body
        var requestBody: [String: Any] = [
            "userId": userId,
            "profileId": profileId
        ]
        
        // Add optional parameters if they are not nil
        if let feverPhasesReported = feverPhasesReported {
            requestBody["feverPhasesReported"] = feverPhasesReported
        }
        if let numberOfFeverPhases = numberOfFeverPhases {
            requestBody["numberOfFeverPhases"] = numberOfFeverPhases
        }
        if let documentationStatus = documentationStatus {
            requestBody["documentationStatus"] = documentationStatus
        }
        if let surveyDate = surveyDate {
            requestBody["surveyDate"] = surveyDate
        }
        if let surveyInterval = surveyInterval {
            requestBody["surveyInterval"] = surveyInterval
        }
        
        // Configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert requestBody to JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }

}
