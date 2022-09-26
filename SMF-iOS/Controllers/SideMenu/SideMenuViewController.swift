//
//  SideMenuViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 8/12/22.
//

import UIKit

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int, key: MenuKey)
}

class SideMenuViewController: BaseViewController {
    
    @IBOutlet var sideMenuTableView: UITableView!

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var closeMenu: (() -> Void)?
    var delegate: SideMenuViewControllerDelegate?
    var defaultHighlightedCell: Int = 0

    var menu: [SideMenuModel] = [
        SideMenuModel(key: .dashboard, icon: UIImage(named: "dashboard"), title: "Dashboard"),
        SideMenuModel(key: .availability, icon: UIImage(named: "Calendar"), title: "Availability"),
        SideMenuModel(key: .divider, icon: nil, title: ""),
        SideMenuModel(key: .logout, icon: UIImage(named: "Logout"), title: "Logout"),
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavBar(hidden: true)
    }

    func styleUI() {
        self.view.backgroundColor = _theme.primaryColor
        self.profileImage.image = UIImage(named: "placeholder_avatar")
        self.lblName.font = _theme.muliFont(size: 17, style: .muliSemiBold)
        self.lblName.textColor = UIColor.white
        
        self.lblEmail.font = _theme.muliFont(size: 14, style: .muli)
        self.lblEmail.textColor = UIColor.white
        
        self.lblName.text = AmplifyLoginUtility.user?.userName
        self.lblEmail.text = AmplifyLoginUtility.user?.email
        
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.separatorStyle = .none

//        // Set Highlighted Cell
//        DispatchQueue.main.async {
//            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
//            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
//        }

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        self.sideMenuTableView.register(DividerTableViewCell.nib, forCellReuseIdentifier: DividerTableViewCell.identifier)

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
    
    func setDataToUI() {
        //
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    @IBAction func btnCrossTapped(_ sender: UIButton) {
        self.closeMenu?()
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        //
    }
}

// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.menu[indexPath.row].key == .divider {
            return UITableView.automaticDimension
        }
        return 44
    }
}

// MARK: - UITableViewDataSource
extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.menu[indexPath.row].key == .divider {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DividerTableViewCell.identifier, for: indexPath) as? DividerTableViewCell else { fatalError("xib doesn't exist") }
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }

        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        
        cell.setSelection(isSelected: defaultHighlightedCell == indexPath.row)

        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.menu[indexPath.row].key == .divider {
            return
        }
        defaultHighlightedCell = 0//indexPath.row
        
        self.delegate?.selectedCell(indexPath.row, key: self.menu[indexPath.row].key)
        tableView.reloadData()
    }
}
