//
//  IndividualJournalEntryCard2.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-27.
//

import SwiftUI

struct IndividualJournalEntryCard2: View {
    
    let entry: JournalEntry
    
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                let allImages = entry.entryHighlights.flatMap { $0.entryHighlights }.map { $0 }
                
                if allImages.isEmpty {
                    if entry.entryThumbnail.isEmpty {
                        Image(.emptyImageValue)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame (
                                width: 80,
                                height: 80
                            )
                            .cornerRadius(10)
                            .overlay {
                                Rectangle()
                                    .fill(.gray.opacity(0.5), style: FillStyle())
                                    .overlay {
                                        ProgressView()
                                    }
                                    .cornerRadius(10)
                            }
                    } else {
                        AsyncImage(url: URL(string: entry.entryThumbnail)) { thumbnail in
                            thumbnail
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame (
                                    width: 80,
                                    height: 80
                                )
                                .cornerRadius(10)
                        } placeholder: {
                            Image(.emptyImageValue)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame (
                                    width: 80,
                                    height: 80
                                )
                                .cornerRadius(10)
                                .overlay {
                                    Rectangle()
                                        .fill(.gray.opacity(0.5), style: FillStyle())
                                        .overlay {
                                            ProgressView()
                                        }
                                        .cornerRadius(10)
                                }
                        }
                    }
                } else {
                    TabView(selection: $currentIndex) {
                        ForEach(allImages.indices, id: \.self) { index in
                            AsyncImage(url: URL(string: allImages[index])) { thumbnail in
                                thumbnail
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame (
                                        width: 80,
                                        height: 80
                                    )
                                    .onReceive(timer) { _ in
                                        withAnimation {
                                            if currentIndex < entry.entryHighlights.count - 1 {
                                                currentIndex += 1
                                            } else {
                                                currentIndex = 0
                                            }
                                        }
                                    }
                                    .cornerRadius(10)
                                    .tag(index)
                                    .tabItem { Label(index.description, systemImage: "\(index + 1).circle") }
                            } placeholder: {
                                Image(.emptyImageValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame (
                                        width: 80,
                                        height: 80
                                    )
                                    .overlay {
                                        Rectangle()
                                            .fill(.gray.opacity(0.5), style: FillStyle())
                                            .overlay {
                                                ProgressView()
                                            }
                                            .cornerRadius(10)
                                    }
                                    .onReceive(timer) { _ in
                                        withAnimation {
                                            if currentIndex < entry.entryHighlights.count - 1 {
                                                currentIndex += 1
                                            } else {
                                                currentIndex = 0
                                            }
                                        }
                                    }
                                    .cornerRadius(10)
                                    .tag(index)
                                    .tabItem { Label(index.description, systemImage: "\(index + 1).circle") }
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame (
                        width: 80,
                        height: 80
                    )
                }
                VStack (alignment: .leading) {
                    Text(entry.travelLocation)
                        .font(.system(size: 20, weight: .thin, design: .default))
                        .foregroundStyle(.black)
                        .padding(.bottom, 5)
                    Text("From \(entry.travelStartDate.formatted(date: .abbreviated, time: .omitted)) to \(entry.travelEndDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 2)
                    if !entry.entryHighlights.isEmpty {
                        Text("\(entry.entryHighlights.count) Highlight\(entry.entryHighlights.count > 1 ? "s" : "") Uploaded")
                            .font(.system(size: 11, weight: .regular, design: .rounded))
                            .foregroundStyle(.gray.opacity(0.5))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("No Highlights Uploaded.")
                            .font(.system(size: 11, weight: .regular, design: .rounded))
                            .foregroundStyle(.gray.opacity(0.5))
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.leading, 5)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.black)
                    .padding(.trailing, 5)
            }
            .padding(5)
        }
        .background {
            Color.white
                .cornerRadius(10)
                .shadow (
                color: Color(.sRGBLinear, white: 0, opacity: 0.2),
                radius: 20
            )
        }
    }
}

#Preview {
    IndividualJournalEntryCard2 (
        entry: JournalEntry(
            id: "1",
            entryThumbnail: "thumbnail_image_url",
            travelLocation: "San Francisco",
            travelLocationCoordinates: HighlightCoordinates(latitude: 37.7749, longitude: -122.4194),
            travelStartDate: Date(),
            travelEndDate: Date(),
            dateCreated: Date(),
            lastUpdated: Date(),
            entryHighlights: [
                JournalEntryHighlight(
                    highlightLocation: "Golden Gate Bridge",
                    journalHighlightEntry: "Visited the iconic Golden Gate Bridge and took breathtaking photos.",
                    entryHighlights: [
                        "https://images.freeimages.com/images/large-previews/ab3/puppy-2-1404644.jpg",
                        "https://images.freeimages.com/images/large-previews/ab3/puppy-2-1404644.jpg",
                        "https://images.freeimages.com/images/large-previews/ab3/puppy-2-1404644.jpg"
                    ],
                    locationCoordinates: HighlightCoordinates(latitude: 37.7749, longitude: -122.4194),
                    travelDate: Date(),
                    dateCreated: Date(),
                    lastUpdated: Date()
                ),
                JournalEntryHighlight(
                    highlightLocation: "Alcatraz Island",
                    journalHighlightEntry: "Explored the historic Alcatraz Island and learned about its fascinating history.",
                    entryHighlights: [
                        "https://images.freeimages.com/images/large-previews/ab3/puppy-2-1404644.jpg",
                        "https://images.freeimages.com/images/large-previews/ab3/puppy-2-1404644.jpg",
                        "https://images.freeimages.com/images/large-previews/ab3/puppy-2-1404644.jpg"
                    ],
                    locationCoordinates: HighlightCoordinates(latitude: 37.7749, longitude: -122.4194),
                    travelDate: Date(),
                    dateCreated: Date(),
                    lastUpdated: Date()
                )
            ]
        )
    )
}
