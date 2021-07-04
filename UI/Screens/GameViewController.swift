//
//  GameViewController.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 11.06.2021.
//

import UIKit

protocol GameViewControllerDelegate: AnyObject {
    func gameViewController(_ viewController: GameViewController, didEndGameWith record: Record)
}

final class GameViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var phoneFriendButton: UIButton!
    @IBOutlet private weak var askAudienceButton: UIButton!
    @IBOutlet private weak var fiftyFiftyButton: UIButton!
    
    private var answered = 0
    private var data = [Question]()
    
    weak var gameDelegate: GameViewControllerDelegate?
    private var session = Game.instance.session
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setGradientBackground()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "AnswerCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "AnswerCell")
        
        self.collectionView.backgroundColor = UIColor.clear
        
        self.session = GameSession()
        
        prepareQuestions()
        showNextQuestion()
    }
    
    private func addQuestions(from category: Dificulty) {
        guard let questions = questionsDB[category] else { return }
        for question in questions {
            var answers = question.answers
            let index = Int.random(in: 0..<answers.count)
            answers.insert(answers.removeFirst(), at: index)
            data.append(Question(question: question.question, answers: answers, answerID: index))
        }
    }
    
    private func prepareQuestions() {
        addQuestions(from: .easy)
        addQuestions(from: .medium)
        addQuestions(from: .hard)
    }
    
    private func showNextQuestion() {
        let question = data[self.answered]
        self.questionLabel.text = question.question
        self.collectionView.reloadData()
    }
    
    private func setGradientBackground() {
        let gradient = CAGradientLayer()
        
        let startColor = UIColor(hexString: "#1e3b70").cgColor
        let endColor = UIColor(hexString: "#29539b").cgColor
        
        gradient.colors = [startColor, endColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func endGameSession() {
        self.session?.answered = self.answered
        let record = Record(self.session)
        self.session = nil
        self.gameDelegate?.gameViewController(self, didEndGameWith: record)
    }
    
    @IBAction func homeButtonHandler(_ sender: Any) {
        let alert = UIAlertController(title: "Выход из игры", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { _ in
            self.session?.userBreak = true
            self.endGameSession()
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func phoneFriendButtonHandler(_ sender: Any) {
        let alert = UIAlertController(title: "Ответ друга",
                                      message: "\(data[self.answered].answers[Int.random(in: 0...3)])",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        self.phoneFriendButton.isEnabled = false
        self.session?.hints[.friend] = true
    }
    
    @IBAction func askAudienceButtonHandler(_ sender: Any) {
        var counts = [0, 0, 0, 0];
        
        for _ in 0..<100 {
            let index = Int.random(in: 0...3)
            counts[index] += 1
        }
        
        let answers = data[self.answered].answers
        var statString = ""
        for i in 0..<4 {
            statString += "\(answers[i]) \(counts[i])\n"
        }
        
        let alert = UIAlertController(title: "Опрос зала", message: statString, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
        self.askAudienceButton.isEnabled = false
        self.session?.hints[.audience] = true
    }
    
    @IBAction func fiftyFiftyButtonHandler(_ sender: Any) {
        var indexes = [data[answered].answerID]
        
        while indexes.count < 3 {
            let index = Int.random(in: 0...3)
            
            guard !indexes.contains(index) else { continue }
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell = self.collectionView.cellForItem(at: indexPath)
            
            (cell as! AnswerCollectionViewCell).setAnswerText(answer: "")
            
            indexes.append(index)
        }
        
        self.fiftyFiftyButton.isEnabled = false
        self.session?.hints[.exclude] = true
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCell", for: indexPath) as? AnswerCollectionViewCell else {
            return AnswerCollectionViewCell()
        }
        
        cell.setAnswerText(answer: data[answered].answers[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        
        let answerID = self.data[self.answered].answerID
        if indexPath.row != answerID {
            let message = "Правильный ответ: \(self.data[self.answered].answers[answerID])"
            
            let alert = UIAlertController(title: "Вы проиграли", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.endGameSession()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        self.answered += 1
        
        if self.answered == data.count {
            let alert = UIAlertController(title: "Поздравляю", message: "Вы стали миллионером", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.endGameSession()
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        showNextQuestion()
    }
}
