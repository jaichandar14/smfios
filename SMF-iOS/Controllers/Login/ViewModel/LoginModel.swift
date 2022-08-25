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
        if let cachedCountry = UserDefault[stringValueFor: .countrySelection] {
            if let data = cachedCountry.data(using: .utf8), let country = try? JSONDecoder().decode(Country.self, from: data) {
                selectedCountry = country
            }
        }
    }
    
    func callLoginAPI(id: String, method: HTTPMethod, parameters: [String: Any]?, priority: Operation.QueuePriority?, completionHandler: @escaping ServerCallCompletionHandler) {
        APIManager().executeDataRequest(id: id, url: "https://www.epm-dev.demo-bpmlinks.com/epm-no-auth/api/authentication/user-info", method: method, parameters: parameters, header: nil, cookieRequired: false, priority: priority ?? .normal, queueType: .data) { response, result, error in
            switch result {
            case true:
                do {
//                    var statusCode: Int = 0
//                    if let status = response?["status_code"] as? Int, let code = response?["statusCode"] as? Int {
//                        statusCode = code
//                    }
                    
//                    if statusCode == 200 {
                        completionHandler(response, true, nil)
//                    } else {
//                        completionHandler(response, false, APIError.invalidData)
//                    }
                }
            case false:
                completionHandler(nil, false, error)
            }
        }
    }
    
    func callAppAuthenticatedUser(id: String, method: HTTPMethod, parameters: [String: Any]?, priority: Operation.QueuePriority?, completionHandler: @escaping ServerCallCompletionHandler) {
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        APIManager().executeDataRequest(id: id, url: APIConfig.appAuthenticationURL, method: method, parameters: parameters, header: headers, cookieRequired: false, priority: priority ?? .normal, queueType: .data) { response, result, error in
            switch result {
            case true:
                do {
//                    var statusCode: Int = 0
//                    if let status = response?["status_code"] as? Int, let code = response?["statusCode"] as? Int {
//                        statusCode = code
//                    }
                    
//                    if statusCode == 200 {
                        completionHandler(response, true, nil)
//                    } else {
//                        completionHandler(response, false, APIError.invalidData)
//                    }
                }
            case false:
                completionHandler(nil, false, error)
            }
        }
    }
}
