//
//  RecordTableViewCell.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 12.06.2021.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet private weak var answersCountLabel: UILabel!
    @IBOutlet private weak var prizeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.answersCountLabel.text = nil
        self.prizeLabel.text = nil
        self.dateLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configue(with record: Record) {
        self.answersCountLabel.text = "Правильных ответов \(record.answered)"
        self.prizeLabel.text = "Выигрыш \(record.prize)$"
        self.dateLabel.text =  DateFormatter.localizedString(from: record.date, dateStyle: .medium, timeStyle: .short)
    }
    
}
