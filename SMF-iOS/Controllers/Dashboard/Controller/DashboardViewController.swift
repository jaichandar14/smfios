//
//  DashboardViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/1/22.
//

import UIKit
import DropDown
import Amplify

class DashboardViewController: BaseViewController {
    
    var actionStatusController: ActionStatusViewController?
    var statusListController: StatusListViewController?
    var actionsListController: ActionsListViewController?
    
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnAllServices: UIButton!
    @IBOutlet weak var btnBranch: UIButton!
    @IBOutlet weak var serviceContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    
    var viewModel: DashboardViewModel? {
        didSet {
            setDataToUI()
        }
    }
    
    static func create() -> DashboardViewController {
        let controller = DashboardViewController()
        
        let viewModel = DashboardViewModelContainer(model: DashboardModel())
        controller.viewModel = viewModel
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataToUI()
        styleUI()
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("NetworkChange")
    }
    
    func setDataToUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        setContainer(with: actionStatusController ?? getActionStatusController())
        
        self.lblServices.text = viewModel.servicesTitle
        viewModel.serviceCountList.bindAndFire { [weak self] serviceCounts in
            self?.updateServiceListCount()
        }
        
        viewModel.isServiceCountLoading.bindAndFire { isLoading in
            print("\(isLoading ? "Show" : "Hide") loading")
        }
        
        viewModel.selectedService.bindAndFire { service in
            self.btnAllServices.setTitle((service?.serviceName ?? "All Services") + "   ", for: .normal)
        }
        
        viewModel.selectedBranch.bindAndFire { branch in
            self.btnBranch.setTitle((branch?.branchName ?? "All Branches") + "   ", for: .normal)
        }
        
        viewModel.fetchServiceCount()
        viewModel.fetchServices()
    }
    
    func getActionStatusController() -> ActionStatusViewController {
        actionStatusController = ActionStatusViewController.create(dashboardViewModel: viewModel)
        actionStatusController?.delegate = self
        return actionStatusController!
    }
    
    func getActionListController() -> ActionsListViewController {
        actionsListController = ActionsListViewController.create(dashboardViewModel: viewModel)
        actionsListController?.delegate = self
        return actionsListController!
    }
    
    func getStatusListController() -> StatusListViewController {
        statusListController = StatusListViewController.create(dashboardViewModel: viewModel)
        statusListController?.delegate = self
        return statusListController!
    }
    
    func styleUI() {
        self.title = "Dashboard"
        
        self.actionsListController?.delegate = self
        self.statusListController?.delegate = self
        
        self.lblServices.textColor = UIColor.white
        self.btnCalendar.backgroundColor = UIColor.white
        
        self.lblServices.font = _theme.muliFont(size: 16, style: .muliBold)
        self.btnAllServices.titleLabel?.font = _theme.muliFont(size: 14, style: .muli)
        self.btnBranch.titleLabel?.font = _theme.muliFont(size: 14, style: .muli)
        
        self.serviceContainerView.backgroundColor = _theme.primaryColor
        
        self.servicesCollectionView.backgroundColor = _theme.primaryColor
        self.servicesCollectionView.dataSource = self
        self.servicesCollectionView.delegate = self
        
        setDashboardButton(self.btnAllServices)
        setDashboardButton(self.btnBranch)
        
        self.servicesCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
    }
    
    func setDashboardButton(_ button: UIButton) {
        button.setTitleColor(_theme.textColor, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.borderColor = UIColor().colorFromHex("#E0E0E0").cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
    }
    
    func setContainer(with controller: UIViewController) {
        containerView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        
        containerView.addSubview(controller.view)
        controller.didMove(toParent: self)
        applyContainerConstraint(to: controller)
    }
    
    func applyContainerConstraint(to controller: UIViewController) {
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
    }
    
    func updateServiceListCount() {
        DispatchQueue.main.async {
            self.servicesCollectionView.reloadData()
        }
    }
    
    @IBAction func btnServicesTapped(_ sender: UIButton) {
        var services = viewModel!.serviceList.value.map { $0.serviceName }
        services.insert("All Services", at: 0)
        showDropDown(on: sender, items: services) { [weak self] (index, item) in
            if index == 0 {
                self?.viewModel?.selectedService.value = nil
            } else {
                self?.viewModel?.selectedService.value = self?.viewModel?.getServiceItem(for: index - 1)
            }
            self?.viewModel?.fetchBranches()
            self?.actionStatusController?.updateData()
        }
    }
    
    @IBAction func btnBranchTapped(_ sender: UIButton) {
        var branches = viewModel!.branches.value.map { $0.branchName }
        branches.insert("All Branches", at: 0)
        showDropDown(on: sender, items: branches) { [weak self] (index, item) in
            if index == 0 {
                self?.viewModel?.selectedBranch.value = nil
            } else {
                self?.viewModel?.selectedBranch.value = self?.viewModel?.getBranchItem(for: index - 1)
            }
            self?.actionStatusController?.updateData()
        }
    }
    
    func showDropDown(on view: UIView, items: [String], selection: SelectionClosure?) {
        let dropDown = DropDown()
        dropDown.anchorView = view
        
        dropDown.dataSource = items
        
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected Item \(item)")
            selection?(index, item)
            dropDown.hide()
        }
        
        dropDown.show()
    }
}

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.serviceCountList.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as? DashboardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let service = self.viewModel!.getServiceCountItem(for: indexPath.row)
        
        cell.lblCounter.text = "\(service.count)"
        cell.lblTitle.text = service.title
        
        cell.backgroundColor = _theme.primaryColor
        
        cell.setCornerRadius()
        //        setShadow()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}

extension DashboardViewController: ActionListDelegate, StatusListDelegate {
    func changeInMind(requestId: Int) {
        <#code#>
    }
    
    func eventDetailsView(requestId: Int) {
        let controller = OrderDetailViewController()
        controller.bidRequestId = requestId
        controller.viewModel = BidInfoDetailViewModelContainer(model: BidInfoDetailsModel())
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func btnCloseAction() {
        actionStatusController?.updateData()
        setContainer(with: actionStatusController ?? getActionStatusController())
    }
    
    func interestedInEvent(id: String) {
        let controller = QuoteDetailsPopUpViewController()
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: false, completion: nil)
    }
}

extension DashboardViewController: ActionStatusDelegate {
    func statusPerformedOnCount(label: String) {
        let controller = statusListController ?? getStatusListController()
        controller.status = label
        controller.updateData()
        setContainer(with: controller)
    }
    
    func actionPerformedOnCount(label: String) {
        let controller = actionsListController ?? getActionListController()
        controller.status = label
        controller.updateData()
        setContainer(with: controller)
    }
}
