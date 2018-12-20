//
//  ModelViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 16/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit

class ViewControllerPannable: UIViewController {
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    var dataDic:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
        
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        //        PlayerOverlay.shared.showOverlay(id: VideoModel(), currentTime: 0.0)
        let translation = panGesture.translation(in: view)
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: translation.x,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            if velocity.y >= 150 {
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil,userInfo:nil)
                
                self.dismiss(animated: false, completion: nil)
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height - 0.8
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalIsDimissed"), object: nil,userInfo:nil)
                        
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}




