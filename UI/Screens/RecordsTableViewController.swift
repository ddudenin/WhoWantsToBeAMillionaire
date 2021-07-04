//
//  RecordsTableViewController.swift
//  Millionaire
//
//  Created by Дмитрий Дуденин on 12.06.2021.
//

import UIKit

final class RecordsTableViewController: UITableViewController {
    
    private let game = Game.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "RecordTableViewCell", bundle: .none), forCellReuseIdentifier: "recordCell")
        
        self.tableView.allowsSelection = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.game.records.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath) as! RecordTableViewCell
        cell.configue(withRecord: self.game.records[indexPath.row])
        return cell
    }
    
    
    @IBAction func removeAllButtonHandler(_ sender: Any) {
        self.game.removeAllRecords()
        self.tableView.reloadData()
    }
    
}
