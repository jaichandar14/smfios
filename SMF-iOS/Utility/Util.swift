//
//  Util.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/23/22.
//

import UIKit

class Util {
    static func setIntialController(window: UIWindow) {
        if let textData = UserDefault[stringValueFor: .userData],
           let data = textData.data(using: .utf8),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            APIConfig.user = user
            window.rootViewController = UINavigationController(rootViewController: DashboardViewController.create())
        } else {
            window.rootViewController = UINavigationController(rootViewController: InitialViewController())
        }
        
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
