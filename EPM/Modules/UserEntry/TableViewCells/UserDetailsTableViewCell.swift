//
//  UserDetailsTableViewCell.swift
//  EPM
//
//  Created by lavanya on 02/11/21.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textfield: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(item:String) {
        label.text = item
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
