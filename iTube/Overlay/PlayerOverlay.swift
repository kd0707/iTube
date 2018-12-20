//
//  PlayerOverlay.swift
//  iTube
//
//  Created by Kamaluddin Khan on 19/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import Foundation
import youtube_ios_player_helper
import Kingfisher

class PlayerOverlay:UIView, PlayerOverlayProtocol {
    var overlayView = UIView()
    var playerView = YTPlayerView()
    var titleLabel = UILabel()
    var overlayButton = UIButton()
    var dismissButton = UIButton()
    var data = VideoModel()
    var posterImage = UIImageView()
    var dataDic = [String:String]()
    
    class var shared: PlayerOverlay {
        struct Static {
            static let instance: PlayerOverlay = PlayerOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(data:VideoModel) {
        //        data = id
        if let window = appDelegate.window {
            //MARK:-Setting Frame
            overlayView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 64)
            overlayButton.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width - 70, height: overlayView.bounds.height)
            dismissButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            titleLabel.frame = CGRect(x: 0, y: 0, width: overlayView.frame.width - 70, height: 30)
            playerView = Player.shared.playerView(x: 0, y: 0, width:112, height: Double(overlayView.bounds.height))
            posterImage.frame = CGRect(x: 0, y: 0, width:112, height: Double(playerView.bounds.height))
            //MARK:- Setting center point
            overlayView.center = CGPoint(x: window.frame.width / 2.0, y:  -40)
            titleLabel.center = CGPoint(x: overlayView.frame.width/2  + 100, y: overlayView.frame.height/2)
            dismissButton.center = CGPoint(x: overlayView.frame.width - 15, y: 10)
            overlayButton.center = CGPoint(x: 205, y: overlayView.frame.height)
            posterImage.center = playerView.center
            
            PlayerOverlay.shared.posterImage.isHidden = false
            overlayView.clipsToBounds = true
            overlayView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            titleLabel.textColor = UIColor.white
            
            dismissButton.setBackgroundImage(UIImage(named: DISSMISS_IMAGE_NAME), for: .normal)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            titleLabel.text = data.videoTitle
            overlayButton.backgroundColor = UIColor.clear
            setImageInView(data: data)
            overlayView.addSubview(posterImage)
            overlayView.addSubview(playerView)
            overlayView.addSubview(titleLabel)
            overlayView.addSubview(overlayButton)
            overlayView.addSubview(dismissButton)
            window.addSubview(overlayView)
            overlayButton.addTarget(self, action: #selector(viewTabbedAction), for: .allEvents)
            dismissButton.addTarget(self, action: #selector(dismissButonTabbed), for: .touchUpInside)
        }
    }
    
    public func hideOverlayView() {
        overlayView.removeFromSuperview()
    }
    
    @objc func viewTabbedAction(){
        hideOverlayView()
        PlayerOverlay.shared.posterImage.isHidden = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: OVERLAY_TABBED_NOTIFIER), object: nil)
    }
    
    @objc func dismissButonTabbed() {
        hideOverlayView()
    }
    
    func setImageInView(data:VideoModel){
        if let url = data.videoThumbnail{
            let imagrUrl = URL(string: url)
            posterImage.kf.setImage(with: imagrUrl)
        }
        
    }
}
