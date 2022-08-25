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
    
    @IBOutlet weak var arrowLabel: UILabel!
    @IBOutlet weak var arrowContainer: UIView!
    
    override func awakeFromNib() {
        _theme = ThemeManager.currentTheme()
        
        lblCounter.textColor = _theme.textColor
        lblTitle.textColor = _theme.textGreyColor
        //        lblTitle.font = _theme.muliFont(size: 14, style: .muliSemiBold)
        //        lblCounter.font = _theme.muliFont(size: 22, style: .muliSemiBold)
        //        lblTitle.numberOfLines = 0
        //
        //        lblTitle.lineBreakMode = .byWordWrapping
        
        super.awakeFromNib()
    }
    
    func setCornerRadius() {
        self.cellBackgroundView.layer.masksToBounds = false
        self.cellBackgroundView.layer.cornerRadius = 10
    }
    
    func setShadow() {
        self.cellBackgroundView.setShadowAndRoundedCorner(borderWidth: 0.5, borderColor: UIColor.gray.withAlphaComponent(0.3).cgColor, shadowColor: UIColor.gray.cgColor, offset: CGSize(width: 0.0, height: 1.5), opacity: 0.4, radius:  1)
        
        self.arrowContainer.layer.masksToBounds = false
        self.arrowContainer.layer.cornerRadius = 14
        
        self.arrowContainer.setShadowAndRoundedCorner(borderWidth: 1, borderColor: UIColor.gray.withAlphaComponent(0.3).cgColor, shadowColor: UIColor.gray.cgColor, offset: CGSize(width: 0.0, height: 1.0), opacity: 0.4, radius:  1)
        self.arrowLabel.text = "r"
        self.arrowLabel.textColor = ColorConstant.arrowBtnActionColor
        self.arrowLabel.font = _theme.smfFont(size: 15)
    }
    
    func setData(counter: Int, title: String) {
        lblCounter.text = "\(counter)"
        lblTitle.text = title
    }
}
