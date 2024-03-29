//
//  ActionListModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/20/22.
//

import Foundation

enum BiddingStatus: String, Codable {
    case bidRequested = "BID REQUESTED"
    case pendingForQuote = "PENDING FOR QUOTE"
    case bidSubmitted = "BID SUBMITTED"
    case wonBid = "WON BID"
    case serviceInProgress = "SERVICE IN PROGRESS" // NEW
    case pendingReview = "PENDING REVIEW" // NOT WORKING FOR NOW
    
    case serviceClosed = "SERVICE COMPLETED"
    case bidRejected = "BID REJECTED"
    case bidTimedOut = "BID TIMED OUT"
    case lostBid = "LOST BID"
    
    case none = "none"
}

enum CostingType: String, Codable {
    case bidding = "Bidding"
    case fixed = "Fixed Cost"
    case variable = "Variable Cost"
}

enum CurrencyType: String, Codable, CaseIterable {
    case dollar = "USD($)"
    case pound = "GBP(£)"
    case inr = "INR(₹)"
    
    var currency: String {
        switch self {
        case .dollar:
            return "$"
        case .inr:
            return "₹"
        case .pound:
            return "£"
        }
    }
}


class BidStatusInfo: Codable {
    
    let bidRequestId: Int
    let serviceCategoryId: Int
    let spRegId: Int
    let serviceVendorOnboardingId: Int
    let eventId: Int
    let eventDate: String
    let eventName: String
    let serviceName: String
    let serviceDate: String
    let bidRequestedDate: String
    let biddingCutOffDate: String
    let costingType: CostingType
    var cost: String
    let bidStatus: String
    let currencyType: CurrencyType?
    let isExistingUser: Bool
    let serviceProviderEmail: String?
    let serviceAddress: String
    let eventServiceDescriptionId: Int
    let branchName: String
    let timeLeft: Double
    let serviceAddressDto: VenueAddress
    let latestBidValue: Int?
    //                   let serviceProviderId: null,
    //                   let serviceProviderName: null,
    //                   let bidCurrencyUnit: null,
    //                   let eventOrganizerId: null,
    //                   let latestBidValue: null,
    //                   let rejectedBidReason: null,
    //                   let rejectedBidComment: null,
    //                   let bidAcceptedDate: null,
    //                   let bidRejectedDate: null,
    //                   let branchAddress: null,
    //                   let bidRequested: null,
    //                   let bidSubmitted: null,
    //                   let bidRejected: null,
    //                   let pendingForQuote: null,
    //                   let wonBid: null,
    //                   let lostBid: null,
    //                   let bidTimedOut: null,
    //                   let serviceDone: null,
    
    //                   let serviceBranchDto: null,
    //                   let preferredSlots: null
    
    init() {
        bidRequestId = 12345
        serviceCategoryId = 987654
        spRegId = 789456
        serviceVendorOnboardingId = 78
        eventId = 5654
        eventDate = "05/22/2022"
        eventName = "Birthday"
        serviceName = "Birthday decoration"
        serviceDate = "05/22/2022"
        bidRequestedDate = "05/15/2022"
        biddingCutOffDate = "05/21/2022"
        costingType = CostingType.bidding
        cost = "2540"
        bidStatus = "Completed"
        currencyType = CurrencyType.inr
        isExistingUser = true
        serviceProviderEmail = "service@gmail.com"
        serviceAddress = "14B, My Building, Banglore"
        eventServiceDescriptionId = 852852
        branchName = "Banglore"
        timeLeft = 25
        serviceAddressDto = VenueAddress()
        latestBidValue = 2600
    }
    
    enum CodingKeys: String, CodingKey {
        case bidRequestId, serviceCategoryId, spRegId, serviceVendorOnboardingId, eventId, eventDate, eventName, serviceName, serviceDate, bidRequestedDate, biddingCutOffDate, costingType, cost, bidStatus, currencyType, isExistingUser, serviceProviderEmail, serviceAddress, eventServiceDescriptionId, branchName, timeLeft, serviceAddressDto, latestBidValue
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        bidRequestId = try container.decode(Int.self, forKey: .bidRequestId)
        serviceCategoryId = try container.decode(Int.self, forKey: .serviceCategoryId)
        spRegId = try container.decode(Int.self, forKey: .spRegId)
        serviceVendorOnboardingId = try container.decode(Int.self, forKey: .serviceVendorOnboardingId)
        eventId = try container.decode(Int.self, forKey: .eventId)
        eventDate = try container.decode(String.self, forKey: .eventDate)
        eventName = try container.decode(String.self, forKey: .eventName)
        serviceName = try container.decode(String.self, forKey: .serviceName)
        serviceDate = try container.decode(String.self, forKey: .serviceDate)
        bidRequestedDate = try container.decode(String.self, forKey: .bidRequestedDate)
        biddingCutOffDate = try container.decode(String.self, forKey: .biddingCutOffDate)
        costingType = try container.decode(CostingType.self, forKey: .costingType)
        cost = try container.decode(String.self, forKey: .cost)
        if cost.lowercased() == "null" {
            cost = ""
        }
        bidStatus = try container.decode(String.self, forKey: .bidStatus)
        let currencyString = try? container.decode(String.self, forKey: .currencyType)
        if let currency = currencyString {
            currencyType = CurrencyType(rawValue: currency)
        } else {
            currencyType = nil
        }
        
        isExistingUser = try container.decode(Bool.self, forKey: .isExistingUser)
        serviceProviderEmail = try? container.decode(String.self, forKey: .serviceProviderEmail)
        serviceAddress = try container.decode(String.self, forKey: .serviceAddress)
        eventServiceDescriptionId = try container.decode(Int.self, forKey: .eventServiceDescriptionId)
        branchName = try container.decode(String.self, forKey: .branchName)
        timeLeft = try container.decode(Double.self, forKey: .timeLeft)
        serviceAddressDto = try container.decode(VenueAddress.self, forKey: .serviceAddressDto)
        latestBidValue = try? container.decode(Int.self, forKey: .latestBidValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(bidRequestId, forKey: .bidRequestId)
        try container.encode(serviceCategoryId, forKey: .serviceCategoryId)
        try container.encode(spRegId, forKey: .spRegId)
        try container.encode(serviceVendorOnboardingId, forKey: .serviceVendorOnboardingId)
        try container.encode(eventId, forKey: .eventId)
        try container.encode(eventDate, forKey: .eventDate)
        try container.encode(eventName, forKey: .eventName)
        try container.encode(serviceName, forKey: .serviceName)
        try container.encode(serviceDate, forKey: .serviceDate)
        try container.encode(bidRequestedDate, forKey: .bidRequestedDate)
        try container.encode(biddingCutOffDate, forKey: .biddingCutOffDate)
        try container.encode(costingType.rawValue, forKey: .costingType)
        try container.encode(cost, forKey: .cost)
        try container.encode(bidStatus, forKey: .bidStatus)
        try? container.encode(currencyType, forKey: .currencyType)
        try container.encode(isExistingUser, forKey: .isExistingUser)
        try? container.encode(serviceProviderEmail, forKey: .serviceProviderEmail)
        try container.encode(serviceAddress, forKey: .serviceAddress)
        try container.encode(eventServiceDescriptionId, forKey: .eventServiceDescriptionId)
        try container.encode(branchName, forKey: .branchName)
        try container.encode(timeLeft, forKey: .timeLeft)
        try container.encode(serviceAddressDto, forKey: .serviceAddressDto)
    }
    
}

class VenueAddress: Codable {
    let addressLine1: String?
    let addressLine2: String?
    let city: String?
    let state: String?
    let country: String?
    let zipCode: String?
    let knownVenue: Bool
    
    init() {
        addressLine1 = "Ganesham Society"
        addressLine2 = "Baner, Pune"
        city = "Pune"
        state = "Maharashtra"
        country = "India"
        zipCode = "415654"
        knownVenue = true
    }
    
    enum CodingKeys: String, CodingKey {
        case addressLine1, addressLine2, city, state, country, zipCode, knownVenue
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        addressLine1 = try? container.decode(String.self, forKey: .addressLine1)
        addressLine2 = try? container.decode(String.self, forKey: .addressLine2)
        city = try? container.decode(String.self, forKey: .city)
        state = try? container.decode(String.self, forKey: .state)
        country = try? container.decode(String.self, forKey: .country)
        zipCode = try? container.decode(String.self, forKey: .zipCode)
        knownVenue = try container.decode(Bool.self, forKey: .knownVenue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try? container.encode(addressLine1, forKey: .addressLine1)
        try? container.encode(addressLine2, forKey: .addressLine2)
        try? container.encode(city, forKey: .city)
        try? container.encode(state, forKey: .state)
        try? container.encode(country, forKey: .country)
        try? container.encode(zipCode, forKey: .zipCode)
        try container.encode(knownVenue, forKey: .knownVenue)
    }
}


class ActionListModel {
    func  fetchActionList(categoryId: Int?, vendorOnboardingId: Int?, status: String, completion: @escaping ([[String: Any]]?, String?) -> Void) {
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        var params: [String: Any] = [APIConstant.bidStatus: status]
        if let id = categoryId {
            params[APIConstant.serviceCategoryId] = id
        }
        if let id = vendorOnboardingId {
            params[APIConstant.serviceVendorOnboardingId] = id
        }
        
        let url = APIConfig.biddingStatusInfo + "/\(AmplifyLoginUtility.user!.spRegId)"
        APIManager().executeDataRequest(id: "ServiceList", url: url, method: .GET, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { (response, result, error) in
            
            switch result {
            case true:
                
                if let respData = (response?["data"] as? [String: Any])?["serviceProviderBidRequestDtos"] as? [[String: Any]] {
                     completion(respData, nil)
                } else {
                     completion(nil, "Data could not be parsed")
                }
            case false:
                 completion(nil, error?.localizedDescription ?? "Error in fetchServiceCount")
            }
        }
    }
}
