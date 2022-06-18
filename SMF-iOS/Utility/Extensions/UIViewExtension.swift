//
//  UIViewExtension.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func showBlurLoader() {
        if !subviews.contains(where: { $0 is BlurLoader }) {
            let blurLoader = BlurLoader(frame: frame)
            self.addSubview(blurLoader)
            
            let constraints = [
                blurLoader.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                blurLoader.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                blurLoader.widthAnchor.constraint(equalTo: self.widthAnchor),
                blurLoader.heightAnchor.constraint(equalTo: self.heightAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            
            self.bringSubviewToFront(blurLoader)
            self.addLoader()
        }
    }
    
    func removeBlurLoader() {
        if let blurLoader = subviews.first(where: { $0 is BlurLoader }) {
            blurLoader.removeFromSuperview()
        }
        if let activityIndicator = subviews.first(where: { $0 is UIActivityIndicatorView }) {
            activityIndicator.removeFromSuperview()
        }
    }
    
    fileprivate func addLoader() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.addSubview(activityIndicator)
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        self.bringSubviewToFront(activityIndicator)
    }

    func setBorderedView(borderColor: UIColor = ColorConstant.greyColor8, radius: CGFloat = 5) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
    }
}

class BlurLoader: UIView {
    var blurEffectView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.alpha = 0.4
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        super.init(frame: frame)
        addSubview(blurEffectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
