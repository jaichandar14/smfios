//
//  UINavigationExtension.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/23/22.
//

import UIKit

extension UINavigationController {
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
