//
//  feedBackNetworkManager.swift
//  FeverApp ios
//
//  Created by NEW on 08/01/2025.
//

import Foundation
import UIKit
import CoreData
class feedBackNetworkManager{
    static let shared = feedBackNetworkManager()
    func saveFeedback(
        userId: Int64?,
        generalSatisfaction: String?,
        designSatisfaction: String?,
        usabilitySatisfaction: String?,
        confidenceImpact: String?,
        positiveAspects: String?,
        improvementSuggestions: String?

    ) async {
        do {
            // Step 1: Create feedback
            var createRequestBody: [String: Any] = [:]
            if let userId = userId {
                createRequestBody["userId"] = userId
            }

            let feedbackId = try await createFeedbackApi(createRequestBody)

            // Step 2: Update feedback
            var updateRequestBody: [String: Any] = [:]
            if let generalSatisfaction = generalSatisfaction {
                updateRequestBody["generalSatisfaction"] = generalSatisfaction
            }
            if let designSatisfaction = designSatisfaction {
                updateRequestBody["designSatisfaction"] = designSatisfaction
            }
            if let usabilitySatisfaction = usabilitySatisfaction {
                updateRequestBody["usabilitySatisfaction"] = usabilitySatisfaction
            }
            if let confidenceImpact = confidenceImpact {
                updateRequestBody["confidenceImpact"] = confidenceImpact
            }
            if let positiveAspects = positiveAspects {
                updateRequestBody["positiveAspects"] = positiveAspects
            }
            if let improvementSuggestions = improvementSuggestions {
                updateRequestBody["improvementSuggestions"] = improvementSuggestions
            }

            let updateSuccess = try await updateFeedbackApi(feedbackId, updateRequestBody)

            if updateSuccess {
                // Successfully updated, send local feedbacks
                await sendLocalFeedback()
            } else {
                // If update fails, save locally
                insertFeedbackLocal(
                    feedbackId: feedbackId,
                    userId: userId,
                    generalSatisfaction: generalSatisfaction,
                    designSatisfaction: designSatisfaction,
                    usabilitySatisfaction: usabilitySatisfaction,
                    confidenceImpact: confidenceImpact,
                    positiveAspects: positiveAspects,
                    improvementSuggestions: improvementSuggestions
         
                )
            }
        } catch {
            print("Error occurred while creating or updating feedback: \(error.localizedDescription)")
            // If creation or update fails, save locally
            insertFeedbackLocal(
                feedbackId: nil,
                userId: userId,
                generalSatisfaction: generalSatisfaction,
                designSatisfaction: designSatisfaction,
                usabilitySatisfaction: usabilitySatisfaction,
                confidenceImpact: confidenceImpact,
                positiveAspects: positiveAspects,
                improvementSuggestions: improvementSuggestions
               
            )
        }
    }
 
    private func insertFeedbackLocal(
        feedbackId: Int?,
        userId: Int64?,
        generalSatisfaction: String?,
        designSatisfaction: String?,
        usabilitySatisfaction: String?,
        confidenceImpact: String?,
        positiveAspects: String?,
        improvementSuggestions: String?
      
    ) {
        DispatchQueue.main.async {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.perform {
                do {
                    // Create a new managed object for Feedback
                    let feedbackEntity = FeedbackLocal(context: context)
                
                    feedbackEntity.userId = userId!
                    feedbackEntity.generalSatisfaction = generalSatisfaction
                    feedbackEntity.designSatisfaction = designSatisfaction
                    feedbackEntity.usabilitySatisfaction = usabilitySatisfaction
                    feedbackEntity.confidenceImpact = confidenceImpact
                    feedbackEntity.positiveAspects = positiveAspects
                    feedbackEntity.improvementSuggestions = improvementSuggestions
                    
                    // Save the context
           
                    // Step 4: Extract Core Data-generated object ID
                    if let objectID =  feedbackEntity.objectID.uriRepresentation().absoluteString.split(separator: "/").last,
                       let coreDataId = Int64(objectID.dropFirst()) { // Drop the 'p' prefix from the ID
                        feedbackEntity.feedbackId = coreDataId
                    } else {
                        print("Error: Unable to extract Core Data object ID")
                    }
                    try context.save()
                    print("Feedback successfully saved locally.")
                } catch {
                    print("Failed to save feedback locally: \(error)")
                }
            }
        }
    }
    func createFeedbackApi(_ requestBody: [String: Any]) async throws -> Int {
        let url = URL(string: "http://159.89.102.239:8080/api/feedback/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert the request body to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Server responded with an error when creating feedback")
            throw URLError(.badServerResponse)
        }
        
        // Decode the response body (expecting a single integer)
        if let feedbackId = Int(String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") {
            print("Feedback ID retrieved successfully:", feedbackId)
            return feedbackId
        } else {
            print("Failed to parse the feedback ID")
            throw URLError(.cannotParseResponse)
        }
    }

    func updateFeedbackApi(_ feedbackId: Int, _ requestBody: [String: Any]) async throws -> Bool {
        let url = URL(string: "http://159.89.102.239:8080/api/feedback/update/\(feedbackId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert the request body to JSON data
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
        
        // Perform the network request
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid HTTP response
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("remote feedback updated successfully")
            return true
           
        } else {
            print("failed to update remote")
            return false
        }
    }
    func sendLocalFeedback() async {
        // Fetch local feedback objects
        let context = await MainActor.run {
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
        let fetchRequest: NSFetchRequest<FeedbackLocal> = FeedbackLocal.fetchRequest()
        do {
            let localFeedbacks = try context.fetch(fetchRequest)
            
            for feedback in localFeedbacks {
                // Step 1: Prepare the creation request
                let createRequestBody: [String: Any] = [
                    "userId": feedback.userId
                ]
                
                do {
                    // Create the feedback on the server
                    let createURL = URL(string: "http://159.89.102.239:8080/api/feedback/create")!
                    var createRequest = URLRequest(url: createURL)
                    createRequest.httpMethod = "POST"
                    createRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    createRequest.httpBody = try JSONSerialization.data(withJSONObject: createRequestBody)
                    
                    let (createData, createResponse) = try await URLSession.shared.data(for: createRequest)
                    
                    if let httpResponse = createResponse as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        // Parse the feedback ID from the response
                        if let feedbackId = Int(String(data: createData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") {
                            
                            // Step 2: Prepare the update request
                            var updateRequestBody: [String: Any] = [:]
                            
                            if let generalSatisfaction = feedback.generalSatisfaction {
                                updateRequestBody["generalSatisfaction"] = generalSatisfaction
                            }
                            if let designSatisfaction = feedback.designSatisfaction {
                                updateRequestBody["designSatisfaction"] = designSatisfaction
                            }
                            if let usabilitySatisfaction = feedback.usabilitySatisfaction {
                                updateRequestBody["usabilitySatisfaction"] = usabilitySatisfaction
                            }
                            if let confidenceImpact = feedback.confidenceImpact {
                                updateRequestBody["confidenceImpact"] = confidenceImpact
                            }
                            if let positiveAspects = feedback.positiveAspects {
                                updateRequestBody["positiveAspects"] = positiveAspects
                            }
                            if let improvementSuggestions = feedback.improvementSuggestions {
                                updateRequestBody["improvementSuggestions"] = improvementSuggestions
                            }
                            
                            let updateURL = URL(string: "http://159.89.102.239:8080/api/feedback/update/\(feedbackId)")!
                            var updateRequest = URLRequest(url: updateURL)
                            updateRequest.httpMethod = "PUT"
                            updateRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            updateRequest.httpBody = try JSONSerialization.data(withJSONObject: updateRequestBody)
                            
                            let (_, updateResponse) = try await URLSession.shared.data(for: updateRequest)
                            
                            if let httpResponse = updateResponse as? HTTPURLResponse, httpResponse.statusCode == 200 {
                                // Step 3: Delete the local feedback
                                context.delete(feedback)
                                try context.save()
                            }
                        }
                    }
                } catch {
                    print("Error processing feedback ID \(feedback.feedbackId): \(error)")
                }
            }
        } catch {
            print("Failed to fetch local feedback: \(error)")
        }
    }



    
}
