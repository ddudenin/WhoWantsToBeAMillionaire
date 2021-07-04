//
//  QuestionsBuilder.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 19.06.2021.
//

import Foundation

class QuestionBuilder {
    private(set) var question = ""
    private(set) var answers = [String](repeating: "", count: 4)
    
    func build() throws -> Question {
        guard !self.question.isEmpty else { throw Error.missingQuestion }
        
        guard !self.answers.contains(where: { $0.isEmpty }) else {
            throw Error.missingAnswers
        }
        
        return Question(question: self.question, answers: self.answers)
    }
    
    func setQuestion(_ question: String) -> Self {
        self.question = question
        return self
    }
    
    func setAnwers(_ answers: [String]) -> Self {
        self.answers = answers
        return self
    }
    
    func setAnswer(answer text: String, at index: Int) -> Self {
        self.answers[index] = text
        return self
    }
    
    enum Error: String, Swift.Error {
        case missingQuestion
        case missingAnswers
    }
}

class QuestionGroupBuilder {
    private(set) var questions = [QuestionBuilder]()
    
    func addNewQuestion() {
        let question = QuestionBuilder()
        self.questions.append(question)
    }
    
    func removeQuestion(at index: Int) {
        self.questions.remove(at: index)
    }
    
    func build() throws -> [Question] {
        guard self.questions.count > 0 else { throw Error.missingQuestions }
        
        let userQuestions = try self.questions.map { try $0.build() }
        return userQuestions
    }
    
    public enum Error: String, Swift.Error {
        case missingQuestions
    }
}
