//
//  APIManager.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/29/22.
//

import Foundation

class APIManager {
    func executeDataRequest(id: String, url: String, method: HTTPMethod, parameters: [String: Any]?, header: [String: String]?, cookieRequired: Bool, priority: Operation.QueuePriority?, queueType: OperationQueueType? = nil, completionHandler: @escaping ServerCallCompletionHandler) {
        let operation = DataOperation(identifier: id, url: url)
        operation.taskType = .data
        operation.cookieRequired = cookieRequired
        operation.parameters = parameters
        operation.method = method
        operation.operationQueueType = queueType ?? .data
        operation.header = header
        operation.queuePriority = priority ?? .normal
        operation.completionHandler = completionHandler
        OperationQueueManager.instance.addOperation(newOperation: operation)
    }
}
