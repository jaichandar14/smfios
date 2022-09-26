//
//  ActionsCardTableViewCell.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

class ActionsCardTableViewCell: UITableViewCell {
    
    var delegate: ActionListDelegate?
    var status: BiddingStatus?
    
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
    
    //    @IBOutlet weak var lblRequestType: UILabel!
    
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    @IBOutlet weak var lblNextStatus: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnChangeMind: UIButton!
    @IBOutlet weak var bidContainerView: UIView!
    @IBOutlet weak var cellContainerView: UIView!
    @IBOutlet weak var btnServiceWorkFlow: UIButton!
    
    private var _theme: Theme!
    private var bidInfo: BidStatusInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _theme = ThemeManager.currentTheme()
        
        setUpViews()
        setUpViewShadow(cellContainerView, backgroundColor: UIColor.white, radius: 10, shadowRadius: 10, isHavingBorder: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpViews() {
        self.selectionStyle = .none
        
        lblEventName.textColor = _theme.textColor
        lblEventID.textColor = _theme.eventIDTextColor
        lblEventType.textColor = _theme.textColor
        
        lblEventDateTitle.textColor = _theme.textGreyColor
        lblServiceDateTitle.textColor = _theme.textGreyColor
        lblEventDate.textColor = _theme.textColor
        lblServiceDate.textColor = _theme.textColor
        
        lblQuoteTitle.textColor = _theme.textGreyColor
        lblQuotePrice.textColor = _theme.textColor
        lblBidCutOffTitle.textColor = _theme.textGreyColor
        lblCutOffDate.textColor = _theme.textColor
        
        //        lblRequestType.textColor = _theme.textColor
        
        lblEventName.font = _theme.muliFont(size: 16, style: .muliBold)
        lblQuoteTitle.font = _theme.muliFont(size: 12, style: .muli)
        lblQuotePrice.font = _theme.muliFont(size: 16, style: .muliBold)
        
        lblEventDateTitle.font = _theme.muliFont(size: 14, style: .muli)
        lblServiceDateTitle.font = _theme.muliFont(size: 14, style: .muli)
        lblEventDate.font = _theme.muliFont(size: 16, style: .muli)
        lblServiceDate.font = _theme.muliFont(size: 16, style: .muli)
        
        lblBidCutOffTitle.font = _theme.muliFont(size: 12, style: .muli)
        lblCutOffDate.font = _theme.muliFont(size: 16, style: .muliSemiBold)
        
        //        lblRequestType.font = _theme.muliFont(size: 14, style: .muli)
        
        lblRemainingDate.textColor = ColorConstant.greyColor2
        lblRemainingDate.font = _theme.muliFont(size: 12, style: .muliSemiBold)
        lblRemainingDate.text = "22"
        
        self.btnDislike.setTitleColor(ColorConstant.disLikeBtnActionColor, for: .normal)
        
        self.btnNext.backgroundColor = .clear
        //        self.btnNext.setAttributedTitle(getNextButtonTitle(), for: .normal)
        //        setUpButtonView(self.btnNext, backgroundColor: _theme.primaryColor, size: 34, setBackgroundColor: true)
        setUpButtonView(self.btnDislike, backgroundColor: ColorConstant.disLikeBtnActionColor, size: 40, setBackgroundColor: false)
        setUpButtonView(self.btnLike, backgroundColor: ColorConstant.likeBtnActionColor, size: 40, setBackgroundColor: true)
        
        self.btnChangeMind.backgroundColor = .clear
        self.btnChangeMind.titleLabel?.font = _theme.muliFont(size: 14, style: .muli)
        self.btnChangeMind.setTitleColor(UIColor.systemBlue, for: .normal)
        
        bidContainerView.backgroundColor = UIColor().colorFromHex("#F0F8FF")
        bidContainerView.layer.masksToBounds = false
        bidContainerView.layer.cornerRadius = 8
        bidContainerView.layer.borderWidth = 1
        bidContainerView.layer.borderColor = UIColor().colorFromHex("#D8F2FF").cgColor
        
        self.lblNextStatus.textColor = ColorConstant.textColor
        self.lblNextStatus.font = _theme.muliFont(size: 12, style: .muliSemiBold)
        
    }
    
    func getNextButtonTitle() -> NSAttributedString {
        let newRequest = NSMutableAttributedString(string: "New Request  ", attributes: [NSAttributedString.Key.font: _theme.muliFont(size: 14, style: .muli), NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.baselineOffset: NSNumber(value: 3)])
        let iconAttributed = NSMutableAttributedString(string: "a", attributes: [NSAttributedString.Key.font: _theme.smfFont(size: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let attributed = NSMutableAttributedString()
        attributed.append(newRequest)
        attributed.append(iconAttributed)
        return NSAttributedString(attributedString: attributed)
    }
    
    func setUpButtonView(_ button: UIButton, backgroundColor: UIColor, size: Int, setBackgroundColor: Bool) {
        
        if setBackgroundColor {
            button.backgroundColor = backgroundColor
        } else {
            button.backgroundColor = .clear
        }
        
        button.layer.masksToBounds = false
        button.layer.cornerRadius = CGFloat(size / 2)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = setBackgroundColor ? UIColor.gray.withAlphaComponent(0.3).cgColor : backgroundColor.cgColor
        
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
        
        self.circularProgressView.trackClr = ColorConstant.greyColor8
        self.circularProgressView.progressClr = UIColor().colorFromHex("#FF9100")
    }
    
    func setData(bidInfo: BidStatusInfo) {
        self.bidInfo = bidInfo
        lblEventName.text = bidInfo.eventName
        lblEventID.text = "\(bidInfo.eventServiceDescriptionId)"
        lblEventType.text =  "\(bidInfo.branchName) - \(bidInfo.serviceName)"
        lblEventDate.text = bidInfo.eventDate.toSMFFullFormatDate()
        lblServiceDate.text = bidInfo.serviceDate.toSMFFullFormatDate()
        
        if bidInfo.costingType == .bidding {
            lblQuotePrice.text = bidInfo.latestBidValue == nil ? "" : "\(bidInfo.currencyType?.currency ?? "$")\(bidInfo.latestBidValue!)"            
        } else {
            lblQuotePrice.text = bidInfo.cost == "" ? "" : "\(bidInfo.currencyType?.currency ?? "$")\(bidInfo.cost)"
        }
        
        
        lblRemainingDate.text = bidInfo.biddingCutOffDate.formatDateStringTo(format: "dd")
        lblCutOffDate.text = bidInfo.biddingCutOffDate.formatDateStringTo(format: "MMM")
        self.circularProgressView.setProgressWithAnimation(duration: 1.0, value: Float(bidInfo.timeLeft) / 100)
        
        self.btnServiceWorkFlow.setTitleColor(.white, for: .normal)
        self.btnServiceWorkFlow.backgroundColor = _theme.accentColor
        self.btnServiceWorkFlow.layer.cornerRadius = 6
        
        switch self.status {
        case .bidRequested:
            self.btnServiceWorkFlow.isHidden = true
            break
        case .pendingForQuote:
            self.btnServiceWorkFlow.isHidden = true
            break
        case .bidSubmitted:
            self.btnChangeMind.isHidden = false
            self.btnServiceWorkFlow.isHidden = true
            break
        case .wonBid:
            self.btnChangeMind.isHidden = true
            self.btnServiceWorkFlow.isHidden = false
            self.btnServiceWorkFlow.setTitle("Start Service", for: .normal)
            
            break
        case .serviceInProgress:
            self.btnChangeMind.isHidden = true
            self.btnServiceWorkFlow.isHidden = false
            self.btnServiceWorkFlow.setTitle("Initiate Closer", for: .normal)
            break
        case .pendingReview:
            self.btnServiceWorkFlow.isHidden = true
            break
        case .serviceClosed:
            self.btnChangeMind.isHidden = true
            self.btnServiceWorkFlow.isHidden = true
            break
        case .bidRejected:
            self.btnChangeMind.isHidden = false
            self.btnServiceWorkFlow.isHidden = true
            break
        case .bidTimedOut:
            self.btnChangeMind.isHidden = true
            self.btnServiceWorkFlow.isHidden = true
            break
        case .lostBid:
            self.btnChangeMind.isHidden = true
            self.btnServiceWorkFlow.isHidden = true
            break
        default:
            self.btnChangeMind.isHidden = true
            self.btnServiceWorkFlow.isHidden = true
            break
        }
        
        
        switch self.status {
        case .bidRequested, .pendingForQuote:
            self.lblNextStatus.text = "Order Details"
            break
        case .bidSubmitted:
            self.lblNextStatus.text = "Bidding in Progress"
            break
        case .wonBid:
            self.lblNextStatus.text = "Won bid"
            break
        case .serviceInProgress:
            self.lblNextStatus.text = "Service in Progress"
            break
            
            /// Status items
        case .serviceClosed:
            self.lblNextStatus.text = "Service completed"
            break
        case  .bidRejected, .bidTimedOut, .lostBid:
        
            self.lblNextStatus.text = "Order Details"
            break
        default:
            self.lblNextStatus.text = ""
        }
    }
    
    
    @IBAction func btnDislikeAction(_ sender: UIButton) {
        delegate?.rejectBidAction(requestId: self.bidInfo.bidRequestId)
    }
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
        if self.bidInfo.costingType == .bidding {
            delegate?.showQuoteDetailsPopUp(bidInfo: self.bidInfo)
        } else {
            delegate?.acceptBidAction(bidInfo: self.bidInfo)
        }
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        delegate?.eventDetailsView(bidInfo: self.bidInfo, status: self.status)
    }
    
    @IBAction func btnServiceWorkFlowTapped(_ sender: UIButton) {
        self.delegate?.serviceWorkFlow(bidInfo: self.bidInfo, status: self.status)
    }
    
    @IBAction func btnChangeInMindAction(_ sender: UIButton) {
        delegate?.changeInMind(requestId: self.bidInfo.bidRequestId)
    }
}
