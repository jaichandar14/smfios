//
//  EventDetailsTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import UIKit

class EventDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    private var _theme: Theme!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        _theme = ThemeManager.currentTheme()
        styleUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func styleUI() {
        self.lblTitle.textColor = ColorConstant.greyColor5
        self.lblTitle.font = _theme.muliFont(size: 16, style: .muli)
        
        self.lblTitle.textColor = ColorConstant.greyColor1
        self.lblTitle.font = _theme.muliFont(size: 16, style: .muli)
    }
    
    func setData(eventDetail: EventDetail) {
        self.lblTitle.text = eventDetail.title
        self.lblValue.text = eventDetail.value
    }
    
}
