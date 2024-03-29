//
//  APIConfig.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/28/22.
//

import Foundation

class APIConfig {
    static let domain: String = ".epm-dev.demo-bpmlinks.com"
    static let baseURL: String = "https://www.epm-dev.demo-bpmlinks.com/"
    static let envIdentifier = "epm-"
    
//    static let baseURL: String = "https://qa1.festocloud.com/"
//    static let envIdentifier = "festo-"

    static let loginAPIURL = baseURL + "\(envIdentifier)no-auth/api/authentication/user-info"
    static let loginFailure = baseURL + "\(envIdentifier)no-auth/api/authentication/login-failure"
    
    static let appAuthenticationURL = baseURL + "\(envIdentifier)user/api/app-authentication/login"
    static let serviceCountURL      = baseURL + "\(envIdentifier)service/api/app-services/service-counts"
    static let servicesListURL      = baseURL + "\(envIdentifier)service/api/app-services/services"
    static let branchesListURL      = baseURL + "\(envIdentifier)service/api/app-services/service-branches"
    static let serviceProviderBiddingCount = baseURL + "\(envIdentifier)service/api/app-services/service-provider-bidding-counts"
    static let biddingStatusInfo    = baseURL + "\(envIdentifier)service/api/app-services/bidding-status-info"
    static let orderInfo            = baseURL + "\(envIdentifier)service/api/app-services/order-info"
    static let rejectBidRequest     = baseURL + "\(envIdentifier)service/api/app-services/bid-request-info"
    static let acceptBidRequest     = baseURL + "\(envIdentifier)service/api/app-services/accept-bid"
    static let orderDescriptionAPI  = baseURL + "\(envIdentifier)service/api/app-services/order-description"
    static let serviceProgress      = baseURL + "\(envIdentifier)service/api/app-services/service-progress"
    static let viewQuote            = baseURL + "\(envIdentifier)service/api/app-services/quote"
    
    // Calendar
    static let businessValidity  = baseURL + "\(envIdentifier)service/api/app-services/business-validity"
    static let calendarEvents    = baseURL + "\(envIdentifier)service/api/app-services/calendar-events"
    static let bookedServiceSlot = baseURL + "\(envIdentifier)service/api/app-services/booked-service-slots"
    static let slotsAvailability = baseURL + "\(envIdentifier)service/api/app-services/slot-availability"
    static let modifyDaySlots    = baseURL + "\(envIdentifier)service/api/app-services/modify-day-slot"
    static let modifyWeekSlots   = baseURL + "\(envIdentifier)service/api/app-services/modify-week-slot"
    static let modifyMonthSlots  = baseURL + "\(envIdentifier)service/api/app-services/modify-month-slot"

    // Notifications
    static let getNotificationCount = baseURL + "\(envIdentifier)user/api/mobile-notification/notification-count"
    static let getNotifications     = baseURL + "\(envIdentifier)user/api/mobile-notification/notifications"
    static let moveToOld            = baseURL + "\(envIdentifier)user/api/mobile-notification/notification"
}
