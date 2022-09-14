//
//  BaseUIViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/25/22.
//

import UIKit
import DropDown

class BaseController: UIViewController {
    var _theme: Theme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _theme = ThemeManager.currentTheme()
        
        addNetworkListener()
        if let controller = self as? BaseViewController {
            controller.styleUI()
            controller.setDataToUI()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addNetworkListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkChange(notification:)), name: .networkConnection, object: nil)
    }
    
    func customizeBackButton(){
        if let controller = self as? BaseViewController {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            button.setTitle("l", for: .normal)
            button.setTitleColor(_theme.textColor, for: .normal)
            button.titleLabel?.font = _theme.smfFont(size: 18)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(controller.backButtonAction(_:)), for: .touchUpInside)
            
            let backBarButton = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem = backBarButton
        }
    }
    
    func clearNavigationBar() {
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.standardAppearance.backgroundColor = .clear
            navigationController?.navigationBar.standardAppearance.backgroundEffect = nil
            navigationController?.navigationBar.standardAppearance.shadowImage = UIImage()
            navigationController?.navigationBar.standardAppearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance.backgroundImage = UIImage()
            navigationController?.navigationBar.scrollEdgeAppearance = nil
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = UIColor.clear
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setStatusBarColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
            
        }
    }
    
    func setNavigationBarColor(_ backgroundColor: UIColor, color: UIColor) {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = backgroundColor
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgroundColor
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
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
    
    func showDropDown(on view: UIView, items: [String], selection: SelectionClosure?) {
        let dropDown = DropDown()
        dropDown.anchorView = view
        
        dropDown.dataSource = items
        
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected Item \(item)")
            selection?(index, item)
            dropDown.hide()
        }
        
        dropDown.show()
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(_ barButton: UIBarButtonItem) {
        self.view.endEditing(true)
    }
}
