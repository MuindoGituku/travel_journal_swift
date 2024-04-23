//
//  JournalRepository.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class JournalRepository {
    private lazy var storageRef = Storage.storage().reference()
    private lazy var db = Firestore.firestore()
    
    private func executeWithExceptionHandling<T>(block: @escaping () async throws -> T) async throws -> T {
        do {
            return try await block()
        } catch {
            throw error
        }
    }
    
    private func uploadImageToFirebaseStorageAwait(pathString: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw URLError(.badServerResponse)
        }
        
        let savePath = storageRef.child(pathString)
        
        do {
            let _ = try await savePath.putDataAsync(imageData)
            
            let downloadURL = try await savePath.downloadURL()
            return downloadURL.absoluteString
        } catch {
            throw URLError(.badServerResponse)
        }
    }
    
    func getAllJournalEntriesOnFile() async throws -> [JournalEntry] {
        return try await executeWithExceptionHandling { [self] in
            var allJournalEntries: [JournalEntry] = []
            
            let docsQuery = try await db.collection("entries").getDocuments()
            
            for doc in docsQuery.documents {
                guard var entry = try? doc.data(as: JournalEntry.self) else {
                    throw URLError(.badServerResponse)
                }
                entry.id = doc.documentID
                
                allJournalEntries.append(entry)
            }
            
            return allJournalEntries
        }
    }
    
    func getSingleJournalEntry(entryID: String) async throws -> JournalEntry {
        return try await executeWithExceptionHandling { [self] in
            let snapshot = try await db.collection("entries").document(entryID).getDocument()
            guard var entry = try? snapshot.data(as: JournalEntry.self) else {
                throw URLError(.badServerResponse)
            }
            entry.id = snapshot.documentID
            
            return entry
        }
    }
    
    func uploadNewJournalEntry(startDate: Date, endDate: Date, travelLocation: String, longitude: Double, latitude: Double) async throws -> [JournalEntry] {
        return try await executeWithExceptionHandling { [self] in
            let newJournalEntry = JournalEntry(id: UUID().uuidString, entryThumbnail: "", travelLocation: travelLocation, travelLocationCoordinates: HighlightCoordinates(latitude: latitude, longitude: longitude), travelStartDate: startDate, travelEndDate: endDate, entryHighlights: [])
            
            let newJournalEntryData = try Firestore.Encoder().encode(newJournalEntry)
            
            try await db.collection("entries").addDocument(data: newJournalEntryData)
            
            return try await getAllJournalEntriesOnFile()
        }
    }
    
    func updateSelectedEntryThumbnailImage(entryID: String, imageURL: String) async throws -> JournalEntry {
        return try await executeWithExceptionHandling { [self] in
            var entry = try await getSingleJournalEntry(entryID: entryID)
            entry.id = entryID
            entry.entryThumbnail = imageURL
            
            try db.collection("entries").document(entryID).setData(from: entry)
            
            return entry
        }
    }
    
    func uploadNewHighlightToJournalEntry(entryID: String, highlightDate: Date, entryHighlights: [UIImage], highlightLocation: String, journalHighlightEntry: String, longitude: Double, latitude: Double) async throws -> JournalEntry {
        return try await executeWithExceptionHandling { [self] in
            var highlightsImagesURLs: [String] = []
            
            for image in entryHighlights {
                let imageURL = try await uploadImageToFirebaseStorageAwait(pathString: "highlights/\(entryID)/\(UUID().uuidString).jpg", image: image)
                highlightsImagesURLs.append(imageURL)
            }
            
            let newJournalEntryHighlight = JournalEntryHighlight(highlightLocation: highlightLocation, journalHighlightEntry: journalHighlightEntry, entryHighlights: highlightsImagesURLs, locationCoordinates: HighlightCoordinates(latitude: latitude, longitude: longitude), travelDate: highlightDate)
            
            var entry = try await getSingleJournalEntry(entryID: entryID)
            entry.id = entryID
            entry.entryHighlights.append(newJournalEntryHighlight)
            
            try db.collection("entries").document(entryID).setData(from: entry)
            
            return entry
        }
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw URLError(.cannotDecodeContentData)
        }
        return dictionary
    }
}
