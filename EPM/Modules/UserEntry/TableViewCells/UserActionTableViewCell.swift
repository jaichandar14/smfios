//
//  UserActionTableViewCell.swift
//  EPM
//
//  Created by lavanya on 05/11/21.
//

import UIKit
protocol UserActionTVDelegate {
    func popoverMethod()
}

class UserActionTableViewCell: UITableViewCell {
    var delegate : UserActionTVDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func SignUpAction(_ sender: Any) {
        
    }
    @IBAction func googleLoginAction(_ sender: Any) {
    }
    @IBAction func facebookLoginAction(_ sender: Any) {
    }

    @IBAction func signInAction(_ sender: Any) {
        delegate?.popoverMethod()
    }
}
