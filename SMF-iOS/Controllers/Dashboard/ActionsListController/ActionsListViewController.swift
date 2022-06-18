//
//  ActionsListViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

protocol ActionListDelegate {
    func btnCloseAction()
    func rejectBidAction(requestId: Int)
    func acceptBidAction(bidInfo: BidStatusInfo)
    func eventDetailsView(bidInfo: BidStatusInfo)
    func changeInMind(requestId: Int)
    func showQuoteDetailsPopUp(bidInfo: BidStatusInfo)
}

class ActionsListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var status: BiddingStatus = .none
    var delegate: ActionListDelegate?
    
    @IBOutlet weak var lblNewRequestCount: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    var dashboardViewModel: DashboardViewModel?
    var viewModel: ActionListViewModel? {
        didSet {
            setDataToUI()
        }
    }
    
    static func create(dashboardViewModel: DashboardViewModel?) -> ActionsListViewController {
        let view = ActionsListViewController()
        view.dashboardViewModel = dashboardViewModel
        view.viewModel = ActionListViewModelContainer(model: ActionListModel())
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib.init(nibName: String.init(describing: ActionsCardTableViewCell.self), bundle: nil), forCellReuseIdentifier: "statusCell")
        
        styleUI()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setDataToUI()
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func styleUI() {
        self.btnClose.backgroundColor = .clear
        self.btnClose.setTitleColor(.black, for: .normal)
    }
    
    func setDataToUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }

        viewModel.bidStatusInfoList.bindAndFire { [weak self] infoList in
            self?.updateList(list: infoList)
        }
        
        viewModel.bidStatusInfoLoading.bindAndFire { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.view.showBlurLoader()
                } else {
                    self.view.removeBlurLoader()
                }
            }
        }
                
        updateData()
    }
    
    func updateData() {
        viewModel?.bidStatusInfoList.value.removeAll()
        viewModel?.fetchActionList(categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId, vendorOnboardingId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId, status: status)
    }
    
    func updateList(list: [BidStatusInfo]) {
        DispatchQueue.main.async {
            self.lblNewRequestCount.text = "\(list.count) \(self.status)"
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.delegate?.btnCloseAction()
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("Network Change")
    }
}


extension ActionsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.bidStatusInfoList.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell") as? ActionsCardTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self.delegate
        cell.status = self.status
        
        
        let bidInfo = viewModel!.getBidInfoItem(for: indexPath.row)
        cell.setData(bidInfo: bidInfo)
        
        if status == .bidRequested {
            cell.btnChangeMind.isHidden = true
            cell.btnLike.isHidden = false
            cell.btnDislike.isHidden = false
        } else {
            cell.btnChangeMind.isHidden = false
            cell.btnLike.isHidden = true
            cell.btnDislike.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}
