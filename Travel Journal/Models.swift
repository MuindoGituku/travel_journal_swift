//
//  Models.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI

struct JournalEntry: Codable, Identifiable {
    var id: String = ""
    var entryThumbnail: String
    var travelLocation: String
    var travelLocationCoordinates: HighlightCoordinates
    var travelStartDate: Date
    var travelEndDate: Date
    var entryHighlights: [JournalEntryHighlight]
    
    enum CodingKeys: String, CodingKey {
        case id
        case entryThumbnail = "entry_thumbnail"
        case travelLocation = "travel_location"
        case travelLocationCoordinates = "travel_location_coordinates"
        case travelStartDate = "travel_start_date"
        case travelEndDate = "travel_end_date"
        case entryHighlights = "entry_highlights"
    }
}

struct JournalEntryHighlight: Codable {
    var highlightLocation: String
    var journalHighlightEntry: String
    var entryHighlights: [String]
    var locationCoordinates: HighlightCoordinates
    var travelDate: Date
    
    enum CodingKeys: String, CodingKey {
        case highlightLocation = "highlight_location"
        case journalHighlightEntry = "journal_highlight_entry"
        case entryHighlights = "entry_highlights"
        case locationCoordinates = "location_coordinates"
        case travelDate = "travel_date"
    }
}

struct HighlightCoordinates: Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
