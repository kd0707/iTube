//
//  ReachabilityHandler.swift
//  iTube
//
//  Created by Kamaluddin Khan on 29/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation

protocol ReachabilityStatusHandler {
    func reachabilityStatusChangedHandler(note: Notification)
}
