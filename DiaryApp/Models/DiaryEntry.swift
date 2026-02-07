//
//  DiaryEntry.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//

import Foundation

struct DiaryEntry: Codable, Identifiable {
    let id: UUID
    var title: String
    var message: String
    var date: Date
    var latitude: Double?
    var longitude: Double?
    var imagePath: String?
    var isDraft: Bool

    init(
        id: UUID = UUID(),
        title: String,
        message: String,
        date: Date = Date(),
        latitude: Double? = nil,
        longitude: Double? = nil,
        imagePath: String? = nil,
        isDraft: Bool = false
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.imagePath = imagePath
        self.isDraft = isDraft
    }
}

