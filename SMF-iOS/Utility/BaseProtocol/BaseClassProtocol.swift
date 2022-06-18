//
//  BaseClassProtocol.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/25/22.
//

import Foundation
import UIKit

@objc protocol BaseProtocol {
    func styleUI()
    func setDataToUI()
    func networkChangeListener(connectivity: Bool, connectionType: String?)
    @objc func backButtonAction(_ sender: UIBarButtonItem)
}

typealias BaseViewController = BaseController & BaseProtocol
