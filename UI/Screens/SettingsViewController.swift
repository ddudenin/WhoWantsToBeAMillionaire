//
//  SettingsViewController.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 16.06.2021.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private var game = Game.instance
    @IBOutlet weak var orderSegmentedControl: UISegmentedControl!
    
    private var order: QuestionsOrder {
        return QuestionsOrder(rawValue: self.orderSegmentedControl.selectedSegmentIndex) ?? .predicted
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.orderSegmentedControl.selectedSegmentIndex = self.game.order.rawValue
    }
    
    @IBAction func homeButtonHandler(_ sender: Any) {
        self.game.setOrder(self.order)
        self.dismiss(animated: true)
    }
}
