//
//  FetchProfileFeverPhases.swift
//  FeverApp ios
//
//  Created by user on 12/9/24.
//


import Foundation
import CoreData
import UIKit

struct PdfFeverPhase {
    let feverPhaseStartDate: String
    let feverPhaseEndDate: String
    let key: String
}

class FeverPhaseRepository {
    static let shared = FeverPhaseRepository()
    
    private init() {}
    
    func getAllProfileFeverPhases(profileId: Int64, isLoading: inout Bool) -> [PdfFeverPhase] {
        isLoading = true
        var feverPhases: [PdfFeverPhase] = []
        
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
                let context = appDelegate.persistentContainer.viewContext
        
        // Fetch Fever Phases
        let feverPhaseFetchRequest: NSFetchRequest<FeverPhaseLocal> = FeverPhaseLocal.fetchRequest()
        feverPhaseFetchRequest.predicate = NSPredicate(format: "profileId == %@", NSNumber(value: profileId))
        
        do {
            let profileFeverPhases = try context.fetch(feverPhaseFetchRequest)
            
            // Map to FeverPhase structs
            let mappedFeverPhases = profileFeverPhases.map { feverPhase -> PdfFeverPhase in
                PdfFeverPhase(
                    feverPhaseStartDate: feverPhase.feverPhaseStartDate?.toString() ?? "",
                    feverPhaseEndDate: feverPhase.feverPhaseEndDate?.toString() ?? "",
                    key: String(feverPhase.feverPhaseId)
                )
            }
            
            feverPhases.append(contentsOf: mappedFeverPhases)
        } catch {
            print("Error fetching fever phases: \(error.localizedDescription)")
        }
        
        // Fetch Entries Not Belonging to a Fever Phase
        let entryFetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        entryFetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "belongsToAFeverPhase == nil"),
            NSPredicate(format: "belongsToAFeverPhase == %@", NSNumber(value: false))
        ])
        
        do {
            let entriesNotBelongingToAFeverPhase = try context.fetch(entryFetchRequest)
            
            if !entriesNotBelongingToAFeverPhase.isEmpty {
                // Find the earliest start date
                let earliestStartDate = entriesNotBelongingToAFeverPhase.min {
                    ($0.entryDate ?? Date()) < ($1.entryDate ?? Date())
                }?.entryDate
                
                // Create an ongoing fever phase
                let ongoingFeverPhase = PdfFeverPhase(
                    feverPhaseStartDate: earliestStartDate?.toString() ?? "",
                    feverPhaseEndDate: earliestStartDate?.toString() ?? "",
                    key: "0"
                )
                
                // Add ongoing fever phase to the beginning
                feverPhases.insert(ongoingFeverPhase, at: 0)
            }
        } catch {
            print("Error fetching entries not belonging to a fever phase: \(error.localizedDescription)")
        }
        
        isLoading = false
        return feverPhases
    }
    
    // Fetch entries not belonging to any fever phase
        func getEntriesNotBelongingToAFeverPhase(profileId: Int64) -> [LocalEntry] {
            let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
            
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "profileId == %@", NSNumber(value: profileId)),
                NSCompoundPredicate(orPredicateWithSubpredicates: [
                    NSPredicate(format: "belongsToAFeverPhase == nil"),
                    NSPredicate(format: "belongsToAFeverPhase == %@", NSNumber(value: false))
                ])
            ])
            
            do {
                let context = appDelegate.persistentContainer.viewContext
                return try context.fetch(fetchRequest)
            } catch {
                print("Error fetching entries not belonging to any fever phase: \(error.localizedDescription)")
                return []
            }
        }
    
    func getEntriesByFeverPhaseId(_ feverPhaseId: Int64) -> [LocalEntry] {
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        fetchRequest.predicate = NSPredicate(format: "feverPhaseId == %@", NSNumber(value: feverPhaseId))
        
        do {
            let context = appDelegate.persistentContainer.viewContext
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching entries for feverPhaseId \(feverPhaseId): \(error.localizedDescription)")
            return []
        }
    }
    
    func getFilteredFeverPhases(profileId: Int64, selectedFeverPhaseIds: [Int64], completion: @escaping ([FeverPhaseGraph]?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let repository = FeverPhaseRepository.shared
                var isLoadingFlag = false
                
                // Fetch all fever phases
                let allPdfFeverPhases = repository.getAllProfileFeverPhases(profileId: profileId, isLoading: &isLoadingFlag)
                
                // Map PdfFeverPhase to FeverPhaseGraph
                let allFeverPhases = allPdfFeverPhases.map { pdfFeverPhase -> FeverPhaseGraph in
                    let feverPhaseId = Int64(pdfFeverPhase.key) ?? 0
                    
                    // Fetch entries for the fever phase
                    let entries: [FeverPhaseEntry] = {
                        if feverPhaseId == 0 {
                            return repository.getEntriesNotBelongingToAFeverPhase(profileId: profileId).compactMap { entry in
                                mapLocalEntryToFeverPhaseEntry(localEntry: entry)
                            }
                        } else {
                            return repository.getEntriesByFeverPhaseId(feverPhaseId).compactMap { entry in
                                mapLocalEntryToFeverPhaseEntry(localEntry: entry)
                            }
                        }
                    }()

                    
                    return FeverPhaseGraph(
                        feverPhaseId: feverPhaseId,
                        profileId: profileId,
                        feverPhaseStartDate: pdfFeverPhase.feverPhaseStartDate,
                        feverPhaseEndDate: pdfFeverPhase.feverPhaseEndDate,
                        feverPhaseEntries: entries,
                        bitmap: nil // Add logic for fetching or generating UIImage if necessary
                    )
                }
                
                // Filter the fever phases based on selected IDs
                let filteredFeverPhases = allFeverPhases.filter { selectedFeverPhaseIds.contains($0.feverPhaseId ?? -1) }
                
                // Return the filtered fever phases
                DispatchQueue.main.async {
                    completion(filteredFeverPhases, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
}

extension Date {
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}





func mapLocalEntryToFeverPhaseEntry(localEntry: LocalEntry) -> FeverPhaseEntry {
    return FeverPhaseEntry(
        entryId: localEntry.entryId,
        profileId: localEntry.profileId,
        entryDate: localEntry.entryDate?.toISO8601String(),
        stateOfHealth: localEntry.stateOfHealth.map { stateOfHealth in
            StateOfHealthModel(
                stateOfHealthId: stateOfHealth.stateOfHealthId,
                stateOfHealth: stateOfHealth.stateOfHealth,
                stateOfHealthDateTime: stateOfHealth.stateOfHealthDateTime?.toISO8601String()
            )
        },
        temperature: localEntry.temperature.map { temperature in
            TemperatureModel(
                temperatureId: temperature.temperatureId,
                temperatureComparedToForehead: temperature.temperatureComparedToForehead,
                wayOfDealingWithTemperature: temperature.wayOfDealingWithTemperature,
                temperatureDateTime: temperature.temperatureDateTime?.toISO8601String(),
                temperatureValue: Double(temperature.temperatureValue),
                temperatureMeasurementUnit: temperature.temperatureMeasurementUnit,
                temperatureMeasurementLocation: temperature.temperatureMeasurementLocation,
                vaccination: temperature.vaccination.map { vaccination in
                    VaccinationModel(
                        vaccinationId: vaccination.vaccinationId,
                        vaccinatedLast2WeeksOrNot: vaccination.vaccinatedLast2WeeksOrNot,
                        vaccineReceived: vaccination.vaccineReceived as? [String],
                        vaccinationDateTime: vaccination.vaccinationDateTime?.toISO8601String()
                    )
                }
            )
        },
        pains: localEntry.pains.map { pains in
            PainsModel(
                painId: pains.painId,
                painValue: pains.painValue as? [String],
                painDateTime: pains.painDateTime?.toISO8601String(),
                painSeverityScale: pains.painSeverityScale,
                otherPlaces: pains.otherPlaces
            )
        },
        liquids: localEntry.liquids.map { liquids in
            LiquidsModel(
                liquidId: liquids.liquidId,
                dehydrationSigns: liquids.dehydrationSigns as? [String],
                liquidTime: liquids.liquidTime?.toISO8601String()
            )
        },
        diarrhea: localEntry.diarrhea.map { diarrhea in
            DiarrheaModel(
                diarrheaId: diarrhea.diarrheaId,
                diarrheaAndOrVomiting: diarrhea.diarrheaAndOrVomiting,
                observationTime: diarrhea.observationTime?.toISO8601String()
            )
        },
        symptoms: localEntry.symptoms.map { symptoms in
            SymptomsModel(
                symptomsId: symptoms.symptomsId,
                symptoms: symptoms.symptoms as? [String],
                otherSymptoms: symptoms.otherSymptoms as? [String]
            )
        },
        rash: localEntry.rash.map { rash in
            RashModel(
                rashId: rash.rashId,
                rashes: rash.rashes as? [String]
            )
        },
        warningSigns: localEntry.warningSigns.map { warningSigns in
            WarningSignsModel(
                warningSignsId: warningSigns.warningSignsId,
                warningSigns: warningSigns.warningSigns as? [String],
                warningSignsTime: warningSigns.warningSignsTime?.toISO8601String()
            )
        },
        confidenceLevel: localEntry.confidenceLevel.map { confidenceLevel in
            ConfidenceLevelModel(
                confidenceLevelId: confidenceLevel.confidenceLevelId,
                confidenceLevel: confidenceLevel.confidenceLevel,
                timeOfObservation: confidenceLevel.timeOfObservation?.toISO8601String()
            )
        },
        measures: localEntry.measures.map { measures in
            MeasuresModel(
                measureId: measures.measureId,
                takeMeasures: measures.takeMeasures,
                measures: measures.measures as? [String],
                otherMeasures: measures.otherMeasures,
                measureTime: measures.measureTime?.toISO8601String()
            )
        },
        notes: localEntry.notes.map { notes in
            NotesModel(
                noteId: notes.noteId,
                notesContent: notes.notesContent,
                notesOtherObservations: notes.notesOtherObservations
            )
        },
        contactWithDoctor: localEntry.contactWithDoctor.map { contact in
            ContactWithDoctorModel(
                contactWithDoctorId: contact.contactWithDoctorId,
                hasHadMedicalContact: contact.hasHadMedicalContact,
                dateOfContact: contact.dateOfContact?.toISO8601String(),
                reasonForContact: contact.reasonForContact as? [String],
                otherReasonForContact: contact.otherReasonForContact,
                doctorDiagnoses: contact.doctorDiagnoses as? [String],
                otherDiagnosis: contact.otherDiagnosis,
                doctorsPrescriptionsIssued: contact.doctorsPrescriptionsIssued as? [String],
                otherPrescriptionsIssued: contact.otherPrescriptionsIssued,
                doctorsRecommendationMeasures: contact.doctorsRecommendationMeasures
            )
        },
        belongsToAFeverPhase: localEntry.belongsToAFeverPhase,
        feverPhaseId: localEntry.feverPhaseId,
        feverPhaseIdOnline: localEntry.feverPhaseIdOnline,
        medications: localEntry.medications.map { medications in
            Medications(
                medicationEntryId: medications.medicationEntryId,
                hasTakenMedication: medications.hasTakenMedication
            )
        },
        bitmap: nil // Assuming UIImage needs to be handled separately
    )
}

// Extension to convert Date to ISO8601 string
extension Date {
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
