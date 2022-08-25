//
//  ListCloseTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 6/25/22.
//

import UIKit

class ListCloseTableViewCell: UITableViewCell {
    
    var delegate: ActionListDelegate?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNewRequestCount: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnClose.backgroundColor = .clear
        self.btnClose.setTitleColor(.black, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.delegate?.btnCloseAction()
    }
    
}
