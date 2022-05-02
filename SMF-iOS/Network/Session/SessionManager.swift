//
//  SessionManager.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/28/22.
//

import Foundation

@objc protocol BaseSessionCompletionDelegate {
    func task(_ task: URLSessionTask, didReceiveProgress progress: Float, totalBytesWritten: Int64, fileSize: Int64)
    func task(_ task: URLSessionTask, didFinishDownloadingTo location: URL?, error: Error?)
    func task(_ task: URLSessionTask, didCompleteWithError error: Error?)
}

enum SessionType {
    case defaultSession
    case background
    case ephemeral
}


class SessionManager: NSObject {
    static let instance = SessionManager()
    
    var defaultSession: URLSession?
    var backgroundSession: URLSession?
    var backgroundCompletionHandler: (() -> Void)?
    
    private override init() {
        super.init()
        self.defaultSession = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        self.backgroundSession = URLSession.init(configuration: URLSessionConfiguration.background(withIdentifier: "com.media_upload_download_manager"), delegate: self, delegateQueue: nil)
    }
}

// MARK: - URLSession Delegate
extension SessionManager: URLSessionDelegate {
    // Informs the delegate that all messages enqueued for a session have been delivered
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("background session \(session) finished events.")
        
        DispatchQueue.main.async {
            self.backgroundCompletionHandler?()
            self.backgroundCompletionHandler = nil
        }
    }
}

// MARK: - URLSession Data Delegate
extension SessionManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("didReceivedata called")
        
        if let taskDescription = dataTask.taskDescription,
           let currentOperation = OperationQueueManager.instance.operationsDictionary?[taskDescription] {
            let currentOpertaion = currentOperation as! BaseOperation
            if currentOpertaion.responseData == nil {
                currentOpertaion.responseData = Data.init()
                currentOpertaion.responseData?.append(data)
            } else {
                currentOpertaion.responseData?.append(data)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("didCompleteWithError")
        
        if let taskDescription = task.taskDescription,
           let currentOperation = OperationQueueManager.instance.operationsDictionary?[taskDescription] {
            let currentOperation = currentOperation as? BaseOperation
            if let currentOperation = currentOperation {
                currentOperation.task(task, didCompleteWithError: error)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        
        if let taskDescription = task.taskDescription, let currentOperation = OperationQueueManager.instance.operationsDictionary?[taskDescription] {
            let currentOperation = currentOperation as? BaseOperation
            
            currentOperation?.task(task, didReceiveProgress: uploadProgress, totalBytesWritten: totalBytesSent, fileSize: totalBytesExpectedToSend)
        }
    }
}

// MARK: -  Download Task Delegates
extension SessionManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("File is Downloaded to location: \(location)")
        
        if let taskDescription = downloadTask.taskDescription,
           let currentOperation = OperationQueueManager.instance.operationsDictionary?[taskDescription] {
            let currentOperation = currentOperation as? BaseOperation
            currentOperation?.task(downloadTask, didFinishDownloadingTo: location, error: nil)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        print("totalBytesExpectedToWrite => \(totalBytesExpectedToWrite)")
        
        if let taskDescription = downloadTask.taskDescription,
           let currentOperation = OperationQueueManager.instance.operationsDictionary?[taskDescription] {
            let currentOpertaion = currentOperation as! BaseOperation
            
            let templateZipUrl = "url"//Constant.AppUrl.templateZip
            if templateZipUrl == currentOpertaion.identifier {
                let downloadProgress = (Float(totalBytesWritten)/(1000000)>1.0 ? 1.0 : Float(totalBytesWritten)/(1000000))
                currentOpertaion.task(downloadTask, didReceiveProgress: downloadProgress, totalBytesWritten: totalBytesWritten, fileSize: 1000000)
            } else {
                let downloadProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
                currentOpertaion.task(downloadTask, didReceiveProgress: downloadProgress, totalBytesWritten: totalBytesWritten, fileSize: totalBytesExpectedToWrite)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("fileOffset => \(fileOffset)")
    }
}
