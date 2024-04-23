//
//  GeoLocationService.swift
//  Travel Journal
//
//  Created by Muindo Gituku on 2024-04-19.
//

import SwiftUI
import Combine
import MapKit
import CoreLocation

class MapSearch : NSObject, ObservableObject {
    @Published var locationResults : [MKLocalSearchCompletion] = []
    @Published var searchTerm = ""
    
    private var cancellables : Set<AnyCancellable> = []
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var currentPromise : ((Result<[MKLocalSearchCompletion], Error>) -> Void)?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType([.address])
        
        $searchTerm
            .debounce(for: .seconds(0.2), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap({ (currentSearchTerm) in
                self.searchTermToResults(searchTerm: currentSearchTerm)
            })
            .sink(receiveCompletion: { (completion) in
                //handle error
            }, receiveValue: { (results) in
                //self.locationResults = results.filter { $0.subtitle.contains("United States") }
                self.locationResults = results
            })
            .store(in: &cancellables)
    }
    
    func searchTermToResults(searchTerm: String) -> Future<[MKLocalSearchCompletion], Error> {
        Future { promise in
            self.searchCompleter.queryFragment = searchTerm
            self.currentPromise = promise
        }
    }
}

extension MapSearch : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        currentPromise?(.success(completer.results))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //could deal with the error here, but beware that it will finish the Combine publisher stream
        //currentPromise?(.failure(error))
    }
}

struct ReversedGeoLocation: Equatable {
    let id = UUID()
    let name: String
    let locality: String
    let administrativeArea: String
    let postalCode: String
    let iSOCountryCode: String
    let country: String
    let longitude:Double
    let latitude:Double
    
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name = placemark.name ?? ""
        self.locality = placemark.locality ?? ""
        self.administrativeArea = placemark.administrativeArea ?? ""
        self.postalCode = placemark.postalCode ?? ""
        self.iSOCountryCode = placemark.isoCountryCode ?? ""
        self.country = placemark.country ?? ""
        self.longitude = placemark.location?.coordinate.longitude ?? 0.0
        self.latitude = placemark.location?.coordinate.latitude ?? 0.0
    }
}
