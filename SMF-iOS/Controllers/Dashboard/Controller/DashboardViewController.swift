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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        actionStatusController?.setDataToUI()
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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
        
        self.btnAllServices.setBorderedButton(textColor: _theme.textColor)
        self.btnBranch.setBorderedButton(textColor: _theme.textColor)
        self.btnCalendar.setTitle("c", for: .normal)
        self.btnCalendar.setTitleColor(_theme.textColor, for: .normal)
        self.btnCalendar.titleLabel?.font = _theme.smfFont(size: 20)
        
        self.servicesCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
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
    
    @IBAction func btnCalendarAction(_ sender: UIButton) {
        let view = CalendarPickerViewController.create()
        view.dashboardViewModel = self.viewModel
        self.navigationController?.pushViewController(view, animated: true)
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
            if let self = self {
                self.setContainer(with: self.actionStatusController ?? self.getActionStatusController())
            }
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
            if let self = self {
                self.setContainer(with: self.actionStatusController ?? self.getActionStatusController())
            }
        }
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

extension DashboardViewController: ActionListDelegate, StatusListDelegate, ChangeInMindDelegate {
    func eventDetailsView(bidInfo: BidStatusInfo) {
        let controller = OrderDetailViewController()
        controller.eventId = bidInfo.eventId
        controller.eventServiceDescId = bidInfo.eventServiceDescriptionId
        controller.eventName = bidInfo.eventName
        controller.eventDate = bidInfo.eventDate
        controller.viewModel = BidInfoDetailViewModelContainer(model: BidInfoDetailsModel())
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func changeInMind(requestId: Int) {
        let controller = ChangeInMindViewController()
        controller.viewModel = self.viewModel
        controller.rejectBidId = requestId
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: false, completion: nil)
    }
    
    func rejectionCompleted() {
        actionsListController?.updateData()
    }
    
    func btnCloseAction() {
        actionStatusController?.updateData()
        setContainer(with: actionStatusController ?? getActionStatusController())
    }
    
    func rejectBidAction(requestId: Int) {
        viewModel?.rejectBid(requestId: requestId, reason: nil, comment: nil) { [weak self] in
            self?.actionsListController?.updateData()
        }
    }
    
    func acceptBidAction(bidInfo: BidStatusInfo) {
//        { "bidRequestId":2651,"bidStatus":"BID SUBMITTED","branchName":"jai1","comment":"","cost":"540","costingType":"Variable Cost","currencyType":"USD($)","latestBidValue":0}
        let params: [String: Any] = [
            APIConstant.bidRequestId: bidInfo.bidRequestId,
            APIConstant.bidStatus: BiddingStatus.bidSubmitted.rawValue,
            APIConstant.branchName: bidInfo.branchName,
            APIConstant.comment: "",
            APIConstant.cost: bidInfo.cost,
            APIConstant.costingType: CostingType.variable.rawValue,
            APIConstant.currencyType: bidInfo.currencyType ?? "",
            APIConstant.latestBidValue: 0
        ]
        
        viewModel?.acceptBid(
            requestId: bidInfo.bidRequestId,
            params: params,
            completion: {
            let controller = BidInfoDetailsViewController()
            controller.bidRequestId = bidInfo.bidRequestId
            controller.viewModel = BidInfoDetailViewModelContainer(model: BidInfoDetailsModel())
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
    
    func showQuoteDetailsPopUp(bidInfo: BidStatusInfo) {
        let controller = QuoteDetailsPopUpViewController()
        controller.delegate = self
        controller.bidInfo = bidInfo
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: false, completion: nil)
    }
}

extension DashboardViewController: QuoteDetailsPopUpDelegate {
    func cancelTapped() {
        // Nothing to do here
    }
    
    func okTapped(bidInfo: BidStatusInfo, cost: String, comment: String, isQuoteSelected: Bool) {
        // Will provide later
        // {"bidRequestId":2668,"bidStatus":"PENDING FOR QUOTE", "branchName":"jai56","costingType":"Bidding","fileType":"QUOTE_DETAILS","latestBidValue":0}
        // Having Quote
        //{"bidRequestId":2666,"bidStatus":"BID_SUBMITTED", "branchName":"jai3", "comment":"", "costingType": "Bidding", "currencyType":"USD($)", "fileType": "QUOTE_DETAILS", "latestBidValue":25000}

        var params: [String: Any] = [
            APIConstant.bidRequestId: bidInfo.bidRequestId,
            APIConstant.costingType: CostingType.bidding.rawValue,
            APIConstant.latestBidValue: cost,
            APIConstant.fileType: "QUOTE_DETAILS",
            APIConstant.branchName: bidInfo.branchName
        ]
        
        if isQuoteSelected {
            params[APIConstant.bidStatus] = BiddingStatus.bidSubmitted.rawValue
            params[APIConstant.comment] = comment
            params[APIConstant.currencyType] = bidInfo.currencyType ?? ""
        } else {
            params[APIConstant.bidStatus] = BiddingStatus.pendingForQuote.rawValue
        }
        
        viewModel?.acceptBid(requestId: bidInfo.bidRequestId, params: params, completion: {
            DispatchQueue.main.async {
                let controller = BidInfoDetailsViewController()
                controller.bidRequestId = bidInfo.bidRequestId
                controller.viewModel = BidInfoDetailViewModelContainer(model: BidInfoDetailsModel())
                self.navigationController?.pushViewController(controller, animated: true)
            }
        })
    }
    
    func chooseFileTapped() {
        // Later to be implemented
    }
}

extension DashboardViewController: ActionStatusDelegate {
    func actionPerformedOnCount(label: BiddingStatus) {
        let controller = actionsListController ?? getActionListController()
        controller.status = label
        controller.updateData()
        setContainer(with: controller)
    }
    
    func statusPerformedOnCount(label: BiddingStatus) {
        let controller = statusListController ?? getStatusListController()
        controller.status = label
        controller.updateData()
        setContainer(with: controller)
    }
}
