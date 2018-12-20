//
//  ModelConverter.swift
//  iTube
//
//  Created by Kamaluddin Khan on 23/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation

protocol ModelConverterProtocol {
    static func videoModelToVideo(video: VideoModel) -> Video
    static func videoToVideoModel(video: Video) -> VideoModel
}
