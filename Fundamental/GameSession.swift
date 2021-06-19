//
//  Game.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 12.06.2021.
//

import Foundation

class Game {
    static let instance: Game = Game()
    
    var session: GameSession?
    private(set) var order: QuestionsOrder
    private(set) var records: [Record]
    private var gameCareTaker: GameCareTaker
    
    private init() {
        self.gameCareTaker = GameCareTaker()
        self.order = .predicted
        self.records = []
    }
    
    func restoreState() {
        self.records = (try? self.gameCareTaker.loadRecords()) ?? []
        self.order = (try? self.gameCareTaker.loadOrder()) ?? .predicted
        
        let questions = (try? self.gameCareTaker.loadQuestions()) ?? []
        
        if !questions.isEmpty {
            questionsDB[.easy]?.append(contentsOf: questions)
        }
    }
    
    func addRecord(_ record: Record) {
        if let index = self.records.firstIndex(where: { $0 < record }) {
            self.records.insert(record, at: index)
        } else {
            self.records.append(record)
        }
        
        try? self.gameCareTaker.save(self.records)
    }
    
    func setOrder(_ order: QuestionsOrder) {
        self.order = order
        try? self.gameCareTaker.save(self.order)
    }
        
    func removeAllRecords() {
        self.records = []
    }
}

struct GameSession {
    var hints: [Hint : Bool] = [.friend : false, .audience : false, .exclude : false]
    var facade = HintsUsageFacade()
    var userBreak = false
    var answered = 0
}


