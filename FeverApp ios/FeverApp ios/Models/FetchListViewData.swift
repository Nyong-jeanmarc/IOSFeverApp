//
//  FetchListViewData.swift
//  FeverApp ios
//
//  Created by user on 12/2/24.
//

import Foundation
import CoreData
import UIKit

func fetchProfileDashboardListView(profileId: Int64) -> [GroupData] {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    do {
        // Fetch fever phases for the profile
        let feverPhaseFetchRequest: NSFetchRequest<FeverPhaseLocal> = FeverPhaseLocal.fetchRequest()
        feverPhaseFetchRequest.predicate = NSPredicate(format: "profileId == %d", profileId)
        let feverPhases = try managedContext.fetch(feverPhaseFetchRequest)
        print("\n\nFetched fever phases: \(feverPhases)")
        
        // Fetch entries not belonging to any fever phase for the profile
        let entriesFetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        // Add the predicate to exclude deleted entries
         entriesFetchRequest.predicate = NSPredicate(format: "profileId == %d AND belongsToAFeverPhase == 0 AND (isdeleted == false OR isdeleted == nil)", profileId)
        let entriesNotBelongingToAFeverPhase = try managedContext.fetch(entriesFetchRequest)
        print("\n\nFetched entries not belonging to any fever phase: \(entriesNotBelongingToAFeverPhase)")
                
                if entriesNotBelongingToAFeverPhase.isEmpty {
                    print("\n\nNo entries found for profileId: \(profileId)")
                }
        
        // Date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        let simpleDateFormatter = DateFormatter()
        simpleDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        let simpleTimeFormatter = DateFormatter()
        simpleTimeFormatter.dateFormat = "HH:mm:ss"

        
        // Transform fever phases
        let feverPhaseResponses = feverPhases.compactMap { feverPhase -> FeverPhase? in
            let feverPhaseEntriesFetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            feverPhaseEntriesFetchRequest.predicate = NSPredicate(format: "(feverPhaseId == %d OR feverPhaseIdOnline == %d) AND (isdeleted == false OR isdeleted == nil)", feverPhase.feverPhaseId, feverPhase.onlineFeverPhaseId)
            
            guard let feverPhaseEntries = try? managedContext.fetch(feverPhaseEntriesFetchRequest) else {
                print("Failed to fetch entries for feverPhaseId: \(feverPhase.feverPhaseId)")
                return nil
            }
            
            return FeverPhase(
                feverPhaseId: Int(feverPhase.feverPhaseId),
                profileId: Int(feverPhase.profileId),
                feverPhaseStartDate: dateFormatter.string(from: feverPhase.feverPhaseStartDate ?? Date()),
                feverPhaseEndDate: dateFormatter.string(from: feverPhase.feverPhaseEndDate ?? Date()),
                feverPhaseEntries: feverPhaseEntries.map { entry in
                    mapEntry(entry: entry, dateFormatter: dateFormatter, timeFormatter: timeFormatter)
                }
            )
        }

        
        // Group fever phases by date
        let feverPhasesMap = Dictionary(grouping: feverPhaseResponses, by: { simpleDateFormatter.string(from: dateFormatter.date(from: $0.feverPhaseEndDate) ?? Date()) })
        let entriesMap = Dictionary(grouping: entriesNotBelongingToAFeverPhase, by: { simpleDateFormatter.string(from: $0.entryDate ?? Date()) })
        
        // Combine fever phases and entries into GroupData
        let allDates = Set(feverPhasesMap.keys).union(entriesMap.keys)
        let resultsList = allDates.map { date in
            GroupData(
                groupDate: date,
                feverPhases: feverPhasesMap[date] ?? [],
                entriesNotBelongingToAFeverPhase: (entriesMap[date] ?? []).map { entry in
                    mapEntry(entry: entry, dateFormatter: dateFormatter, timeFormatter: timeFormatter)
                }
            )
        }
        
        return resultsList.sorted(by: { $0.groupDate > $1.groupDate }) // Sort by date
    } catch let error as NSError {
        print("Could not fetch profile dashboard data: \(error), \(error.userInfo)")
        return []
    }
}

func mapEntry(entry: LocalEntry, dateFormatter: DateFormatter, timeFormatter: DateFormatter) -> Entry {
    return Entry(
        entryId: Int(entry.entryId),
        profileId: Int(entry.profileId),
        entryDate: dateFormatter.string(from: entry.entryDate ?? Date()),
        stateOfHealth: entry.stateOfHealth.map {
            StateOfHealth(
                stateOfHealthId: Int($0.stateOfHealthId),
                stateOfHealth: $0.stateOfHealth ?? "",
                stateOfHealthDateTime: dateFormatter.string(from: $0.stateOfHealthDateTime ?? Date())
            )
        },
        temperature: entry.temperature.map {
            Temperature(
                temperatureId: Int($0.temperatureId),
                temperatureComparedToForehead: $0.temperatureComparedToForehead ?? "",
                wayOfDealingWithTemperature: $0.wayOfDealingWithTemperature ?? "",
                temperatureDateTime: dateFormatter.string(from: $0.temperatureDateTime ?? Date()),
                temperatureValue: Double($0.temperatureValue),
                temperatureMeasurementUnit: $0.temperatureMeasurementUnit,
                temperatureMeasurementLocation: $0.temperatureMeasurementLocation ?? "",
                vaccination: $0.vaccination.map {
                    Vaccination(
                        vaccinationId: Int($0.vaccinationId),
                        vaccinatedLast2WeeksOrNot: $0.vaccinatedLast2WeeksOrNot ?? "",
                        vaccineReceived: $0.vaccineReceived as? [String] ?? [],
                        vaccinationDateTime: dateFormatter.string(from: $0.vaccinationDateTime ?? Date())
                    )
                }
            )
        },
        pains: entry.pains.map {
            Pains(
                painId: Int($0.painId),
                painValue: $0.painValue as? [String] ?? [],
                painDateTime: dateFormatter.string(from: $0.painDateTime ?? Date()),
                painSeverityScale: $0.painSeverityScale ?? "",
                otherPlaces: $0.otherPlaces ?? ""
            )
        },
        liquids: entry.liquids.map {
            Liquids(
                liquidId: Int($0.liquidId),
                dehydrationSigns: $0.dehydrationSigns as? [String] ?? [],
                liquidTime: dateFormatter.string(from: $0.liquidTime ?? Date())
            )
        },
        diarrhea: entry.diarrhea.map {
            Diarrhea(
                diarrheaId: Int($0.diarrheaId),
                diarrheaAndOrVomiting: $0.diarrheaAndOrVomiting ?? "",
                observationTime: dateFormatter.string(from: $0.observationTime ?? Date())
            )
        },
        symptoms: entry.symptoms.map {
            Symptoms(
                symptomsId: Int($0.symptomsId),
                symptoms: $0.symptoms as? [String] ?? [],
                otherSymptoms: $0.otherSymptoms as? [String],
                symptomsTime: dateFormatter.string(from: $0.symptomsTime ?? Date())
            )
        },
        rash: entry.rash.map {
            Rash(
                rashId: Int($0.rashId),
                rashes: $0.rashes as? [String] ?? [],
                rashTime: dateFormatter.string(from: $0.rashTime ?? Date())
            )
        },
        warningSigns: entry.warningSigns.map {
            WarningSigns(
                warningSignsId: Int($0.warningSignsId),
                warningSigns: $0.warningSigns as? [String] ?? [],
                warningSignsTime: dateFormatter.string(from: $0.warningSignsTime ?? Date())
            )
        },
        confidenceLevel: entry.confidenceLevel.map {
            ConfidenceLevel(
                confidenceLevelId: Int($0.confidenceLevelId),
                confidenceLevel: $0.confidenceLevel ?? "",
                timeOfObservation: dateFormatter.string(from: $0.timeOfObservation ?? Date())
            )
        },
        measures: entry.measures.map {
            Measures(
                measureId: Int($0.measureId),
                takeMeasures: $0.takeMeasures ?? "",
                measures: $0.measures as? [String] ?? [],
                otherMeasures: $0.otherMeasures,
                measureTime: dateFormatter.string(from: $0.measureTime ?? Date())
            )
        },
        notes: entry.notes.map {
            Notes(
                noteId: Int($0.noteId),
                notesContent: $0.notesContent ?? "",
                notesOtherContent: $0.notesOtherObservations ?? "",
                notesTime: dateFormatter.string(from: $0.notesTime ?? Date())
            )
        },
        contactWithDoctor: entry.contactWithDoctor.map {
            ContactWithDoctor(
                contactWithDoctorId: Int($0.contactWithDoctorId),
                hasHadMedicalContact: $0.hasHadMedicalContact ?? "",
                dateOfContact: dateFormatter.string(from: $0.dateOfContact ?? Date()),
                reasonForContact: $0.reasonForContact as? [String] ?? [],
                otherReasonForContact: $0.otherReasonForContact,
                doctorDiagnoses: $0.doctorDiagnoses as? [String] ?? [],
                otherDiagnosis: $0.otherDiagnosis ?? "",
                doctorsPrescriptionsIssued: $0.doctorsPrescriptionsIssued as? [String] ?? [],
                otherPrescriptionsIssued: $0.otherPrescriptionsIssued,
                doctorsRecommendationMeasures: $0.doctorsRecommendationMeasures
            )
        },
        belongsToAFeverPhase: entry.belongsToAFeverPhase,
        feverPhaseId: Int(entry.feverPhaseId),
        medications: entry.medications.map {
            MedicationsModel(
                medicationEntryId: Int($0.medicationEntryId),
                hasTakenMedications: $0.hasTakenMedication ?? "",
                medicationList: ($0.entryMedications?.allObjects as? [Entry_medications])?.map { medication in
                    Medication(
                        medicationId: Int(medication.id),
                        medicationEntryId: Int(medication.medicationEntryId),
                        userId: Int(medication.userMedicationId),
                        medicationName: medication.medicationName ?? "",
                        typeOfMedication: medication.typeOfMedication ?? "",
                        activeIngredientQuantity: medication.activeIngredientQuantity,
                        amountAdministered: medication.amountAdministered,
                        reasonForAdministration: medication.reasonForAdministration,
                        basisOfDecision: medication.basisOfDecision,
                        dateOfAdministration:
                            dateFormatter.string(from: medication.dateOfAdministration ?? Date()),
                        timeOfAdministration: timeFormatter.string(from: medication.timeOfAdministration ?? Date())
                    )
                } ?? []
            )
        }

    )
}
