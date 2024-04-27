//
//  AllJournalEntriesList.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI

struct AllJournalEntriesList: View {
    @StateObject var journalViewModel = JournalViewModel(journalRepo: JournalRepository())
    @StateObject var appSettingsManager = AppSettingsManager()
    
    @State private var navigateToAddNewEntry = false
    @State private var navigateToViewEntryDetails = false
    
    let presentationDetents: Set<PresentationDetent> = [.medium, .large]
    @State var selectedPresentationDetent: PresentationDetent = PresentationDetent.medium
    
    var body: some View {
        VStack (alignment: .leading) {
            if journalViewModel.loading {
                FullSizeLottieAnimations(
                    animationText: "Fetching all the uploaded journal entries from the cloud. Please wait...",
                    animation: LottieAnimations.loading
                )
            } else if let error = journalViewModel.error {
                FullSizeLottieButtonAnimations(
                    animationText: error, animation: LottieAnimations.generalError,
                    buttonAction: {
                        journalViewModel.getAllJournalEntriesOnFile()
                    }, clickableButton: true
                )
            } else {
                if journalViewModel.allEntriesOnFile.isEmpty {
                    FullSizeLottieButtonAnimations(
                        animationText: "You have not uploaded any journal entries yet. Click on the button below to upload a new entry to the database.", animation: LottieAnimations.emptyList,
                        buttonAction: { navigateToAddNewEntry = true }, buttonText: "Add Your First Entry", buttonImage: "plus", clickableButton: true
                    )
                } else {
                    let entries = journalViewModel.allEntriesOnFile
                    let showHeroSectionCard = appSettingsManager.showHeroSectionCard
                    let heroSectionContent = appSettingsManager.heroSectionContent
                    let entriesListStyle = appSettingsManager.entriesListStyle
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        if showHeroSectionCard {
                            let heroSectionEntry = if heroSectionContent == "newest_added" {
                                entries.sorted(by: { entry1, entry2 in
                                    entry1.dateCreated > entry2.dateCreated
                                }).first!
                            } else if heroSectionContent == "latest_updated" {
                                entries.sorted(by: { entry1, entry2 in
                                    entry1.lastUpdated > entry2.lastUpdated
                                }).first!
                            } else {
                                entries.sorted(by: { entry1, entry2 in
                                    entry1.dateCreated > entry2.dateCreated
                                }).first!
                            }
                            
                            NavigationLink {
                                JournalEntryDetails(
                                    journalViewModel: journalViewModel,
                                    selectedJournalEntryID: heroSectionEntry.id
                                )
                            } label:{
                                HeroSectionCard(entry: heroSectionEntry)
                                    .padding([.horizontal, .top])
                            }
                        }
                        
                        HStack {
                            Text("All Journal Entries")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                            Spacer()
                            Image(systemName: entriesListStyle == "list_view" ? "rectangle.grid.2x2.fill" : "rectangle.grid.1x2.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .onTapGesture {
                                    if entriesListStyle == "list_view" {
                                        appSettingsManager.updateEntriesListStyle(listStyle: "grid_view")
                                    } else {
                                        appSettingsManager.updateEntriesListStyle(listStyle: "list_view")
                                    }
                                }
                                .foregroundStyle(.blue)
                        }
                        .padding()
                        
                        if entriesListStyle == "list_view" {
                            LazyVGrid (
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ]
                            ) {
                                ForEach (entries.indices, id: \.self) { index in
                                    NavigationLink {
                                        JournalEntryDetails(
                                            journalViewModel: journalViewModel,
                                            selectedJournalEntryID: entries[index].id
                                        )
                                    } label: {
                                        IndividualJournalEntryCard(entry: entries[index])
                                            .padding(.bottom)
                                    }
                                    
                                }
                            }
                        } else {
                            ForEach (entries.indices, id: \.self) { index in
                                NavigationLink {
                                    JournalEntryDetails(
                                        journalViewModel: journalViewModel,
                                        selectedJournalEntryID: entries[index].id
                                    )
                                } label: {
                                    IndividualJournalEntryCard2(entry: entries[index])
                                        .padding([.horizontal, .bottom])
                                }
                                
                            }
                        }
                    }
                    .refreshable {
                        journalViewModel.getAllJournalEntriesOnFile()
                    }
                    Button(
                        action: {
                            navigateToAddNewEntry = true
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                    .padding(.trailing, 10)
                                Text("Upload New Entry")
                                    .bold()
                            }
                            .padding()
                        })
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
        .sheet(
            isPresented: $navigateToAddNewEntry,
            onDismiss: {
                selectedPresentationDetent = PresentationDetent.medium
            },
            content: {
                NavigationStack {
                    AddJournalEntry(journalViewModel: journalViewModel)
                }
                .presentationDetents(presentationDetents, selection: $selectedPresentationDetent)
            }
        )
        .onAppear {
            journalViewModel.getAllJournalEntriesOnFile()
        }
        .animation(.spring(), value: appSettingsManager.entriesListStyle)
    }
}

#Preview {
    NavigationStack {
        AllJournalEntriesList()
            .navigationTitle("Travel Journal")
    }
}
