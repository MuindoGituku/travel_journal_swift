//
//  AllJournalEntriesList.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI

struct AllJournalEntriesList: View {
    @StateObject var journalViewModel = JournalViewModel(journalRepo: JournalRepository())
    
    @State private var navigateToAddNewEntry = false
    @State private var navigateToViewEntryDetails = false
    
    let presentationDetents: Set<PresentationDetent> = [.medium, .large]
    @State var selectedPresentationDetent: PresentationDetent = PresentationDetent.medium
    
    var body: some View {
        NavigationStack {
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
                        VStack {
                            ScrollView (.vertical, showsIndicators: false) {
                                LazyVGrid(
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
                            }
                            .padding(.top)
                            //.padding([.horizontal, .top])
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
            .navigationTitle("Travel Journal")
        }
    }
}

#Preview {
    AllJournalEntriesList()
}
