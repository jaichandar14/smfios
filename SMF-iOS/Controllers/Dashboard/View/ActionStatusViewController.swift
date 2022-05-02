//
//  ActionStatusViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/2/22.
//

import UIKit

class ActionStatusViewController: UIViewController {

    @IBOutlet weak var lblAction: UILabel!
    @IBOutlet weak var lblPendingActions: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPendingStatus: UILabel!
    @IBOutlet weak var actionsCollectionView: UICollectionView!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    
    private var _theme = ThemeManager.currentTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView() {
        self.lblAction.textColor = _theme.textColor
        self.lblPendingActions.textColor = _theme.textGreyColor
        self.lblStatus.textColor = _theme.textColor
        self.lblPendingStatus.textColor = _theme.textGreyColor
                
        self.actionsCollectionView.backgroundColor = UIColor.white
        self.actionsCollectionView.dataSource = self
        self.actionsCollectionView.delegate = self
        
        self.statusCollectionView.backgroundColor = UIColor.white
        self.statusCollectionView.dataSource = self
        self.statusCollectionView.delegate = self
                        
        self.actionsCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
        self.statusCollectionView.register(UINib.init(nibName: String.init(describing: DashboardCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "serviceCell")
    }

}

extension ActionStatusViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as? DashboardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.lblCounter.text = "\(indexPath.row)"
        cell.lblTitle.text = "New Request"
        cell.backgroundColor = UIColor.white
        
        cell.setCornerRadius()
        cell.setShadow()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}

