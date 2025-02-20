//
//  searchMedicationNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 27/11/2024.
//

import Foundation
import UIKit
class searchMedicationNetworkManager{
    static let shared = searchMedicationNetworkManager()
    
    func fetchMedications(searchTerm: String, completion: @escaping (Result<[searchedMedications], Error>) -> Void) {
        let baseURL = "http://159.89.102.239:8080/api/uploadedMedications/search"
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "searchTerm", value: searchTerm)]
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(searchedMedicationResponse.self, from: data)
                completion(.success(response.uploadedMedication))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func fetchMedicationsByPzn(pzn: Int, completion: @escaping (Result<[searchedMedications], Error>) -> Void) {
        let baseURL = "http://159.89.102.239:8080/api/uploadedMedications/searchPzn"
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "pzn", value: "\(pzn)")]
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(searchedMedicationResponse.self, from: data)
                completion(.success(response.uploadedMedication))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}

// Root response struct
struct searchedMedicationResponse: Codable {
    let message: String
    let uploadedMedication: [searchedMedications] // Matches the array in the response
}

// Medication struct for individual medication details
struct searchedMedications: Codable , Equatable {
    let uploadedMedicationId: Int
    let pzn: Int
    let productDescription: String
    let quantity: Double
    let unit: String
    let dosageForm: String
    let productName: String
    let productGroupIdentifier: Int
    let pharmacyProductNumber: Int
    let groupIdentifier: Int
    let correction: String? // Optional because the "correction" field is null in the example
}
