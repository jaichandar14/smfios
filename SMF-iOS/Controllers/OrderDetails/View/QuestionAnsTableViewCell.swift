//
//  QuestionAnsTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/23/22.
//

import UIKit

class QuestionAnsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblAnswer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
