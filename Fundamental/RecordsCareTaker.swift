//
//  RecordsCareTaker.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 12.06.2021.
//

import Foundation

typealias Memento = Data

class GameCareTaker {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    static let recordsKey = "record"
    
    func save(_ record: [Record]) throws {
        let memento = try encoder.encode(record)
        UserDefaults.standard.setValue(memento, forKey: Self.recordsKey)
    }
    
    func load() throws -> [Record] {
        guard let memento = UserDefaults.standard.value(forKey: Self.recordsKey) as? Memento else {
            return []
        }
        return try decoder.decode([Record].self, from: memento)
    }
}
