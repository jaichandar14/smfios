//
//  UIImageview+Extension.swift
//  EPM
//
//  Created by lavanya on 29/10/21.
//

import UIKit

extension UIImageView {

   func setRounded() {
      let radius = self.frame.width / 2
      self.layer.cornerRadius = radius
      self.layer.masksToBounds = true
   }
}
