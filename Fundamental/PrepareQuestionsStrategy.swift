//
//  PrepareQuestionsStrategy.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 16.06.2021.
//

import Foundation

protocol PrepareQuestionsStrtegy {
    func prepareQuestions(for difficulty: Dificulty) -> [Question]
}

struct PredictedOrderQuestionsStrategy: PrepareQuestionsStrtegy {
    func prepareQuestions(for difficulty: Dificulty) -> [Question] {
        var questions: [Question] = []
        
        guard let category = questionsDB[difficulty] else { return questions }
        
        for question in category {
            var answers = question.answers
            let index = Int.random(in: 0..<answers.count)
            answers.insert(answers.removeFirst(), at: index)
            questions.append(Question(question: question.question, answers: answers, answerID: index))
        }
        
        return questions
    }
}

struct RandomOrderQuestionsStrategy: PrepareQuestionsStrtegy {
    func prepareQuestions(for difficulty: Dificulty) -> [Question] {
        var questions: [Question] = []
        
        guard var category = questionsDB[difficulty] else { return questions }
        category.shuffle()
        
        for question in category {
            var answers = question.answers
            let index = Int.random(in: 0..<answers.count)
            answers.insert(answers.removeFirst(), at: index)
            questions.append(Question(question: question.question, answers: answers, answerID: index))
        }
        
        return questions
    }
}
