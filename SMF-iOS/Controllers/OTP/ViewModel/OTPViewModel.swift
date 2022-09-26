//
//  OTPViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/1/22.
//

import Foundation

class OTPViewModel {
    func loginAPIFailed(id: String, method: HTTPMethod, parameters: [String: Any]?, priority: Operation.QueuePriority?, completionHandler: @escaping ServerCallCompletionHandler) {
        APIManager().executeDataRequest(id: id, url: APIConfig.loginFailure, method: method, parameters: parameters, header: nil, cookieRequired: false, priority: priority ?? .normal, queueType: .data) { response, result, error in
            switch result {
            case true:
                do {
                    completionHandler(response, true, nil)
                }
            case false:
                completionHandler(nil, false, error)
            }
        }
    }
}
