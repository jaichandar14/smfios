//
//  User.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/18/22.
//

import Foundation

class User: Codable {
    var userId: Int
    var roleId: Int
    var role: String
    var firstName: String
    var userName: String
    var lastName: String
    var email: String
    var mobileNumber: String
    var userStatus: String
    var isActive: Bool
    var spRegId: Int
    var countryCode: String?
    
    enum CodingKeys: String, CodingKey {
        case userId, roleId, role, firstName, userName, lastName, email, mobileNumber, userStatus, isActive, spRegId, countryCode
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userId = try container.decode(Int.self, forKey: .userId)
        roleId = try container.decode(Int.self, forKey: .roleId)
        role = try container.decode(String.self, forKey: .role)
        firstName = try container.decode(String.self, forKey: .firstName)
        userName = try container.decode(String.self, forKey: .userName)
        lastName = try container.decode(String.self, forKey: .lastName)
        email = try container.decode(String.self, forKey: .email)
        mobileNumber = try container.decode(String.self, forKey: .mobileNumber)
        userStatus = try container.decode(String.self, forKey: .userStatus)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        spRegId = try container.decode(Int.self, forKey: .spRegId)
        countryCode = try? container.decode(String.self, forKey: .countryCode)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(userId, forKey: .userId)
        try container.encode(userId, forKey: .userId)
        try container.encode(roleId, forKey: .roleId)
        try container.encode(role, forKey: .role)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(userName, forKey: .userName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encode(mobileNumber, forKey: .mobileNumber)
        try container.encode(userStatus, forKey: .userStatus)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(spRegId, forKey: .spRegId)
        try? container.encode(countryCode, forKey: .countryCode)
    }
}

