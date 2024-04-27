//
//  AddHighlightLocation.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-20.
//

import SwiftUI
import MapKit

struct AddHighlightLocation: View {
    
    @Binding var selectedLocation: ReversedGeoLocation?
    @Binding var selectedLocationTitle: String
    @State private var showSelectedLocationInfo = false
    let entryInView: JournalEntry
    
    @Environment(\.dismiss) var dismiss
    
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
    @State private var searchText: String = ""
    @State private var results:[MKMapItem] = []
    @State private var mapSelection: MKMapItem? = nil
    
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion (
            center: CLLocationCoordinate2D (
                latitude: entryInView.travelLocationCoordinates.latitude,
                longitude: entryInView.travelLocationCoordinates.longitude
            ),
            latitudinalMeters: 50000,
            longitudinalMeters: 50000
        )
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Search Highlight Location")
                .font(.title2)
                .bold()
                .padding()
            Map(position: $cameraPosition, selection: $mapSelection) {
                
                ForEach(results, id: \.self) { item in
                    let placeMark = item.placemark
                    
                    Marker(placeMark.title ?? "", systemImage: "mappin.and.ellipse", coordinate: placeMark.coordinate)
                        .tint(.cyan)
                }
            }
            .onAppear {
                withAnimation {
                    cameraPosition = .region(
                        MKCoordinateRegion (
                            center: CLLocationCoordinate2D (
                                latitude: entryInView.travelLocationCoordinates.latitude,
                                longitude: entryInView.travelLocationCoordinates.longitude
                            ),
                            latitudinalMeters: 30000,
                            longitudinalMeters: 30000
                        )
                    )
                }
            }
            .overlay(alignment: .top) {
                TextField("Enter location to search...", text: $searchText)
                    .keyboardType(.alphabet)
                    .textInputAutocapitalization(.words)
                    .font(.subheadline)
                    .padding(12)
                    .background(.white)
                    .padding()
                    .shadow(radius: 5)
            }
            .overlay(alignment: .bottom) {
                if let selectedLocation = selectedLocation,
                   let mapSelection = mapSelection {
                    VStack (alignment: .leading) {
                        Text("Selected Location")
                            .font(.title3)
                            .bold()
                            .padding()
                            .shadow(radius: 0)
                        Text(selectedLocation.name)
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                            .padding(.horizontal)
                            .shadow(radius: 0)
                        Text(mapSelection.placemark.title ?? selectedLocation.name)
                            .font(.system(size: 14, weight: .light, design: .rounded))
                            .foregroundStyle(.gray)
                            .padding(.horizontal)
                            .shadow(radius: 0)
                        TextField("Location Title", text: $selectedLocationTitle)
                            .keyboardType(.alphabet)
                            .textInputAutocapitalization(.words)
                            .font(.subheadline)
                            .padding()
                            .border(.gray)
                            .padding()
                            .shadow(radius: 0)
                        Button(
                            action: {
                                dismiss()
                            }, label: {
                                HStack {
                                    Image(systemName: "checkmark.diamond")
                                        .padding(.trailing, 10)
                                    Text("Confirm Location")
                                        .bold()
                                }
                                .padding()
                            })
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .cornerRadius(10)
                        .padding()
                        .shadow(radius: 0)
                    }
                    .background(.white)
                    .shadow(radius: 3)
                    .cornerRadius(5)
                    .padding()
                }
            }
        }
        .onSubmit(of: .text) {
            Task {
                await searchPlaces()
            }
        }
        .onChange(of: mapSelection){ oldVlaue, newValue in
            withAnimation {
                guard let placemark = newValue?.placemark else { return }
                selectedLocation = ReversedGeoLocation(with: placemark)
                selectedLocationTitle = selectedLocation?.name ?? searchText
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
        }
    }
}
