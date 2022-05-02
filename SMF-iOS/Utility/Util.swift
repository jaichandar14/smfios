//
//  Util.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/23/22.
//

import UIKit

class Util {
    
    static func setIntialController(window: UIWindow) {
        
        window.rootViewController = UINavigationController(rootViewController: DashboardViewController())//InitialViewController())
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
