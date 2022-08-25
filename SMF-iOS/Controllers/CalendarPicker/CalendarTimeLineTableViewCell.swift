//
//  CalendarTimeLineTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 28/05/22.
//

import UIKit

protocol CalendarTimeLineActionDelegate {
    func tapOnChangeAvailability(indexPath: IndexPath)
}

class CalendarTimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lineTopView: UIView!
    @IBOutlet weak var lineBottomView: UIView!
    @IBOutlet weak var btnChangeBooking: UIButton!
    
    var delegate: CalendarTimeLineActionDelegate?
    var indexPath: IndexPath!
    
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
        self.lblEventTitle.textColor = ColorConstant.greyColor1
        self.lblEventTitle.font = _theme.muliFont(size: 14, style: .muli)
        
        self.lblTime.textColor = ColorConstant.greyColor2
        self.lblTime.font = _theme.muliFont(size: 15, style: .muli)
        
        self.iconLabel.layer.borderWidth = 1
        self.iconLabel.layer.borderColor = _theme.primaryColor.cgColor
        self.iconLabel.layer.cornerRadius = 16
        self.iconLabel.backgroundColor = .clear
        self.iconLabel.text = "m"
        self.iconLabel.font = _theme.smfFont(size: 18)
        self.iconLabel.textColor = _theme.primaryColor
    }
    
    func setData(time: String, bookedDescription: String?, isLast: Bool, slotAvailable: Bool? = nil) {
        self.lblTime.text = time
        self.lblEventTitle.text = bookedDescription
        
        if isLast {
            self.lineBottomView.isHidden = true
        } else {
            self.lineBottomView.isHidden = false
        }
        
        if let available = slotAvailable {
            if available {
                self.lblEventTitle.text = "Slot available"
                self.lblEventTitle.textColor = _theme.accentColor.withAlphaComponent(0.8)
                self.iconLabel.text = "g"
            } else {
                self.lblEventTitle.text = "Slot not available"
                self.lblEventTitle.textColor = ColorConstant.greyColor2
                self.iconLabel.text = ""
            }
        }
        
        if let desc = bookedDescription, desc != "" {
            self.iconLabel.text = "m"
            self.lblEventTitle.text = desc
            self.lblEventTitle.textColor = ColorConstant.greyColor2
        }
    }
    
    @IBAction func btnChangeBooking(_ sender: UIButton) {
        self.delegate?.tapOnChangeAvailability(indexPath: self.indexPath)
    }
    
}
