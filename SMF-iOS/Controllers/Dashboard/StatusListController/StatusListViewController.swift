//
//  StatusListViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

protocol StatusListDelegate {
    func btnCloseAction()
}

class StatusListViewController: BaseViewController {

    var status: BiddingStatus = .none
    var delegate: StatusListDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    var dashboardViewModel: DashboardViewModel?
    var viewModel: ActionListViewModel? {
        didSet {
            setDataToUI()
        }
    }
    
    static func create(dashboardViewModel: DashboardViewModel?) -> StatusListViewController {
        let view = StatusListViewController()
        view.dashboardViewModel = dashboardViewModel
        view.viewModel = ActionListViewModelContainer(model: ActionListModel())
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib.init(nibName: String.init(describing: StatusTableViewCell.self), bundle: nil), forCellReuseIdentifier: "statusCell")
        
        styleUI()
        setDataToUI()
        self.tableView.reloadData()
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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
        viewModel?.fetchActionList(categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId, vendorOnboardingId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId, status: status)
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
        print("NetworkChange")
    }
}

extension StatusListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1// viewModel?.bidStatusInfoList.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell") as? StatusTableViewCell else {
            return UITableViewCell()
        }
        
        cell.lblTitle.text = "Cell \(indexPath.row)"
        
        return cell
    }
}
