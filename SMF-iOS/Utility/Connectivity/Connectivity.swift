//
//  Connectivity.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 4/25/22.
//

import Foundation
import Reachability

class Connectivity {
    static let shared = Connectivity()
    
    var isConnected: Bool {
        get {
            if reachability.connection != .unavailable {
                print("Connected by: \(reachability.connection)")
                return true
            } else {
                return false
            }
        }
    }
    
    private var reachability: Reachability
    
    private init() {
        reachability = try! Reachability(hostname: "google.com")
    }
    
    deinit {
        reachability.stopNotifier()
    }
    
    func startNotifier() {
        addListener()
    }
    
    func stopNotifier() {
        reachability.stopNotifier()
    }
    
    private func addListener() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                NotificationCenter.default.post(name: .networkConnection, object: nil, userInfo: ["connectivity": true, "connectionType": "wifi"])
            } else {
                NotificationCenter.default.post(name: .networkConnection, object: nil, userInfo: ["connectivity": true, "connectionType": "cellular"])
            }
        }
        
        reachability.whenUnreachable = { reachability in
            NotificationCenter.default.post(name: .networkConnection, object: nil, userInfo: ["connectivity": false])
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start network reachability")
        }
    }
}
