//
//  HomeViewController.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 11.06.2021.
//

import UIKit

final class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setGradientBackground()
    }
    
    @IBAction func newGameButtonHandler(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .none)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "gameScreen") as? GameViewController else { return }
        vc.gameDelegate = self
        Game.instance.session = GameSession()
        self.present(vc, animated: true, completion: .none)
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
}

extension HomeViewController: GameViewControllerDelegate {
    func gameViewController(_ viewController: GameViewController, didEndGameWith record: Record) {
        if record.answered > 0 {
            Game.instance.addRecord(record)
        }
        viewController.dismiss(animated: true)
    }
}
