//
//  syncProfileNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 09/12/2024.
//

import Foundation
import UIKit
class ProfileNetworkManager {
    static let shared = ProfileNetworkManager()

    struct ProfileResponse: Decodable {
        let profileId: Int?
        let userId: Int?
        let profileName: String?
        let profileDateOfBirth: String?
        let profileGender: String?
        let hasChronicDisease: String?
        let chronicDiseases: [String]?
        let profileHeight: Double?
        let hadFeverSeizure: String?
        let profileWeight: Double?
        let feverPhases: Int?
        let wayOfDealingWithFeverSeizures: String?
        let willingnessToBeRandomized: String?
        let doctorReferenceNumber: String?
        let profileColor: String?
        let profilePediatricianId: Int?
        let feverFrequency: String?
        let hasTakenAntipyretics: String?
    }

    func syncProfile(
        userId: Int,
        profileName: String,
        profileDateOfBirth: String?,
        profileGender: String?,
        hasChronicDisease: String?,
        chronicDiseases: [String]?,
        profileHeight: Double?,
        hadFeverSeizure: String?,
        profileWeight: Double?,
        feverPhases: Int?,
        wayOfDealingWithFeverSeizures: String?,
        willingnessToBeRandomized: String?,
        doctorReferenceNumber: String?,
        profileColor: String?,
        profilePediatricianId: Int?,
        feverFrequency: String?,
        hasTakenAntipyretics: String?,
        completion: @escaping (Result<ProfileResponse, Error>) -> Void
    ) {
        // Create the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/profile/syncProfiles") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Set the body
        var body: [String: Any] = [
            "userId": userId,
            "profileName": profileName
        ]

        if let profileDateOfBirth = profileDateOfBirth {
            body["profileDateOfBirth"] = profileDateOfBirth
        }
        if let profileGender = profileGender {
            body["profileGender"] = profileGender
        }
        if let hasChronicDisease = hasChronicDisease {
            body["hasChronicDisease"] = hasChronicDisease
        }
        if let chronicDiseases = chronicDiseases {
            body["chronicDiseases"] = chronicDiseases
        }
        if let profileHeight = profileHeight {
            body["profileHeight"] = profileHeight
        }
        if let hadFeverSeizure = hadFeverSeizure {
            body["hadFeverSeizure"] = hadFeverSeizure
        }
        if let profileWeight = profileWeight {
            body["profileWeight"] = profileWeight
        }
        if let feverPhases = feverPhases {
            body["feverPhases"] = feverPhases
        }
        if let wayOfDealingWithFeverSeizures = wayOfDealingWithFeverSeizures {
            body["wayOfDealingWithFeverSeizures"] = wayOfDealingWithFeverSeizures
        }
        if let willingnessToBeRandomized = willingnessToBeRandomized {
            body["willingnessToBeRandomized"] = willingnessToBeRandomized
        }
        if let doctorReferenceNumber = doctorReferenceNumber {
            body["doctorReferenceNumber"] = doctorReferenceNumber
        }
        if let profileColor = profileColor {
            body["profileColor"] = profileColor
        }
        if let profilePediatricianId = profilePediatricianId {
            body["profilePediatricianId"] = profilePediatricianId
        }
        if let feverFrequency = feverFrequency {
            body["feverFrequency"] = feverFrequency
        }
        if let hasTakenAntipyretics = hasTakenAntipyretics {
            body["hasTakenAntipyretics"] = hasTakenAntipyretics
        }

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Handle response
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }

            do {
                let profileResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
                completion(.success(profileResponse))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
