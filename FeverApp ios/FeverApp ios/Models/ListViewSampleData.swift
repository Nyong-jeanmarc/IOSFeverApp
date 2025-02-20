//
//  ListViewSampleData.swift
//  FeverApp ios
//
//  Created by user on 11/7/24.
//

import Foundation

let sampleGroupData: [GroupData] = [
    GroupData(
        groupDate: "2024-07-26T00:00:00.000+00:00",
        feverPhases: [
            FeverPhase(
                feverPhaseId: 92,
                profileId: 519,
                feverPhaseStartDate: "2024-07-24T00:00:00.000+00:00",
                feverPhaseEndDate: "2024-07-26T00:00:00.000+00:00",
                feverPhaseEntries: [
                    Entry(
                        entryId: 1164,
                        profileId: 519,
                        entryDate: "2024-07-25T14:37:00.000+00:00",
                        stateOfHealth: StateOfHealth(stateOfHealthId: 605, stateOfHealth: "FINE", stateOfHealthDateTime: "2024-07-24T14:37:00.000+00:00"),
                        temperature: Temperature(
                            temperatureId: 455,
                            temperatureComparedToForehead: "EQUALLY_WARM_OR_WARMER_HANDS_AND_FEET",
                            wayOfDealingWithTemperature: "NEITHER_WARM_NOR_COOL",
                            temperatureDateTime: "2024-11-07T21:59:00.000+00:00",
                            temperatureValue: 38.0,
                            temperatureMeasurementUnit: nil,
                            temperatureMeasurementLocation: "UNDER_THE_ARM",
                            vaccination: Vaccination(
                                vaccinationId: 157,
                                vaccinatedLast2WeeksOrNot: "NO",
                                vaccineReceived: [],
                                vaccinationDateTime: "2024-11-07T22:00:05.000+00:00"
                            )
                        ),
                        pains: Pains(
                            painId: 102,
                            painValue: ["YES_IN_NECK", "YES_SOMEWHERE_ELSE"],
                            painDateTime: "2024-11-07T21:59:00.000+00:00",
                            painSeverityScale: "THREE",
                            otherPlaces: "Back pain"
                        ),
                        liquids: Liquids(liquidId: 227, dehydrationSigns: ["YES_SUNKEN_EYE_SOCKETS", "YES_DRY_MUCOUS_MEMBRANES"], liquidTime: "2024-07-26T20:00:00.000+00:00"),
                        diarrhea: Diarrhea(
                            diarrheaId: 202,
                            diarrheaAndOrVomiting: "YES_DIARRHEA_AND_VOMITING",
                            observationTime: "2024-11-07T21:59:00.000+00:00"
                        ),
                        symptoms: Symptoms(
                            symptomsId: 406,
                            symptoms: ["COUGH", "FREEZING_CHILLS", "OTHER", "TONSILLITIS", "JOINT_SWELLING", "TEETHING"],
                            otherSymptoms: ["Nausea", "Dizziness"],
                            symptomsTime: "2024-11-07T21:59:00.000+00:00"
                        ),
                        rash: Rash(
                            rashId: 304,
                            rashes: ["YES_REDNESS_CAN_BE_PUSHED_AWAY", "YES_REDNESS_CANNOT_BE_PUSHED_AWAY"],
                            rashTime: "2024-11-07T21:59:00.000+00:00"
                        ),
                        warningSigns: WarningSigns(
                            warningSignsId: 505,
                            warningSigns: [
                                "YES_TOUCH_SENSITIVITY",
                                "YES_SHRILL_SCREAMING_LIKE_I_VE_NEVER_HEARD_IT_BEFORE",
                                "YES_ACTING_DIFFERENTLY_CLOUDED_CONSCIOUSNESS_APATHY",
                                "YES_SEEMS_SERIOUSLY_SICK"
                            ],
                            warningSignsTime: "2024-11-07T21:59:00.000+00:00"
                        ),
                        confidenceLevel: ConfidenceLevel(
                            confidenceLevelId: 604,
                            confidenceLevel: "FOUR",
                            timeOfObservation: "2024-11-07T21:59:00.000+00:00"
                        ),
                        measures: Measures(
                            measureId: 904,
                            takeMeasures: "YES",
                            measures: ["HOT_WATER_BOTTLE", "LEG_COMPRESSES", "OTHER_MEASURES"],
                            otherMeasures: "Applied essential oil rubs",
                            measureTime: "2024-11-07T21:59:00.000+00:00"
                        ),
                        notes: Notes(
                            noteId: 1004,
                            notesContent: "Doctor recommended resting for two days.",
                            notesOtherContent: "Administered prescribed antibiotics.",
                            notesTime: "2024-11-04T12:00:00.000+00:00"
                        ),
                        contactWithDoctor: ContactWithDoctor(
                            contactWithDoctorId: 706,
                            hasHadMedicalContact: "SPOKE_WITH_ANOTHER_DOCTOR",
                            dateOfContact: "2024-11-03T18:00:00.000+00:00",
                            reasonForContact: ["OTHER"],
                            otherReasonForContact: "Persistent cough",
                            doctorDiagnoses: ["BRONCHITIS"],
                            otherDiagnosis: "",
                            doctorsPrescriptionsIssued: ["OTHER"],
                            otherPrescriptionsIssued: "Cough syrup",
                            doctorsRecommendationMeasures: "Avoid cold air and drink warm fluids."
                        ),
                        belongsToAFeverPhase: true,
                        feverPhaseId: 92,
                        medications: MedicationsModel(
                            medicationEntryId: 803,
                            hasTakenMedications: "YES",
                            medicationList: [
                                Medication(
                                    medicationId: 102,
                                    medicationEntryId: 803,
                                    userId: 1002,
                                    medicationName: "Paracetamol",
                                    typeOfMedication: "Antipyretic",
                                    activeIngredientQuantity: 500.0,
                                    amountAdministered: 2.0,
                                    reasonForAdministration: "Pain relief",
                                    basisOfDecision: "Self-medication",
                                    dateOfAdministration: "2024-11-06",
                                    timeOfAdministration: "09:00"
                                ),
                                Medication(
                                    medicationId: 103,
                                    medicationEntryId: 803,
                                    userId: 1002,
                                    medicationName: "Amoxicillin",
                                    typeOfMedication: "Antibiotic",
                                    activeIngredientQuantity: 250.0,
                                    amountAdministered: 1.5,
                                    reasonForAdministration: "Bacterial infection",
                                    basisOfDecision: "Doctor's prescription",
                                    dateOfAdministration: "2024-11-06",
                                    timeOfAdministration: "21:00"
                                )
                            ]
                        )
                    )
                ]
            )
        ],
        entriesNotBelongingToAFeverPhase: [
            Entry(
                entryId: 1167,
                profileId: 519,
                entryDate: "2024-07-26T20:00:00.000+00:00",
                stateOfHealth: StateOfHealth(stateOfHealthId: 608, stateOfHealth: "NEUTRAL", stateOfHealthDateTime: "2024-07-26T20:00:00.000+00:00"),
                temperature: nil,
                pains: nil,
                liquids: Liquids(liquidId: 227, dehydrationSigns: ["YES_SUNKEN_EYE_SOCKETS"], liquidTime: "2024-07-26T20:00:00.000+00:00"),
                diarrhea: nil,
                symptoms: nil,
                rash: nil,
                warningSigns: nil,
                confidenceLevel: nil,
                measures:Measures(
                    measureId: 904,
                    takeMeasures: "YES",
                    measures: ["READING_STORY_TELLING_SINGING", "TEA_WITH_HONEY", "CLOTHS_ON_THE_FOREHEAD"],
                    otherMeasures: nil,
                    measureTime: "2024-11-07T21:59:00.000+00:00"
                ),
                notes: Notes(
                    noteId: 1003,
                    notesContent: "Observed rash on arms and legs.",
                    notesOtherContent: "Applied soothing cream as per doctor's advice.",
                    notesTime: "2024-11-05T18:45:00.000+00:00"
                ),
                contactWithDoctor: nil,
                belongsToAFeverPhase: false,
                feverPhaseId: nil,
                medications: nil
            )
        ]
    ),
    GroupData(
        groupDate: "2024-08-29T00:00:00.000+00:00",
        feverPhases: [
            FeverPhase(
                feverPhaseId: 93,
                profileId: 519,
                feverPhaseStartDate: "2024-08-24T00:00:00.000+00:00",
                feverPhaseEndDate: "2024-08-26T00:00:00.000+00:00",
                feverPhaseEntries: [
                    Entry(
                        entryId: 1168,
                        profileId: 519,
                        entryDate: "2024-08-24T14:37:00.000+00:00",
                        stateOfHealth: StateOfHealth(stateOfHealthId: 605, stateOfHealth: "UNWELL", stateOfHealthDateTime: "2024-08-24T14:37:00.000+00:00"),
                        temperature: nil,
                        pains: nil,
                        liquids: nil,
                        diarrhea: nil,
                        symptoms: nil,
                        rash: nil,
                        warningSigns: nil,
                        confidenceLevel: nil,
                        measures: nil,
                        notes: nil,
                        contactWithDoctor: nil,
                        belongsToAFeverPhase: true,
                        feverPhaseId: 92,
                        medications: nil
                    ),
                    Entry(
                        entryId: 1169,
                        profileId: 519,
                        entryDate: "2024-07-24T14:37:00.000+00:00",
                        stateOfHealth: StateOfHealth(stateOfHealthId: 605, stateOfHealth: "EXCELLENT", stateOfHealthDateTime: "2024-07-24T14:37:00.000+00:00"),
                        temperature: nil,
                        pains: nil,
                        liquids: nil,
                        diarrhea: nil,
                        symptoms: nil,
                        rash: nil,
                        warningSigns: nil,
                        confidenceLevel: nil,
                        measures: nil,
                        notes: nil,
                        contactWithDoctor: nil,
                        belongsToAFeverPhase: true,
                        feverPhaseId: 92,
                        medications: nil
                    )
                ]
            )
        ],
        entriesNotBelongingToAFeverPhase: [
            Entry(
                entryId: 1170,
                profileId: 519,
                entryDate: "2024-07-26T20:00:00.000+00:00",
                stateOfHealth: StateOfHealth(stateOfHealthId: 608, stateOfHealth: "VERY_SICK", stateOfHealthDateTime: "2024-07-26T20:00:00.000+00:00"),
                temperature: nil,
                pains: nil,
                liquids: Liquids(liquidId: 227, dehydrationSigns: ["YES_SUNKEN_EYE_SOCKETS"], liquidTime: "2024-07-26T20:00:00.000+00:00"),
                diarrhea: nil,
                symptoms: nil,
                rash: nil,
                warningSigns: nil,
                confidenceLevel: nil,
                measures: nil,
                notes: nil,
                contactWithDoctor: nil,
                belongsToAFeverPhase: false,
                feverPhaseId: nil,
                medications: nil
            )
        ]
    )
]


