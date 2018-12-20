//
//  ModelConverter.swift
//  iTube
//
//  Created by Kamaluddin Khan on 23/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation

class ModelConverter: ModelConverterProtocol {
    
    static func videoModelToVideo(video: VideoModel) -> Video {
        print(video.videoId)
        let videoData = Video(context: appDelegate.persistentContainer.viewContext)
        videoData.videoId = video.videoId
        videoData.videoImageString = video.videoThumbnail
        videoData.nextPageToken = video.nextPageToken
        videoData.videoDescription = video.videoDescription
        videoData.videoTitle = video.videoTitle
        return videoData
    }
    
    static func videoToVideoModel(video: Video) -> VideoModel {
        var videoModelData = VideoModel()
        videoModelData.videoId = video.videoId
        videoModelData.videoThumbnail = video.videoImageString
        videoModelData.nextPageToken = video.nextPageToken
        videoModelData.videoDescription = video.videoDescription
        videoModelData.videoTitle = video.videoTitle
        return videoModelData
    }
    
}
