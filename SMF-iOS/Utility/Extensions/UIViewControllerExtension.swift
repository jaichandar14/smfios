//
//  UIViewControllerExtension.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/24/22.
//

import UIKit
import ProgressHUD

extension UIViewController {
    
    func setNavBar(hidden: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: false)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func showLoader() {
        ProgressHUD.show("Progress loader...")
    }
    
    func hideLoader() {
        ProgressHUD.dismiss()
    }
    
    func showAlert(withTitle title: String, withMessage message: String, isDefault: Bool?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if (isDefault ?? false) {
            let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
        } else {
            actions.forEach { action in
                alert.addAction(action)
            }
        }
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}

