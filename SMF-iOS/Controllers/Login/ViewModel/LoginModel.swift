//
//  LoginModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/24/22.
//

import Foundation

final class LoginModel {
    
    var email: String?
    var mobileNo: String?
    var selectedCountry: Country?
    
    init() {
        if let cachedCountry = UserDefaults.standard.string(forKey: "country_selection") {
            if let data = cachedCountry.data(using: .utf8), let country = try? JSONDecoder().decode(Country.self, from: data) {
                selectedCountry = country
            }
        }
    }
    
    func callLoginAPI(id: String, method: HTTPMethod, parameters: [String: Any]?, priority: Operation.QueuePriority?, completionHandler: @escaping ServerCallCompletionHandler) {
        APIManager().executeDataRequest(id: id, url: "https://reqres.in/api/users", method: .POST, parameters: ["name": "Swapnil", "job": "Developer"], header: nil, cookieRequired: false, priority: .high, queueType: .data) { response, result, error in
            print("API Executed")
        }
    }
}
