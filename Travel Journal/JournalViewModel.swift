//
//  JournalViewModel.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI
import Combine

class JournalViewModel: ObservableObject {
    @Published private(set) var loading = false
    @Published private(set) var entryInView: JournalEntry? = nil
    @Published private(set) var error: String? = nil
    @Published private(set) var allEntriesOnFile: [JournalEntry] = []
    
    private let journalRepo: JournalRepository
    
    init(journalRepo: JournalRepository) {
        self.journalRepo = journalRepo
        getAllJournalEntriesOnFile()
    }
    
    private func launchDataOperation(operation: @escaping () async throws -> Void) {
        loading = true
        error = nil
        entryInView = nil
        
        Task {
            defer {
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
            do {
                try await operation()
            } catch {
                DispatchQueue.main.async {
                    self.error = self.mapError(error)
                }
            }
        }
    }
    
    private func mapError(_ error: Error) -> String {
        "An unexpected error occurred: \(error.localizedDescription). Please try again later."
    }
    
    func getAllJournalEntriesOnFile() {
        launchDataOperation { [self] in
            do {
                let allEntries = try await journalRepo.getAllJournalEntriesOnFile()
                DispatchQueue.main.async {
                    self.allEntriesOnFile = allEntries
                }
            } catch {
                DispatchQueue.main.async { [self] in
                    self.error = mapError(error)
                }
            }
        }
    }
    
    func getSingleJournalEntry(entryID: String) {
        launchDataOperation { [self] in
            do {
                let singleEntry = try await journalRepo.getSingleJournalEntry(entryID: entryID)
                DispatchQueue.main.async {
                    self.entryInView = singleEntry
                }
            } catch {
                DispatchQueue.main.async { [self] in
                    self.error = mapError(error)
                }
            }
        }
    }
    
    func uploadNewJournalEntry(startDate: Date, endDate: Date, travelLocation: String, longitude: Double, latitude: Double) {
        launchDataOperation { [self] in
            do {
                let allEntries = try await journalRepo.uploadNewJournalEntry(startDate: startDate, endDate: endDate, travelLocation: travelLocation, longitude: longitude, latitude: latitude)
                DispatchQueue.main.async {
                    self.allEntriesOnFile = allEntries
                }
            } catch {
                DispatchQueue.main.async { [self] in
                    self.error = mapError(error)
                }
            }
        }
    }
    
    func updateSelectedEntryThumbnailImage(entryID: String, imageURL: String) {
        launchDataOperation { [self] in
            do {
                let singleEntry = try await journalRepo.updateSelectedEntryThumbnailImage(entryID: entryID, imageURL: imageURL)
                DispatchQueue.main.async {
                    self.entryInView = singleEntry
                }
            } catch {
                DispatchQueue.main.async { [self] in
                    self.error = mapError(error)
                }
            }
        }
    }
    
    func uploadNewHighlightToJournalEntry(entryID: String, highlightDate: Date, entryHighlights: [UIImage], highlightLocation: String, journalHighlightEntry: String, longitude: Double, latitude: Double) {
        launchDataOperation { [self] in
            do {
                let singleEntry = try await journalRepo.uploadNewHighlightToJournalEntry(entryID: entryID, highlightDate: highlightDate, entryHighlights: entryHighlights, highlightLocation: highlightLocation, journalHighlightEntry: journalHighlightEntry, longitude: longitude, latitude: latitude)
                DispatchQueue.main.async {
                    self.entryInView = singleEntry
                }
            } catch {
                DispatchQueue.main.async { [self] in
                    self.error = mapError(error)
                }
            }
        }
    }
}
