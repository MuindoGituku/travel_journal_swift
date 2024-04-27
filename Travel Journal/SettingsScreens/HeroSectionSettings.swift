//
//  HeroSectionSettings.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-25.
//

import SwiftUI

struct HeroSectionSettings: View {
    
    @StateObject var appSettingsManager = AppSettingsManager()
    
    @State var isShowingHeroCard: Bool = UserDefaults().bool(forKey: "showHeroSectionCard")
    @State var heroSectionContent = UserDefaults().string(forKey: "heroSectionContent") ?? "newest_added"
    
    @Environment(\.dismiss) var dismiss
    
    let entry = JournalEntry(
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
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading) {
                Toggle(
                    isOn: $isShowingHeroCard,
                    label: {
                        VStack (alignment: .leading) {
                            Text("Display Hero Section Card")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(.black.opacity(0.7))
                            Text("Show a card on the home screen for the latest added journal entry or the most recent updated entry.")
                                .font(.system(size: 13, weight: .regular, design: .rounded))
                                .foregroundStyle(.gray)
                                .padding(.top, 1)
                        }
                        
                    }
                )
                .toggleStyle(.switch)
                
                HeroSectionCard(entry: entry)
                    .overlay {
                        Color.gray.opacity(isShowingHeroCard ? 0.0 : 0.5).cornerRadius(10)
                    }
                    .padding(.vertical)
                
                Toggle(
                    isOn: Binding (
                        get: {
                            heroSectionContent == "newest_added"
                        },
                        set: { _ in
                            heroSectionContent = "newest_added"
                        }
                    ),
                    label: {
                        Text("Show newest Journal Entry")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(.black)
                    }
                )
                .toggleStyle(.switch)
                .allowsHitTesting(isShowingHeroCard)
                .disabled(!isShowingHeroCard)
                .padding()
                .background(heroSectionContent == "newest_added" ? .green.opacity(0.6) : .gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom)
                
                Toggle(
                    isOn: Binding (
                        get: {
                            heroSectionContent == "latest_updated"
                        },
                        set: { _ in
                            heroSectionContent = "latest_updated"
                        }
                    ),
                    label: {
                        Text("Show last updated Journal Entry")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(.black)
                    }
                )
                .toggleStyle(.switch)
                .allowsHitTesting(isShowingHeroCard)
                .disabled(!isShowingHeroCard)
                .padding()
                .background(heroSectionContent == "latest_updated" ? .green.opacity(0.6) : .gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.bottom)
                
                Button(
                    action: {
                        appSettingsManager.updateHeroSectionViewAndContent (
                            showHeroSectionCard: isShowingHeroCard,
                            heroSectionContent: heroSectionContent
                        )
                        
                        //dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .padding(.trailing, 10)
                            Text("Save Changes")
                                .bold()
                        }
                        .padding()
                    })
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .background(isShowingHeroCard != appSettingsManager.showHeroSectionCard || heroSectionContent != appSettingsManager.heroSectionContent ? .blue : .gray.opacity(0.4))
                .cornerRadius(10)
                .padding(.vertical)
            }
        }
        .animation(.easeIn, value: isShowingHeroCard)
        .animation(.easeIn, value: heroSectionContent)
        .padding()
        .navigationTitle("Hero Section")
    }
}

#Preview {
    NavigationStack {
        HeroSectionSettings()
    }
}
