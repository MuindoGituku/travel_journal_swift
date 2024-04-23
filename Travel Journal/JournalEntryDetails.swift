//
//  JournalEntryDetails.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI
import MapKit

struct JournalEntryDetails: View {
    
    @ObservedObject var journalViewModel: JournalViewModel
    let selectedJournalEntryID: String
    
    @State private var navigateToAddNewHighlight = false
    
    @State private var showHighlightsInfoSheet = false
    @State private var fabOffset: CGFloat = 0
    @State var selectedHighlightIndex = 0
    
    @State private var showHighlightImagesPopover = false
    @State var selectedImageIndex = 0
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 90.8588443, longitude: 2.2943506),
        latitudinalMeters: 10000,
        longitudinalMeters: 10000
    )
    @State private var cameraPosition: MapCameraPosition = .region(
        .init(
            center: CLLocationCoordinate2D(
                latitude: 48.8588443,
                longitude: 2.2943506
            ),
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
    )
    
    @State private var selectedHighlight: String?
    
    var body: some View {
        VStack {
            if journalViewModel.loading {
                FullSizeLottieAnimations(
                    animationText: "Fetching details about the selected journal entry from the cloud. Please wait...",
                    animation: LottieAnimations.loading
                )
            } else if let error = journalViewModel.error {
                FullSizeLottieButtonAnimations(
                    animationText: error, animation: LottieAnimations.docError,
                    buttonAction: {
                        journalViewModel.getSingleJournalEntry(entryID: selectedJournalEntryID)
                    }, clickableButton: true
                )
            } else if let entry = journalViewModel.entryInView {
                let townCoordinate = CLLocationCoordinate2D(
                    latitude: entry.travelLocationCoordinates.latitude,
                    longitude: entry.travelLocationCoordinates.longitude
                )
                
                VStack {
                    Map(
                        position: $cameraPosition,
                        interactionModes: .all,
                        selection: $selectedHighlight
                    ) {
                        ForEach(entry.entryHighlights.indices, id: \.self) { index in
                            Marker(
                                entry.entryHighlights[index].highlightLocation,
                                systemImage: "paperplane",
                                coordinate: CLLocationCoordinate2D(
                                    latitude: entry.entryHighlights[index].locationCoordinates.latitude,
                                    longitude: entry.entryHighlights[index].locationCoordinates.longitude
                                )
                            )
                        }
                    }
                    .frame(maxHeight: showHighlightsInfoSheet ? UIScreen.main.bounds.height * 0.45 : UIScreen.main.bounds.height)
                    .mapControls {
                        MapCompass()
                        MapScaleView()
                        MapPitchToggle()
                    }
                    .onAppear {
                        withAnimation {
                            region.center = townCoordinate
                            cameraPosition = .region(region)
                        }
                    }
                    if showHighlightsInfoSheet {
                        Spacer()
                    }
                }
                .navigationDestination(isPresented: $navigateToAddNewHighlight) {
                    AddJournalHighlight (
                        entryInView: entry,
                        journalViewModel: journalViewModel
                    )
                }
                .onChange(of: showHighlightsInfoSheet) { _, newVal in
                    if !newVal {
                        fabOffset = 0
                        region = MKCoordinateRegion(
                            center: townCoordinate,
                            latitudinalMeters: 10000,
                            longitudinalMeters: 10000
                        )
                        cameraPosition = .region(region)
                    } else {
                        fabOffset = -UIScreen.main.bounds.height * 0.55
                        if !entry.entryHighlights.isEmpty && selectedHighlightIndex <= entry.entryHighlights.count - 1 {
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D (
                                    latitude: entry.entryHighlights[selectedHighlightIndex].locationCoordinates.latitude,
                                    longitude: entry.entryHighlights[selectedHighlightIndex].locationCoordinates.longitude
                                ),
                                latitudinalMeters: 100,
                                longitudinalMeters: 100
                            )
                            cameraPosition = .region(region)
                        }
                    }
                }
                .onChange(of: selectedHighlightIndex) { _, newVal in
                    if !entry.entryHighlights.isEmpty && newVal <= entry.entryHighlights.count - 1 {
                        cameraPosition = .region (
                            MKCoordinateRegion (
                                center: CLLocationCoordinate2D (
                                    latitude: entry.entryHighlights[newVal].locationCoordinates.latitude,
                                    longitude: entry.entryHighlights[newVal].locationCoordinates.longitude
                                ),
                                latitudinalMeters: 100,
                                longitudinalMeters: 100
                            )
                        )
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Button(action: {
                        showHighlightsInfoSheet.toggle()
                    }) {
                        Image(systemName: !showHighlightsInfoSheet ? "arrow.up" : "arrow.down")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(15)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .offset(y: fabOffset)
                    }
                    .padding(.trailing)
                }
                .overlay(alignment: .center) {
                    ZStack {
                        Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                        if showHighlightImagesPopover {
                            HighlightImagesDialog(
                                currentSelectedEntryHighlight: .constant(entry.entryThumbnail),
                                onImageSetAsThumbnail: { imageURL in
                                    journalViewModel.updateSelectedEntryThumbnailImage(
                                        entryID: selectedJournalEntryID,
                                        imageURL: imageURL
                                    )
                                }, onImageDialogDismiss: { showHighlightImagesPopover = false },
                                uploadedHighlightImages: entry.entryHighlights[selectedHighlightIndex].entryHighlights,
                                selectedImageIndex: $selectedImageIndex
                            )
                            .background(.white.opacity(0.5))
                            .shadow(radius: 10)
                        }
                    }
                    .opacity(showHighlightImagesPopover ? 1 : 0)
                }
                .sheet(
                    isPresented: $showHighlightsInfoSheet,
                    onDismiss: {
                        showHighlightsInfoSheet = false
                        fabOffset = 0
                    },
                    content: {
                        JournalEntryHighlightsSheet(
                            entryInView: entry,
                            addHighlightButtonAction: {
                                showHighlightsInfoSheet = false
                                navigateToAddNewHighlight = true
                            },
                            onTapImageRect: {
                                showHighlightsInfoSheet = false
                                showHighlightImagesPopover = true
                            },
                            journalViewModel: journalViewModel,
                            selectedHighlightIndex: $selectedHighlightIndex
                        )
                        .presentationDetents ([.fraction(0.6)])
                    }
                )
            }
        }
        .navigationTitle("\(journalViewModel.entryInView?.travelLocation ?? "Entry Details")")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            journalViewModel.getSingleJournalEntry(entryID: selectedJournalEntryID)
        }
        .animation(.spring(), value: fabOffset)
        .animation(.spring(), value: selectedHighlightIndex)
        .animation(.spring(), value: showHighlightsInfoSheet)
    }
}

#Preview {
    NavigationStack {
        JournalEntryDetails(
            journalViewModel: JournalViewModel(
                journalRepo: JournalRepository()
            ),
            selectedJournalEntryID: "8K8x64Mu9BwOginp69Dg"
        )
    }
}
