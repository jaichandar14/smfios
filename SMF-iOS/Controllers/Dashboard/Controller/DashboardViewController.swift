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
    
    @IBOutlet weak var cornerRadiusView: UIView!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblEventOverview: UILabel!
    @IBOutlet weak var lblCalendar: UILabel!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnAllServices: UIButton!
    @IBOutlet weak var btnBranch: UIButton!
    @IBOutlet weak var serviceContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var arrowDown1: UILabel!
    @IBOutlet weak var arrowDown2: UILabel!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    
    var bottomSemiCirleLayer: CAShapeLayer = CAShapeLayer()
    var rightSemiCirleLayer: CAShapeLayer = CAShapeLayer()
    
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
        self.navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()
                
        setDataToUI()
        styleUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clearNavigationBar()
        self.addMenuButton();
        
        actionStatusController?.setDataToUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.cornerRadiusView.roundCorners([.topLeft, .topRight], radius: 25)
        self.btnAllServices.setBorderedButton(textColor: _theme.textColor, borderSide: .bottom)
        self.btnBranch.setBorderedButton(textColor: _theme.textColor, borderSide: .bottom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let width = self.serviceContainerView.bounds.size.width
//        let height = self.serviceContainerView.bounds.size.height
//        let radius: CGFloat = width + 20
//        let rightRadius: CGFloat = 260
//        self.addSemiCircle(rect: CGRect(x: width - (rightRadius / 2), y: -(height / 2), width: rightRadius, height: rightRadius), view: self.serviceContainerView, shape: self.rightSemiCirleLayer, name: "RightSemiCircle", radius: 130)
//        self.addSemiCircle(rect: CGRect(x: -40, y: height / 2, width: radius, height: radius), view: self.serviceContainerView, shape: self.bottomSemiCirleLayer, name: "BottomSemiCircle", radius: radius)
    }
    
    func addMenuButton() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "dashboard_menu"), for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.tintColor = UIColor.white
        button.backgroundColor = .clear
        let barButton = UIBarButtonItem.init(customView: button)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: -4, width: 150, height: 40))
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Welcome \(AmplifyLoginUtility.user?.firstName ?? "")"
        titleLabel.font = _theme.muliFont(size: 18, style: .muliSemiBold)
        let barButtonTitle = UIBarButtonItem.init(customView: titleLabel)
        
        barButton.target = revealViewController()
        
        self.navigationItem.leftBarButtonItems = [barButton, barButtonTitle]
    }
    
    @objc func buttonTapped(sender: UIButton) {
        revealViewController()?.revealSideMenu()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func addSemiCircle(rect: CGRect, view: UIView, shape: CAShapeLayer, name: String, radius: CGFloat) {
        let circlePath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        
        shape.path = circlePath.cgPath
        shape.fillColor = ColorConstant.dashboardCircleColor.cgColor
        
        shape.name = name
        
        if !(view.layer.sublayers?.contains(where: {$0.name == name}) ?? false) {
            view.layer.addSublayer(shape)
        }
        
        self.serviceContainerView.bringSubviewToFront(self.servicesCollectionView)
        self.serviceContainerView.bringSubviewToFront(self.lblCalendar)
        self.serviceContainerView.bringSubviewToFront(self.btnCalendar)
        self.serviceContainerView.bringSubviewToFront(self.btnRight)
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
        
        self.lblCalendar.text = viewModel.calendarTitle
        self.lblEventOverview.text = viewModel.eventsOverviewTitle
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
        self.title = ""
        
        self.actionsListController?.delegate = self
        self.statusListController?.delegate = self
        
        self.lblEventOverview.textColor = UIColor.white
        self.lblCalendar.textColor = UIColor.white
        self.btnCalendar.backgroundColor = _theme.accentColor
        
        self.lblEventOverview.font = _theme.muliFont(size: 16, style: .muliBold)
        self.lblCalendar.font = _theme.muliFont(size: 14, style: .muli)
        self.btnAllServices.titleLabel?.font = _theme.muliFont(size: 16, style: .muli)
        self.btnBranch.titleLabel?.font = _theme.muliFont(size: 16, style: .muli)
        
        self.serviceContainerView.backgroundColor = _theme.primaryColor
        
        self.servicesCollectionView.backgroundColor = _theme.primaryColor
        self.servicesCollectionView.dataSource = self
        self.servicesCollectionView.delegate = self
        
        self.btnAllServices.backgroundColor = .clear
        self.btnBranch.backgroundColor = .clear
        self.btnCalendar.setTitle("c", for: .normal)
        self.btnCalendar.setTitleColor(UIColor.white, for: .normal)
        self.btnCalendar.titleLabel?.font = _theme.smfFont(size: 23)
        
        self.arrowDown1.textColor = ColorConstant.arrowDownBtnColor
        self.arrowDown2.textColor = ColorConstant.arrowDownBtnColor
        
        self.btnLeft.backgroundColor = .clear
        self.btnRight.backgroundColor = .clear
        
        self.servicesCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
        self.servicesCollectionView.backgroundColor = .clear
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                print("Swiped down")
                self.viewModel?.fetchServiceCount()
                self.viewModel?.fetchServices()
                setContainer(with: getActionStatusController())
                showLoadingSpinnerOnSwipe()
                
            case .left:
                print("Swiped left")
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }

    func showLoadingSpinnerOnSwipe() {
        
        let backDrop = UIView(frame: UIScreen.main.bounds)
        backDrop.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backDrop.backgroundColor = .black
        backDrop.alpha = 0.5
        
        let spinnerView = UIActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 40, y: 100, width: 80, height: 80))
        if #available(iOS 13.0, *) {
            spinnerView.style = .large
        }
        spinnerView.color = UIColor.white
        spinnerView.startAnimating()
        
        self.view.addSubview(backDrop)
        self.view.addSubview(spinnerView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            backDrop.removeFromSuperview()
            spinnerView.removeFromSuperview()
        }
        
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
    
    @IBAction func btnCalendarLeftAction(_ sender: UIButton) {
        if let indexPath = self.servicesCollectionView.indexPathsForVisibleItems.first {
            if indexPath.row > 0 {
                let indexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                self.servicesCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            } else {
                let indexPath = IndexPath(row: 0, section: indexPath.section)
                self.servicesCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }
        }
    }
    
    @IBAction func btnCalendarRightAction(_ sender: UIButton) {
        if let indexPath = self.servicesCollectionView.indexPathsForVisibleItems.last {
            let serviceCount = viewModel?.serviceCountList.value.count ?? 0
            if indexPath.row < serviceCount - 1 {
                let indexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                self.servicesCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            } else {
                let indexPath = IndexPath(row: serviceCount - 1, section: indexPath.section)
                self.servicesCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            }
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
        
        cell.backgroundColor = UIColor.clear
        cell.lblCounter.font = _theme.muliFont(size: 30, style: .muliBold)
        cell.lblCounter.textColor = ColorConstant.eventCountLabelColor
        cell.lblCounter.textAlignment = .center
        cell.lblTitle.textAlignment = .center
        cell.lblTitle.textColor = UIColor.white
        cell.cellBackgroundView.backgroundColor = _theme.primaryDarkColor
        cell.arrowContainer.isHidden = true
        
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
