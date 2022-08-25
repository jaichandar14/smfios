//
//  UIButtonExtension.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 28/05/22.
//

import UIKit

extension UIButton {
    func setBorderedButton(textColor: UIColor, borderColor: UIColor = UIColor().colorFromHex("#E0E0E0"), borderSide: BorderSide? = nil) {
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = UIColor.white
        
        if let side = borderSide {
            self.addBorder(toSide: side, withColor: borderColor.cgColor, andThickness: 1.2)
        } else {
            self.setBorderedView(borderColor: borderColor)
        }
    }
}

