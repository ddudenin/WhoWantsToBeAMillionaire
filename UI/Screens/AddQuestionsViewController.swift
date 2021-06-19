//
//  AddQuestionsViewController.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 17.06.2021.
//

import UIKit

class AddQuestionsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var model = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: .none), forCellReuseIdentifier: "newQuestionCell")
    }
    
    @IBAction func addButtonHandler(_ sender: Any) {
        self.model.append([String].init(repeating: "", count: 5))
        self.tableView.reloadData()
    }
    
    @IBAction func doneButtonHandler(_ sender: Any) {
        //Builder
        self.dismiss(animated: true)
    }
}

extension AddQuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newQuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.configure(withData: self.model[indexPath.row], delegate: self)
        return cell
    }
    

}

extension AddQuestionsViewController: TableViewCellDelegate {
    func report(textField: UITextField, in cell: UITableViewCell) {
        guard
            let row = tableView.indexPath(for: cell)?.row,
            let text =  textField.text,
            textField.tag < self.model.count
        else { return }
        
        
        self.model[row][textField.tag] = text
    }
}
