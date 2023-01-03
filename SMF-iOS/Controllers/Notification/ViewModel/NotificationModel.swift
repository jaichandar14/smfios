//
//  NotificationModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 10/11/22.
//

import Foundation

struct NotificationInfo: Decodable {
    var serviceVendorOnboardingId: Int
    var bidRequestId: Int
    var eventId: Int
    var eventServiceDescriptionId: Int
    
    enum CodingKeys: String, CodingKey {
        case serviceVendorOnboardingId, bidRequestId, eventId, eventServiceDescriptionId
    }
}

struct NotificationModel: Decodable {
    var notificationId: Int
    var notificationTitle: String
    var notificationType: String
    var moduleType: String
    var createdDate: String
    var formatedCreatedDate: String
    var notificationInfo: NotificationInfo?
    var notificationContent: String
    var isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case notificationId, notificationTitle, notificationType, createdDate, formatedCreatedDate, moduleType, notificationContent, isActive
        case notificationInfo = "notificationMetadata"
    }
}
