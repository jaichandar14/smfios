//
//  CalendarExpandCollapseTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 04/06/22.
//

import UIKit

class CalendarExpandCollapseTableViewCell: UITableViewCell {

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
        var textColor: UIColor = .clear
        if isEnabled {
            textColor = _theme.textColor
            self.containerView.backgroundColor = .clear
        } else {
            textColor = ColorConstant.greyColor4
            self.containerView.backgroundColor = ColorConstant.greyColor9
        }
        
        let attributes: [NSAttributedString.Key: Any]  = [
            .foregroundColor: textColor,
            .font: _theme.muliFont(size: 14, style: .muli),
            
        ]
        let iconAttributes: [NSAttributedString.Key: Any]  = [
            .foregroundColor: textColor,
            .font: _theme.smfFont(size: 18),
            .baselineOffset: -2
        ]
        
        let attributedString = NSMutableAttributedString(string: "\(isEnabled ? "f" : "e") \(title)", attributes: attributes)
        attributedString.addAttributes(iconAttributes, range: NSRange(location: 0, length: 2))
        self.lblTitle.attributedText = attributedString
        
        self.lblExpandCollapseIcon.text = isExpanded ? "m" : "p"
        self.lblExpandCollapseIcon.font = _theme.smfFont(size: 16)
        self.lblExpandCollapseIcon.textColor = textColor
    }
}
