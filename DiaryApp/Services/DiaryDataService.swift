//
//  DiaryDataServices.swift
//  DiaryApp
//
//  Created by Karla Lopez on 06/02/26.
//

import Foundation

final class DiaryDataService {

    static let shared = DiaryDataService()
    private let fileName = "entries.json"

    private var fileURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    func loadEntries() -> [DiaryEntry] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }

        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([DiaryEntry].self, from: data)
        } catch {
            print(error)
            return []
        }
    }

    func saveEntries(_ entries: [DiaryEntry]) {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print(error)
        }
    }
}
