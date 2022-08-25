//
//  Theme.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/29/22.
//

import UIKit
import SwiftUI

enum Theme: Int {
    case defaultTheme, darkTheme
    
    var primaryColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.primaryColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var accentColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.accentColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.backgroundColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: - Button Color
    var buttonColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.buttonColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var buttonDisabledColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.buttonDisabledColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var buttonTextColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.buttonTextColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: - Text Color
    var textColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.textColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var textGreyColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.textDarkColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var textLinkColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.textLinkColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: -  Event Status Color
    var activeStatusColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.activeStatusColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var closedStatusColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.closedStatusColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var rejectedStatusColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.rejectedStatusColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var draftStatusColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.draftStatusColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // MARK: - Banner Color
    var successColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.successColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var informationColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.informationColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var warningColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.warningColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var errorColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.errorColor
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    // New
    var eventIDTextColor: UIColor {
        switch self {
        case .defaultTheme:
            return UIColor().colorFromHex("bca234")
        case .darkTheme:
            return UIColor().colorFromHex("")
        }
    }
    
    var primaryDarkColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.primaryDarkColor
        case .darkTheme:
            
            return UIColor().colorFromHex("")
        }
    }
    var accentDisabledColor: UIColor {
        switch self {
        case .defaultTheme:
            return ColorConstant.accentDisabledColor
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
    
    // MARK: - Fonts Setup
    func ralewayFont(size: CGFloat, style: RalewayStyle) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: size) else {
            fatalError("""
                    Failed to load the "\(style.rawValue)" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
            )
        }
        
        return customFont
    }
    
    func muliFont(size: CGFloat, style: MuliStyle) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: size) else {
            fatalError("""
                    Failed to load the "\(style.rawValue)" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
            )
        }
        
        return customFont
    }
    
    func playballFont(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "Playball-Regular", size: size) else {
            fatalError("""
                    Failed to load the "Playball-Regular" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
            )
        }
        
        return customFont
    }
    
    func smfFont(size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: "smf_icon", size: size) else {
            fatalError("""
                    Failed to load the "smf_icon_2" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
            )
        }
        
        return customFont
    }
}

enum MuliStyle: String {
    case muliBold = "Muli-Bold"
    case muliBoldItalic = "Muli-BoldItalic"
    case muliExtraLight = "Muli-ExtraLight"
    case muliExtraLightItalic = "Muli-ExtraLightItalic"
    case muliItalic = "Muli-Italic"
    case muliLight = "Muli-Light"
    case muliLightItalic = "Muli-LightItalic"
    case muliSemiBoldItalic = "Muli-Semi-BoldItalic"
    case muliSemiBold = "Muli-SemiBold"
    case muli = "Muli"
}

enum RalewayStyle: String {
    case ralewayExtraLightItalic = "Raleway-ExtraLightItalic"
    case ralewayBlack = "Raleway-Black"
    case ralewayBlackItalic = "Raleway-BlackItalic"
    case ralewayBold = "Raleway-Bold"
    case ralewayBoldItalic = "Raleway-BoldItalic"
    case ralewayExtraBold = "Raleway-ExtraBold"
    case ralewayExtraBoldItalic = "Raleway-ExtraBoldItalic"
    case ralewayExtraLight = "Raleway-ExtraLight"
    case ralewayItalic = "Raleway-Italic"
    case ralewayLight = "Raleway-Light"
    case ralewayLightItalic = "Raleway-LightItalic"
    case ralewayMedium = "Raleway-Medium"
    case ralewayMediumItalic = "Raleway-MediumItalic"
    case ralewayRegular = "Raleway-Regular"
    case ralewaySemiBold = "Raleway-SemiBold"
    case ralewaySemiBoldItalic = "Raleway-SemiBoldItalic"
    case ralewayThin = "Raleway-Thin"
    case ralewayThinItalic = "Raleway-ThinItalic"
}
