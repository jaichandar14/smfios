//
//  NotificationExtension.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/25/22.
//

import Foundation

extension Notification.Name {
    static var networkConnection: Notification.Name {
        return .init(rawValue: "NotificationConnection")
    }
}
