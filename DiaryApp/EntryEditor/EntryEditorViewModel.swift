//
//  EntryEditorViewModel.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import UIKit

final class EntryEditorViewModel {

    private(set) var entry: DiaryEntry
    private let dataService = DiaryDataService.shared

    init(entry: DiaryEntry? = nil) {
        self.entry = entry ?? DiaryEntry(
            title: "",
            message: "",
            isDraft: true
        )
    }

    func updateTitle(_ title: String) {
        entry.title = title
    }

    func updateMessage(_ message: String) {
        entry.message = message
    }

    func setImage(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let documentsURL = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
              ).first else { return }

        let imageName = UUID().uuidString + ".jpg"
        let imageURL = documentsURL.appendingPathComponent(imageName)

        try? data.write(to: imageURL)
        entry.imagePath = imageURL.lastPathComponent
    }

    func setLocation(_ location: Location) {
        entry.latitude = location.latitude
        entry.longitude = location.longitude
    }

    func save(isDraft: Bool) {
        entry.isDraft = isDraft

        var entries = dataService.loadEntries()

        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }

        dataService.saveEntries(entries)
    }
}
