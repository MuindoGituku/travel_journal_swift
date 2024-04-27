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
    let onTapImageRect: () -> Void
    @ObservedObject var journalViewModel: JournalViewModel
    @Binding var selectedHighlightIndex: Int
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Journal Highlights")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .padding()
            TabView(selection: $selectedHighlightIndex) {
                ForEach(entryInView.entryHighlights.indices, id: \.self) { index in
                    EntryHighlightCard (
                        entryInView: entryInView.id,
                        highlightInView: entryInView.entryHighlights[index], 
                        onTapImageRect: onTapImageRect
                    )
                    .padding(.horizontal)
                    .tabItem {
                        Text(entryInView.entryHighlights[index].highlightLocation)
                    }
                    .tag(index)
                }
                AddingNewHighlightWidget (
                    isFirstEntryToAdd: entryInView.entryHighlights.isEmpty,
                    buttonAction: addHighlightButtonAction
                )
                .padding(.horizontal)
                .tabItem {
                    Label("Add", systemImage: "plus")
                }
                .tag(entryInView.entryHighlights.count)
            }
            //.padding(.horizontal)
            .tabViewStyle(.page(indexDisplayMode: .never))
            if selectedHighlightIndex != entryInView.entryHighlights.count {
                HStack {
                    Spacer()
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
                    Image(systemName: "plus.circle")
                        .foregroundStyle(.blue.opacity(0.5))
                        .onTapGesture {
                            selectedHighlightIndex = entryInView.entryHighlights.count
                        }
                    Spacer()
                }
            }
        }
    }
}
