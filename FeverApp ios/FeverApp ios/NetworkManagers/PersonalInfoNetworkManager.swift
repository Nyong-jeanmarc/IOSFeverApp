////
////  PersonalInfoNetworkManager.swift
////  FeverApp ios
////
////  Created by user on 1/10/25.
////
//
//import Foundation
//
//class PersonalInfoNetworkManager {
//    static let shared = PersonalInfoNetworkManager()
//    let apiService: APIServiceProtocol
//    
//    init(apiService: APIServiceProtocol = APIService()) {
//        self.apiService = apiService
//    }
//    
//    func getPersonalInfo(userId: String, completion: @escaping (PersonalInfoResponse?, Error?) -> Void) {
//        apiService.makeRequest(endpoint: "/api/personalInfo/retrieve/\(userId)", method: .get, parameters: nil) { (response: (any Decodable)?, error: Error?) in
//            if let response = response as? PersonalInfoResponse {
//                completion(response, error)
//            } else {
//                completion(nil, error)
//            }
//        }
//    }
//
//    func updatePersonalInfo(userId: String, request: PersonalInfoRequest, completion: @escaping (PersonalInfoResponse?, Error?) -> Void) {
//        apiService.makeRequest(endpoint: "/api/personalInfo/update/\(userId)", method: .put, parameters: request as? Encodable) { (response: (any Decodable)?, error: Error?) in
//            if let response = response as? PersonalInfoResponse {
//                completion(response, error)
//            } else {
//                completion(nil, error)
//            }
//        }
//    }
//}
//
//protocol APIServiceProtocol {
//    func makeRequest(endpoint: String, method: RequestMethod, parameters: Encodable?, completion: @escaping (Decodable?, Error?) -> Void)
//}
//
//class APIService: APIServiceProtocol {
//    func makeRequest(endpoint: String, method: RequestMethod, parameters: Encodable?, completion: @escaping (Decodable?, Error?) -> Void) {
//        guard let url = URL(string: "http://159.89.102.239:8080\(endpoint)") else {
//            completion(nil, NSError(domain: "Invalid URL", code: 0))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        
//        if let parameters = parameters {
//            request.httpBody = try? JSONEncoder().encode(parameters)
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        }
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            
//            if let data = data {
//                do {
//                    let response = try JSONDecoder().decode(PersonalInfoResponse.self, from: data)
//                    completion(response, nil)
//                } catch {
//                    completion(nil, error)
//                }
//            }
//        }.resume()
//    }
//}
//
//enum RequestMethod: String {
//    case get = "GET"
//    case put = "PUT"
//}
//
//struct PersonalInfoRequest {
//    let userFirstName: String?
//    let userLastName: String?
//    let familyRole: FamilyRole?
//    let userYearOfBirth: String?
//    let educationalLevel: String?
//    
//    init(userFirstName: String?, userLastName: String?, familyRole: FamilyRole?, userYearOfBirth: String?, educationalLevel: String?) {
//        self.userFirstName = userFirstName
//        self.userLastName = userLastName
//        self.familyRole = familyRole
//        self.userYearOfBirth = userYearOfBirth
//        self.educationalLevel = educationalLevel
//    }
//}
//
//struct PersonalInfoResponse: Decodable {
//    let userFirstName: String?
//    let userLastName: String?
//    let familyRole: String?
//    let userYearOfBirth: String?
//    let educationalLevel: String?
//}

//
//  PersonalInfoNetworkManager.swift
//  FeverApp ios
//
//  Created by user on 1/10/25.
//

import Foundation
import UIKit
import CoreData

class PersonalInfoNetworkManager {
    static let shared = PersonalInfoNetworkManager()
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func getPersonalInfo(userId: String, completion: @escaping (PersonalInfoResponse?, Error?) -> Void) {
        apiService.makeRequest(
            endpoint: "/api/personalInfo/retrieve/\(userId)",
            method: .get,
            parameters: nil
        ) { (response: Decodable?, error: Error?) in
            if let response = response as? PersonalInfoResponse {
                // Insert or update Core Data
                self.insertOrUpdatePersonalInfo(response: response) { success, coreDataError in
                    if success {
                        completion(response, nil)
                    } else {
                        print("Error saving to Core Data: \(String(describing: coreDataError?.localizedDescription))")
                        completion(nil, coreDataError)
                    }
                }
            } else {
                completion(nil, error)
            }
        }
    }



    func updatePersonalInfo(userId: String, request: PersonalInfoRequest, completion: @escaping (PersonalInfoResponse?, Error?) -> Void) {
        apiService.makeRequest(endpoint: "/api/personalInfo/update/\(userId)", method: .put, parameters: request) { response, error in
            if let response = response as? PersonalInfoResponse {
                completion(response, error)
            } else {
                completion(nil, error)
            }
        }
    }
    
    private func insertOrUpdatePersonalInfo(response: PersonalInfoResponse, completion: @escaping (Bool, Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false, NSError(domain: "CoreDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "AppDelegate not found"]))
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserPersonalInformationEntity> = UserPersonalInformationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "personalInfoId == %d", response.personalInfoId ?? 0)

        do {
            let results = try context.fetch(fetchRequest)

            let personalInfo: UserPersonalInformationEntity
            if let existingEntity = results.first {
                // Update the existing entity
                personalInfo = existingEntity
            } else {
                // Create a new entity
                let entity = NSEntityDescription.entity(forEntityName: "UserPersonalInformationEntity", in: context)!
                personalInfo = UserPersonalInformationEntity(entity: entity, insertInto: context)
            }

            // Update the properties
            personalInfo.personalInfoId = Int64(response.personalInfoId ?? 0)
            personalInfo.userFirstName = response.userFirstName
            personalInfo.userLastName = response.userLastName
            personalInfo.familyRole = response.familyRole
            personalInfo.userYearOfBirth = response.userYearOfBirth
            personalInfo.educationalLevel = response.educationalLevel
            personalInfo.nationality = response.nationality
            personalInfo.countryOfResidence = response.countryOfResidence
            personalInfo.postcode = response.postcode
            personalInfo.isSync = true // Assuming the data fetched from the server is synced

            // Save the context
            try context.save()
            completion(true, nil)
        } catch {
            print("Core Data fetch or save error: \(error.localizedDescription)")
            completion(false, error)
        }
    }
}

protocol APIServiceProtocol {
    func makeRequest(endpoint: String, method: RequestMethod, parameters: Encodable?, completion: @escaping (Decodable?, Error?) -> Void)
}

class APIService: APIServiceProtocol {
    func makeRequest(endpoint: String, method: RequestMethod, parameters: Encodable?, completion: @escaping (Decodable?, Error?) -> Void) {
        print("\n\nfever cramps Attempting to make request to the endpoint: http://159.89.102.239:8080\(endpoint)\n\n")
        guard let url = URL(string: "http://159.89.102.239:8080\(endpoint)") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let parameters = parameters {
            do {
                request.httpBody = try JSONEncoder().encode(parameters)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Failed to encode request parameters: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
        }

        // Log the request details
        print("\n\nSending Request:")
        print("\nURL: \(request.url?.absoluteString ?? "No URL")")
        print("\nMethod: \(request.httpMethod ?? "No Method")")
        if let headers = request.allHTTPHeaderFields {
            print("\nHeaders: \(headers)")
        }
        if let body = request.httpBody {
            print("\nBody: \(String(data: body, encoding: .utf8) ?? "Invalid Body")")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("\nStatus code: \(httpResponse.statusCode)")
                print("\nHeaders: \(httpResponse.allHeaderFields)")
            }

            if let data = data, !data.isEmpty {
                do {
                    // Decode the response based on the endpoint
                                    var response: Decodable?
                                    if endpoint.contains("contactInfo") {
                                        response = try JSONDecoder().decode(ContactInfoResponse.self, from: data)
                                    } else if endpoint.contains("personalInfo") {
                                        response = try JSONDecoder().decode(PersonalInfoResponse.self, from: data)
                                    } else if endpoint.contains("feverCramps/document") {
                                        response = try JSONDecoder().decode(FeverCrampsResponse.self, from: data)
                                    }else if endpoint.contains("feverCramps/") {  // Handle fever cramps by profileId
                                        response = try JSONDecoder().decode([FeverCrampsResponse].self, from: data) // Array
                                    }else {
                                        print("Unknown endpoint: \(endpoint)")
                                        completion(nil, NSError(domain: "UnknownEndpoint", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown endpoint"]))
                                        return
                                    }
                    completion(response, nil)
                } catch {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Failed JSON: \(jsonString)")
                    }
                    print("JSON decoding error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            } else {
                print("Empty response data")
                completion(nil, NSError(domain: "No Data", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from server."]))
            }
        }.resume()
    }
}

enum RequestMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
}



struct PersonalInfoRequest: Encodable {
    let userFirstName: String?
    let userLastName: String?
    let familyRole: FamilyRole?
    let userYearOfBirth: String?

    enum CodingKeys: String, CodingKey {
        case userFirstName
        case userLastName
        case familyRole
        case userYearOfBirth
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userFirstName, forKey: .userFirstName)
        try container.encode(userLastName, forKey: .userLastName)
        try container.encode(familyRole?.rawValue, forKey: .familyRole)
        try container.encode(userYearOfBirth, forKey: .userYearOfBirth)
    }
}

struct PersonalInfoResponse: Decodable {
    let personalInfoId: Int?
    let userFirstName: String?
    let userLastName: String?
    let familyRole: String?
    let userYearOfBirth: String?
    let educationalLevel: String?
    let nationality: String?
    let countryOfResidence: String?
    let postcode: String?
    let userId: Int?
}
