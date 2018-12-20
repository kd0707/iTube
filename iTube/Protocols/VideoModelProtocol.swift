//
//  File.swift
//  iTube
//
//  Created by Kamaluddin Khan on 16/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation

protocol VideoModelProtocol {
    var videoId:String? {set get}
    var videoTitle:String? {set get}
    var videoThumbnail:String? {set get}
    var videoDescription:String? {set get}
    var nextPageToken:String? {set get}
}
