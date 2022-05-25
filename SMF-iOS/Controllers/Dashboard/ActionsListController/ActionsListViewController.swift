//
//  ActionsListViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

protocol ActionListDelegate {
    func btnCloseAction()
    func notInterestedInEvent(requestId: Int)
    func interestedInEvent(requestId: Int)
    func eventDetailsView(requestId: Int)
    func changeInMind(requestId: Int)
}

class ActionsListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var status: String = ""
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
    
    func styleUI() {
        self.btnClose.backgroundColor = .clear
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
                    self.view.removeBluerLoader()
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
        cell.delegate = self
        cell.circularProgressView.trackClr = ColorConstant.greyColor8
        cell.circularProgressView.progressClr = _theme.primaryColor
        cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.70)
        
        let bidInfo = viewModel!.getBidInfoItem(for: indexPath.row)
        cell.setData(bidInfo: bidInfo)
        
        if status == "BID REQUESTED" {
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

extension ActionsListViewController: ActionCardProtocol {
    func changeInMind(requestId: Int) {
        delegate?.changeInMind(requestId: requestId)
    }
    
    func notInterestedInEvent(requestId: Int) {
        delegate?.notInterestedInEvent(requestId: requestId)
    }
    
    func interestedInEvent(requestId: Int) {
        delegate?.interestedInEvent(requestId: requestId)
    }
    
    func lookForwardForEvent(requestId: Int) {
        delegate?.eventDetailsView(requestId: requestId)
    }
}
