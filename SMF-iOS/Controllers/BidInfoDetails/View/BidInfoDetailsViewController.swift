//
//  EventDetailsViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import UIKit

class BidInfoDetailsViewController: BaseViewController {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var eventDetailsContainerView: UIView!
    
    @IBOutlet weak var bidTableView: UITableView!
    @IBOutlet weak var eventDetailsTableView: UITableView!
    
    @IBOutlet weak var eventDetailsView: UIView!
    @IBOutlet weak var bidTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventDetailsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblEventId: UILabel!
    @IBOutlet weak var lblCosting: UILabel!
    @IBOutlet weak var btnViewQuote: UIButton!
    
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var btnExpandCollapse: UIButton!
    
    @IBOutlet weak var btnDisLike: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    
    var bidRequestId: Int?
    var isBidVisible = true
    @IBOutlet weak var eventDetailsTopConstraint: NSLayoutConstraint!
    
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
        
        setNavBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setNavBar(hidden: false)
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func styleUI() {
        setUpViewShadow(self.eventDetailsContainerView, backgroundColor: UIColor.white, radius: 15, shadowRadius: 10, isHavingBorder: false)
        
        self.btnBack.roundCorners([.allCorners], radius: 45 / 2)
        self.btnLike.roundCorners([.allCorners], radius: 32 / 2)
        self.btnDisLike.roundCorners([.allCorners], radius: 32 / 2)
        self.btnViewQuote.setTitleColor(.systemBlue, for: .normal)
        self.btnViewQuote.backgroundColor = .clear
        self.btnExpandCollapse.backgroundColor = .clear
        
        self.bidTableView.delegate = self
        self.bidTableView.dataSource = self
        
        self.bidTableView.register(UINib.init(nibName: String.init(describing: BidDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "bidDetail")
        
        self.eventDetailsTableView.delegate = self
        self.eventDetailsTableView.dataSource = self
        self.eventDetailsTableView.rowHeight = UITableView.automaticDimension
        self.eventDetailsTableView.estimatedRowHeight = 50
        self.eventDetailsTableView.register(UINib.init(nibName: String.init(describing: EventDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "eventDetail")
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
                
        updateData()
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func updateData() {
        viewModel?.fetchBidDetailsList(bidRequestId: self.bidRequestId!)
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
        
        
        //
    }
    
    func toggleBidDetailsVisibility(isHidden: Bool) {
        UIView.animate(withDuration: 0.2) {
            if isHidden {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: Double.pi);
                self.eventDetailsTopConstraint.priority = UILayoutPriority(850)
                self.view.layoutIfNeeded()
            } else {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: 0);
                self.eventDetailsTopConstraint.priority = UILayoutPriority(650)
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    @IBAction func btnBidExpandCollapse(_ sender: UIButton) {
        self.isBidVisible = !self.isBidVisible
        self.toggleBidDetailsVisibility(isHidden: !self.isBidVisible)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnViewQuoteAction(_ sender: UIButton) {
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
