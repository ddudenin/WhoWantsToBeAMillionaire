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
    private(set) var questions: [Question]
    private var gameCareTaker: GameCareTaker
    
    private init() {
        self.gameCareTaker = GameCareTaker()
        self.order = .predicted
        self.records = []
        self.questions = []
    }
    
    func restoreState() {
        self.records = (try? self.gameCareTaker.loadRecords()) ?? []
        self.order = (try? self.gameCareTaker.loadOrder()) ?? .predicted
        self.questions = (try? self.gameCareTaker.loadQuestions()) ?? []
    }
    
    func addRecord(_ record: Record) {
        if let index = self.records.firstIndex(where: { $0 < record }) {
            self.records.insert(record, at: index)
        } else {
            self.records.append(record)
        }
        
        try? self.gameCareTaker.save(self.records)
    }
    
    func addQuestions(_ questions: [Question]) {
        self.questions.append(contentsOf: questions)
        try? self.gameCareTaker.save(self.questions)
    }
    
    func setOrder(_ order: QuestionsOrder) {
        self.order = order
        try? self.gameCareTaker.save(self.order)
    }
    
    func removeAllRecords() {
        self.records = []
        try? self.gameCareTaker.save(self.records)
    }
    
    func removeAllUserQuestions() {
        self.questions = []
        try? self.gameCareTaker.save(self.questions)
    }
}

protocol GameSessionDelegate: AnyObject {
    func nextQuestion(question: Question)
    func applyHint(hint type: Hint)
    func setUserBreak()
}

class GameSession {
    var hints: [Hint : Bool] = [.friend : false, .audience : false, .exclude : false]
    var facade = HintsUsageFacade()
    var userBreak = false
    var answered = -1
}

extension GameSession : GameSessionDelegate {
    
    func nextQuestion(question: Question) {
        self.facade.question = question
        self.answered += 1
    }
    
    func applyHint(hint type: Hint) {
        self.hints[type] = true
        self.facade.useHint(withType: type)
    }
    
    func setUserBreak() {
        self.userBreak = true
    }
}

