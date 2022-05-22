//
//  BaseClassProtocol.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/25/22.
//

import Foundation

protocol BaseProtocol {
    func styleUI()
    func setDataToUI()
    func networkChangeListener(connectivity: Bool, connectionType: String?)
}

typealias BaseViewController = BaseController & BaseProtocol
