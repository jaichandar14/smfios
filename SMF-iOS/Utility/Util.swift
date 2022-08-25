//
//  Util.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/23/22.
//

import UIKit

class Util {
    static func checkAndUpdateController(window: UIWindow) {
        if UserDefault[boolValueFor: .isAlreadyLaunch] {
            setLoadingController(window: window)
        } else {
            setInitialController(window: window)
        }
    }
    
    static func setDashboardController(navigationController: UINavigationController) {
        navigationController.setViewControllers([LandingViewController.create()], animated: true)
    }
    
    static func setLoginController(navigationController: UINavigationController) {
        navigationController.setViewControllers([LoginViewController()], animated: true)
    }
    
    static func setLoadingController(window: UIWindow) {
        window.rootViewController = UINavigationController(rootViewController: LoadingSplashViewController())
        window.makeKeyAndVisible()
    }
    
    static func setInitialController(window: UIWindow) {
        window.rootViewController = UINavigationController(rootViewController: InitialViewController())
        window.makeKeyAndVisible()
    }
    
    static func isBackPressed(string: String) -> Bool {
        let char = string.cString(using: String.Encoding.utf8)
        let isBackSpace: Int = Int(strcmp(char, "\u{8}"))
        if isBackSpace == -8 {
            return true
        } else {
            return false
        }
    }
}
