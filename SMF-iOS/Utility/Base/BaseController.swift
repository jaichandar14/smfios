//
//  BaseUIViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/25/22.
//

import UIKit

class BaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNetworkListener()
    }
    
    func addNetworkListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkChange(notification:)), name: .networkConnection, object: nil)
    }
    
    @objc func networkChange(notification: Notification) {
        var connectivity = false
        var connectionType: String?
        if let isConnected = notification.userInfo?["connectivity"] as? Bool {
            connectivity = isConnected
        }
        
        if let type = notification.userInfo?["connectionType"] as? String {
            connectionType = type
        }
        
        if let controller = self as? BaseViewController {
            controller.networkChangeListener(connectivity: connectivity, connectionType: connectionType)
        }
    }
}
