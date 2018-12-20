//
//  VideoModel.swift
//  iTube
//
//  Created by Kamaluddin Khan on 15/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation
import Alamofire


struct VideoModel:VideoModelProtocol {
    
    var videoId: String?
    
    var videoTitle: String?
    
    var videoThumbnail: String?
    
    var videoDescription: String?
    
    var nextPageToken: String?
    
}

extension VideoModel {
    init(json:Parameters) {
        
        
    }
}

