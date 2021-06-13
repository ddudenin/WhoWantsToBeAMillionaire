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
    private(set) var records: [Record] = []
    private var recordsCareTaker: GameCareTaker
    
    private init() {
        self.recordsCareTaker = GameCareTaker()
    }
    
    func restoreState() {
        self.records = (try? self.recordsCareTaker.load()) ?? []
    }
    
    func addRecord(_ record: Record) {
        if let index = self.records.firstIndex(where: { $0 < record }) {
            self.records.insert(record, at: index)
        } else {
            self.records.append(record)
        }
        
        try? self.recordsCareTaker.save(self.records)
    }
    
    func removeAllRecords() {
        self.records = []
    }
}

struct GameSession {
    var hints: [Hint : Bool] = [.friend : false, .audience : false, .exclude : false]
    var userBreak = false
    var answered = 0
}


