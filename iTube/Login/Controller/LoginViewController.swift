//
//  ViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 12/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import SVProgressHUD
import youtube_ios_player_helper
import CoreData
import Reachability
//import FBSDKCoreKit
//import FBSDKLoginKit
//import FirebaseAuth


class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let service = GTLRYouTubeService()
    private let scopes = [kGTLRAuthScopeYouTubeReadonly]
    private var videoListData = [VideoModel]()
    private var flag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        perforFetch()
        updateLocalDatabase()
    }
    
    //MARK:- Create FetchResultController
    fileprivate lazy var fetchedResultController: NSFetchedResultsController<Video> = {
        var fetchRequest = NSFetchRequest<Video>(entityName: VIDEO_ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: VIDEO_ID, ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    @IBAction func googleLoginButtonTabbed(_ sender: Any) {
        googleSignInAction()
    }
    
    //MARK:- Sign in action
    func googleSignInAction(){
        if NetworkManager.sharedInstance.reachability.connection != .none {
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().scopes = scopes
            GIDSignIn.sharedInstance()?.signIn()
        }else{
            Alert.showAlertMessage(vc: self, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
        }
    }
}

//MARK:- Google SignIn Delegates
extension LoginViewController: GIDSignInDelegate, GIDSignInUIDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            Alert.showAlertMessage(vc: self, title: AUTHENTICATION_ERROR, message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            UserDefaults.standard.set(true, forKey: LOGINSTATUS)
            fetchLocationResource(location: LOCATION)
        }
    }
    
    func fetchLocationResource(location:String){
        SVProgressHUD.show()
        
        let query = GTLRYouTubeQuery_SearchList.query(withPart: SNIPPET)
        query.location = location
        query.locationRadius = LOCATION_RADIUS
        query.q = Q
        query.type = TYPE
        query.regionCode = REGION_CODE
        query.maxResults = 50
        service.executeQuery(query, delegate: self, didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
        
    }
    
    @objc func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_SearchListResponse,
        error : NSError?) {
        
        if let error = error {
            SVProgressHUD.dismiss()
            Alert.showAlertMessage(vc: self,title: ERROR_TITLE, message: error.localizedDescription)
            return
        }
        //
        if let channels = response.items, !channels.isEmpty {
            //            for item in channels{
            //                var videoDetail = VideoModel()
            //                videoDetail.videoId = item.identifier?.videoId
            //                videoDetail.videoTitle = item.snippet?.title
            //                videoDetail.videoThumbnail = item.snippet?.thumbnails?.high?.url
            //                videoDetail.videoDescription = item.snippet?.descriptionProperty
            ////                videoDetail.nextPageToken = response.nextPageToken
            //                videoListDetail.append(videoDetail)
            //            }
            
            let userTabViewController = storyboard?.instantiateViewController(withIdentifier: TAB_VIEW_CONTROLLER_IDENTIFIER) as! UserTabViewController
            self.present(userTabViewController, animated: true, completion: nil)
            //            print("Kamal",videoListDetail)
            SVProgressHUD.dismiss()
        }
    }
}


extension LoginViewController{
    
    //MARK:- Update local database
    func updateLocalDatabase(){
        let searchByUrl =  APIParameters.chart.rawValue + MOST_POPULAR + APIParameters.AND.rawValue + APIParameters.regionCode.rawValue + REGION_CODE + APIParameters.AND.rawValue //+  APIParameters.videoCategoryId.rawValue + VIDEO_CATEGORY_ID + APIParameters.AND.rawValue
        let url = headUrlForVideos + searchByUrl + tailUrl
        
        if  flag == 0{
            APIHandler.requestForData(url: url) { (error, response) in
                if error!{
                    Alert.showAlertMessage(vc:self, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
                    return
                }else{
                    if let response = response{
                        for item in response{
                            if self.checkDuplicacy(data: item){
                                var video = Video()
                                video = ModelConverter.videoModelToVideo(video: item)
                                video.favourite = false
                                appDelegate.saveContext()
                            }
                        }
                        self.flag = 1
                    }
                }
            }
        }else {
            Alert.showAlertMessage(vc: self, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
        }
    }
    
    //MARK:- Performing FetchResultController
    func perforFetch(){
        do {
            try fetchedResultController.performFetch()
        }catch {
            print("Fetch failed")
        }
    }
    
    //MARK:- Chcek dublicacy in local database
    func checkDuplicacy(data:VideoModel) -> Bool{
        if let fetched = fetchedResultController.fetchedObjects{
            for item in fetched{
                if item.videoId == data.videoId!{
                    return false
                }
            }
        }
        return true
    }
}

extension LoginViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
            
        }
    }
    
}




