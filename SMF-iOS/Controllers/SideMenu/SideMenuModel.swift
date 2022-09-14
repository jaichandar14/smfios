//
//  MenuModel.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/20/21.
//

import UIKit

enum MenuKey {
    case dashboard, availability, divider, logout
}

class SideMenuModel {
    var key: MenuKey
    var icon: UIImage?
    var title: String
    
    init(key: MenuKey, icon: UIImage?, title: String) {
        self.key = key
        self.icon = icon
        self.title = title
    }
}
