//
//  Location.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import Foundation
import CoreLocation

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let address: String?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
