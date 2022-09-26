//
//  BidDetailsTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import UIKit

class BidDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var firstLine: UIView!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var circleView: Circle!
    
    @IBOutlet weak var lblBitTitle: UILabel!
    @IBOutlet weak var lblBidValue: UILabel!
    
    @IBOutlet weak var bidStatusImage: UIImageView!
    private var _theme: Theme!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _theme = ThemeManager.currentTheme()
        styleUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func styleUI() {
        self.lblBitTitle.textColor = ColorConstant.greyColor1
        self.lblBitTitle.font = _theme.muliFont(size: 14, style: .muli)
        
        self.lblBidValue.textColor = ColorConstant.greyColor5
        self.lblBidValue.font = _theme.muliFont(size: 12, style: .muli)
        
        self.circleView.trackClr = UIColor.gray
        self.circleView.lineWidth = 0.5
        self.firstLine.backgroundColor = UIColor.black
        self.secondLine.backgroundColor = UIColor.black
        
        self.backgroundColor = .clear
    }
    
    func setData(bidStatus: BidStatus, isFirst: Bool, isLast: Bool) {
        self.lblBitTitle.text = bidStatus.title
        self.lblBidValue.text = bidStatus.subTitle
        
        switch bidStatus.progressStatus {
        case .isPending:
            bidStatusImage.image = UIImage(named: "pending")
            break
        case .isInProgress:
            bidStatusImage.image = UIImage(named: "in_progress")
            break
        case .isCompleted:
            bidStatusImage.image = UIImage(named: "completed")
            break
        }
        
        if isFirst {
            firstLine.isHidden = true
        } else {
            firstLine.isHidden = false
        }
        
        if isLast {
            secondLine.isHidden = true
        } else {
            secondLine.isHidden = false
        }
        
    }
}
