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
    static let questionsKey = "userQuestions"
    static let order = "questionsOrder"
    
    func save(_ record: [Record]) throws {
        let memento = try encoder.encode(record)
        UserDefaults.standard.setValue(memento, forKey: Self.recordsKey)
    }
    
    func save(_ questions: [Question]) throws {
        let memento = try encoder.encode(questions)
        UserDefaults.standard.setValue(memento, forKey: Self.questionsKey)
    }
    
    func save(_ order: QuestionsOrder) throws {
        let memento = try encoder.encode(order.rawValue)
        UserDefaults.standard.setValue(memento, forKey: Self.order)
    }
    
    func loadRecords() throws -> [Record] {
        guard let memento = UserDefaults.standard.value(forKey: Self.recordsKey) as? Memento else {
            return []
        }
        return try decoder.decode([Record].self, from: memento)
    }
    
    func loadQuestions() throws -> [Question] {
        guard let memento = UserDefaults.standard.value(forKey: Self.questionsKey) as? Memento else {
            return []
        }
        return try decoder.decode([Question].self, from: memento)
    }
    
    func loadOrder() throws -> QuestionsOrder {
        guard
            let memento = UserDefaults.standard.value(forKey: Self.order) as? Memento,
            let index = try? decoder.decode(Int.self, from: memento)
        else {
            return .predicted
        }
        
        return QuestionsOrder(rawValue: index) ?? .predicted
    }
}
