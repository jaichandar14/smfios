//
//  UIFont+Extension.swift
//  EPM
//
//  Created by lavanya on 29/10/21.
//

import UIKit


struct Resources {

    struct Fonts {
        //struct is extended in Fonts
    }
}

extension Resources.Fonts {

    enum Weight: String {
        case light = "SFProText-Light"
        case regular = "SFProText-Regular"
        case semibold = "SFProText-Semibold"
        case bold = "SFProText-Bold"
        case medium = "SFProText-Medium"
    }
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {

    @objc class func mySystemFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .semibold:
            return UIFont(name: Resources.Fonts.Weight.semibold.rawValue, size: ofSize)!
        case .bold:
            return UIFont(name: Resources.Fonts.Weight.bold.rawValue, size: ofSize)!
        case .regular:
            return UIFont(name: Resources.Fonts.Weight.regular.rawValue, size: ofSize)!
        case .medium:
            return UIFont(name: Resources.Fonts.Weight.medium.rawValue, size: ofSize)!
        default:
            return UIFont(name: Resources.Fonts.Weight.light.rawValue, size: ofSize)!
        }
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.regular.rawValue, size: size)!
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.bold.rawValue, size: size)!
    }
    
    @objc class func mySemiBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: Resources.Fonts.Weight.semibold.rawValue, size: size)!
    }

    @objc convenience init(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = Resources.Fonts.Weight.regular.rawValue
        case "CTFontMediumUsage":
            fontName = Resources.Fonts.Weight.medium.rawValue
        case "CTFontBoldUsage":
            fontName = Resources.Fonts.Weight.bold.rawValue
        case "CTFontSemiboldUsage":
            fontName = Resources.Fonts.Weight.semibold.rawValue
        default:
            fontName = Resources.Fonts.Weight.light.rawValue
        }
        self.init(name: fontName, size: fontDescriptor.pointSize)!
    }

    class func overrideDefaultTypography() {
        guard self == UIFont.self else { return }

        if let systemFontMethodWithWeight = class_getClassMethod(self, #selector(systemFont(ofSize: weight:))),
            let mySystemFontMethodWithWeight = class_getClassMethod(self, #selector(mySystemFont(ofSize: weight:))) {
            method_exchangeImplementations(systemFontMethodWithWeight, mySystemFontMethodWithWeight)
        }

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        if let semiBoldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let mySemiBoldSystemFontMethod = class_getClassMethod(self, #selector(mySemiBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(semiBoldSystemFontMethod, mySemiBoldSystemFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
