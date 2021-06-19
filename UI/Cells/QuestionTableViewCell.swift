//
//  QuestionTableViewCell.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 17.06.2021.
//

import UIKit

enum TextFieldData: Int {
    case question = -1
    case answer1
    case answer2
    case answer3
    case answer4
}

final class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var questionTextField: UITextField!
    @IBOutlet private weak var correctAnswerTextField: UITextField!
    @IBOutlet private weak var answer2TextField: UITextField!
    @IBOutlet private weak var answer3TextField: UITextField!
    @IBOutlet private weak var answer4TextField: UITextField!
    
    private var delegate: UpdateQuestionDataDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.questionTextField.tag = TextFieldData.question.rawValue
        self.questionTextField.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        self.correctAnswerTextField.tag = TextFieldData.answer1.rawValue
        self.correctAnswerTextField.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        self.answer2TextField.tag = TextFieldData.answer2.rawValue
        self.answer2TextField.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        self.answer3TextField.tag = TextFieldData.answer3.rawValue
        self.answer3TextField.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        self.answer4TextField.tag = TextFieldData.answer4.rawValue
        self.answer4TextField.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.questionTextField.text = nil
        self.correctAnswerTextField.text = nil
        self.answer2TextField.text = nil
        self.answer3TextField.text = nil
        self.answer4TextField.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withQuestion text: String, answers: [String], delegate: UpdateQuestionDataDelegate) {
        self.questionTextField.text = text
        self.correctAnswerTextField.text = answers[TextFieldData.answer1.rawValue]
        self.answer2TextField.text = answers[TextFieldData.answer2.rawValue]
        self.answer3TextField.text = answers[TextFieldData.answer3.rawValue]
        self.answer4TextField.text = answers[TextFieldData.answer4.rawValue]
        
        self.delegate = delegate
    }
    
    @objc private func valueChanged(_ textField: UITextField){
        self.delegate?.update(textField: textField, in: self)
    }
}
