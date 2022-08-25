//
//  CVProgressHUD.swift
//  CVProgressHUD
//
//  Created by Swapnil Dhotre on 17/09/19.
//  Copyright © 2019 247 Software. All rights reserved.
//

import UIKit

final class CVProgressHUD: UIView {
    
    /// Style is for designing differnt type of progress bar if needed. Currently not used it.
    ///
    /// - activity: Show normal activity indicator
    /// - progressBar: Show progress indicator
    /// - circularProgress: Show Circular progress indicator
    enum Style : Int {
        case activity
        case progressBar
        case circularProgress
    }
    
    private var style: Style?
    static private let shared = CVProgressHUD.getSharedProgressHUD(frame: UIScreen.main.bounds)
    
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate var activityBackgroundView: UIVisualEffectView!
    @IBOutlet fileprivate var activityLabel: UILabel!
    
    /// This will prohibit from creating instance of this class
    private init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// This will create instance of progressHUD. Do not access this from any other file. For showing full screen progress this func is used.
    /// If you want to show or add to to specific UIView then you can use instance of UIView following showProgressHUD().
    ///
    /// - Parameter frame: frame size you want to show
    /// - Returns: returns instance of ProgressHUD
    class fileprivate func getSharedProgressHUD(frame: CGRect) -> CVProgressHUD {
        let nib: CVProgressHUD = Bundle.main.loadNibNamed("CVProgressHUD", owner: self, options: nil)?.first as! CVProgressHUD
        nib.frame = frame
        return nib
    }
    
    /// Fetch progress hud if ever created.
    ///
    /// - Returns: returns view of progress hud if it is created and already added in stack
    class private func getProgressHUD() -> CVProgressHUD? {
        var progressHUD: CVProgressHUD?
        for view in UIApplication.shared.keyWindow?.subviews ?? [] where view is CVProgressHUD {
            progressHUD = view as? CVProgressHUD
            break
        }
        return progressHUD
    }
    
    /// Show Progress bar. This will be added to UIWindow.
    ///
    /// - Parameter title: add title to loader
    class func showProgressHUD(title: String) {
        
        var progressHUD = CVProgressHUD.shared
        if let stackProgressHUD = self.getProgressHUD() {
            progressHUD = stackProgressHUD
        } else {
            let window = UIApplication.shared.keyWindow!
            window.addSubview(progressHUD)
        }
        
        progressHUD.isHidden = false
        progressHUD.activityLabel.text = title
        UIApplication.shared.keyWindow!.bringSubviewToFront(progressHUD)
    }
    
    /// Hide progress view
    class func hideProgressHUD(){
        CVProgressHUD.shared.isHidden = true
    }
}

extension UIView {
    
    /// Show progress bar by adding this to view from it is called.
    ///
    /// - Parameter title: Progress bar message
    /// - Returns: returns progressBar instance incase you need to customize
    @discardableResult
    func showProgressHUD(title: String) -> CVProgressHUD {
        let progressHUD = CVProgressHUD.getSharedProgressHUD(frame: self.frame)
        progressHUD.activityLabel.text = title
        self.addSubview(progressHUD)
        return progressHUD
    }
    
    /// When this function is called it will remove view from subViews. Even though if you do not call hide it will be removed when parentView is removed from memory.
    ///
    /// - Parameter progressHUD: Optional parameter if passed then it will remove specific view. If not passed it iterate and then remove CVProgressHUD.
    func hideProgressHUD(progressHUD: UIView? = nil) {
        if progressHUD != nil {
            progressHUD?.removeFromSuperview()
        } else {
            for case let view as CVProgressHUD in self.subviews {
                view.removeFromSuperview()
            }
        }
    }
}
