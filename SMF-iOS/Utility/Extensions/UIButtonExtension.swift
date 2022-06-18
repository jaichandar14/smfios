//
//  UIButtonExtension.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 28/05/22.
//

import UIKit

extension UIButton {
    func setBorderedButton(textColor: UIColor, borderColor: UIColor = UIColor().colorFromHex("#E0E0E0")) {
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = UIColor.white
        self.setBorderedView(borderColor: borderColor)
    }
}

