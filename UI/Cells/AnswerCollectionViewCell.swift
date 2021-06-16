//
//  AnswerCollectionViewCell.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 11.06.2021.
//

import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.answerLabel.text = nil
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.systemBlue
    }
    
    func setAnswerText(answer text: String) {
        self.answerLabel.text = text
        self.isUserInteractionEnabled = !text.isEmpty
    }
    
}
