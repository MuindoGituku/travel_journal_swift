//
//  IndividualJournalEntryCard.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI

struct IndividualJournalEntryCard: View {
    let entry: JournalEntry
    
    var body: some View {
        VStack (alignment: .leading) {
            if entry.entryThumbnail.isEmpty {
                Image(.emptyImageValue)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .cornerRadius(10)
                    .overlay {
                        Rectangle()
                            .fill(.gray.opacity(0.5), style: FillStyle())
                            .cornerRadius(10)
                    }
            } else {
                AsyncImage(url: URL(string: entry.entryThumbnail)) { thumbnail in
                    thumbnail
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .cornerRadius(10)
                } placeholder: {
                    Image(.emptyImageValue)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .cornerRadius(10)
                        .overlay {
                            Rectangle()
                                .fill(.gray.opacity(0.5), style: FillStyle())
                                .cornerRadius(10)
                                .overlay {
                                    ProgressView()
                                }
                        }
                }
            }
            Text(entry.travelLocation.components(separatedBy: ",").first ?? "Town")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.bottom, 2)
            Text(entry.travelStartDate.formatted(date: .abbreviated, time: .omitted))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
        ForEach (1...10, id: \.self) { index in
            IndividualJournalEntryCard(entry: JournalEntry(
                id: "1",
                entryThumbnail: "https://cdn.britannica.com/93/94493-050-35524FED/Toronto.jpg?w=300",
                travelLocation: "Paris, France", travelLocationCoordinates: HighlightCoordinates(latitude: 48.8588443, longitude: 2.2943506),
                travelStartDate: Date(timeIntervalSince1970: 1633046400), // October 1, 2023
                travelEndDate: Date(timeIntervalSince1970: 1633824000), // October 10, 2023
                entryHighlights: [
                    JournalEntryHighlight(
                        highlightLocation: "Eiffel Tower",
                        journalHighlightEntry: "Visited the iconic Eiffel Tower",
                        entryHighlights: ["Eiffel Tower", "Paris"],
                        locationCoordinates: HighlightCoordinates(latitude: 48.8588443, longitude: 2.2943506),
                        travelDate: Date(timeIntervalSince1970: 1633219200) // October 3, 2023
                    ),
                    JournalEntryHighlight(
                        highlightLocation: "Louvre Museum",
                        journalHighlightEntry: "Explored amazing artworks at the Louvre",
                        entryHighlights: ["Louvre Museum", "Paris"],
                        locationCoordinates: HighlightCoordinates(latitude: 48.8606111, longitude: 2.337644),
                        travelDate: Date(timeIntervalSince1970: 1633392000) // October 5, 2023
                    )
                ]
            ))
        }
    }
}
