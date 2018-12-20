//
//  NetworkManagerProtocol.swift
//  iTube
//
//  Created by Kamaluddin Khan on 03/12/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
        func networkStatusChanged(_ notification: Notification)
    static func stopNotifier() -> Void
    static func isReachable(completed: @escaping (NetworkManager) -> Void)
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void)
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void)
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void)
}
