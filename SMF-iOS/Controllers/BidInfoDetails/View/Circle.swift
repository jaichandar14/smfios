//
//  Circle.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import UIKit

class Circle: UIView {
    
    var trackLyr = CAShapeLayer()
    
    var trackClr = UIColor.white {
       didSet {
          trackLyr.strokeColor = trackClr.cgColor
       }
    }
    
    var lineWidth: CGFloat = 1.0 {
       didSet {
          trackLyr.lineWidth = lineWidth
       }
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       makeCircularPath()
    }

    func makeCircularPath() {
       self.backgroundColor = UIColor.clear
       self.layer.cornerRadius = self.frame.size.width / 2
       let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: (frame.size.width - 1.5) / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
       trackLyr.path = circlePath.cgPath
       trackLyr.fillColor = UIColor.clear.cgColor
       trackLyr.strokeColor = trackClr.cgColor
       trackLyr.lineWidth = lineWidth
       trackLyr.strokeEnd = 1.0
       layer.addSublayer(trackLyr)
    }
}
