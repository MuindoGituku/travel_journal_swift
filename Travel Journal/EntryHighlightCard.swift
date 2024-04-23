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
    let onTapImageRect: () -> Void
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: true) {
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
                HStack {
                    if highlightInView.entryHighlights.count < 4 {
                        ForEach(highlightInView.entryHighlights, id: \.self) { imageName in
                            AsyncImage(url: URL(string: imageName)) { thumbnail in
                                thumbnail
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 85)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        onTapImageRect()
                                    }
                            } placeholder: {
                                Image(.emptyImageValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 85)
                                    .cornerRadius(5)
                                    .overlay {
                                        Rectangle()
                                            .fill(.gray.opacity(0.5), style: FillStyle())
                                            .cornerRadius(5)
                                            .overlay {
                                                ProgressView()
                                            }
                                    }
                                    .onTapGesture {
                                        onTapImageRect()
                                    }
                            }
                        }
                    } else {
                        ForEach(highlightInView.entryHighlights.prefix(2), id: \.self) { imageName in
                            AsyncImage(url: URL(string: imageName)) { thumbnail in
                                thumbnail
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 85)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        onTapImageRect()
                                    }
                            } placeholder: {
                                Image(.emptyImageValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: 85)
                                    .cornerRadius(5)
                                    .overlay {
                                        Rectangle()
                                            .fill(.gray.opacity(0.5), style: FillStyle())
                                            .cornerRadius(5)
                                            .overlay {
                                                ProgressView()
                                            }
                                    }
                                    .onTapGesture {
                                        onTapImageRect()
                                    }
                            }
                        }
                        AsyncImage(url: URL(string: highlightInView.entryHighlights[2])) { thumbnail in
                            thumbnail
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: 85)
                                .cornerRadius(5)
                                .overlay {
                                    Text("+ \(highlightInView.entryHighlights.count - 3)")
                                        .font(.system(size: 30, weight: .black, design: .rounded))
                                        .foregroundStyle(.white)
                                        .shadow(radius: 3)
                                }
                                .onTapGesture {
                                    onTapImageRect()
                                }
                        } placeholder: {
                            Image(.emptyImageValue)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: 85)
                                .cornerRadius(5)
                                .overlay {
                                    Rectangle()
                                        .fill(.gray.opacity(0.5), style: FillStyle())
                                        .cornerRadius(5)
                                        .overlay {
                                            ProgressView()
                                        }
                                }
                                .onTapGesture {
                                    onTapImageRect()
                                }
                        }
                        .overlay {
                            Text("+ \(highlightInView.entryHighlights.count - 3)")
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .foregroundStyle(.white)
                                .shadow(radius: 3)
                        }
                    }
                }
                .padding(.vertical)
                Text("Journal Entry")
                    .font(.title3)
                    .padding(.bottom, 5)
                    .underline()
                Text(highlightInView.journalHighlightEntry)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    EntryHighlightCard (
        entryInView: "8K8x64Mu9BwOginp69Dg",
        highlightInView: JournalEntryHighlight(
            highlightLocation: "Eiffel Tower",
            journalHighlightEntry: "Visited the iconic Eiffel Tower",
            entryHighlights: ["Eiffel Tower", "Paris", "Another One", "One More", "Niivo Sasa"],
            locationCoordinates: HighlightCoordinates(latitude: 48.8588443, longitude: 2.2943506),
            travelDate: Date(timeIntervalSince1970: 1633219200) // October 3, 2023
        ), 
        onTapImageRect: { }
    )
}
