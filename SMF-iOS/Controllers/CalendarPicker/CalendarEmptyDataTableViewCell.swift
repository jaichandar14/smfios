//
//  CalendarEmptyDataTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 06/06/22.
//

import UIKit

class CalendarEmptyDataTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    private var _theme: Theme!
    override func awakeFromNib() {
        super.awakeFromNib()
        _theme = ThemeManager.currentTheme()
        
        self.title.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
