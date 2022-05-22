//
//  ActionStatusViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

protocol ActionStatusDelegate {
    func actionPerformedOnCount(label: String)
    func statusPerformedOnCount(label: String)
}

class ActionStatusViewController: BaseViewController {
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblPendingActions: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPendingStatus: UILabel!
    @IBOutlet weak var actionsCollectionView: UICollectionView!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    
    var viewModel: ActionStatusViewModel? {
        didSet {
            setDataToUI()
        }
    }
    
    var dashboardViewModel: DashboardViewModel?
    var delegate: ActionStatusDelegate?
        
    static func create(dashboardViewModel: DashboardViewModel?) -> ActionStatusViewController {
        let view = ActionStatusViewController()
        view.dashboardViewModel = dashboardViewModel
        view.viewModel = ActionStatusViewModelContainer(model: ActionStatusModel())
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleUI()
        setDataToUI()
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("NetworkChange")
    }
    
    func styleUI() {
        self.lblAction.textColor = _theme.textColor
        self.lblPendingActions.textColor = _theme.textGreyColor
        self.lblStatus.textColor = _theme.textColor
        self.lblPendingStatus.textColor = _theme.textGreyColor
                
        self.lblAction.font = _theme.muliFont(size: 16, style: .muliBold)
        self.lblStatus.font = _theme.muliFont(size: 16, style: .muliBold)
        
        self.lblPendingActions.font = _theme.muliFont(size: 14, style: .muli)
        self.lblPendingStatus.font = _theme.muliFont(size: 14, style: .muli)
        
        self.actionsCollectionView.backgroundColor = UIColor.white
        self.actionsCollectionView.dataSource = self
        self.actionsCollectionView.delegate = self
        
        self.statusCollectionView.backgroundColor = UIColor.white
        self.statusCollectionView.dataSource = self
        self.statusCollectionView.delegate = self
                        
        self.actionsCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
        self.statusCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
    }
    
    func setDataToUI() {
        // Set data here
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
//        self.lblServices.text = viewModel.servicesTitle
        viewModel.pendingActions.bindAndFire { count in
            DispatchQueue.main.async {
                self.lblPendingActions.text = "\(count) pending actions"
            }
        }
        
        viewModel.pendingStatus.bindAndFire { count in
            DispatchQueue.main.async {
                self.lblPendingStatus.text = "\(count) status"
            }
        }
        
        viewModel.actionBidCountList.bindAndFire { [weak self] bidCounts in
            self?.updateActionBidListCount()
        }
        
        viewModel.statusBidCountList.bindAndFire { [weak self] bidCounts in
            self?.updateStatusBidListCount()
        }
        
        viewModel.isBidCountLoading.bindAndFire { [weak self] isLoading in
            print("\(isLoading ? "Show" : "Hide") Loading")
        }
        
        viewModel.bidCountFetchError.bind { [weak self] error in
            print("Error:: \(error)")
        }
        
        updateData()
    }
    
    func updateActionBidListCount() {
        DispatchQueue.main.async {
            self.actionsCollectionView.reloadData()
        }
    }
    
    func updateStatusBidListCount() {
        DispatchQueue.main.async {
            self.statusCollectionView.reloadData()
        }
    }

    func updateData() {
//        viewModel?.fetchBidCount(categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId, vendorOnboardingId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId)
    }
}

extension ActionStatusViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.actionsCollectionView {
            return viewModel!.actionBidCountList.value.count
        } else {
            return viewModel!.statusBidCountList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as? DashboardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        var item: BidCount!
        if collectionView == actionsCollectionView {
            item = viewModel!.getActionCountItem(for: indexPath.row)
        } else {
            item = viewModel!.getStatusCountItem(for: indexPath.row)
        }
        
        cell.lblCounter.text = "\(item.count)"
        cell.lblTitle.text = item.title
        cell.backgroundColor = UIColor.white
        
        cell.setCornerRadius()
        cell.setShadow()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.actionsCollectionView {
            if viewModel!.actionBidCountList.value[indexPath.row].apiLabel != "" {
                self.delegate?.actionPerformedOnCount(label: viewModel!.actionBidCountList.value[indexPath.row].apiLabel)
            }
        } else {
//            self.delegate?.statusPerformedOnCount(label: "")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}

