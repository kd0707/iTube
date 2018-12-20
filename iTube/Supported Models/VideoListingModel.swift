//
//  VideoListingModel.swift
//  iTube
//
//  Created by Kamaluddin Khan on 28/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation
import Alamofire

struct VideoListingModel {
    var videoId: String?
    
    var videoTitle: String?
    
    var videoThumbnail: String?
    
    var videoDescription: String?
    
    var nextPageToken: String?
    
}

extension VideoListingModel {
    init(json: Parameters) {
        //       nextPageToken = videoData?["nextPageToken"] as? String
        let id = json["id"] as? Parameters
        videoId = (id?["videoId"] as? String) == nil ? (json["id"] as? String) : (id?["videoId"]  as? String)
        let snippet = json["snippet"] as? Parameters
        videoTitle = snippet?["title"] as? String
        videoDescription = snippet?["description"] as? String
        let thumbnail = snippet?["thumbnails"] as? Parameters
        let high = thumbnail?["high"] as? Parameters
        videoThumbnail = high?["url"] as? String
    }
}

struct VideoDescription: Decodable {
    var nextPageToken: String
    var item: [VideoListing]
}
struct VideoListing: Decodable {
    
    var snippet: [Snippet]
    var id: String
    
}

struct Snippet: Decodable {
    var title: String
    var description: String
    var thumbnails: String
}
