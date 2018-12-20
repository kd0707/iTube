//
//  RelatedVideoTableViewCell.swift
//  iTube
//
//  Created by Kamaluddin Khan on 14/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
import Kingfisher

class RelatedVideoTableViewCell: UITableViewCell {
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data:VideoModel) {
        titleLabel.text = data.videoTitle
        descriptionLabel.text = data.videoDescription
        if let url = data.videoThumbnail{
            let imagrUrl = URL(string: url)
            videoImage.kf.setImage(with: imagrUrl)
        }
    }
    
    func setDataForRelated(data:Video) {
        titleLabel.text = data.videoTitle
        descriptionLabel.text = data.videoDescription
        if data.videoImageString != nil{
            let imagrUrl = URL(string: data.videoImageString!)
            videoImage.kf.setImage(with: imagrUrl)
        }
    }
}
