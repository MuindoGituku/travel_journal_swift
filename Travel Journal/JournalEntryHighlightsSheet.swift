//
//  JournalEntryHighlightsSheet.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-20.
//

import SwiftUI

struct JournalEntryHighlightsSheet: View {
    
    let entryInView: JournalEntry
    let addHighlightButtonAction: () -> Void
    @ObservedObject var journalViewModel: JournalViewModel
    @Binding var selectedHighlightIndex: Int
    
    var body: some View {
        VStack {
            Text("Journal Highlights")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .padding()
            TabView(selection: $selectedHighlightIndex) {
                ForEach(entryInView.entryHighlights.indices, id: \.self) { index in
                    EntryHighlightCard (
                        entryInView: entryInView.id,
                        highlightInView: entryInView.entryHighlights[index],
                        journalViewModel: journalViewModel
                    )
                    .tabItem {
                        Text(entryInView.entryHighlights[index].highlightLocation)
                    }
                    .tag(index)
                }
                AddingNewHighlightWidget (
                    isFirstEntryToAdd: entryInView.entryHighlights.isEmpty,
                    buttonAction: addHighlightButtonAction
                )
                .tabItem {
                    Label("Add", systemImage: "plus")
                }
                .tag(entryInView.entryHighlights.count)
            }
            .padding(.horizontal)
            .tabViewStyle(.page(indexDisplayMode: .never))
            if selectedHighlightIndex != entryInView.entryHighlights.count {
                HStack {
                    ForEach (entryInView.entryHighlights.indices, id: \.self) { index in
                        Rectangle()
                            .frame(width: selectedHighlightIndex == index ? 35 : 10, height: 10)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            .foregroundStyle(.blue.opacity(selectedHighlightIndex == index ? 1.0 : 0.5))
                            .onTapGesture {
                                withAnimation {
                                    selectedHighlightIndex = index
                                }
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    JournalEntryHighlightsSheet(
        entryInView: JournalEntry(
            id: "8K8x64Mu9BwOginp69Dg",
            entryThumbnail: "",
            travelLocation: "Paris, France",
            travelLocationCoordinates: HighlightCoordinates(latitude: 48.8588443, longitude: 2.2943506),
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
        ), addHighlightButtonAction: { },
        journalViewModel: JournalViewModel(
            journalRepo: JournalRepository()
        ),
        selectedHighlightIndex: .constant(0)
    )
}
