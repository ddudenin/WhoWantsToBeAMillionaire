//
//  RecordData.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 12.06.2021.
//

import Foundation

struct Record: Codable {
    var date = Date()
    var answered: Int = 0
    var prize: Int = 0

    init(_ session: GameSession?) {
        guard let sessionData = session else { return }
        
        let count = sessionData.answered
        self.answered = count
        self.prize = prizes[sessionData.userBreak ? count : count - (count % 5)]
    }
    
    static func < (left: Record, right: Record) -> Bool {
        return left.answered < right.answered
    }
    
    static func > (left: Record, right: Record) -> Bool {
        return left.answered > right.answered
    }
}
