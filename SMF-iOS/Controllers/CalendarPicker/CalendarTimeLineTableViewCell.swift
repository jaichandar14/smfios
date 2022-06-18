//
//  CalendarTimeLineTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 28/05/22.
//

import UIKit

class CalendarTimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lineTopView: UIView!
    @IBOutlet weak var lineBottomView: UIView!
    
    private var _theme: Theme!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _theme = ThemeManager.currentTheme()
        setUpViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpViews() {
        self.lblEventTitle.textColor = ColorConstant.greyColor2
        self.lblEventTitle.font = _theme.muliFont(size: 14, style: .muli)
        
        self.lblTime.textColor = _theme.textColor
        self.lblTime.font = _theme.muliFont(size: 15, style: .muli)
    }
    
    func setData(time: String, bookedDescription: String?, isLast: Bool) {
        self.lblTime.text = time
        self.lblEventTitle.text = bookedDescription
        
        if isLast {
            self.lineBottomView.isHidden = true
        } else {
            self.lineBottomView.isHidden = false
        }
    }
}
