//
//  AddJournalHighlight.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI
import PhotosUI
import MapKit

struct AddJournalHighlight: View {
    
    @State private var cameraPosition: MapCameraPosition = .region(
        .init(
            center: CLLocationCoordinate2D(
                latitude: 48.8588443,
                longitude: 2.2943506
            ),
            latitudinalMeters: 30000,
            longitudinalMeters: 30000
        )
    )
    
    let entryInView: JournalEntry
    @ObservedObject var journalViewModel: JournalViewModel
    
    @StateObject private var photosPicker = PhotoPickerViewModel()
    @State var highlightImagesHasError: Bool = false
    
    @State var highlightLocation: String = ""
    @State var selectedHighlightLocation: ReversedGeoLocation? = nil
    @State var selectedHighlightHasError: Bool = false
    @State var showLocationSelectSheet: Bool = false
    
    @State var highlightDate: Date = Date()
    @State var highlightDateHasError: Bool = false
    
    @State var highlightDescription: String = ""
    @State var highlightDescriptionHasError: Bool = false
    
    init(entryInView: JournalEntry, journalViewModel: JournalViewModel) {
        self.entryInView = entryInView
        self.journalViewModel = journalViewModel
        
        _highlightDate = State(initialValue: entryInView.travelStartDate)
    }
    
    func validateHighlightDetails() -> Bool {
        var isValid = true
        
        highlightImagesHasError = photosPicker.selectedImages.isEmpty
        selectedHighlightHasError = selectedHighlightLocation == nil
        highlightDateHasError = highlightDate < entryInView.travelStartDate || highlightDate > entryInView.travelEndDate
        highlightDescriptionHasError = highlightDescription.isEmpty
        
        if highlightImagesHasError || selectedHighlightHasError || highlightDateHasError || highlightDescriptionHasError {
            isValid = false
        }
        
        return isValid
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading) {
                Text("Choose Highlight Location")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .padding([.leading, .trailing, .top])
                    .padding(.bottom, 5)
                Text("Click on the map below to select the exact location where you visited within \(entryInView.travelLocation).")
                    .font(.subheadline)
                    .padding(.horizontal)
                Map(position: $cameraPosition, interactionModes: []) {
                    if let location = selectedHighlightLocation {
                        Marker (
                            highlightLocation,
                            systemImage: "mappin.and.ellipse",
                            coordinate: CLLocationCoordinate2D(
                                latitude: location.latitude,
                                longitude: location.longitude
                            )
                        )
                    }
                }
                .frame(height: 150)
                .cornerRadius(5)
                .padding([.leading, .trailing, .bottom])
                .padding(.top, 5)
                .onAppear {
                    withAnimation {
                        cameraPosition = .region(
                            MKCoordinateRegion (
                                center: CLLocationCoordinate2D (
                                    latitude: entryInView.travelLocationCoordinates.latitude,
                                    longitude: entryInView.travelLocationCoordinates.longitude
                                ),
                                latitudinalMeters: 1000,
                                longitudinalMeters: 1000
                            )
                        )
                    }
                }
                .onChange(of: selectedHighlightLocation) { oldValue, newValue in
                    guard let newLocation = newValue else { return }
                    
                    withAnimation {
                        cameraPosition = .region(
                            MKCoordinateRegion (
                                center: CLLocationCoordinate2D (
                                    latitude: newLocation.latitude,
                                    longitude: newLocation.longitude
                                ),
                                latitudinalMeters: 1000,
                                longitudinalMeters: 1000
                            )
                        )
                    }
                }
                .onTapGesture {
                    showLocationSelectSheet = true
                }
                if selectedHighlightHasError {
                    Text("You have not selected a location where you visited within \(entryInView.travelLocation). Click on the map to select a location in order to proceed.")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding([.leading, .trailing])
                } else if selectedHighlightLocation != nil {
                    Text("You have selected: \(highlightLocation)")
                        .font(.subheadline)
                        .padding([.leading, .trailing])
                }
                Text("Highlight Details")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .padding([.leading, .trailing, .top])
                    .padding(.bottom, 5)
                DatePicker(
                    selection: $highlightDate,
                    in: entryInView.travelStartDate...entryInView.travelEndDate,
                    displayedComponents: .date
                ) {
                    HStack (alignment: .center) {
                        Image(systemName: "calendar")
                        Text("Date Visited")
                    }
                }
                .padding(.horizontal)
                if highlightDateHasError {
                    Text("Check the date you have selected as when you visited this highlight. It should be within \(entryInView.travelStartDate.formatted(date: .numeric, time: .omitted)) and \(entryInView.travelEndDate.formatted(date: .numeric, time: .omitted)).")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding([.leading, .trailing])
                }
                TextEditor(text: $highlightDescription)
                    .keyboardType(.alphabet)
                    .textInputAutocapitalization(.sentences)
                    .font(.callout)
                    .padding(5)
                    .frame(minHeight: 100, maxHeight: 300)
                    .border(.black)
                    .padding([.horizontal, .top])
                if highlightDescriptionHasError {
                    Text("Please give a journal entry for how the day was in order to proceed with the upload.")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding([.leading, .trailing])
                }
                Text("Highlight Photos")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .padding([.leading, .trailing, .top])
                    .padding(.bottom, 5)
                Text("Click on the button below to upload some of the photos you took when you visited \(entryInView.travelLocation). You can upload up to 5 images.")
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        PhotosPicker(selection: $photosPicker.imagesSelection, maxSelectionCount: 5, selectionBehavior: .continuousAndOrdered, matching: .images) {
                            VStack (alignment: .center) {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .foregroundStyle(.gray)
                                    .padding(15)
                            }
                            .background(.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                        }
                        
                        ForEach(photosPicker.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(5)
                        }
                    }
                }
                .padding(.horizontal)
                if highlightImagesHasError {
                    Text("You have not shared any photos you took while you visited within the town. Click on the button above to select some images in order to proceed. You can share between 1 to 5 images.")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding([.leading, .trailing])
                        .padding(.top, 5)
                }
                if journalViewModel.loading {
                    FullWidthLottieAnimations(
                        animationText: "Uploading a new journal entry highlight for \(highlightLocation) to your cloud journal on \(entryInView.travelLocation). Please wait...",
                        animation: LottieAnimations.loading
                    )
                } else if journalViewModel.error != nil {
                    Button(
                        action: {
                            if validateHighlightDetails() {
                                journalViewModel.uploadNewHighlightToJournalEntry(
                                    entryID: entryInView.id,
                                    highlightDate: highlightDate,
                                    entryHighlights: photosPicker.selectedImages,
                                    highlightLocation: highlightLocation,
                                    journalHighlightEntry: highlightDescription,
                                    longitude: selectedHighlightLocation?.longitude ?? 0.0,
                                    latitude: selectedHighlightLocation?.longitude ?? 0.0
                                )
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "paperplane")
                                    .padding(.trailing, 10)
                                Text("Upload New Highlight")
                                    .bold()
                            }
                            .padding()
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding()
                } else {
                    Button(
                        action: {
                            if validateHighlightDetails() {
                                if validateHighlightDetails() {
                                    journalViewModel.uploadNewHighlightToJournalEntry(
                                        entryID: entryInView.id,
                                        highlightDate: highlightDate,
                                        entryHighlights: photosPicker.selectedImages,
                                        highlightLocation: highlightLocation,
                                        journalHighlightEntry: highlightDescription,
                                        longitude: selectedHighlightLocation?.longitude ?? 0.0,
                                        latitude: selectedHighlightLocation?.longitude ?? 0.0
                                    )
                                }
                            }
                        }, label: {
                            HStack {
                                Image(systemName: "paperplane")
                                    .padding(.trailing, 10)
                                Text("Upload New Highlight")
                                    .bold()
                            }
                            .padding()
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
        .sheet(
            isPresented: $showLocationSelectSheet,
            onDismiss: { showLocationSelectSheet = false },
            content: {
                AddHighlightLocation(
                    selectedLocation: $selectedHighlightLocation,
                    selectedLocationTitle: $highlightLocation,
                    entryInView: entryInView
                )
                .presentationDetents([.large])
            }
        )
        .navigationTitle("Add Highlight")
    }
}
