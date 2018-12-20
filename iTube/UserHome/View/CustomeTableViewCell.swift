//
//  CustomeTableViewCell.swift
//  YoutubeDemo
//
//  Created by Kamaluddin Khan on 13/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
import  CoreData
import Kingfisher

protocol CustomeTableViewCellDelegate {
    func didTapOnfavouriteButtonT(imageName: UIImage, cell: UITableViewCell)
}

class CustomeTableViewCell: UITableViewCell {
    var delegate: CustomeTableViewCellDelegate?
    
    @IBOutlet weak var favouriteButton: UIButton?
    @IBOutlet weak var channelImage: UIImageView?
    @IBOutlet weak var videoThumbnailImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    var videoData = VideoModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        performFetchResultController()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Favourite Button Action
    @IBAction func favouriteButtonAction(_ sender: UIButton) {
        self.delegate?.didTapOnfavouriteButtonT(imageName: sender.backgroundImage(for: .normal)!, cell: self)

        DispatchQueue.global().async {
            self.saveDataInFavourite()
        }
    }
    
    //MARK:- Fetch resultcontroller initialisation
    fileprivate lazy var fetchResultController: NSFetchedResultsController<Video> = {
        var fetchRequest = NSFetchRequest<Video>(entityName: VIDEO_ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: VIDEO_ID, ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    //Setting data to cell element
    func setData(data:VideoModel, favouriteButtonImageName: String) {
        videoData =  data
        favouriteButton?.setBackgroundImage(UIImage(named: favouriteButtonImageName), for: .normal)
        titleLabel?.text = data.videoTitle
        descriptionLabel?.text = data.videoDescription
        
        if data.videoThumbnail != nil {
            let imagrUrl = URL(string: (data.videoThumbnail)!)
            if (try? Data(contentsOf: imagrUrl!)) != nil{
                channelImage?.kf.setImage(with: imagrUrl)
                videoThumbnailImageView?.kf.setImage(with: imagrUrl)
            }
        }
    }
    
    //Favourite database update
    func saveDataInFavourite() {
        let fetched = self.fetchResultController.fetchedObjects
        for item in fetched!{
            if item.videoId == self.videoData.videoId!{
                if item.favourite{
                    item.favourite = false
                    DispatchQueue.main.async {
                    appDelegate.saveContext()
                    }
                    return
                }else {
                    item.favourite = true
                     DispatchQueue.main.async {
                    appDelegate.saveContext()
                    }
                    return
                }
            }
        }
        var video = Video()
        video = ModelConverter.videoModelToVideo(video: self.videoData)
        video.favourite = true
        appDelegate.saveContext()
        print("Saved......................")
        
        
    }
    
    //MARK:- Setting image in imageview function
    func setImageInView(data:Video){
        if let url = data.videoImageString{
            let imagrUrl = URL(string: url)
            channelImage?.kf.setImage(with: imagrUrl)
            videoThumbnailImageView?.kf.setImage(with: imagrUrl)
        }
    }
    
    //MARK:- PerformFetch
    func performFetchResultController() {
        do {
            try fetchResultController.performFetch()
            
        } catch  {
            print("Fetch Failed")
        }
    }
    
}
