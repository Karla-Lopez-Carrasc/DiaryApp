//
//  DiaryListViewModel.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//


import Foundation

final class DiaryListViewModel {

    private(set) var entries: [DiaryEntry] = []

    func load() {
        entries = DiaryDataService.shared
            .loadEntries()
            .sorted { $0.date > $1.date }
    }

    func save() {
        DiaryDataService.shared.saveEntries(entries)
    }

    func add(_ entry: DiaryEntry) {
        entries.append(entry)
        save()
    }
}
