//
//  OperationQueueManager.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/28/22.
//

import Foundation

enum OperationQueueType: String {
    case data = "dataOperationQueue"
    case uploadMedia = "uploadMediaQueue"
    case downloadMedia = "downloadMediaQueue"
    
    fileprivate func suspend(_ state: Bool) {
        switch self {
        case .data:
            OperationQueueManager.instance.dataQueue.isSuspended = state
        case .uploadMedia:
            OperationQueueManager.instance.uploadMediaQueue.isSuspended = state
        case .downloadMedia:
            OperationQueueManager.instance.downloadMediaQueue.isSuspended = state
        }
    }
    
    fileprivate func cancelAllOperations() {
        switch self {
        case .data:
            OperationQueueManager.instance.dataQueue.cancelAllOperations()
        case .uploadMedia:
            OperationQueueManager.instance.uploadMediaQueue.cancelAllOperations()
        case .downloadMedia:
            OperationQueueManager.instance.downloadMediaQueue.cancelAllOperations()
        }
    }
    
    fileprivate func getCurrentOperationQueue() -> OperationQueue?{
        switch self {
        case .data:
            return OperationQueueManager.instance.dataQueue
        case .uploadMedia:
            return OperationQueueManager.instance.uploadMediaQueue
        case .downloadMedia:
            return OperationQueueManager.instance.downloadMediaQueue
        }
    }
}


class OperationQueueManager {
    static let instance = OperationQueueManager()
    
    /// Operation Queue to manage all API related operation
    fileprivate var dataQueue: OperationQueue
    fileprivate var uploadMediaQueue: OperationQueue
    fileprivate var downloadMediaQueue: OperationQueue
    
    var operationsDictionary: [String: BaseSessionCompletionDelegate]?
    
    private init() {
        self.dataQueue = OperationQueue()
        self.uploadMediaQueue = OperationQueue()
        self.downloadMediaQueue = OperationQueue()
        
        self.dataQueue.maxConcurrentOperationCount = 1
        self.uploadMediaQueue.maxConcurrentOperationCount = 1
        self.downloadMediaQueue.maxConcurrentOperationCount = 1
        
        self.operationsDictionary = [String: BaseSessionCompletionDelegate]()
    }
    
    /// Add new Operation in existing OperationQueue
    func addOperation(newOperation: BaseOperation) {
        if let currentOperationQueue = newOperation.operationQueueType.getCurrentOperationQueue() {
            var operationFound = false
            
            for operation in currentOperationQueue.operations {
                if let op = operation as? BaseOperation {
                    if op.identifier == newOperation.identifier {
                        operationFound = true
                        break;
                    }
                } else {
                    assertionFailure("Operation must be subclass of BaseOperation")
                }
            }
            
            if !operationFound {
                currentOperationQueue.addOperation(newOperation)
            }
            print("\(newOperation.operationQueueType.rawValue) Count=>\(String(describing: currentOperationQueue.operationCount))")
        }
    }
    
    /// Suspend all operation added in queue
    func suspendOperationQueue(of type: OperationQueueType, state: Bool) {
        type.suspend(state)
    }
    
    /// Suspend all operation added in queue
    func cancelOperationQueue(of type: OperationQueueType, state: Bool) {
        type.cancelAllOperations()
    }
    
    /// Suspend all queue operations
    func suspendAllOperationQueue(_ state: Bool) {
        self.dataQueue.isSuspended = state
        self.uploadMediaQueue.isSuspended = state
        self.downloadMediaQueue.isSuspended = state
    }
    
    /// Cancel all queue operations
    func cancelAllOperations(){
        self.dataQueue.cancelAllOperations()
        self.uploadMediaQueue.cancelAllOperations()
        self.downloadMediaQueue.cancelAllOperations()
    }
}
