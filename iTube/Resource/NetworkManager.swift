
//
//  NetworkManager.swift
//  iTube
//
//  Created by Kamaluddin Khan on 21/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//


import Foundation
import Reachability

class NetworkManager: NSObject, NetworkManagerProtocol {
    
    var reachability: Reachability!
    
    //MARK:- Create a singleton instance
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    
    
    override init() {
        super.init()
        
        //MARK:- Initialise reachability
        reachability = Reachability()!
        
        //MARK:- Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            //MARK:- Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        
        NetworkManager.isReachable { networkManagerInstance in
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                //                guard !(topController is UserTabViewController) else{
                //                return
                //                }
                
                Alert.showAlertMessage(vc: topController, title: INTERNET_CONNECTED, message: WITH_WIFI)
            }
        }
        
        NetworkManager.isUnreachable { networkManagerInstance in
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                Alert.showAlertMessage(vc: topController, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
            }
        }
    }
    
    static func stopNotifier() -> Void {
        do {
            //MARK:- Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    //MARK:- Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    //MARK:- Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    //MARK:- Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    //MARK:- Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
}
