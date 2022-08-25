//
//  CalendarExpandCollapseTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 04/06/22.
//

import UIKit

class CalendarExpandCollapseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLeadingIcon: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblExpandCollapseIcon: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    private var _theme: Theme!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _theme = ThemeManager.currentTheme()
        self.lblExpandCollapseIcon.font = _theme.smfFont(size: 16)
        self.lblExpandCollapseIcon.textColor = _theme.textColor
        
        self.containerView.setBorderedView(radius: 3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setData(title: String, isEnabled: Bool, isExpanded: Bool) {
        if isEnabled {
            self.containerView.backgroundColor = .clear
        } else {
            self.containerView.backgroundColor = ColorConstant.greyColor9
        }
        
        self.lblTitle.text = title
        self.lblTitle.textColor = UIColor.white
        self.lblTitle.font = _theme.muliFont(size: 16, style: .muliSemiBold)
        
        self.lblExpandCollapseIcon.text = isExpanded ? "m" : "p"
        self.lblExpandCollapseIcon.font = _theme.smfFont(size: 20)
        self.lblExpandCollapseIcon.textColor = UIColor.white
        
        self.lblLeadingIcon.layer.masksToBounds = true
        self.lblLeadingIcon.layer.cornerRadius = 12
        self.lblLeadingIcon.backgroundColor = .white
        self.lblLeadingIcon.text = "g"
        self.lblLeadingIcon.textColor = _theme.primaryColor
        
        self.containerView.backgroundColor = ColorConstant.currentDateBackgroundColor
        self.containerView.layer.cornerRadius = 8
    }
}
