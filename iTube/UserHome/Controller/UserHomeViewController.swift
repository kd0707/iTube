//
//  UserHomeViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 13/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import SVProgressHUD
import Alamofire
import CoreData
import Reachability
import UserNotifications

class UserHomeViewController: UIViewController {
    @IBOutlet weak var videoListTableView: UITableView?
    
    private var videoList = [VideoModel]()
    private var favouriteButtonImageNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Total Space",DiskStatus.totalDiskSpace)

        print("Free Space",DiskStatus.freeDiskSpace)
        
        
        do {
            try fetchResultController.performFetch()
        }catch {
            print("Fetch failed")
        }
        
        //MARK:- cell nib registration
        let customeCellNib = UINib(nibName: CUSTOME_CELL_IDENTITY, bundle: nil)
        videoListTableView?.register(customeCellNib, forCellReuseIdentifier: CUSTOME_CELL_IDENTITY)
        
        //requesting for authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            
        })
        
        fetchDataFromLocal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //MARK:- Overlay Notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(notificationOverlayTabbedHandler(data:)), name: NSNotification.Name(rawValue: OVERLAY_TABBED_NOTIFIER), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Logout action
    @IBAction func logOutAction(_ sender: Any) {
        PlayerOverlay.shared.hideOverlayView()
        GIDSignIn.sharedInstance()?.signOut()
        UserDefaults.standard.set(false, forKey: LOGINSTATUS)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyBoard.instantiateViewController(withIdentifier: LOGIN_VIEW_CONTROLLER_IDENTITY) as? LoginViewController {
            appDelegate.window?.rootViewController = loginViewController
        }
    }
    
    //MARK:- Search button action
    @IBAction func searchButtonTabbed(_ sender: Any) {
        if let videoSearchController = storyboard?.instantiateViewController(withIdentifier: NAVIGATION_CONTROLLER_IDENTITY) as? UINavigationController{
            let transition = CATransition()
            transition.duration = 0.0
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear)
            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(videoSearchController, animated: false, completion: nil)
            PlayerOverlay.shared.hideOverlayView()
        }
    }
    
    //Fetch Result Controller instance
    fileprivate lazy var fetchResultController: NSFetchedResultsController<Video> = {
        var fetchRequest = NSFetchRequest<Video>(entityName: VIDEO_ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: VIDEO_ID, ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
}


//MARK:- Tableview delegate and data source function
extension UserHomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customeCell = videoListTableView?.dequeueReusableCell(withIdentifier: CUSTOME_CELL_IDENTITY) as! CustomeTableViewCell
        let video = videoList[indexPath.row]
        customeCell.delegate = self
        let favouriteImageName = favouriteButtonImageNameArray[indexPath.row]
        customeCell.setData(data: video, favouriteButtonImageName: favouriteImageName)
        return customeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  NetworkConnection.isConnectedToNetwork(){
            let video = videoList[indexPath.row]
            PlayerOverlay.shared.showOverlay(data: video)
            
            if let playerViewController = storyboard?.instantiateViewController(withIdentifier: PLAYER_VIDEO_CONTROLLER_IDENTITY) as? PlayerViewController {
                playerViewController.videoData = video
                playerViewController.modalPresentationStyle = .fullScreen
                //                modalPresentationStyle = .overCurrentContext
                present(playerViewController, animated: true, completion: nil)
            }
        } else {
            Alert.showAlertMessage(vc: self, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
        }
        videoListTableView?.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == videoList.count - 3{
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            spinner.color = .white
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(66))
            videoListTableView?.tableFooterView = spinner
            videoListTableView?.tableFooterView?.isHidden = false
            fetchDataFromServer(nextPageToken: videoList[indexPath.row].nextPageToken!)
        }
    }
    
}


//MARK:- FetchResultController Delegate function
extension UserHomeViewController: NSFetchedResultsControllerDelegate{
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        videoListTableView?.reloadData()
    }
    
}


extension UserHomeViewController{
    
    //MARK:- fetching data from local
    func fetchDataFromLocal(){
        if let fetchedLocalData = fetchResultController.fetchedObjects {
            if fetchedLocalData.count > 0 {
                for item in fetchedLocalData{
                    if item.favourite {
                        favouriteButtonImageNameArray.append(FAVOURITE_IMAGE_SELECTED)
                    }else {
                        favouriteButtonImageNameArray.append(FAVOURITE_IMAGE_BLACK)
                    }
                    videoList.append(ModelConverter.videoToVideoModel(video: item))
                }
            } else {
                Alert.showAlertMessage(vc: self, title: "No Data Found", message: "Logout and Login again")
                
            }
        }
        videoListTableView?.reloadData()
        print(videoList)
    }
    
    //MARK:- Fetching data from server
    func fetchDataFromServer(nextPageToken: String) {
        let searchByUrlPart = APIParameters.pageToken.rawValue + nextPageToken + APIParameters.AND.rawValue + APIParameters.videoCategoryId.rawValue + VIDEO_CATEGORY_ID + APIParameters.AND.rawValue
        let url = headUrlForSearch + searchByUrlPart + tailUrl
        APIHandler.requestForData(url: url) { (error, response) in
            if !(error!){
                for item in response!{
                    self.videoList.append(item)
                    self.favouriteButtonImageNameArray.append(FAVOURITE_IMAGE_BLACK)
                }
            }
            self.videoListTableView?.reloadData()
        }
    }
    
}


extension UIViewController {
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-100, width: self.view.frame.size.width, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

extension UserHomeViewController: NotificationHandlerProtocol {
    
    //MARK:- OverlayView notifcation handler
    @objc func notificationOverlayTabbedHandler(data:Notification){
        if let playerViewController = storyboard?.instantiateViewController(withIdentifier: PLAYER_VIDEO_CONTROLLER_IDENTITY) as? PlayerViewController {
            playerViewController.modalPresentationStyle = .fullScreen
            present(playerViewController, animated: true, completion: nil)
        }
    }
    
}

extension UserHomeViewController: CustomeTableViewCellDelegate {
    
    //MARK:- CustomeTableViewCell delegate method
    func didTapOnfavouriteButtonT(imageName: UIImage, cell: UITableViewCell) {
        guard let tappedIndexPath = videoListTableView?.indexPath(for: cell) else{return}
        if imageName == UIImage(named: FAVOURITE_IMAGE_SELECTED) {
            favouriteButtonImageNameArray[tappedIndexPath.row] = FAVOURITE_IMAGE_BLACK
            self.showToast(message: "Removed from Favourite List")
            
        } else {
            favouriteButtonImageNameArray[tappedIndexPath.row] = FAVOURITE_IMAGE_SELECTED
            self.showToast(message: "Saved in Favourite List")
        }
        videoListTableView?.reloadRows(at: [tappedIndexPath], with: .none)
    }
    
}
