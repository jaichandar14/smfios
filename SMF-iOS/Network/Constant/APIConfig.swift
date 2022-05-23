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
    
    static var user: User? = nil {
        didSet {
            if let data = try? JSONEncoder().encode(user) {
                UserDefault[key: .userData] = String(data: data, encoding: .utf8)!
            }
        }
    }
    
    static let appAuthenticationURL = baseURL + "epm-user/api/app-authentication/login"
    static let serviceCountURL = baseURL + "epm-service/api/app-services/service-counts"
    static let servicesListURL = baseURL + "epm-service/api/app-services/services"
    static let branchesListURL = baseURL + "epm-service/api/app-services/service-branches"
    static let serviceProviderBiddingCount = baseURL + "epm-service/api/app-services/service-provider-bidding-counts"
    static let biddingStatusInfo = baseURL + "epm-service/api/app-services/bidding-status-info"
    static let orderInfo = baseURL + "epm-service/api/app-services/order-info"
}
