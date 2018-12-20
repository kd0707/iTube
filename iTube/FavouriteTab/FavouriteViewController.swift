//
//  FavouriteViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 15/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {
    @IBOutlet weak var favouriteListTableView: UITableView?
    private var favouriteData = [VideoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customeCellNib = UINib(nibName: RELATED_CELL_IDENTIFIER, bundle: nil)
        favouriteListTableView?.register(customeCellNib, forCellReuseIdentifier: RELATED_CELL_IDENTIFIER)
        do {
            try fetchResultController.performFetch()
        } catch  {
            debugPrint(exception.self)
        }
        fetchFavouriteData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //MARK:- Overlay Notification observer
        NotificationCenter.default.addObserver(self, selector: #selector(notificationOverlayTabbedHandler(data:)), name: NSNotification.Name(rawValue: OVERLAY_TABBED_NOTIFIER), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:Fetch Result Controller
    fileprivate lazy var fetchResultController: NSFetchedResultsController<Video> = {
        var fetchRequest = NSFetchRequest<Video>(entityName: VIDEO_ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: VIDEO_ID, ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
}


//MARK:- TableView Delegates
extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let relatedVideoTableViewCell = favouriteListTableView?.dequeueReusableCell(withIdentifier: RELATED_CELL_IDENTIFIER) as! RelatedVideoTableViewCell
        let data = favouriteData[indexPath.row]
        relatedVideoTableViewCell.setData(data: data)
        return relatedVideoTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playerViewController = storyboard?.instantiateViewController(withIdentifier:  PLAYER_VIDEO_CONTROLLER_IDENTITY) as! PlayerViewController
        playerViewController.videoData = favouriteData[indexPath.row]
        self.present(playerViewController, animated: true, completion: nil)
        favouriteListTableView?.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteDataFromFavourite(row: indexPath.row)
        default:
            print("Nothing edited")
        }
    }
    
}

//MARK:- FetchResultcontroller Delegates Method
extension FavouriteViewController: NSFetchedResultsControllerDelegate{
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        fetchFavouriteData()
        favouriteListTableView?.reloadData()
    }
    
}

extension FavouriteViewController{
    
    //MARK:- Fetching favourite data
    private func fetchFavouriteData(){
        favouriteData = []
        if let fetchedLocalData = fetchResultController.fetchedObjects {
            for item in fetchedLocalData {
                if item.favourite == true{
                    var video = VideoModel()
                    video = ModelConverter.videoToVideoModel(video: item)
                    favouriteData.append(video)
                }
            }
        }
        if favouriteData.count <= 0  {
            let noDataLabel = UILabel()
            noDataLabel.center = view.center
            noDataLabel.font = UIFont.boldSystemFont(ofSize: 26.0)
            noDataLabel.text = "No Video in Favourite List"
            noDataLabel.textAlignment = .center
            favouriteListTableView?.backgroundView = noDataLabel
        } else {
            favouriteListTableView?.backgroundView = nil
        }
        favouriteListTableView?.reloadData()
    }
    
    //Delete from Favourite list
    func deleteDataFromFavourite(row: Int) {
        let fetched = fetchResultController.fetchedObjects
        for item in fetched!{
            if item.videoId == favouriteData[row].videoId{
                    item.favourite = false
                    appDelegate.saveContext()
                    favouriteListTableView?.reloadData()
                    return
            }
        }
    }
    
}

extension FavouriteViewController: NotificationHandlerProtocol {
    
    //MARK:- OverlayView notifcation handler
    @objc func notificationOverlayTabbedHandler(data:Notification){
        if let playerViewController = storyboard?.instantiateViewController(withIdentifier: PLAYER_VIDEO_CONTROLLER_IDENTITY) as? PlayerViewController {
            playerViewController.modalPresentationStyle = .overCurrentContext
            present(playerViewController, animated: true, completion: nil)
        }
    }
    
}
