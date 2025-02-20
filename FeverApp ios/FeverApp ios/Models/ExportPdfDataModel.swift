//
//  ExportPdfDataModel.swift
//  FeverApp ios
//
//  Created by user on 11/11/24.
//

import Foundation
import UIKit

// FeverPhaseResponse Struct
struct FeverPhaseResponse {
    var message: String
    var feverPhases: [FeverPhaseGraph]
}

// FeverPhaseGraph Struct
struct FeverPhaseGraph {
    var feverPhaseId: Int64?
    var profileId: Int64?
    var feverPhaseStartDate: String?
    var feverPhaseEndDate: String?
    var feverPhaseEntries: [FeverPhaseEntry]?
    var bitmap: UIImage? // Replace Android Bitmap with UIImage in Swift
}

// FeverPhaseEntry Struct
struct FeverPhaseEntry {
    var entryId: Int64?
    var profileId: Int64?
    var entryDate: String?
    var stateOfHealth: StateOfHealthModel?
    var temperature: TemperatureModel?
    var pains: PainsModel?
    var liquids: LiquidsModel?
    var diarrhea: DiarrheaModel?
    var symptoms: SymptomsModel?
    var rash: RashModel?
    var warningSigns: WarningSignsModel?
    var confidenceLevel: ConfidenceLevelModel?
    var measures: MeasuresModel?
    var notes: NotesModel?
    var contactWithDoctor: ContactWithDoctorModel?
    var belongsToAFeverPhase: Bool?
    var feverPhaseId: Int64?
    var feverPhaseIdOnline: Int64?
    var medications: Medications?
    var bitmap: UIImage?
}

// Notes Struct
struct NotesModel {
    var noteId: Int64?
    var notesContent: String?
    var notesOtherObservations: String?
}

// StateOfHealth Struct
struct StateOfHealthModel {
    var stateOfHealthId: Int64?
    var stateOfHealth: String?
    var stateOfHealthDateTime: String?
}

// Temperature Struct
struct TemperatureModel {
    var temperatureId: Int64?
    var temperatureComparedToForehead: String?
    var wayOfDealingWithTemperature: String?
    var temperatureDateTime: String?
    var temperatureValue: Double?
    var temperatureMeasurementUnit: String?
    var temperatureMeasurementLocation: String?
    var vaccination: VaccinationModel?
}

// Vaccination Struct
struct VaccinationModel {
    var vaccinationId: Int64?
    var vaccinatedLast2WeeksOrNot: String? // Replace enum with String or define your own enum
    var vaccineReceived: [String]?
    var vaccinationDateTime: String?
}

// Pains Struct
struct PainsModel {
    var painId: Int64?
    var painValue: [String]?
    var painDateTime: String?
    var painSeverityScale: String?
    var otherPlaces: String?
}

// Liquids Struct
struct LiquidsModel {
    var liquidId: Int64?
    var dehydrationSigns: [String]?
    var liquidTime: String?
}

// Diarrhea Struct
struct DiarrheaModel {
    var diarrheaId: Int64?
    var diarrheaAndOrVomiting: String?
    var observationTime: String?
}

// Symptoms Struct
struct SymptomsModel {
    var symptomsId: Int64?
    var symptoms: [String]?
    var otherSymptoms: [String]?
}

// Rash Struct
struct RashModel {
    var rashId: Int64?
    var rashes: [String]?
}

// WarningSigns Struct
struct WarningSignsModel {
    var warningSignsId: Int64?
    var warningSigns: [String]?
    var warningSignsTime: String?
}

// ConfidenceLevel Struct
struct ConfidenceLevelModel {
    var confidenceLevelId: Int64?
    var confidenceLevel: String?
    var timeOfObservation: String?
}

// Measures Struct
struct MeasuresModel {
    var measureId: Int64?
    var takeMeasures: String?
    var measures: [String]?
    var otherMeasures: String?
    var measureTime: String?
}

// Medications Struct
struct Medications {
    var medicationEntryId: Int64?
    var hasTakenMedication: String?
}

// ContactWithDoctor Struct
struct ContactWithDoctorModel {
    var contactWithDoctorId: Int64?
    var hasHadMedicalContact: String?
    var dateOfContact: String?
    var reasonForContact: [String]?
    var otherReasonForContact: String?
    var doctorDiagnoses: [String]?
    var otherDiagnosis: String?
    var doctorsPrescriptionsIssued: [String]?
    var otherPrescriptionsIssued: String?
    var doctorsRecommendationMeasures: String?
}

struct ProfilePdfData {
    var profileName: String
    var profileGender: String
    var profileDateOfBirth: String
    var familyCode: String
}

struct FooterContent {
    var userFamilyCode: String
    var feverPhaseInfo: String
    var profileName: String
}

// Sample FeverPhaseGraph Data
let sampleFeverPhaseGraph: [FeverPhaseGraph] = [
    FeverPhaseGraph(
    feverPhaseId: 101,
    profileId: 1,
    feverPhaseStartDate: "2024-07-24T00:00:00.000+00:00",
    feverPhaseEndDate: "2024-07-26T00:00:00.000+00:00",
    feverPhaseEntries: [
        FeverPhaseEntry(
            entryId: 1001,
            profileId: 1,
            entryDate: "2024-07-24T14:37:00.000+00:00",
            stateOfHealth: StateOfHealthModel(
                stateOfHealthId: 201,
                stateOfHealth: "FINE",
                stateOfHealthDateTime: "2024-01-02T10:00:00Z"
            ),
            temperature: TemperatureModel(
                temperatureId: 301,
                temperatureComparedToForehead: "EQUALLY_WARM_OR_WARMER_HANDS_AND_FEET",
                wayOfDealingWithTemperature: "Cool cloths on the forehead",
                temperatureDateTime: "2024-05-03T16:30:00.000+00:00",
                temperatureValue: 39.5,
                temperatureMeasurementUnit: "C",
                temperatureMeasurementLocation: "IN_THE_MOUTH",
                vaccination: VaccinationModel(
                    vaccinationId: 401,
                    vaccinatedLast2WeeksOrNot: "YES",
                    vaccineReceived: ["Flu Vaccine"],
                    vaccinationDateTime: "2023-12-25T09:00:00Z"
                )
            ),
            pains: PainsModel(
                painId: 501,
                painValue: ["YES_IN_HEAD"],
                painDateTime: "2024-01-02T10:20:00Z",
                painSeverityScale: "THREE",
                otherPlaces: "Neck"
            ),
            liquids: LiquidsModel(
                liquidId: 601,
                dehydrationSigns: ["YES_DRY_SKIN"],
                liquidTime: "2024-01-02T11:00:00Z"
            ),
            diarrhea: DiarrheaModel(
                diarrheaId: 701,
                diarrheaAndOrVomiting: "YES_DIARRHEA",
                observationTime: "2024-01-02T12:00:00Z"
            ),
            symptoms: SymptomsModel(
                symptomsId: 801,
                symptoms: ["COUGH", "MUCUS"],
                otherSymptoms: ["Sore throat"]
            ),
            rash: RashModel(
                rashId: 901,
                rashes: ["YES_REDNESS_CAN_BE_PUSHED_AWAY"]
            ),
            warningSigns: WarningSignsModel(
                warningSignsId: 1001,
                warningSigns: ["YES_TOUCH_SENSITIVITY"],
                warningSignsTime: "2024-01-02T14:00:00Z"
            ),
            confidenceLevel: ConfidenceLevelModel(
                confidenceLevelId: 1101,
                confidenceLevel: "THREE",
                timeOfObservation: "2024-01-02T15:00:00Z"
            ),
            measures: MeasuresModel(
                measureId: 1201,
                takeMeasures: "YES",
                measures: ["CLOTHS_ON_THE_FOREHEAD"],
                otherMeasures: "Chamomile tea",
                measureTime: "2024-01-02T16:00:00Z"
            ),
            notes: NotesModel(
                noteId: 1301,
                notesContent: "Patient is feeling better.",
                notesOtherObservations: "No new symptoms observed."
            ),
            contactWithDoctor: ContactWithDoctorModel(
                contactWithDoctorId: 1401,
                hasHadMedicalContact: "SPOKE_WITH_OUR_DOCTOR",
                dateOfContact: "2024-01-02T17:00:00Z",
                reasonForContact: ["WORRY_AND_INSECURITY"],
                otherReasonForContact: "High fever",
                doctorDiagnoses: ["Flu"],
                otherDiagnosis: "Mild dehydration",
                doctorsPrescriptionsIssued: ["Paracetamol"],
                otherPrescriptionsIssued: "Honey tea",
                doctorsRecommendationMeasures: "Keep hydrated"
            ),
            belongsToAFeverPhase: true,
            feverPhaseId: 101,
            feverPhaseIdOnline: 2001,
            medications: Medications(
                medicationEntryId: 1501,
                hasTakenMedication: "YES"
            ),
            bitmap: UIImage(named: "sample_graph")
        ),
            FeverPhaseEntry(
                entryId: 1001,
                profileId: 1,
                entryDate: "2024-07-24T14:37:00.000+00:00",
                stateOfHealth: StateOfHealthModel(
                    stateOfHealthId: 201,
                    stateOfHealth: "FINE",
                    stateOfHealthDateTime: "2024-01-02T10:00:00Z"
                ),
                temperature: TemperatureModel(
                    temperatureId: 301,
                    temperatureComparedToForehead: "EQUALLY_WARM_OR_WARMER_HANDS_AND_FEET",
                    wayOfDealingWithTemperature: "Cool cloths on the forehead",
                    temperatureDateTime: "2024-05-03T16:30:00.000+00:00",
                    temperatureValue: 40.5,
                    temperatureMeasurementUnit: "C",
                    temperatureMeasurementLocation: "IN_THE_MOUTH",
                    vaccination: VaccinationModel(
                        vaccinationId: 401,
                        vaccinatedLast2WeeksOrNot: "YES",
                        vaccineReceived: ["Flu Vaccine"],
                        vaccinationDateTime: "2023-12-25T09:00:00Z"
                    )
                ),
                pains: PainsModel(
                    painId: 501,
                    painValue: ["YES_IN_HEAD"],
                    painDateTime: "2024-01-02T10:20:00Z",
                    painSeverityScale: "THREE",
                    otherPlaces: "Neck"
                ),
                liquids: LiquidsModel(
                    liquidId: 601,
                    dehydrationSigns: ["YES_DRY_SKIN"],
                    liquidTime: "2024-01-02T11:00:00Z"
                ),
                diarrhea: DiarrheaModel(
                    diarrheaId: 701,
                    diarrheaAndOrVomiting: "YES_DIARRHEA",
                    observationTime: "2024-01-02T12:00:00Z"
                ),
                symptoms: SymptomsModel(
                    symptomsId: 801,
                    symptoms: ["COUGH", "MUCUS"],
                    otherSymptoms: ["Sore throat"]
                ),
                rash: RashModel(
                    rashId: 901,
                    rashes: ["YES_REDNESS_CAN_BE_PUSHED_AWAY"]
                ),
                warningSigns: WarningSignsModel(
                    warningSignsId: 1001,
                    warningSigns: ["YES_TOUCH_SENSITIVITY"],
                    warningSignsTime: "2024-01-02T14:00:00Z"
                ),
                confidenceLevel: ConfidenceLevelModel(
                    confidenceLevelId: 1101,
                    confidenceLevel: "THREE",
                    timeOfObservation: "2024-01-02T15:00:00Z"
                ),
                measures: MeasuresModel(
                    measureId: 1201,
                    takeMeasures: "YES",
                    measures: ["CLOTHS_ON_THE_FOREHEAD"],
                    otherMeasures: "Chamomile tea",
                    measureTime: "2024-01-02T16:00:00Z"
                ),
                notes: NotesModel(
                    noteId: 1301,
                    notesContent: "Patient is feeling better.",
                    notesOtherObservations: "No new symptoms observed."
                ),
                contactWithDoctor: ContactWithDoctorModel(
                    contactWithDoctorId: 1401,
                    hasHadMedicalContact: "SPOKE_WITH_OUR_DOCTOR",
                    dateOfContact: "2024-01-02T17:00:00Z",
                    reasonForContact: ["WORRY_AND_INSECURITY"],
                    otherReasonForContact: "High fever",
                    doctorDiagnoses: ["Flu"],
                    otherDiagnosis: "Mild dehydration",
                    doctorsPrescriptionsIssued: ["Paracetamol"],
                    otherPrescriptionsIssued: "Honey tea",
                    doctorsRecommendationMeasures: "Keep hydrated"
                ),
                belongsToAFeverPhase: true,
                feverPhaseId: 101,
                feverPhaseIdOnline: 2001,
                medications: Medications(
                    medicationEntryId: 1501,
                    hasTakenMedication: "YES"
                ),
                bitmap: UIImage(named: "sample_graph")
            ),
        FeverPhaseEntry(
            entryId: 1001,
            profileId: 1,
            entryDate: "2024-07-25T14:37:00.000+00:00",
            stateOfHealth: StateOfHealthModel(
                stateOfHealthId: 201,
                stateOfHealth: "UNWELL",
                stateOfHealthDateTime: "2024-01-02T10:00:00Z"
            ),

            pains: PainsModel(
                painId: 501,
                painValue: ["YES_IN_HEAD"],
                painDateTime: "2024-01-02T10:20:00Z",
                painSeverityScale: "FIVE",
                otherPlaces: "Neck"
            ),
            liquids: LiquidsModel(
                liquidId: 601,
                dehydrationSigns: ["YES_DRY_SKIN"],
                liquidTime: "2024-01-02T11:00:00Z"
            ),
            belongsToAFeverPhase: true,
            feverPhaseId: 101,
            feverPhaseIdOnline: 2001,
            medications: Medications(
                medicationEntryId: 1501,
                hasTakenMedication: "YES"
            ),
            bitmap: UIImage(named: "sample_graph")
        )
    ],
    bitmap: UIImage(named: "fever_phase_graph")
),
    FeverPhaseGraph(
    feverPhaseId: 101,
    profileId: 1,
    feverPhaseStartDate: "2024-08-24T00:00:00.000+00:00",
    feverPhaseEndDate: "2024-09-26T00:00:00.000+00:00",
    feverPhaseEntries: [
        FeverPhaseEntry(
            entryId: 1001,
            profileId: 1,
            entryDate: "2024-08-25T14:37:00.000+00:00",
            stateOfHealth: StateOfHealthModel(
                stateOfHealthId: 201,
                stateOfHealth: "VERY_SICK",
                stateOfHealthDateTime: "2024-01-02T10:00:00Z"
            ),
            temperature: TemperatureModel(
                temperatureId: 301,
                temperatureComparedToForehead: "EQUALLY_WARM_OR_WARMER_HANDS_AND_FEET",
                wayOfDealingWithTemperature: "Cool cloths on the forehead",
                temperatureDateTime: "2024-05-02T16:30:00.000+00:00",
                temperatureValue: 38.5,
                temperatureMeasurementUnit: "C",
                temperatureMeasurementLocation: "IN_THE_MOUTH",
                vaccination: VaccinationModel(
                    vaccinationId: 401,
                    vaccinatedLast2WeeksOrNot: "YES",
                    vaccineReceived: ["Flu Vaccine"],
                    vaccinationDateTime: "2023-12-25T09:00:00Z"
                )
            ),
            pains: PainsModel(
                painId: 501,
                painValue: ["YES_IN_HEAD"],
                painDateTime: "2024-01-02T10:20:00Z",
                painSeverityScale: "ONE",
                otherPlaces: "Neck"
            ),
            liquids: LiquidsModel(
                liquidId: 601,
                dehydrationSigns: ["YES_DRY_SKIN"],
                liquidTime: "2024-01-02T11:00:00Z"
            ),
            confidenceLevel: ConfidenceLevelModel(
                confidenceLevelId: 1101,
                confidenceLevel: "THREE",
                timeOfObservation: "2024-01-02T15:00:00Z"
            ),
            measures: MeasuresModel(
                measureId: 1201,
                takeMeasures: "YES",
                measures: ["CLOTHS_ON_THE_FOREHEAD"],
                otherMeasures: "Chamomile tea",
                measureTime: "2024-01-02T16:00:00Z"
            ),
            notes: NotesModel(
                noteId: 1301,
                notesContent: "Patient is feeling better.",
                notesOtherObservations: "No new symptoms observed."
            ),
            contactWithDoctor: ContactWithDoctorModel(
                contactWithDoctorId: 1401,
                hasHadMedicalContact: "SPOKE_WITH_OUR_DOCTOR",
                dateOfContact: "2024-01-02T17:00:00Z",
                reasonForContact: ["WORRY_AND_INSECURITY"],
                otherReasonForContact: "High fever",
                doctorDiagnoses: ["Flu"],
                otherDiagnosis: "Mild dehydration",
                doctorsPrescriptionsIssued: ["Paracetamol"],
                otherPrescriptionsIssued: "Honey tea",
                doctorsRecommendationMeasures: "Keep hydrated"
            ),
            belongsToAFeverPhase: true,
            feverPhaseId: 101,
            feverPhaseIdOnline: 2001,
            medications: Medications(
                medicationEntryId: 1501,
                hasTakenMedication: "YES"
            ),
            bitmap: UIImage(named: "sample_graph")
        )
    ],
    bitmap: UIImage(named: "fever_phase_graph")
),
]
