//
//  ActionStatusViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

protocol ActionStatusDelegate {
    func actionPerformedOnCount(label: BiddingStatus)
    func statusPerformedOnCount(label: BiddingStatus)
}

class ActionStatusViewController: BaseViewController {
    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblPendingActions: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPendingStatus: UILabel!
    @IBOutlet weak var lblUpcomingEvents: UILabel!
    @IBOutlet weak var actionsCollectionView: UICollectionView!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    @IBOutlet weak var upcomingEventsCollectionView: UICollectionView!
    
    @IBOutlet weak var gradientView: UIView!
    
    var imageObjects: [UpdateEventImageObject] = []
    
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setCornerRadius()
        }
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("NetworkChange")
    }
    
    func styleUI() {
        self.lblAction.text = "ACTIVE REQUESTS"
        self.lblAction.textColor = _theme.textColor
        self.lblPendingActions.textColor = _theme.textGreyColor
        self.lblStatus.text = "INACTIVE REQUESTS"
        self.lblStatus.textColor = _theme.textColor
        self.lblPendingStatus.textColor = _theme.textGreyColor
        
        self.lblAction.font = _theme.muliFont(size: 16, style: .muliBold)
        self.lblStatus.font = _theme.muliFont(size: 16, style: .muliBold)
        
        self.lblPendingActions.font = _theme.muliFont(size: 14, style: .muli)
        self.lblPendingStatus.font = _theme.muliFont(size: 14, style: .muli)
        
        self.lblUpcomingEvents.text = "Upcoming events"
        self.lblUpcomingEvents.textColor = ColorConstant.textBlueColor
        self.lblUpcomingEvents.font = _theme.muliFont(size: 16, style: .muliBold)
        
        self.actionsCollectionView.backgroundColor = UIColor.white
        self.actionsCollectionView.allowsMultipleSelection = false
        
        self.actionsCollectionView.dataSource = self
        self.actionsCollectionView.delegate = self
        
        self.statusCollectionView.backgroundColor = UIColor.white
        self.statusCollectionView.dataSource = self
        self.statusCollectionView.delegate = self
        
        self.upcomingEventsCollectionView.dataSource = self
        self.upcomingEventsCollectionView.delegate = self
        
        self.actionsCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
        self.statusCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
        self.upcomingEventsCollectionView.register(UINib.init(nibName: String.init(describing: UpcomingEventCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "upcomingCell")
        self.upcomingEventsCollectionView.backgroundColor = UIColor.white
    }
    
    func setCornerRadius() {
        self.gradientView.layer.cornerRadius = 25
        self.gradientView.setShadowAndRoundedCorner(borderWidth: 0, borderColor: UIColor.gray.cgColor, shadowColor: UIColor.gray.cgColor, offset: CGSize(width: 0.0, height: 3.0), opacity: 0.4, radius: 3)
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
                self.lblPendingActions.text = "\(count) Active Services"
            }
        }
        
        viewModel.pendingStatus.bindAndFire { count in
            DispatchQueue.main.async {
                self.lblPendingStatus.text = "\(count) Inactive Services"
            }
        }
        
        viewModel.actionBidCountList.bindAndFire { [weak self] bidCounts in
            self?.updateActionBidListCount()
        }
        
        viewModel.statusBidCountList.bindAndFire { [weak self] bidCounts in
            self?.updateStatusBidListCount()
        }
        
        viewModel.isBidCountLoading.bindAndFire { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.view.showBlurLoader()
                } else {
                    self?.view.removeBlurLoader()
                }
            }
        }
        
        viewModel.bidCountFetchError.bind { [weak self] error in
            print("Error:: \(error)")
        }
        
        updateData()
        
        if imageObjects.isEmpty {
            for index in 1...100 {
                let itemIndex:Int = 100 + index
                if let url = URL(string: "https://picsum.photos/id/\(itemIndex)/300/300"), let placeholderImage = UIImage(named: "placeholder") {
                    self.imageObjects.append(UpdateEventImageObject(image: placeholderImage, url: url))
                }
            }
            self.upcomingEventsCollectionView.reloadData()
        }
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
        viewModel?.fetchBidCount(categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId, vendorOnboardingId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId)
    }
}

extension ActionStatusViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.upcomingEventsCollectionView {
            return imageObjects.count
        } else if collectionView == self.actionsCollectionView {
            return viewModel!.actionBidCountList.value.count
        } else {
            return viewModel!.statusBidCountList.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.upcomingEventsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as? UpcomingEventCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            imageObjects[indexPath.row].indexPath = indexPath
            
            if let nsURL = imageObjects[indexPath.row].url as NSURL?, !imageObjects[indexPath.row].isLoaded {
                ImageCache.publicCache.load(url: nsURL, item: imageObjects[indexPath.row]) { [weak self] (fetchedItem, image) in
                    if let img = image, img != fetchedItem.image {
                        fetchedItem.isLoaded = true
                        fetchedItem.image = img
                        self?.upcomingEventsCollectionView.reloadItems(at: [fetchedItem.indexPath])
                    }
                }
            }
            
            cell.eventImageView.image = imageObjects[indexPath.row].image
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as? DashboardCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            var item: BidCount!
            if collectionView == actionsCollectionView {
                item = viewModel!.getActionCountItem(for: indexPath.row)
                self.setCellView(cell: cell, isActive: true)
            } else {
                item = viewModel!.getStatusCountItem(for: indexPath.row)
                self.setCellView(cell: cell, isActive: false)
            }
            
            cell.lblCounter.text = "\(item.count)"
            cell.lblTitle.text = item.title
            
            cell.setCornerRadius()
            cell.setShadow()
                        
            return cell
        }
    }
    
    func setCellView(cell: DashboardCollectionViewCell, isActive: Bool) {
        cell.lblTitle.textColor = ColorConstant.textPrimary
        cell.lblCounter.textColor = ColorConstant.textPrimary
        
        cell.lblTitle.font = _theme.muliFont(size: 14, style: .muli)
        cell.lblCounter.font = _theme.muliFont(size: 22, style: .muliBold)
        
        cell.backgroundColor = UIColor.white
        cell.cellBackgroundView.backgroundColor = isActive ? ColorConstant.actionCardBackgroundColor : UIColor.white
        cell.contentView.isUserInteractionEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view did select")
        if collectionView == self.actionsCollectionView {
            if viewModel!.actionBidCountList.value[indexPath.row].apiLabel != .none {
                self.delegate?.actionPerformedOnCount(label: viewModel!.actionBidCountList.value[indexPath.row].apiLabel)
            }
        } else {
            //            self.delegate?.statusPerformedOnCount(label: "")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.upcomingEventsCollectionView {
            return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: collectionView.frame.size.height + 15, height: collectionView.frame.size.height)
        }
    }
}

