//
//  UIImageExtension.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 6/19/22.
//

import UIKit


extension UIImage {
  convenience init?(url: URL?) {
    guard let url = url else { return nil }
            
    do {
      self.init(data: try Data(contentsOf: url))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}
