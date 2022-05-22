//
//  DashboardModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/19/22.
//

import Foundation

enum ServiceCountLabel: String {
    case Active = "activeServiceCount"
    case Pending = "approvalPendingServiceCount"
    case Draft = "draftServiceCount"
    case Inactive = "inactiveServiceCount"
    case Rejected = "rejectedServiceCount"
    
    var name: String {
        switch self {
        case .Active:
            return "Active"
        case .Pending:
            return "Pending"
        case .Draft:
            return "Draft"
        case .Inactive:
            return "Inactive"
        case .Rejected:
            return "Rejected"
        }
    }
}

struct ServiceCount {
    
    var count: Int
    var key: String
    var title: String?
    
    init(key: String, count: Int) {
        self.key = key
        self.count = count
        self.title = ServiceCountLabel(rawValue: key)?.name
    }
}

struct Service: Codable {
    let serviceCategoryId: Int
    let serviceName: String
    //                serviceCategoryTemplateDto: null,
    //                customerServiceCategory: null,
    //                questionnaireWrapperDto: null
    
    enum CodingKeys: String, CodingKey {
        case serviceCategoryId, serviceName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        serviceCategoryId = try container.decode(Int.self, forKey: .serviceCategoryId)
        serviceName = try container.decode(String.self, forKey: .serviceName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(serviceCategoryId, forKey: .serviceCategoryId)
        try container.encode(serviceName, forKey: .serviceName)
    }
}

struct Branch: Codable {
    let spRegId: Int
    let serviceVendorOnboardingId: Int
    let branchName: String
    //                let serviceVendorMetadataDto: null,
    //                let serviceVendorBranchDto: null,
    //                let status: null,
    
    enum CodingKeys: String, CodingKey {
        case spRegId, serviceVendorOnboardingId, branchName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        spRegId = try container.decode(Int.self, forKey: .spRegId)
        serviceVendorOnboardingId = try container.decode(Int.self, forKey: .serviceVendorOnboardingId)
        branchName = try container.decode(String.self, forKey: .branchName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(spRegId, forKey: .spRegId)
        try container.encode(serviceVendorOnboardingId, forKey: .serviceVendorOnboardingId)
        try container.encode(branchName, forKey: .branchName)
    }
}

class DashboardModel {
    func getServicesList() {
        
    }
}

