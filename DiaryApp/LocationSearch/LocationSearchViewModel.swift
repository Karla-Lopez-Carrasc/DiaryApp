//
//  LocationSearchViewModel.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import MapKit

final class LocationSearchViewModel: NSObject {

    private let completer = MKLocalSearchCompleter()
    private(set) var results: [MKLocalSearchCompletion] = []

    var onUpdate: (() -> Void)?

    override init() {
        super.init()
        completer.delegate = self
    }

    func updateQuery(_ query: String) {
        completer.queryFragment = query
    }

    func resolve(
        completion: MKLocalSearchCompletion,
        handler: @escaping (Location) -> Void
    ) {
        let request = MKLocalSearch.Request(completion: completion)
        MKLocalSearch(request: request).start { response, _ in
            guard let item = response?.mapItems.first,
                  let coord = item.placemark.location?.coordinate else { return }

            handler(Location(
                latitude: coord.latitude,
                longitude: coord.longitude,
                address: item.name
            ))
        }
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
        onUpdate?()
    }
}
