//
//  File.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/28/22.
//

import Foundation
import UIKit

enum APIError: Error {
    case invalidData
    case validationError(String)
}

class DataOperation: BaseOperation {
    var cookieRequired:Bool = true
    var parameters: [String: Any]?
    var method: HTTPMethod = .GET
    var header: [String: String]?
    var completionHandler: ServerCallCompletionHandler?
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
            self.executeDataRequest()
        }
    }
    
    func executeDataRequest()  {
        let dataTask : URLSessionDataTask?
        dataTask = APIRequestExecutor().executeAPIRequest(currentOperation: self)
        self.task = dataTask
        dataTask?.resume()
    }
}

extension DataOperation {
    override func task(_ task: URLSessionTask, didCompleteWithError error: Error?) {
        self.finish()
        
        if let taskDescription = task.taskDescription {
            OperationQueueManager.instance.operationsDictionary?.removeValue(forKey: taskDescription)
        }
        if error == nil {
            if (self.responseData != nil) {
                do {
                    let json = try JSONSerialization.jsonObject(with: self.responseData!, options: []) as? [String : Any]
                    if let json = json {
                        if let message = json["message"] as? String, message == "The incoming token has expired" {
                            print("API response - TokenExpired fetch new token")
                            AmplifyLoginUtility.fetchAuthToken { authStatus in
                                switch authStatus {
                                case .authenticationFailed:
                                    DispatchQueue.main.async {
                                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                            appDelegate.showAlertAndLogOut()
                                        }
                                    }
                                    break
                                case .authenticationSuccess(_, _):
                                    self.completionHandler!(json, true, nil)
                                    break
                                }
                            }
                        } else {
                            self.completionHandler!(json, true, nil)
                        }
                    } else {
                        print("DataTask while parsing the json")
                        self.completionHandler!(nil, false, APIError.invalidData)
                    }
                } catch {
                    print("DataTask failed with error: \(error.localizedDescription)")
                    self.completionHandler!(nil, false, error)
                }
            } else {
                print("Response data is nil")
                self.completionHandler!(nil, false, error)
            }
        } else {
            print("DataTask failed with error:\(String(describing: error?.localizedDescription)) ")
            self.completionHandler!(nil, false, error)
        }
    }
}

