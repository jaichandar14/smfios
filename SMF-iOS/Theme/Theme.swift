//
//  Theme.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/29/22.
//

import UIKit

enum Theme: Int {
    case defaultTheme, darkTheme
    
    var primaryColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#556CD4")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var accentColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#FF3577")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#F6FBFF")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: - Button Color
    var buttonColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#556CD4")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var buttonDisabledColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#9aa4e4")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var buttonTextColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#E1E1E1")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: - Text Color
    var textColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#2B2D5C")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var textGreyColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#9596AD")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var textLinkColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#319FFF")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: -  Event Status Color
    var activeStatusColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#97c852")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var closedStatusColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#556CD4")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var rejectedStatusColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#ff0011")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var draftStatusColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#ffc637")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: - Banner Color
    var successColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#44d672")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var informationColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#4e7de2")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var warningColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#f7de6e")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var errorColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("#e9274b")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: - Navigation Bar Style
    var barStyle: UIBarStyle {
        switch self {
        case .defaultTheme:
            return .default
        case .darkTheme:
            return .black
        }
    }
    
    
}
