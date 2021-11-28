//
//  UIStoryBoard+Util.swift
//  EPM
//
//  Created by lavanya on 29/10/21.
//

import Foundation
import UIKit

enum Storyboard : String {
    case main = "UserEntry"
}

enum ViewControllerIdentifier : String {
    case signInVC = "SignInViewController"
    case signUpVC = "SignUpViewController"
}


extension UIStoryboard {
    
    static func loadViewController(fromStoryBoard storyboard: Storyboard, identifier: ViewControllerIdentifier) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier.rawValue)
    }
    
    static func loadInitialViewController(fromStoryBoard storyboard: Storyboard) -> UIViewController{
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateInitialViewController()!
    }
    
}
