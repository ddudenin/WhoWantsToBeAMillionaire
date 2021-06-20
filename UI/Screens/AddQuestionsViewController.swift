//
//  AddQuestionsViewController.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 17.06.2021.
//

import UIKit

protocol UpdateQuestionDataDelegate {
    func update(textField: UITextField, in cell: UITableViewCell)
}

final class AddQuestionsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let game = Game.instance
    
    private let questionsBuilder = QuestionGroupBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: .none), forCellReuseIdentifier: "QuestionCell")
    }
    
    @IBAction func deleteAllUserQuestionsHandler(_ sender: Any) {
        self.game.removeAllUserQuestions()
    }
    
    @IBAction func doneButtonHandler(_ sender: Any) {
        guard !self.questionsBuilder.questions.isEmpty else {
            self.dismiss(animated: true)
            return
        }
        
        do {
            let questions = try questionsBuilder.build()
            self.game.addQuestions(questions)
            self.dismiss(animated: true)
        } catch {
            displayMissingInputsAlert()
        }
    }
    
    private func displayMissingInputsAlert() {
        let alert = UIAlertController(
            title: "Ошибка ввода данных",
            message: "Пожалуйста, укажите все обязательные значения",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func questionBuilder(for indexPath: IndexPath) -> QuestionBuilder {
        return self.questionsBuilder.questions[indexPath.row - 1]
    }
    
}

extension AddQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionsBuilder.questions.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row >= 0, row < self.questionsBuilder.questions.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
            let question = self.questionsBuilder.questions[indexPath.row]
            cell.delegate = self
            cell.configure(withQuestion: question.question, answers: question.answers)
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "AddQuestionCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.questionsBuilder.removeQuestion(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard isLastIndexPath(indexPath) else { return }
        self.questionsBuilder.addNewQuestion()
        self.tableView.insertRows(at: [indexPath], with: .top)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func isLastIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row ==
            self.tableView.numberOfRows(inSection: indexPath.section) - 1
    }
}

extension AddQuestionsViewController: UpdateQuestionDataDelegate {
    func update(textField: UITextField, in cell: UITableViewCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let text =  textField.text
        else { return }
        
        let index = textField.tag
        
        if index >= 0 {
            _ = questionBuilder(for: indexPath).setAnswer(answer: text, at: index)
        } else {
            _ = questionBuilder(for: indexPath).setQuestion(text)
        }
    }
}
