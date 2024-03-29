//
//  EventDetailsViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import UIKit

class BidInfoDetailsViewController: BaseViewController {
    @IBOutlet weak var eventDetailsContainerView: UIView!
    
    @IBOutlet weak var bidTableView: UITableView!
    @IBOutlet weak var eventDetailsTableView: UITableView!
    
    @IBOutlet weak var eventDetailsView: UIView!
    @IBOutlet weak var bidTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventDetailsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblBranchName: UILabel!
    @IBOutlet weak var lblEventDetails: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblEventId: UILabel!
    @IBOutlet weak var lblCosting: UILabel!
    @IBOutlet weak var btnViewQuote: UIButton!
    @IBOutlet weak var lblBidStatus: UILabel!
    
    @IBOutlet weak var bidContainer: UIView!
    @IBOutlet weak var btnExpandCollapse: UIButton!
    
    @IBOutlet weak var btnDisLike: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    var bidStatus: BiddingStatus?
    var bidInfo: BidStatusInfo?
    var isBidVisible = true
    @IBOutlet weak var eventDetailsTopConstraint: NSLayoutConstraint!
    
    var eventDetails: [(eventKey: String, eventValue: String)] = []
    
    var viewModel: BidInfoDetailViewModel? {
        didSet {
            setDataToUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleUI()
        setDataToUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBar(hidden: false)
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func styleUI() {
        if let bidInfo = self.bidInfo {
            self.title = "\(bidInfo.serviceName) - \(bidInfo.branchName)"
            self.lblBidStatus.text = self.getStatusTitle(status: self.bidStatus)
            
            self.lblEventTitle.text = bidInfo.eventName
            self.lblEventId.text = "\(bidInfo.eventServiceDescriptionId )"
            
            self.lblServiceName.text = bidInfo.serviceName
            self.lblBranchName.text = bidInfo.branchName
            
            if bidInfo.costingType == .bidding {
                self.lblCosting.text = bidInfo.latestBidValue == nil ? "" : "\(bidInfo.currencyType?.currency ?? "$")\(bidInfo.latestBidValue!)"
            } else {
                self.lblCosting.text = bidInfo.cost == "" ? "" : "\(bidInfo.currencyType?.currency ?? "$")\(bidInfo.cost)"
            }
        }
        self.setNavigationBarColor(_theme.primaryColor, color: .white)
        self.customizeBackButton()
        
        setUpViewShadow(self.eventDetailsContainerView, backgroundColor: UIColor.white, radius: 11, shadowRadius: 10, isHavingBorder: false)
        
        self.lblEventId.textColor = _theme.eventIDTextColor
        
        
        self.lblBidStatus.textColor = _theme.accentColor
        self.lblBidStatus.font = _theme.muliFont(size: 14, style: .muli)
        
        self.btnLike.roundCorners([.allCorners], radius: 32 / 2)
        self.btnDisLike.roundCorners([.allCorners], radius: 32 / 2)
        self.btnViewQuote.setTitleColor(.systemBlue, for: .normal)
        self.btnViewQuote.backgroundColor = .clear
        self.btnExpandCollapse.backgroundColor = .clear
        
        self.lblEventDetails.text = "EVENT DETAILS"
        self.lblEventDetails.textColor = _theme.primaryDarkColor
        self.lblEventDetails.font = _theme.muliFont(size: 16, style: .muliBold)
        
        self.lblServiceName.textColor = _theme.textGreyColor
        self.lblServiceName.font = _theme.muliFont(size: 16, style: .muliSemiBold)
        self.lblBranchName.textColor = _theme.textColor
        self.lblBranchName.font = _theme.muliFont(size: 16, style: .muliSemiBold)
        
        self.bidTableView.delegate = self
        self.bidTableView.dataSource = self
        
        self.bidContainer.backgroundColor = ColorConstant.lightBlueColor
        self.bidTableView.backgroundColor = .clear
        
        self.bidTableView.register(UINib.init(nibName: String.init(describing: BidDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "bidDetail")
        
        self.eventDetailsTableView.delegate = self
        self.eventDetailsTableView.dataSource = self
        self.eventDetailsTableView.rowHeight = UITableView.automaticDimension
        self.eventDetailsTableView.estimatedRowHeight = 50
        self.eventDetailsTableView.register(UINib.init(nibName: String.init(describing: EventDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "eventDetail")
    }
    
    func getStatusTitle(status: BiddingStatus?) -> String {
        switch status {
        case .bidSubmitted:
            return "Bidding in progress"
        case .wonBid:
            return "Won Bid"
        case .serviceInProgress:
            return "Service in progress"
        case .serviceClosed:
            return "Service completed"
        default:
            return ""
        }
    }
    
    func setDataToUI() {
        
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }

        viewModel.bidStatusList.bindAndFire { [weak self] infoList in
            self?.updateBidList()
        }
        
        viewModel.bidStatusInfoLoading.bindAndFire { isLoading in
            print("\(isLoading ? "Show" : "Hide") loading")
        }
        
        viewModel.eventInfoList.bindAndFire { [weak self] infoList in
            self?.updateEventList()
        }
        
        if let bidInfo = self.bidInfo {
            viewModel.prepareEventInfo(info: bidInfo)
        }
        if let status = self.bidStatus {
            viewModel.prepareStatus(with: status)
        }
                
        updateData()
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func updateData() {
        viewModel?.fetchBidDetailsList(bidRequestId: self.bidInfo!.bidRequestId)
    }
    
    func updateBidList() {
        self.bidTableViewHeightConstraint.constant = CGFloat(viewModel!.bidStatusList.value.count * 50)
        self.bidTableView.reloadData()
    }
    
    func updateEventList() {
        DispatchQueue.main.async {
            self.eventDetailsTableView.reloadData()
            self.eventDetailsHeightConstraint.constant = CGFloat(self.viewModel!.eventInfoList.value.count * 45 + 50)
        }
    }
    
    func toggleBidDetailsVisibility(isHidden: Bool) {
//        UIView.animate(withDuration: 0.2) {
//            if isHidden {
//                self.lblArrowImage.transform = CGAffineTransform(rotationAngle: Double.pi);
//                self.eventDetailsTopConstraint.priority = UILayoutPriority(850)
//                self.view.layoutIfNeeded()
//            } else {
//                self.lblArrowImage.transform = CGAffineTransform(rotationAngle: 0);
//                self.eventDetailsTopConstraint.priority = UILayoutPriority(650)
//                self.view.layoutIfNeeded()
//            }
//        }
    }
    
    @IBAction func btnBidExpandCollapse(_ sender: UIButton) {
        self.isBidVisible = !self.isBidVisible
        self.toggleBidDetailsVisibility(isHidden: !self.isBidVisible)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnViewQuoteAction(_ sender: UIButton) {
        let controller = ViewQuoteViewController()
        controller.viewModel = self.viewModel
        controller.bidInfo = self.bidInfo
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnDisLikeAction(_ sender: UIButton) {
    }
    
    @IBAction func btnLikeAction(_ sender: UIButton) {
    }
}

extension BidInfoDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.bidTableView {
            return viewModel?.bidStatusList.value.count ?? 0
        } else {
            return viewModel?.eventInfoList.value.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.bidTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "bidDetail") as? BidDetailsTableViewCell else {
                return UITableViewCell()
            }
            
            if indexPath.row == 0 {
                cell.setData(bidStatus: viewModel!.getBidInfoItem(for: indexPath.row), isFirst: true, isLast: false)
            } else {
                cell.setData(bidStatus: viewModel!.getBidInfoItem(for: indexPath.row), isFirst: false, isLast: false)
            }
            
            if indexPath.row == viewModel!.bidStatusList.value.count - 1 {
                cell.setData(bidStatus: viewModel!.getBidInfoItem(for: indexPath.row), isFirst: false, isLast: true)
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventDetail") as? EventDetailsTableViewCell else {
                return UITableViewCell()
            }
            
            cell.backgroundColor = .clear
            cell.setData(eventDetail: viewModel!.getEventInfoItem(for: indexPath.row))
            
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.bidTableView {
            return 50
        } else {
            return UITableView.automaticDimension
        }
    }
}
