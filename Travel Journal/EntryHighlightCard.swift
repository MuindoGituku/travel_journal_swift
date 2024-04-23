//
//  EntryHighlightCard.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-20.
//

import SwiftUI

struct EntryHighlightCard: View {
    
    let entryInView: String
    let highlightInView: JournalEntryHighlight
    @ObservedObject var journalViewModel: JournalViewModel
        
    var body: some View {
        VStack (alignment: .leading) {
            Text(highlightInView.highlightLocation)
                .font(.title3)
            HStack {
                Image(systemName: "calendar")
                    .padding(.trailing, 3)
                    .foregroundStyle(.gray)
                Text(highlightInView.travelDate.formatted(date: .complete, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 3)
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(highlightInView.entryHighlights, id: \.self) { imageName in
                        AsyncImage(url: URL(string: imageName)) { thumbnail in
                            thumbnail
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: 100)
                                .cornerRadius(5)
                                .clipped()
                        } placeholder: {
                            Image(.emptyImageValue)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: 100)
                                .cornerRadius(5)
                                .clipped()
                        }
                        .onTapGesture {
                            journalViewModel.updateSelectedEntryThumbnailImage(
                                entryID: entryInView,
                                imageURL: imageName
                            )
                        }
                    }
                }
            }
            .padding(.vertical)
            Text("Journal Entry")
                .font(.title3)
                .padding(.bottom, 5)
            Text(highlightInView.journalHighlightEntry)
                .font(.caption)
        }
    }
}

#Preview {
    EntryHighlightCard (
        entryInView: "8K8x64Mu9BwOginp69Dg",
        highlightInView: JournalEntryHighlight(
            highlightLocation: "Eiffel Tower",
            journalHighlightEntry: "Visited the iconic Eiffel Tower",
            entryHighlights: ["Eiffel Tower", "Paris"],
            locationCoordinates: HighlightCoordinates(latitude: 48.8588443, longitude: 2.2943506),
            travelDate: Date(timeIntervalSince1970: 1633219200) // October 3, 2023
        ),
        journalViewModel: JournalViewModel(
            journalRepo: JournalRepository()
        )
    )
}
