//
//  FavouriteViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 14/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Alamofire
import SVProgressHUD
import Kingfisher


class PlayerViewController: UIViewController {
    @IBOutlet weak var playerView: UIView?
    @IBOutlet weak var videoTitleLabel: UILabel?
    @IBOutlet weak var videoDescriptionLabel: UILabel?
    @IBOutlet weak var videoTableView: UITableView?
    private var player = YTPlayerView()
    private var thumbnailImageView = UIImageView()
    private var window = UIWindow()
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var originalPosition: CGPoint?
    
    var videoData:VideoModel?
    private var relatedVideoData = [VideoModel]()
    private var nextPageToken:String?
    private static var data = VideoModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        window = (appDelegate.window)!
        
        //Panable Initialization
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
        
        navigationController?.navigationBar.isHidden = true
        
        player.delegate = self
        
        //MARK:- Cell Nib registration
        let customeCellNib = UINib(nibName: RELATED_CELL_IDENTIFIER, bundle: nil)
        videoTableView?.register(customeCellNib, forCellReuseIdentifier: RELATED_CELL_IDENTIFIER)
        videoTableView?.rowHeight = 88
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //MARK:- Adding PlayerView on view
        addPlayerInView()
        
        //MARK:- Setting data to player
        if videoData != nil{
            Player.shared.setData(data: videoData!)
            fetchRelatedVideoData(videoId: (videoData?.videoId)!)
            PlayerViewController.data = videoData!
            
        }else{
            player.playVideo()
            if PlayerViewController.data.videoId != nil{
                fetchRelatedVideoData(videoId: PlayerViewController.data.videoId!)
            }
        }
        videoTitleLabel?.text = PlayerViewController.data.videoTitle
        videoDescriptionLabel?.text = PlayerViewController.data.videoDescription
    }
    
    //MARK:- Back Button Action
    @IBAction func backButtonTabbed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- Table Delegates and datasource
extension PlayerViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedVideoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let relatedVideoTableViewCell = videoTableView?.dequeueReusableCell(withIdentifier: RELATED_CELL_IDENTIFIER) as! RelatedVideoTableViewCell
        
        if let _ = relatedVideoData[indexPath.row].videoId {
            let videoItem = relatedVideoData[indexPath.row]
            relatedVideoTableViewCell.setData(data:videoItem)
        }
        return relatedVideoTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if NetworkConnection.isConnectedToNetwork(){
            tableView.isUserInteractionEnabled = false
            SVProgressHUD.setBackgroundColor(.clear)
            SVProgressHUD.setForegroundColor(.white)
            SVProgressHUD.show()
            let videoData = relatedVideoData[indexPath.row]
            if videoData.videoId != nil {
                PlayerViewController.data = videoData
                Player.shared.setData(data: videoData)
                PlayerOverlay.shared.showOverlay(data: videoData)
                addPlayerInView()
                fetchRelatedVideoData(videoId: videoData.videoId)
            }
        }else{
            Alert.showAlertMessage(vc: self, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return RELATED_VIDEO
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == relatedVideoData.count - 2{
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            spinner.color = .white
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            videoTableView?.tableFooterView = spinner
            videoTableView?.tableFooterView?.isHidden = false
            if NetworkConnection.isConnectedToNetwork(){
                fetchRelatedVideoData(videoId: nil, nextPageToken: relatedVideoData[indexPath.row].nextPageToken)
                
            }else{
                Alert.showAlertMessage(vc:self, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = true
    }
    
    @objc func reLoadData() {
        videoTableView?.reloadData()
    }
    
}


extension PlayerViewController {
    
    //MARK:- Fetch data from server
    func  fetchRelatedVideoData(videoId:String? = nil, nextPageToken:String? = nil) {
        var url = String()
        if  videoId != nil{
            relatedVideoData = []
            let searchByUrlPart = APIParameters.relatedToVideoId.rawValue + videoId! + APIParameters.AND.rawValue
            url = headUrlForSearch + searchByUrlPart + tailUrl
        }
        if  nextPageToken != nil{
            let searchByUrlPart = APIParameters.pageToken.rawValue + nextPageToken! + APIParameters.AND.rawValue
            url = headUrlForSearch + searchByUrlPart + tailUrl
        }
        APIHandler.requestForData(url: url) { (error, response) in
            if error! {
                Alert.showAlertMessage(vc: self, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
            }else{
                if let response = response{
                    for item in response{
                        self.relatedVideoData.append(item)
                    }
                    self.videoTableView?.reloadData()
                }
            }
        }
    }
    
}


extension PlayerViewController {
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
    }
    
    //Orientation changes action
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation{
        case .portrait:
            player = Player.shared.playerView(x: 0, y: 0, width: Double(window.bounds.width), height: 225)
            panGestureRecognizer?.isEnabled = true
            text = "portait"
        case .portraitUpsideDown:
            player = Player.shared.playerView(x: 0, y: 0, width: Double(window.bounds.width), height: 225)
        case .landscapeLeft:
            panGestureRecognizer?.isEnabled = false
            player = Player.shared.playerView(x: 0, y: 0, width: Double((appDelegate.window?.bounds.width)!), height: Double((appDelegate.window?.bounds.height)!))
        case .landscapeRight:
            panGestureRecognizer?.isEnabled = false
            player = Player.shared.playerView(x: 0, y: 0, width: Double((appDelegate.window?.bounds.width)!), height: Double((appDelegate.window?.bounds.height)!))
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
    }
    
}


extension PlayerViewController{
    
    //PanGesture Action
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        PlayerOverlay.shared.showOverlay(data: PlayerViewController.data)
        view.addSubview(PlayerOverlay.shared.overlayView)
        //        let screenshotOfPlayer = screenshot()
        //        PlayerOverlay.shared.posterImage.image = screenshotOfPlayer
        self.addPlayerInView()
        let translation = panGesture.translation(in: view)
        print("translation \(translation)")
        if translation.y >= view.frame.height - 300 {
            smallOverlayPlayer()
            self.dismiss(animated: false, completion: nil)
        }
        
        if panGesture.state == .began{
            originalPosition = view.center
            
        } else if panGesture.state == .changed || panGesture.state == .began {
            view.frame.origin = CGPoint(
                x: translation.x,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            
            let velocity = panGesture.velocity(in: view)
            print("End translation\(translation.y)","view height\(view.frame.height)")
            if velocity.y >= 1500 {
                smallOverlayPlayer()
                self.dismiss(animated: false, completion: nil)
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height - 0.8
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.addPlayerInView()
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
    
}


extension PlayerViewController{
    
    //MARK:- Setting small overlay player frame
    private func smallOverlayPlayer() {
        PlayerOverlay.shared.showOverlay(data: PlayerViewController.data)
        PlayerOverlay.shared.overlayView.center = CGPoint(x: window.frame.width / 2.0, y: window.frame.height - 85)
        PlayerOverlay.shared.posterImage.isHidden = true
        window.addSubview(PlayerOverlay.shared.overlayView)
    }
    
    //MARK:- Add player on view function
    func addPlayerInView() {
        player = Player.shared.playerView(x: 0, y: 0, width: Double(playerView?.frame.width ?? 0), height: Double(playerView?.frame.height ?? 0))
        player.center = CGPoint(x: (playerView?.frame.width ?? 0)/2, y: (playerView?.frame.height ?? 0)/2)
        playerView?.addSubview(player)
    }
    
    //MARK:- Setting image in ImageView function
    func setImageInImageView(){
        if videoData?.videoThumbnail != nil{
            let imagrUrl = URL(string: (videoData?.videoThumbnail)!)
            thumbnailImageView.kf.setImage(with: imagrUrl )
        }
    }
    
    //MARK:- Registering cell nib function
    func cellNibRegistration() {
        let customeCellNib = UINib(nibName: RELATED_CELL_IDENTIFIER, bundle: nil)
        videoTableView?.register(customeCellNib, forCellReuseIdentifier: RELATED_CELL_IDENTIFIER)
    }
    
    //MARK:- Taking screenshot of player
    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(player.frame.size, false, 0);
        player.drawHierarchy(in: player.bounds, afterScreenUpdates: true)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension PlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        player.playVideo()
    }
}
