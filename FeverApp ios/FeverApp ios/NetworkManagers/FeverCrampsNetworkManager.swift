//
//  FeverCrampsNetworkManager.swift
//  FeverApp ios
//
//  Created by user on 1/30/25.
//

import Foundation
import UIKit
import CoreData

class FeverCrampsNetworkManager {
    static let shared = FeverCrampsNetworkManager()
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    // Sync fever cramps data
    func documentFeverCramps(profileId: Int64, request: FeverCrampsRequest, completion: @escaping (FeverCrampsResponse?, Error?) -> Void) {
        
        print("\n\n\n\n\n\n\n\n\nRequesting URL: http://159.89.102.239:8080/api/feverCramps/document/\(profileId)\n\n\n\n\n\n\n\n\n")

        
        let endpoint = "/api/feverCramps/document/\(profileId)"
        
        apiService.makeRequest(endpoint: endpoint, method: .post, parameters: request) { (response: Decodable?, error: Error?) in
            if let response = response as? FeverCrampsResponse {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    // Fetch fever cramps data
    func getFeverCramps(profileId: Int64, localProfileId: Int64, completion: @escaping ([FeverCrampsResponse]?, Error?) -> Void) {
        let endpoint = "/api/feverCramps/\(profileId)"
        
        apiService.makeRequest(endpoint: endpoint, method: .get, parameters: nil) { (response: Decodable?, error: Error?) in
            if let response = response as? [FeverCrampsResponse] {
                self.insertFeverCramps(response: response, localProfileId: localProfileId) { success, coreDataError in
                    if success {
                        completion(response, nil)
                    } else {
                        print("Error saving to Core Data: \(String(describing: coreDataError?.localizedDescription))")
                        completion(nil, coreDataError)
                    }
                }
            } else {
                print("Failed to fetch fever cramps data \(error)")
                completion(nil, error)
            }
        }
    }
    
    private func insertFeverCramps(response: [FeverCrampsResponse], localProfileId: Int64, completion: @escaping (Bool, Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false, NSError(domain: "CoreDataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "AppDelegate not found"]))
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            for feverCramp in response {
                let entity = NSEntityDescription.entity(forEntityName: "FeverCrampsEntity", in: context)!
                let newFeverCramp = FeverCrampsEntity(entity: entity, insertInto: context)
                
                newFeverCramp.feverCrampsOnlineId = Int64(feverCramp.feverCrampsId ?? 0)
                newFeverCramp.feverCrampsDate = FeverCrampsNetworkManager.formatDate(from: feverCramp.feverCrampsDate)
                newFeverCramp.feverCrampsTime = FeverCrampsNetworkManager.formatTime(from: feverCramp.feverCrampsTime)
                newFeverCramp.feverCrampsDescription = feverCramp.feverCrampsDescription
                newFeverCramp.isFeverCrampsSynced = 1
                newFeverCramp.profileId = localProfileId
            }
            
            try context.save()
            completion(true, nil)
        } catch {
            print("Core Data save error: \(error.localizedDescription)")
            completion(false, error)
        }
    }
    
    private static func formatDate(from dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: dateString)
    }
    
    private static func formatTime(from timeString: String?) -> String? {
        guard let timeString = timeString else { return nil }
        return timeString.hasSuffix(":00") ? String(timeString.dropLast(3)) : timeString
    }
    
}

struct FeverCrampsRequest: Encodable {
    let feverCrampsDate: String
    let feverCrampsTime: String
    let feverCrampsDescription: String

    init(feverCrampsDate: Date, feverCrampsTime: String, feverCrampsDescription: String) {
        self.feverCrampsDate = FeverCrampsRequest.formatDate(feverCrampsDate)
        self.feverCrampsTime = FeverCrampsRequest.formatTime(feverCrampsTime)
        self.feverCrampsDescription = feverCrampsDescription
    }
    
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Ensure consistency
        return formatter.string(from: date)
    }

    private static func formatTime(_ time: String) -> String {
        // Ensure time is in "HH:mm:ss" format
        if time.count == 5 { // If "HH:mm", append ":00" for seconds
            return time + ":00"
        }
        return time
    }
}


struct FeverCrampsResponse: Decodable {
    let feverCrampsId: Int?
    let profileId: Int?
    let feverCrampsDate: String?
    let feverCrampsTime: String?
    let feverCrampsDescription: String?
}
