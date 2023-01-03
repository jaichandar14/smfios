//
//  NotificationViewModelExecutor.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 10/11/22.
//

import Foundation

class NotificationViewModelExecutor: NotificationsViewModel {
    var activeNotifications: Observable<Int?>
    var oldNotifications: Observable<Int?>
    
    var notifications: Observable<[NotificationModel]>
    var notificationsLoading: Observable<Bool>
    var notificationsCountFetchError: Observable<String?>
    var notificationsFetchError: Observable<String?>
    var notificationsUpdateError: Observable<String?>
    
    var notificationDeleteSuccess: Observable<Bool?>
    
    init() {
        self.activeNotifications = Observable<Int?>(nil)
        self.oldNotifications = Observable<Int?>(nil)
        
        self.notifications = Observable<[NotificationModel]>([])
        self.notificationsLoading = Observable<Bool>(false)
        self.notificationsFetchError = Observable<String?>(nil)
        self.notificationsCountFetchError = Observable<String?>(nil)
        self.notificationsUpdateError = Observable<String?>(nil)
    
        self.notificationDeleteSuccess = Observable<Bool?>(nil)
    }
    
    func fetchNotifications(type: NotificationType) {
        self.notifications.value = []
        self.notificationsLoading.value = true
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        let params = [APIConstant.isActive: "\(type == .active)"]
        
        let url = APIConfig.getNotifications + "/\(AmplifyLoginUtility.user!.userName)"
        APIManager().executeDataRequest(id: "Get Notifications", url: url, method: .GET, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            self.notificationsLoading.value = false
            switch result {
            case true:
                
                if let respData = response?["data"] as? [[String: Any]] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: respData, options: [])
                        let notifications = try JSONDecoder().decode([NotificationModel].self, from: data)
                        
                        self.notifications.value = notifications
                    } catch {
                        print("Error :: \(error)")
                        self.notificationsFetchError.value = "Data could not be parsed"
                    }
                } else {
                    self.notificationsFetchError.value = "Data could not be parsed"
                }
            case false:
                self.notificationsFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func fetchNotificationsCount() {
        self.notificationsLoading.value = true
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        let url = APIConfig.getNotificationCount + "/\(AmplifyLoginUtility.user!.userName)"
        APIManager().executeDataRequest(id: "Get Notifications count", url: url, method: .GET, parameters: nil, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            self.notificationsLoading.value = false
            switch result {
            case true:
                
                if let respData = response?["data"] as? [String: Any] {
                    if let oldCount = respData["oldCounts"] as? Int {
                        self.oldNotifications.value = oldCount
                    } else {
                        self.oldNotifications.value = 0
                    }
                    
                    if let activeCount = respData["activeCounts"] as? Int {
                        self.activeNotifications.value = activeCount
                    } else {
                        self.activeNotifications.value = 0
                    }
                    
                    // Set notifications object
                } else {
                    self.notificationsCountFetchError.value = "Data could not be parsed"
                }
            case false:
                self.notificationsCountFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func updateNotificationStatus(notificationIds: [Int]) {
        self.notificationsLoading.value = true
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        let url = APIConfig.moveToOld
        let params = [APIConstant.noKey: notificationIds]
        
        APIManager().executeDataRequest(id: "Update Notifications", url: url, method: .PUT, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            self.notificationsLoading.value = false
            switch result {
            case true:
                
                if let respData = response?["data"] as? [String: Any] {
                    if let status = respData["status"] as? String, status == "Success" {
                        self.notificationDeleteSuccess.value = true
                    } else {
                        self.notificationDeleteSuccess.value = false
                    }
                } else {
                    self.notificationsUpdateError.value = "Data could not be parsed"
                }
            case false:
                self.notificationsUpdateError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
}
