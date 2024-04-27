//
//  HeroSectionCard.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-25.
//

import SwiftUI

struct HeroSectionCard: View {
    
    let entry: JournalEntry
    
    var invertedTrapeziumShape: some View {
        let height = CGFloat(200)
        let longWidth = CGFloat(UIScreen.main.bounds.width * 0.55)
        let shortWidth = CGFloat(UIScreen.main.bounds.width * 0.40)
        
        return Path { path in
            path.move(to: CGPoint(x: longWidth, y: 0))
            path.addLine(to: CGPoint(x: shortWidth, y: height))
            path.addLine(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.closeSubpath()
        }
    }
    
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack (alignment: .center) {
            Spacer()
            
            let allImages = entry.entryHighlights.flatMap { $0.entryHighlights }.map { $0 }
            
            if allImages.isEmpty {
                if entry.entryThumbnail.isEmpty {
                    Image(.emptyImageValue)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame (
                            width: UIScreen.main.bounds.width * 0.60,
                            height: 200
                        )
                        .overlay {
                            Rectangle()
                                .fill(.gray.opacity(0.5), style: FillStyle())
                                .overlay {
                                    ProgressView()
                                }
                        }
                } else {
                    AsyncImage(url: URL(string: entry.entryThumbnail)) { thumbnail in
                        thumbnail
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame (
                                width: UIScreen.main.bounds.width * 0.60,
                                height: 200
                            )
                    } placeholder: {
                        Image(.emptyImageValue)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame (
                                width: UIScreen.main.bounds.width * 0.60,
                                height: 200
                            )
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
                                    width: UIScreen.main.bounds.width * 0.60,
                                    height: 200
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
                                .tag(index)
                                .tabItem { Label(index.description, systemImage: "\(index + 1).circle") }
                        } placeholder: {
                            Image(.emptyImageValue)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame (
                                    width: UIScreen.main.bounds.width * 0.60,
                                    height: 200
                                )
                                .overlay {
                                    Rectangle()
                                        .fill(.gray.opacity(0.5), style: FillStyle())
                                        .overlay {
                                            ProgressView()
                                        }
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
                                .tag(index)
                                .tabItem { Label(index.description, systemImage: "\(index + 1).circle") }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame (
                    width: UIScreen.main.bounds.width * 0.60,
                    height: 200
                )
            }
        }
        .overlay(alignment: .topLeading) {
            Color.blue.opacity(1)
                .mask(invertedTrapeziumShape)
                .overlay(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(entry.travelLocation)
                                .font(.system(size: 35, weight: .thin, design: .rounded))
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .foregroundStyle(.white)
                                .shadow(radius: 5)
                                .padding(.bottom, 5)
                            Text("From \(entry.travelStartDate.formatted(date: .complete, time: .omitted))")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundStyle(.white.opacity(0.5))
                                .padding(.bottom)
                            if !entry.entryHighlights.isEmpty {
                                Text("\(entry.entryHighlights.count) highlights")
                                    .font(.system(size: 15, weight: .regular, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                            } else {
                                Text("No highlights added.")
                                    .font(.system(size: 15, weight: .regular, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 10)
                    .frame(width: UIScreen.main.bounds.width * 0.5)
                }
        }
        .cornerRadius(10)
    }
}

#Preview {
    HeroSectionCard (
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
    .padding()
}
