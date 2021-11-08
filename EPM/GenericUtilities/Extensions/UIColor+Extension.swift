//
//  UIColor+Extension.swift
//  EPM
//
//  Created by lavanya on 29/10/21.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
         assert(red >= 0 && red <= 255, "Invalid red component")
         assert(green >= 0 && green <= 255, "Invalid green component")
         assert(blue >= 0 && blue <= 255, "Invalid blue component")

         self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
     }

     convenience init(rgb: Int) {
         self.init(
             red: (rgb >> 16) & 0xFF,
             green: (rgb >> 8) & 0xFF,
             blue: rgb & 0xFF
         )
     }
    struct White {
        static let white = UIColor(rgb: 0xFFFFFF)
    }
    struct Black {
        static let black = UIColor(rgb: 0x000000)
        static let mineShaft = UIColor(rgb: 0x1F1F1F)
        static let riverBed = UIColor(rgb: 0x434B56)
        static let shark = UIColor(rgb: 0x1D2226)
        static let darkTwo = UIColor(rgb: 0x1A2E35)
    
    }
    struct Blue {
        static let turquoiseBlue = UIColor(rgb: 0x67DEE8)
        static let java = UIColor(rgb: 0x1DC5D4)
        static let light = UIColor(rgb: 0xC8FAFF)
        static let zircon = UIColor(rgb: 0xF6F9FF)
        static let azure = UIColor(rgb: 0x008fff)
    }
    struct Gray {
        static let silver = UIColor(rgb: 0xC3C3C3)
        static let dustyGray = UIColor(rgb: 0x9A9A9A)
        static let jumbo = UIColor(rgb: 0x7B7A7C)
        static let athensGray = UIColor(rgb: 0xEEEDEF)
        static let mercury = UIColor(rgb: 0xE1E1E1)
        static let silverChalice = UIColor(rgb: 0xB1B1B1)
        static let silverChaliceTwo = UIColor(rgb: 0xA7A7A7)
        static let alabaster = UIColor(rgb: 0xF8F8F8)
        static let mercuryLine = UIColor(rgb: 0xDEDEDE)
        
      
      }
    struct Orange {
        static let orangePeel = UIColor(rgb: 0xFFA000)
    }
    
}


