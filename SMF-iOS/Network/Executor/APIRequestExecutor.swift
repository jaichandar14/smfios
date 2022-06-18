//
//  WebRequestExecutor.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/28/22.
//

import Foundation

enum HTTPMethod {
    case GET
    case POST
    case PUT
    case DELETE
}

typealias ServerCallCompletionHandler = (_ response: [String:Any]?, _ result: Bool, _ error: Error?) -> Void
typealias DownloadCompletionHandler = (_ location: URL?, _ error: Error?) -> ()
typealias Progress = (_ progress: Float, _ totalBytesWritten: Int64, _ fileSize: Int64) -> ()
 
class APIRequestExecutor {
    func executeAPIRequest(currentOperation: DataOperation) -> URLSessionDataTask {
        if currentOperation.cookieRequired {
            Cookie.instance.deleteCookie(of: SessionManager.instance.defaultSession!)
            Cookie.instance.setCookie(to: SessionManager.instance.defaultSession!)
        } else {
            Cookie.instance.deleteCookie(of: SessionManager.instance.defaultSession!)
        }
        
        let request = self.createRequest(with: currentOperation.url, parameters: currentOperation.parameters, method: currentOperation.method, header: currentOperation.header)
        let dataRequest = SessionManager.instance.defaultSession!.dataTask(with: request)
        dataRequest.taskDescription = currentOperation.identifier
        if OperationQueueManager.instance.operationsDictionary != nil {
            OperationQueueManager.instance.operationsDictionary?[dataRequest.taskDescription!] = currentOperation
        } else {
            assertionFailure("Operation dictionary has deallocated hence it does not have tasks")
        }
        
        return dataRequest
    }
    
    /// Create request
    private func createRequest(with urlString: String,
                               parameters: [String:Any]?,
                               method: HTTPMethod,
                               header: [String:String]?) -> URLRequest{
        
        var request: URLRequest
        let url = URL(string: urlString)!
        
        request = URLRequest(url: url)
        request.cachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        request.httpMethod = String(describing: method)
        
        if let header = header {
            request.allHTTPHeaderFields = header
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        print("URL Request:\(urlString)")
        print("Parameters:\(parameters?.printPrettyJSON())")
        switch method {
        case .GET:
//            if let param = parameters {
//                let jsonString = self.createJsonString(parameter: param)
//                let url = urlString + "?" + jsonString
//                request.url = URL.init(string: url)
//            }
            request.url = createURLRequest(url: urlString, parameters: parameters)
            
        case .POST, .PUT, .DELETE:
            do {
                if let params = parameters{
                    let data = try JSONSerialization.data(withJSONObject: params, options: [])
//                    let jsonString = String.init(data: data, encoding: .utf8)
//                    let url = ["data": jsonString]
//                    let data1 = try JSONSerialization.data(withJSONObject: url, options: [])
                    request.httpBody =  data
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return request
    }
    
    private func createURLRequest(url: String, parameters: [String: Any]?) -> URL? {
        if let params = parameters {
            let urlComp = NSURLComponents(string: url)
            var items = [URLQueryItem]()
            params.forEach { (key: String, value: Any) in
                if value is Int {
                    items.append(URLQueryItem(name: key, value: "\(value)"))
                } else {
                    items.append(URLQueryItem(name: key, value: value as? String))
                }
            }
            
            if !items.isEmpty {
                urlComp?.queryItems = items
            }
            
            return urlComp?.url
        } else {
            return URL(string: url)
        }
    }
    
    /// This method accepts a dictionary and creates json string
    func createJsonString(parameter dict: [String:Any]) -> String {
        
        if JSONSerialization.isValidJSONObject(dict) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions())
                
                var safeCharacterSet = NSCharacterSet.urlQueryAllowed
                safeCharacterSet.remove(charactersIn: "&=")
                safeCharacterSet.remove(charactersIn: "+=")
                
                if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)?.addingPercentEncoding(withAllowedCharacters: safeCharacterSet) {
                    return jsonString as String
                }
            } catch let JSONError as NSError {
                print("\(JSONError)")
            }
        }
        return ""
    }
}
