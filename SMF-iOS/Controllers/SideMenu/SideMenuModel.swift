//
//  MenuModel.swift
//  CustomSideMenuiOSExample
//
//  Created by John Codeos on 2/20/21.
//

import UIKit

enum MenuKey {
    case dashboard, availability, logout
}

struct SideMenuModel {
    var key: MenuKey
    var icon: UIImage
    var title: String
}
