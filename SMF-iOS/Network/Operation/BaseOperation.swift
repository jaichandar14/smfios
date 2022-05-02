//
//  BaseOperation.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/28/22.
//

import Foundation

enum TaskType {
    case upload
    case download
    case data
    case resumeDownload
}

class BaseOperation: Operation {
    var identifier: String
    var url: String
    var progress: Progress?
    var responseData: Data?
    var taskType: TaskType?
    var task: URLSessionTask? = URLSessionTask()
    var sessionType: SessionType?
    var operationQueueType: OperationQueueType = .data
    
    override var isAsynchronous: Bool { return true }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        var keyPath: String { return "is" + self.rawValue }
    }
    
    init(identifier: String, url: String) {
        self.identifier = identifier
        self.url = url
    }
    
    final func finish() {
        if isExecuting {
            self.task = nil
            state = .finished
        }
    }
    
    override func cancel() {
        super.cancel()
        
        if isExecuting {
            if self.task is URLSessionDataTask ||
                self.task is URLSessionUploadTask ||
                self.task is URLSessionDownloadTask {
                self.task?.cancel()
            }
            state = .finished
        }
    }
}

extension BaseOperation: BaseSessionCompletionDelegate {
    func task(_ task: URLSessionTask, didReceiveProgress progress: Float, totalBytesWritten: Int64, fileSize: Int64) {
        
    }
    
    func task(_ task: URLSessionTask, didFinishDownloadingTo location: URL?, error: Error?) {
        
    }
    
    func task(_ task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
}
