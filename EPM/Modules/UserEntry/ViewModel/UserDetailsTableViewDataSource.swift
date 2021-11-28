//
//  UserDetailsTableViewDataSource.swift
//  EPM
//
//  Created by lavanya on 02/11/21.
//

import Foundation
import UIKit



class UserDetailsTableViewDataSource<CELL: UITableViewCell,C> : NSObject,UITableViewDataSource,UITableViewDelegate, UserActionTVDelegate {
     
    var configureCell : (CELL, C) -> () = {_,_ in }
    var fieldName = ["First name","Last Name","Email ID","Mobile Number"]
     
    init(configureCell : @escaping (CELL, C) -> ()) {
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          switch indexPath.row {
        case 0...3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailsTableViewCell", for: indexPath) as! UserDetailsTableViewCell
            let item = self.fieldName[indexPath.row]
            cell.configureCell(item: item)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserActionTableViewCell", for: indexPath) as! UserActionTableViewCell
            cell.delegate = self
            return cell
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func popoverMethod() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "popover"), object: nil)
    }
 
}
