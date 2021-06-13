//
//  QuestionData.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 11.06.2021.
//

import Foundation

struct Question: Codable {
    let question: String
    let answers: [String]
    var answerID = 0
}
