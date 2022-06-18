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
    
    private var _theme: Theme!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _theme = ThemeManager.currentTheme()
        
        self.lblQuestion.textColor = _theme.textColor
        self.lblQuestion.font = _theme.muliFont(size: 15, style: .muli)
        
        self.lblAnswer.textColor = _theme.textColor
        self.lblAnswer.font = _theme.muliFont(size: 15, style: .muli)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
