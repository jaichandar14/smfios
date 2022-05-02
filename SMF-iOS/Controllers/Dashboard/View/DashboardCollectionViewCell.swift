//
//  DashboardCollectionViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var cellBackgroundView: UIView!
    private var _theme: Theme!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _theme = ThemeManager.currentTheme()
        
        lblCounter.textColor = _theme.textColor
        lblTitle.textColor = _theme.textGreyColor
    }
    
    func setCornerRadius() {
        self.cellBackgroundView.layer.masksToBounds = false
        self.cellBackgroundView.layer.cornerRadius = 10
    }
    
    func setShadow() {
        self.cellBackgroundView.layer.borderWidth = 1
        self.cellBackgroundView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        self.cellBackgroundView.layer.shadowColor = UIColor.gray.cgColor
//        self.cellBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: self.cellBackgroundView.bounds, cornerRadius: 10).cgPath
        self.cellBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.cellBackgroundView.layer.shadowOpacity = 0.4
        self.cellBackgroundView.layer.shadowRadius = 3
    }

    func setData(counter: Int, title: String) {
        lblCounter.text = "\(counter)"
        lblTitle.text = title
    }
}
