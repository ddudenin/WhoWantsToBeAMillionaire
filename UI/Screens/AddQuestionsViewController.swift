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
    
    private let questionsBuilder = QuestionGroupBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: .none), forCellReuseIdentifier: "newQuestionCell")
    }
    
    @IBAction func addButtonHandler(_ sender: Any) {
        self.questionsBuilder.addNewQuestion()
        self.tableView.reloadData()
    }
    
    @IBAction func doneButtonHandler(_ sender: Any) {
        do {
            let questions = try questionsBuilder.build()
            Game.instance.addQuestions(questions)
            self.dismiss(animated: true)
        } catch {
            displayMissingInputsAlert()
        }
    }
    
    private func displayMissingInputsAlert() {
        let alert = UIAlertController(
            title: "Missing Inputs",
            message: "Please provide all non-optional values",
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension AddQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionsBuilder.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newQuestionCell", for: indexPath) as! QuestionTableViewCell
        let question = self.questionsBuilder.questions[indexPath.row]
        cell.configure(withQuestion: question.question, answers: question.answers, delegate: self)
        return cell
    }
}

extension AddQuestionsViewController: UpdateQuestionDataDelegate {
    func update(textField: UITextField, in cell: UITableViewCell) {
        guard
            let row = tableView.indexPath(for: cell)?.row,
            let text =  textField.text
        else { return }
        
        let index = textField.tag
        
        if index >= 0 {
            _ = self.questionsBuilder.questions[row].setAnswer(answer: text, at: index)
        } else {
            _ = self.questionsBuilder.questions[row].setQuestion(text)
        }
    }
}
