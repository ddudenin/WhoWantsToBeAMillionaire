//
//  QuestionTableViewCell.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 17.06.2021.
//

import UIKit

enum TextFieldData: Int {
    case question = 0
    case answer1
    case answer2
    case answer3
    case answer4
}

protocol TableViewCellDelegate {
    func report(textField: UITextField, in cell: UITableViewCell)
}

final class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var questionTextField: UITextField!
    @IBOutlet private weak var correctAnswerTextField: UITextField!
    @IBOutlet private weak var answer2TextField: UITextField!
    @IBOutlet private weak var answer3TextField: UITextField!
    @IBOutlet private weak var answer4TextField: UITextField!
    
    private var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.questionTextField.tag = TextFieldData.question.rawValue
        self.questionTextField.addTarget(self, action: #selector(valueChanged), for: .editingDidEnd)
        
        self.correctAnswerTextField.tag = TextFieldData.answer1.rawValue
        self.correctAnswerTextField.addTarget(self, action: #selector(valueChanged), for: .editingDidEnd)
        
        self.answer2TextField.tag = TextFieldData.answer2.rawValue
        self.answer2TextField.addTarget(self, action: #selector(valueChanged), for: .editingDidEnd)
        
        self.answer3TextField.tag = TextFieldData.answer3.rawValue
        self.answer3TextField.addTarget(self, action: #selector(valueChanged), for: .editingDidEnd)
        
        self.answer4TextField.tag = TextFieldData.answer4.rawValue
        self.answer4TextField.addTarget(self, action: #selector(valueChanged), for: .editingDidEnd)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(withData data: [String], delegate: TableViewCellDelegate) {
        self.questionTextField.text = data[TextFieldData.question.rawValue]
        self.correctAnswerTextField.text = data[TextFieldData.answer1.rawValue]
        self.answer2TextField.text = data[TextFieldData.answer2.rawValue]
        self.answer3TextField.text = data[TextFieldData.answer3.rawValue]
        self.answer4TextField.text = data[TextFieldData.answer4.rawValue]
        
        self.delegate = delegate
    }
    
    @objc private func valueChanged(_ textField: UITextField){
        self.delegate?.report(textField: textField, in: self)
    }
}
