//
//  StatusListViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

class StatusListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib.init(nibName: String.init(describing: StatusTableViewCell.self), bundle: nil), forCellReuseIdentifier: "statusCell")
    }


}

extension StatusListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell") as? StatusTableViewCell else {
            return UITableViewCell()
        }
        
        cell.lblTitle.text = "Cell \(indexPath.row)"
        
        return cell
    }
    
    
}
