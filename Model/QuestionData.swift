//
//  QuestionData.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 11.06.2021.
//

import Foundation

class Question: Codable {
    let question: String
    var answers: [String]
    var answerID = 0
    var friendID = -1

    init(question: String, answers: [String], answerID: Int = 0) {
        self.question = question
        self.answers = answers
        self.answerID = answerID
    }
    
    func callFriend() {
        friendID = Int.random(in: 0...3)
    }
    
    func useAuditoryHelp() {
        var counts = [0, 0, 0, 0];
        
        for _ in 0..<100 {
            counts[Int.random(in: 0...3)] += 1
        }
        
        for i in 0..<4 {
            answers[i] += "(\(counts[i])%)"
        }
    }
    
    func use50to50 () {
        var indexes = [self.answerID]
        
        while indexes.count < 3 {
            let index = Int.random(in: 0...3)
            
            guard !indexes.contains(index) else { continue }
            
            answers[index] = ""
            
            indexes.append(index)
        }
    }
}
