//
//  ActionsCardTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

protocol ActionCardProtocol {
    func notInterestedInEvent(requestId: Int)
    func interestedInEvent(requestId: Int)
    func lookForwardForEvent(requestId: Int)
    func changeInMind(requestId: Int)
}

class ActionsCardTableViewCell: UITableViewCell {
    
    var delegate: ActionCardProtocol?

    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventID: UILabel!
    
    @IBOutlet weak var lblQuoteTitle: UILabel!
    @IBOutlet weak var lblQuotePrice: UILabel!
    @IBOutlet weak var lblBidCutOffTitle: UILabel!
    @IBOutlet weak var lblCutOffDate: UILabel!
    @IBOutlet weak var lblRemainingDate: UILabel!
    @IBOutlet weak var circularProgressView: CircularProgressView!
    
    @IBOutlet weak var lblEventType: UILabel!
    
    @IBOutlet weak var lblEventDateTitle: UILabel!
    @IBOutlet weak var lblServiceDateTitle: UILabel!
    @IBOutlet weak var lblEventDate: UILabel!
    @IBOutlet weak var lblServiceDate: UILabel!
    
    @IBOutlet weak var lblRequestType: UILabel!
    
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnChangeMind: UIButton!
    @IBOutlet weak var bidContainerView: UIView!
    @IBOutlet weak var cellContainerView: UIView!
    
    private var _theme: Theme!
    private var bidInfo: BidStatusInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _theme = ThemeManager.currentTheme()
        
        setUpViews()
        setUpViewShadow(cellContainerView, backgroundColor: UIColor.white, radius: 15, shadowRadius: 10, isHavingBorder: false)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpViews() {
        
        
        lblEventName.textColor = _theme.textColor
        lblEventID.textColor = UIColor.systemBlue
        lblEventType.textColor = _theme.textColor
        
        lblEventDateTitle.textColor = _theme.textGreyColor
        lblServiceDateTitle.textColor = _theme.textGreyColor
        lblEventDate.textColor = _theme.textColor
        lblServiceDate.textColor = _theme.textColor
        
        lblQuoteTitle.textColor = _theme.textGreyColor
        lblQuotePrice.textColor = _theme.textColor
        lblBidCutOffTitle.textColor = _theme.textGreyColor
        lblCutOffDate.textColor = _theme.textColor
        
        lblRequestType.textColor = _theme.textColor
        
        lblEventName.font = _theme.muliFont(size: 16, style: .muliBold)
        lblQuoteTitle.font = _theme.muliFont(size: 12, style: .muli)
        lblQuotePrice.font = _theme.muliFont(size: 16, style: .muliBold)
        
        lblEventDateTitle.font = _theme.muliFont(size: 11, style: .muli)
        lblServiceDateTitle.font = _theme.muliFont(size: 11, style: .muli)
        lblEventDate.font = _theme.muliFont(size: 14, style: .muli)
        lblServiceDate.font = _theme.muliFont(size: 14, style: .muli)
        
        lblBidCutOffTitle.font = _theme.muliFont(size: 10, style: .muli)
        lblCutOffDate.font = _theme.muliFont(size: 12, style: .muliSemiBold)
        
        lblRequestType.font = _theme.muliFont(size: 14, style: .muli)
        
        lblRemainingDate.textColor = ColorConstant.greyColor4
        lblRemainingDate.font = _theme.muliFont(size: 12, style: .muliSemiBold)
        lblRemainingDate.text = "22"
        
        self.btnNext.setTitleColor(ColorConstant.greyColor4, for: .normal)
        setUpButtonView(self.btnNext, backgroundColor: ColorConstant.greyColor8, size: 34)
        setUpButtonView(self.btnDislike, backgroundColor: _theme.errorColor, size: 30)
        setUpButtonView(self.btnLike, backgroundColor: _theme.successColor, size: 30)
        
        self.btnChangeMind.backgroundColor = .clear
        self.btnChangeMind.titleLabel?.font = _theme.muliFont(size: 14, style: .muli)
        self.btnChangeMind.setTitleColor(UIColor.systemBlue, for: .normal)
        
        bidContainerView.backgroundColor = UIColor().colorFromHex("f5f5f5")
        bidContainerView.layer.masksToBounds = false
        bidContainerView.layer.cornerRadius = 8
        bidContainerView.layer.borderWidth = 1
        bidContainerView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
    }
    
    func setUpButtonView(_ button: UIButton, backgroundColor: UIColor, size: Int) {
        
        button.backgroundColor = backgroundColor
        
        button.layer.masksToBounds = false
        button.layer.cornerRadius = CGFloat(size / 2)
                
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        
        button.layer.shadowColor = UIColor.gray.cgColor
        //        self.cellBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: self.cellBackgroundView.bounds, cornerRadius: 10).cgPath
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 3
        
    }
    
    func setUpViewShadow(_ view: UIView, backgroundColor: UIColor, radius: CGFloat, shadowRadius: CGFloat, isHavingBorder: Bool) {
                
        view.backgroundColor = backgroundColor
        
        view.layer.masksToBounds = false
        view.layer.cornerRadius = radius
                
        if isHavingBorder {
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        }
        
        view.layer.shadowColor = UIColor.gray.cgColor
        //        self.cellBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: self.cellBackgroundView.bounds, cornerRadius: 10).cgPath
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = shadowRadius
        
    }
    
    func setData(bidInfo: BidStatusInfo) {
        self.bidInfo = bidInfo
        lblEventName.text = bidInfo.eventName
        lblEventID.text = "\(bidInfo.eventServiceDescriptionId)"
        lblEventType.text = bidInfo.serviceName
        lblEventDate.text = bidInfo.eventDate.toSMFShortFormat()
        lblServiceDate.text = bidInfo.serviceDate.toSMFShortFormat()
//        lblRequestType.text = bidInfo.
        lblQuotePrice.text = bidInfo.cost
        lblRemainingDate.text = "22"
        
    }
    
    
    @IBAction func btnDislikeAction(_ sender: UIButton) {
        delegate?.notInterestedInEvent(requestId: self.bidInfo.bidRequestId)
    }
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
        delegate?.interestedInEvent(requestId: self.bidInfo.bidRequestId)
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        delegate?.lookForwardForEvent(requestId: self.bidInfo.bidRequestId)
    }
    
    @IBAction func btnChangeInMindAction(_ sender: UIButton) {
        delegate?.changeInMind(requestId: self.bidInfo.bidRequestId)
    }
}
