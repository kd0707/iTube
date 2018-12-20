//
//  APIHandler.swift
//  iTube
//
//  Created by Kamaluddin Khan on 22/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation
import Alamofire


class APIHandler {
    
    class func requestForData(url: String, completion: @escaping (Bool?,[VideoModel]?)->Void) {
        
        if NetworkConnection.isConnectedToNetwork(){
            var response = [VideoModel]()
            
            Alamofire.request(url).responseJSON { (dataResponse) in
                print("Result: \(dataResponse.result)")
                // response serialization result
                if let json = dataResponse.result.value {
                    let videoData = json as? Parameters
                    
                    guard let videoCatalog = videoData?["items"] as? [Parameters] else{
                        completion(true,nil)
                        return
                    }
                    var video = VideoModel()
                    for videoIteration in videoCatalog{
                        video.nextPageToken = videoData?["nextPageToken"] as? String
                        let id = videoIteration["id"] as? Parameters
                        
                        video.videoId = (id?["videoId"] as? String) == nil ? (videoIteration["id"] as? String) : (id?["videoId"]  as? String)
                        
                        let snippet = videoIteration["snippet"] as? Parameters
                        video.videoTitle = snippet?["title"] as? String
                        video.videoDescription = snippet?["description"] as? String
                        let thumbnail = snippet?["thumbnails"] as? Parameters
                        let high = thumbnail?["high"] as? Parameters
                        video.videoThumbnail = high?["url"] as? String
                        response.append(video)
                    }
                }
                completion(false,response)
            }
        }else{
            completion(true,nil)
        }
    }
    
    
    
}
