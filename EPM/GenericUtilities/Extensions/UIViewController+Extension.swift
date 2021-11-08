//
//  UIViewController+Extension.swift
//  EPM
//
//  Created by lavanya on 29/10/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setupNavigationBar(showBack: Bool, title: String) {
        
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 157.0, height: 44.0))
        //customView.backgroundColor = UIColor.yellow
        var marginX = CGFloat(0.0)
        if showBack {
            let button = UIButton.init(type: .custom)
            button.setBackgroundImage(UIImage(named: "hamburger"), for: .normal)
            button.frame = CGRect(x: 0.0, y: 5.0, width: 32.0, height: 32.0)
            button.addTarget(self, action: #selector(goBack(button:)), for: .touchUpInside)
            customView.addSubview(button)
            marginX = CGFloat(button.frame.origin.x + button.frame.size.width + 5)
        }
        
        let label = UILabel(frame: CGRect(x: marginX, y: 0.0, width: 125.0, height: 44.0))
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.backgroundColor = .clear
        customView.addSubview(label)
        
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setupNavigationBarRightItem(title: String) {
        
        let customView = UIView(frame: CGRect(x: self.view.frame.size.width - 105, y: 0.0, width: 95.0, height: 44.0))
        let label = UILabel(frame: CGRect(x: 0, y: 0.0, width: 95.0, height: 36.0))
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        //label.backgroundColor = UIColor.Red.amarnath
        label.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft, .topRight], radius: 4)
        customView.addSubview(label)
        
        let rightButton = UIBarButtonItem(customView: customView)
        self.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    func presentAlert(withTitle title: String, message : String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                print("You've pressed OK Button")
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func showMakeToast(message: String) {
//        // create a new style
//        var style = ToastStyle()
//        // this is just one of many style options
//        style.messageColor = .white
//        // present the toast with the new style
//        self.view.makeToast(message, duration: 4.0, position: .top, style: style)
    }
    
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc func goBack(button: UIButton) {
        // Handle menu button event here...
        self.navigationController?.popViewController(animated: true)
    }
    func navigateToNoInternetConnectionScreen() {
//        let controller = UIStoryboard.loadViewController(fromStoryBoard: .main, identifier: .noInternetConnectionViewController) as! NoInternetConnectionViewController
 //       controller.modalPresentationStyle = .fullScreen
//        let navController = UINavigationController(rootViewController: controller)
 //       self.navigationController?.present(controller, animated: true, completion: nil)
    }
}

protocol Loadable {
    func showLoadingView()
    func hideLoadingView()
}

extension  UIViewController: Loadable{
    
    @objc func showLoadingView() {
        
        let loadingView = LoadingView()
        self.hideLoadingView()
        self.view.addSubview(loadingView)
        self.view.isUserInteractionEnabled = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        loadingView.animate()
        
        loadingView.tag = LoaderConstants.loadingViewTag
    }
    
    @objc func hideLoadingView() {
            self.view.isUserInteractionEnabled = true
            self.view.alpha = 1
            self.view.subviews.forEach { subview in
                if subview.tag == LoaderConstants.loadingViewTag {
                    subview.removeFromSuperview()
                }
            }
    }
    
    
    
}

final class LoadingView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.Blue.turquoiseBlue
        layer.cornerRadius = 5
        activityIndicatorView.color = .white
        
        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorView.startAnimating()
        }
    }
    
    public func animate() {
        activityIndicatorView.startAnimating()
    }
    
}
fileprivate struct LoaderConstants {
    /// an arbitrary tag id for the loading view, so it can be retrieved later without keeping a reference to it
    fileprivate static let loadingViewTag = 1234
}
