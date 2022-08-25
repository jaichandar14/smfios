//
//  SideMenuCell.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/7/21.
//

import UIKit



class SideMenuCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    private var _theme: Theme!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _theme = ThemeManager.currentTheme()
        
        // Background
        self.backgroundColor = .clear
        self.setSelection(isSelected: false)
    }
    
    func setSelection(isSelected: Bool) {
       // Icon
        self.iconImageView.tintColor = isSelected ? _theme.primaryColor : _theme.textColor
        
        // Title
        self.titleLabel.textColor = isSelected ? _theme.primaryColor : _theme.textColor
    }
}
