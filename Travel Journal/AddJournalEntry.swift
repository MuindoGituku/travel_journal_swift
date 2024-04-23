//
//  AddJournalEntry.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-18.
//

import SwiftUI
import MapKit
import CoreLocation

struct AddJournalEntry: View {
    @ObservedObject var journalViewModel: JournalViewModel
    
    @State var entryLocation: String = ""
    
    @State var locationLatitude: Double = 0.0
    @State var locationLongitude: Double = 0.0
    
    @State var entryStartDate: Date = Date()
    @State var entryEndDate: Date = Date()
    
    @Environment(\.dismiss) var dismiss
    
    @FocusState var isEntryLocationFocused: Bool
    @StateObject var mapSearch: MapSearch = MapSearch()
    
    func reverseGeo(location: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        var coordinateK : CLLocationCoordinate2D?
        search.start { (response, error) in
            if error == nil, let coordinate = response?.mapItems.first?.placemark.coordinate {
                coordinateK = coordinate
            }
            
            if let c = coordinateK {
                let location = CLLocation(latitude: c.latitude, longitude: c.longitude)
                CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                    
                    guard let placemark = placemarks?.first else {
                        let errorString = error?.localizedDescription ?? "Unexpected Error"
                        print("Unable to reverse geocode the given location. Error: \(errorString)")
                        return
                    }
                    
                    let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                    
                    entryLocation = "\(reversedGeoLocation.locality), \(reversedGeoLocation.country)"
                    
                    locationLongitude = reversedGeoLocation.longitude
                    locationLatitude = reversedGeoLocation.latitude
                    mapSearch.searchTerm = entryLocation
                    isEntryLocationFocused = false
                    
                }
            }
        }
    }
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading) {
                Text("Enter City Name")
                    .padding([.leading])
                TextField(text: $mapSearch.searchTerm) {
                    Text("City, Country")
                }
                .keyboardType(.default)
                .textInputAutocapitalization(.words)
                .textContentType(.countryName)
                .padding()
                .border(.gray)
                .padding([.horizontal, .bottom])
                
                if entryLocation != mapSearch.searchTerm && isEntryLocationFocused == false {
                    ForEach(mapSearch.locationResults, id: \.self) { location in
                        Button {
                            reverseGeo(location: location)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(location.title)
                                    .foregroundColor(.black)
                                Text(location.subtitle)
                                    .font(.system(.caption))
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                    }
                }
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Start Date")
                        DatePicker(selection: $entryStartDate, displayedComponents: .date) {}
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .leading) {
                        Text("End Date")
                        DatePicker(selection: $entryEndDate, displayedComponents: .date) {}
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                }
                .padding(.horizontal)
                
                if journalViewModel.loading {
                    FullWidthLottieAnimations(animationText: "Uploading a new journal entry for \(entryLocation) to your cloud journal. Please wait...", animation: LottieAnimations.loading)
                } else if journalViewModel.error != nil {
                    Button(
                        action: {
                            journalViewModel.uploadNewJournalEntry(startDate: entryStartDate, endDate: entryEndDate, travelLocation: entryLocation, longitude: locationLongitude, latitude: locationLatitude)
                            
                            dismiss()
                            
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                    .padding(.trailing, 10)
                                Text("Retry Entry Upload")
                                    .bold()
                            }
                            .padding()
                        })
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(10)
                    .padding()
                } else {
                    Button(
                        action: {
                            journalViewModel.uploadNewJournalEntry(startDate: entryStartDate, endDate: entryEndDate, travelLocation: entryLocation, longitude: locationLongitude, latitude: locationLatitude)
                            
                            dismiss()
                            
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
        .navigationTitle("Add New Entry")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddJournalEntry(journalViewModel: JournalViewModel(journalRepo: JournalRepository()), entryLocation: "", entryStartDate: Date(), entryEndDate: Date())
}
