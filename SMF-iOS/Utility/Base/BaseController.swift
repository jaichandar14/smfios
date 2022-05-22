//
//  BaseUIViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/25/22.
//

import UIKit

class BaseController: UIViewController {
    var _theme: Theme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _theme = ThemeManager.currentTheme()
        
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
    
    func setUpViewShadow(_ view: UIView, backgroundColor: UIColor, radius: CGFloat, shadowRadius: CGFloat, isHavingBorder: Bool) {
                
        view.backgroundColor = backgroundColor
        
        view.layer.masksToBounds = false
        view.layer.cornerRadius = radius
                
        if isHavingBorder {
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        }
        
        view.layer.shadowColor = UIColor.gray.cgColor
        //        self.cellBackgroundView.layer.shadowPath = UIBezierPath(roundedRect: self.cellBackgroundView.bounds, cornerRadius: 10).cgPath
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = shadowRadius
        
    }
}
