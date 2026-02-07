//
//  EntryDetailViewModel.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import MapKit

final class EntryDetailViewModel {

    let entry: DiaryEntry

    init(entry: DiaryEntry) {
        self.entry = entry
    }

    var title: String {
        entry.title
    }

    var message: String {
        entry.message
    }

    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: entry.date)
    }

    var coordinate: CLLocationCoordinate2D? {
        guard let lat = entry.latitude,
              let lon = entry.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    
}

