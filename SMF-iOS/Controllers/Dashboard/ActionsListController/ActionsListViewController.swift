//
//  ActionsListViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

protocol ActionListDelegate {
    func btnCloseAction()
    func interestedInEvent(id: String)
    func eventDetailsView()
}

class ActionsListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var status: String = ""
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
        
        self.tableView.register(UINib.init(nibName: String.init(describing: ActionsCardTableViewCell.self), bundle: nil), forCellReuseIdentifier: "statusCell")
        
        styleUI()
        setDataToUI()
        self.tableView.reloadData()
    }
    
    func styleUI() {
        // add Stubs
    }
    
    func setDataToUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }

        viewModel.bidStatusInfoList.bindAndFire { [weak self] infoList in
            self?.updateList()
        }
        
        viewModel.bidStatusInfoLoading.bindAndFire { isLoading in
            print("\(isLoading ? "Show" : "Hide") loading")
        }
                
        updateData()
    }
    
    func updateData() {
//        viewModel?.fetchActionList(categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId, vendorOnboardingId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId, status: status)
    }
    
    func updateList() {
        DispatchQueue.main.async {
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
        return 1// viewModel?.bidStatusInfoList.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell") as? ActionsCardTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.circularProgressView.trackClr = ColorConstant.greyColor8
        cell.circularProgressView.progressClr = _theme.primaryColor
        cell.circularProgressView.setProgressWithAnimation(duration: 1.0, value: 0.70)
        
//        let bidInfo = viewModel!.getBidInfoItem(for: indexPath.row)
//        cell.setData(bidInfo: bidInfo)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}

extension ActionsListViewController: ActionCardProtocol {
    func notInterestedInEvent() {
        
    }
    
    func interestedInEvent() {
        delegate?.interestedInEvent(id: "0")
    }
    
    func lookForwardForEvent() {
        delegate?.eventDetailsView()
    }
}
