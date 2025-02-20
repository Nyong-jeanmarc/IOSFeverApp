//
//  feedBackQuestionaireModel.swift
//  FeverApp ios
//
//  Created by NEW on 07/01/2025.
//

import Foundation
import UIKit
class feedBackQuestionaireModel{
  
    static let shared = feedBackQuestionaireModel()
    var confidenceImpact: String?
    var designSatisfaction: String?
    var feedbackId : Int64?
    var generalSatisfaction : String?
    var improvementSuggestions :String?
    var positiveAspects: String?
    var usabilitySatisfaction: String?
    var userId: Int64?
    func updateFeedBackModel(
           confidenceImpact: String? = nil,
           designSatisfaction: String? = nil,
           feedbackId: Int64? = nil,
           generalSatisfaction: String? = nil,
           improvementSuggestions: String? = nil,
           positiveAspects: String? = nil,
           usabilitySatisfaction: String? = nil,
           userId: Int64? = nil
       ) {
           if let confidenceImpact = confidenceImpact {
               self.confidenceImpact = confidenceImpact
           }
           if let designSatisfaction = designSatisfaction {
               self.designSatisfaction = designSatisfaction
           }
           if let feedbackId = feedbackId {
               self.feedbackId = feedbackId
           }
           if let generalSatisfaction = generalSatisfaction {
               self.generalSatisfaction = generalSatisfaction
           }
           if let improvementSuggestions = improvementSuggestions {
               self.improvementSuggestions = improvementSuggestions
           }
           if let positiveAspects = positiveAspects {
               self.positiveAspects = positiveAspects
           }
           if let usabilitySatisfaction = usabilitySatisfaction {
               self.usabilitySatisfaction = usabilitySatisfaction
           }
           if let userId = userId {
               self.userId = userId
           }
       }
    func saveFeedBack() async{
        print(self.generalSatisfaction ?? "")
        print(self.designSatisfaction ?? "")
        print(self.usabilitySatisfaction ?? "")
        print(self.confidenceImpact ?? "")
        print(self.positiveAspects ?? "")
        print(self.improvementSuggestions ?? "")
     
       
        await feedBackNetworkManager.shared.saveFeedback(userId: userId, generalSatisfaction: self.generalSatisfaction, designSatisfaction: self.designSatisfaction, usabilitySatisfaction: self.usabilitySatisfaction, confidenceImpact: self.confidenceImpact, positiveAspects: self.positiveAspects, improvementSuggestions: self.improvementSuggestions)
    }
    
}
