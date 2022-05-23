//
//  Util.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/23/22.
//

import UIKit

class Util {
    static var loader: UIAlertController?
    
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
    
    static func getLoader() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        Util.loader = alert
        
        return alert
    }
}
