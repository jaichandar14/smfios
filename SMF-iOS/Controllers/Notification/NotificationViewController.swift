//
//  NotificationViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 10/11/22.
//

import UIKit

class NotificationViewController: BaseViewController {
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnOld: UIButton!
    
    @IBOutlet weak var lblCrossIcon: UILabel!
    @IBOutlet weak var btnClearAll: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: NotificationsViewModel?
    var tabButtons: [UIButton] = []
    
    var selectedTabIndex = 0
    var borderView: UIView?
    
    static func create(viewModel: NotificationsViewModel) -> NotificationViewController {
        let controller = NotificationViewController()
        controller.viewModel = viewModel
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationBarColor(_theme.primaryColor, color: UIColor.white)
        self.tabButtons = [self.btnActive, self.btnOld]
        for i in 0..<self.tabButtons.count {
            self.tabButtons[i].tag = i
            self.tabButtons[i].setTitleColor(_theme.textGreyColor, for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateButtons()
    }
    
    func updateButtons() {
        self.tabButtons.forEach { button in
            button.isHighlighted = false
            button.setTitleColor(_theme.textGreyColor, for: .normal)
        }
        
        self.borderView?.removeFromSuperview()
        
        self.btnClearAll.isHidden = selectedTabIndex != 0
        self.lblCrossIcon.isHidden = selectedTabIndex != 0
        
        
        let button = self.tabButtons[self.selectedTabIndex]
        button.setTitleColor(_theme.primaryColor, for: .normal)
        self.borderView = UIView(frame: CGRect(x: 0, y: button.bounds.height - 2, width: button.bounds.width, height: 2))
        self.borderView?.backgroundColor = _theme.primaryColor
        self.tabButtons[self.selectedTabIndex].addSubview(self.borderView!)
    }
    
    func styleUI() {
        self.title = "Notifications"
        self.customizeBackButton()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib.init(nibName: String.init(describing: NotificationsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "notificationCell")
    }
    
    func setDataToUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.fetchNotificationsCount()
        
        viewModel.activeNotifications.bind { activeCount in
            if activeCount != nil {
                viewModel.fetchNotifications(type: .active)
                
                let oldCount = viewModel.oldNotifications.value ?? 0
                
                DispatchQueue.main.async {
                    self.btnActive.setTitle("Active (\(activeCount!))", for: .normal)
                    self.btnOld.setTitle("Old (\(oldCount))", for: .normal)
                }
            }
        }
        
        viewModel.notificationsCountFetchError.bind { countFetchError in
            if let error = countFetchError {
                self.hideLoader()
                viewModel.fetchNotifications(type: .active)
                print("Notification Count error: \(error)")
            }
        }
        
        viewModel.notifications.bind { notifications in
            DispatchQueue.main.async {
                self.hideLoader()
                self.tableView.reloadData()
            }
        }
        
        viewModel.notificationDeleteSuccess.bind { isNotificationDeleted in
            if let isDeleted = isNotificationDeleted {
                print("Is Notification deleted:: \(isDeleted)")
                viewModel.fetchNotificationsCount()
            }
        }
        
        viewModel.notificationsLoading.bind { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoader()
                } else {
                    self.hideLoader()
                }
            }
        }
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTabTapped(_ sender: UIButton) {
        self.selectedTabIndex = sender.tag
        self.updateButtons()
        
        self.viewModel?.fetchNotifications(type: sender.tag == 0 ? .active : .old)
    }
    
    @IBAction func btnClearNotification(_ sender: UIButton) {
        if let ids = self.viewModel?.notifications.value.map({ $0.notificationId }) {
            self.viewModel?.updateNotificationStatus(notificationIds: ids)
        }
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.notifications.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as? NotificationsTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.indexPath = indexPath
        cell.setData(notification: self.viewModel!.notifications.value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let notificationCell = cell as? NotificationsTableViewCell {
            notificationCell.containerView.layer.cornerRadius = 8
            notificationCell.containerView.setShadowAndRoundedCorner(borderWidth: 0, borderColor: UIColor.clear.cgColor, shadowColor: UIColor.gray.cgColor, offset: CGSize(width: 0.0, height: 1.5), opacity: 0.4, radius: 5)
        }
    }
}

extension NotificationViewController: NotificationDelegate {
    func deleteNotification(with indexPath: IndexPath) {
        if let id = self.viewModel?.notifications.value[indexPath.row].notificationId {
            self.viewModel?.updateNotificationStatus(notificationIds: [id])
        }
    }
}
