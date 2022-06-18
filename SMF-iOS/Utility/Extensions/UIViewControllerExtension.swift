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
}

