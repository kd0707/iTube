//
//  Player.swift
//  iTube
//
//  Created by Kamaluddin Khan on 20/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation
import youtube_ios_player_helper
import Kingfisher
import SVProgressHUD
enum PlayerParameter: String {
    case controls, playsinline, autohide, showinfo, autoplay, modestbranding
}

class Player: UIView,YTPlayerViewDelegate, PlayerProtocol{
    let ytplayer = YTPlayerView()
    let imageView = UIImageView()
    
    class var shared: Player {
        struct Static {
            static let instance: Player = Player()
        }
        return Static.instance
    }
    
    
    func playerView(x:Double,y:Double,width:Double,height:Double) -> YTPlayerView {
        
        ytplayer.frame = CGRect(x: x, y: y, width: width, height: height)
        return ytplayer
    }
    
    func setData(data:VideoModel) {
        imageView.frame = ytplayer.frame
        imageView.center = ytplayer.center
        if data.videoThumbnail != nil{
            let imagrUrl = URL(string: (data.videoThumbnail)!)
            imageView.kf.setImage(with: imagrUrl)
        }
        imageView.contentMode = .scaleAspectFill
        
        ytplayer.addSubview(imageView)
        ytplayer.delegate = self
        let playVarsDictionary = [PlayerParameter.controls.rawValue: 1, PlayerParameter.playsinline.rawValue: 1, PlayerParameter.autohide.rawValue: 1, PlayerParameter.showinfo.rawValue: 0, PlayerParameter.autoplay.rawValue: 1, PlayerParameter.modestbranding.rawValue: 0]
        if data.videoId != nil{
            ytplayer.load(withVideoId: data.videoId!, playerVars: playVarsDictionary)
        }
        
        
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        print("Play Timeeee",playTime)
        
//        let state = UIApplication.shared.applicationState
//        if state == .background  || state == .inactive{
//            ytplayer.playVideo()
//        }else if state == .active {
//            ytplayer.playVideo()
//        }
        
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        SVProgressHUD.dismiss()
        imageView.isHidden = true
        playerView.playVideo()
        
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
        switch state {
        case .buffering:
            print("buffering")
//        case .playing:
            
        default:
            print("default")
        }
        
    }
    //    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
    //
    //    }
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        
    }
    
    
}

