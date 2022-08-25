//
//  ThemeManager.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/29/22.
//

import UIKit

class ThemeManager {
    static func currentTheme() -> Theme {
        if let storedTheme = Theme(rawValue: UserDefault[intValueFor: .selectedTheme]) {
            return storedTheme
        } else {
            return .defaultTheme
        }
    }
    
    static func applyTheme(theme: Theme) {
        UserDefault[key: .selectedTheme] = theme.rawValue
        
//        let sharedApplication = UIApplication.shared
//        sharedApplication.delegate?.window??.tintColor = theme.primaryColor
//        
////        UINavigationBar.appearance().barStyle = theme.barStyle
////        //        UINavigationBar.appearance().setBackgroundImage(theme.navigationBackgroundImage, for: .default)
////        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back_arrow")
//////        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
//        
//        UITabBar.appearance().barStyle = theme.barStyle
//        //        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
//        
//        /** UIButton appearance **/
//        UIButton.appearance().backgroundColor = theme.buttonColor
//        UIButton.appearance().setTitleColor(theme.buttonTextColor, for: .normal)
    }
}
