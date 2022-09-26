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
    func eventDetailsView(bidInfo: BidStatusInfo, status: BiddingStatus?)
    func changeInMind(requestId: Int)
    func showQuoteDetailsPopUp(bidInfo: BidStatusInfo)
    func serviceWorkFlow(bidInfo: BidStatusInfo, status: BiddingStatus?)
}

class ActionsListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var bidCount: BidCount?
    var delegate: ActionListDelegate?
    
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
        
        self.tableView.register(UINib.init(nibName: String.init(describing: ListCloseTableViewCell.self), bundle: nil), forCellReuseIdentifier: "listCloseCell")
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
        if let count = self.bidCount {
            viewModel?.fetchActionList(categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId, vendorOnboardingId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId, status: count.apiLabel)
        }
    }
    
    func updateList(list: [BidStatusInfo]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("Network Change")
    }
}

extension ActionsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.bidStatusInfoList.value.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCloseCell") as? ListCloseTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self.delegate
            cell.lblNewRequestCount.text = "\(viewModel?.bidStatusInfoList.value.count ?? 0) \(self.bidCount?.title ?? "")"
            
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell") as? ActionsCardTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self.delegate
            cell.status = self.bidCount?.apiLabel
            
            let bidInfo = viewModel!.getBidInfoItem(for: indexPath.row - 1)
            cell.setData(bidInfo: bidInfo)
            
            if self.bidCount?.apiLabel == .bidRequested {
                cell.btnLike.isHidden = false
                cell.btnDislike.isHidden = false
            } else {
                cell.btnLike.isHidden = true
                cell.btnDislike.isHidden = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else {
            return 270
        }
    }
}
