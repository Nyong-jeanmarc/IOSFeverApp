//
//  AddUserPediatricianNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 18/10/2024.
//

import Foundation
import UIKit
import CoreData
struct UserPediatrician: Codable {
    let pediatricianId: Int
    let userId: Int
    let firstName: String
    let lastName: String
    let streetAndHouseNumber: String
    let postalCode: Int
    let city: String
    let country: String
    let phoneNumber: String
    let email: String
    let reference: String?
}
class AddUserPediatricianNetworkManager{
    static let shared = AddUserPediatricianNetworkManager()
    // Define the structs to match the server response
    struct UserPediatricianResponse: Codable {
        let message: String
        let pediatrician: UserPediatrician
    }
    
    func createUserPediatricianLocally(
        pediatricianId: Int64,
        userId: Int64,
        firstName: String?,
        lastName: String?,
        streetAndHouseNumber: String?,
        postalCode: Int64,
        city: String?,
        country: String?,
        phoneNumber: String?,
        email: String?,
        reference: String?,
        completion: @escaping (Bool) -> Void
    ) {
        // Access the persistent container
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a new User_pediatricians object
        let newPediatrician = User_pediatricians(context: context)
        
        // Assign values to the attributes
        newPediatrician.pediatricianId = pediatricianId
        newPediatrician.userId = userId
        newPediatrician.firstName = firstName
        newPediatrician.lastName = lastName
        newPediatrician.streetAndHouseNumber = streetAndHouseNumber
        newPediatrician.postalCode = postalCode
        newPediatrician.city = city
        newPediatrician.country = country
        newPediatrician.phoneNumber = phoneNumber
        newPediatrician.email = email
        newPediatrician.reference = reference
        
        // Save the context
        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to save the new pediatrician: \(error)")
            completion(false)
        }
    }

    func addUserPediatricianRequest(
        userId: Int64,
        firstName: String,
        lastName: String,
        streetAndHouseNumber: String,
        postalCode: Int,
        city: String,
        country: String,
        phoneNumber: String,
        email: String,
        completion: @escaping (Result<UserPediatrician, Error>) -> Void
    ) {
        // Construct the URL
        guard let url = URL(string: "http://159.89.102.239:8080/api/user/pediatrician/\(userId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        // Create the request body
        let requestBody: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "streetAndHouseNumber": streetAndHouseNumber,
            "postalCode": postalCode,
            "city": city,
            "country": country,
            "phoneNumber": phoneNumber,
            "email": email
        ]
        
        // Serialize the request body to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            completion(.failure(NSError(domain: "JSON Serialization Error", code: 0, userInfo: nil)))
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Create a URL session to send the request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "Server Error", code: statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            // Decode the JSON response into the UserPediatricianResponse
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(UserPediatricianResponse.self, from: data)
                    completion(.success(decodedResponse.pediatrician))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
            }
        }
        task.resume()
    }
    func fetchAllUserPediatricians(completion: @escaping ([User_pediatricians]?) -> Void) {
        // Get the Core Data context
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            print("Error: Unable to access Core Data context.")
            completion(nil)
            return
        }
        
        // Create the fetch request
        let fetchRequest: NSFetchRequest<User_pediatricians> = User_pediatricians.fetchRequest()
        
        do {
            // Perform the fetch
            let userPediatricians = try context.fetch(fetchRequest)
            completion(userPediatricians)
        } catch let error as NSError {
            print("Error fetching User_pediatricians: \(error.localizedDescription)")
            completion(nil)
        }
    }

}
