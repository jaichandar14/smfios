//
//  NotificationViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 10/11/22.
//

import Foundation

enum NotificationType {
    case active, old
}

protocol NotificationsViewModel {
    var activeNotifications: Observable<Int?> { get }
    var oldNotifications: Observable<Int?> { get }
    
    var notifications: Observable<[NotificationModel]> { get }
    var notificationsLoading: Observable<Bool> { get }
    var notificationsFetchError: Observable<String?> { get }
    var notificationsCountFetchError: Observable<String?> { get }
    var notificationsUpdateError: Observable<String?> { get }
    
    var notificationDeleteSuccess: Observable<Bool?> { get }
    
    func fetchNotificationsCount()
    func fetchNotifications(type: NotificationType)
    
    func updateNotificationStatus(notificationIds: [Int])
}
