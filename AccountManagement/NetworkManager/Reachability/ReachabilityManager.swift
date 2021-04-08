//
//  ReachabilityManager.swift
//  NetworkManagerDemo
//
//  Created by Sunil Kumar on 14/03/21.
//  Copyright © 2021 Sunil Kumar. All rights reserved.

import UIKit
import Reachability 

protocol ReachabilityManagerDelegate: NSObjectProtocol {
    func networkStatusDidChnaged(_ isReachable: Bool)
}

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    private let reachability = try! Reachability()
    
    var isReachable: Bool!
    weak var delegate: ReachabilityManagerDelegate?
    
    override init() {
        super.init()
        isReachable = reachability.connection != .unavailable
    }
    
    func startListening() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self.isReachable = true
            self.delegate?.networkStatusDidChnaged(true)
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.isReachable = false
            self.delegate?.networkStatusDidChnaged(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopListening() {
        reachability.stopNotifier()
    }
    
}
