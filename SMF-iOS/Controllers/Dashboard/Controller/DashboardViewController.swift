//
//  DashboardViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/1/22.
//

import UIKit

class DashboardViewController: UIViewController {

    let actionStatusController = ActionStatusViewController()
    let statusListController = StatusListViewController()
    let actionsListController = ActionsListViewController()
    
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var btnAllServices: UIButton!
    @IBOutlet weak var btnBranch: UIButton!
    @IBOutlet weak var serviceContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    
    private var _theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setContainer(with: self.actionStatusController)
    }
    
    func setUpView() {
        self.title = "Dashboard"
        self.lblServices.textColor = UIColor.white
        self.btnCalendar.backgroundColor = UIColor.white
        
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
        button.layer.borderColor = _theme.textGreyColor.cgColor
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
    
    @IBAction func btnServicesTapped(_ sender: UIButton) {
        setContainer(with: actionsListController)
    }
    @IBAction func btnBranchTapped(_ sender: UIButton) {
        setContainer(with: statusListController)
    }
}

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as? DashboardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.lblCounter.text = "\(indexPath.row)"
        cell.lblTitle.text = "\(indexPath.row) Row"
        
        cell.backgroundColor = _theme.primaryColor
        
        cell.setCornerRadius()
//        setShadow()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}
