//
//  ListViewModel.swift
//  FeverApp ios
//
//  Created by user on 11/7/24.
//

import Foundation

struct GroupData {
    let groupDate: String
    let feverPhases: [FeverPhase]
    let entriesNotBelongingToAFeverPhase: [Entry]
}

struct FeverPhase {
    let feverPhaseId: Int
    let profileId: Int
    let feverPhaseStartDate: String
    let feverPhaseEndDate: String
    let feverPhaseEntries: [Entry]
}

struct Entry {
    let entryId: Int
    let profileId: Int
    let entryDate: String
    let stateOfHealth: StateOfHealth?
    let temperature: Temperature?
    let pains: Pains?
    let liquids: Liquids?
    let diarrhea: Diarrhea?
    let symptoms: Symptoms?
    let rash: Rash?
    let warningSigns: WarningSigns?
    let confidenceLevel: ConfidenceLevel?
    let measures: Measures?
    let notes: Notes?
    let contactWithDoctor: ContactWithDoctor?
    let belongsToAFeverPhase: Bool
    let feverPhaseId: Int?
    let medications: MedicationsModel?
}

struct StateOfHealth {
    let stateOfHealthId: Int
    let stateOfHealth: String
    let stateOfHealthDateTime: String
}

struct Temperature{
    let temperatureId: Int
    let temperatureComparedToForehead: String
    let wayOfDealingWithTemperature: String
    let temperatureDateTime: String
    let temperatureValue: Double
    let temperatureMeasurementUnit: String?
    let temperatureMeasurementLocation: String
    let vaccination: Vaccination?
}

struct Vaccination {
    let vaccinationId: Int
    let vaccinatedLast2WeeksOrNot: String
    let vaccineReceived: [String]
    let vaccinationDateTime: String
}

struct Pains {
    let painId: Int
    let painValue: [String]
    let painDateTime: String
    let painSeverityScale: String
    let otherPlaces: String
}

struct Liquids {
    let liquidId: Int
    let dehydrationSigns: [String]
    let liquidTime: String
}

struct Diarrhea {
    let diarrheaId: Int
    let diarrheaAndOrVomiting: String
    let observationTime: String
}

struct Symptoms {
    let symptomsId: Int
    let symptoms: [String]
    let otherSymptoms: [String]?
    let symptomsTime: String
}

struct Rash {
    let rashId: Int
    let rashes: [String]
    let rashTime: String
}

struct WarningSigns {
    let warningSignsId: Int
    let warningSigns: [String]
    let warningSignsTime: String
}

struct ConfidenceLevel {
    let confidenceLevelId: Int
    let confidenceLevel: String
    let timeOfObservation: String
}

struct Measures {
    let measureId: Int
    let takeMeasures: String
    let measures: [String]
    let otherMeasures: String?
    let measureTime: String
}

struct Notes {
    let noteId: Int
    let notesContent: String
    let notesOtherContent: String
    let notesTime: String
}

struct ContactWithDoctor {
    let contactWithDoctorId: Int
    let hasHadMedicalContact: String
    let dateOfContact: String
    let reasonForContact: [String]
    let otherReasonForContact: String?
    let doctorDiagnoses: [String]
    let otherDiagnosis: String
    let doctorsPrescriptionsIssued: [String]
    let otherPrescriptionsIssued: String?
    let doctorsRecommendationMeasures: String?
}

struct MedicationsModel {
    let medicationEntryId: Int
    let hasTakenMedications: String?
    let medicationList: [Medication]? 
}
struct Medication {
    let medicationId: Int
    let medicationEntryId: Int
    let userId: Int
    let medicationName: String
    let typeOfMedication: String
    let activeIngredientQuantity: Double
    let amountAdministered: Double?
    let reasonForAdministration: String?
    let basisOfDecision: String?
    let dateOfAdministration: String?
    let timeOfAdministration: String?
}
