//
//  SearchResultTableViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 27/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
import Reachability
import SVProgressHUD

class SearchResultTableViewController: UITableViewController {
    private var searchResultData = [VideoModel]()
    var keyword:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:-  Cell nib registration
        let customeCellNib = UINib(nibName: RELATED_CELL_IDENTIFIER, bundle: nil)
        tableView.register(customeCellNib, forCellReuseIdentifier: RELATED_CELL_IDENTIFIER)
        tableView.rowHeight = 90
        
        addCancelButton()
        
        // MARK:- Fetching data for table cell
        fetchData()
    }
    
}


extension SearchResultTableViewController {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let relatedCell = tableView.dequeueReusableCell(withIdentifier: RELATED_CELL_IDENTIFIER, for: indexPath) as! RelatedVideoTableViewCell
        relatedCell.setData(data: searchResultData[indexPath.row])
        return relatedCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let playerViewController = storyboard?.instantiateViewController(withIdentifier: PLAYER_VIDEO_CONTROLLER_IDENTITY) as? PlayerViewController {
            let video = searchResultData[indexPath.row]
            playerViewController.videoData = video
            playerViewController.modalPresentationStyle = .overCurrentContext
            navigationController?.pushViewController(playerViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == searchResultData.count - 1{
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            spinner.color = .white
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            if NetworkManager.sharedInstance.reachability.connection != .none {
                fetchData(nexePageToken: searchResultData[indexPath.row].nextPageToken)
            }else{
                Alert.showAlertMessage(vc:self, title: NO_INTERNET, message: CONNECT_TO_NETWORK)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
}


extension SearchResultTableViewController {
    
    //Fetching data from server
    func fetchData(nexePageToken:String? = nil) {
        SVProgressHUD.show()
        guard let keywordForSearch = keyword?.components(separatedBy: CharacterSet.symbols).joined()
            else{
                return
        }
        let modifiedkeywordForSearch = keywordForSearch.replacingOccurrences(of: " ", with: "%20")
        let searchByUrl = APIParameters.q.rawValue + modifiedkeywordForSearch + APIParameters.AND.rawValue
        var url = headUrlForSearch + searchByUrl + tailUrl
        
        if nexePageToken != nil{
            let searchByUrlPart = APIParameters.pageToken.rawValue + nexePageToken! + APIParameters.AND.rawValue
            url = headUrlForSearch + searchByUrlPart + tailUrl
        }
        
        APIHandler.requestForData(url: url) { (error, response) in
            if !error!{
                for item in response! {
                    self.searchResultData.append(item)
                }
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
}

extension SearchResultTableViewController {
    
    func addCancelButton() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTabbed))
        navigationItem.leftBarButtonItem = backButton
    }
    
    //MARK:- navigationBar Cancel button action
    @objc func cancelButtonTabbed(){
        //        self.dismiss(animated: false, completion: nil)
        navigationController?.popViewController(animated: false)
    }
    
}


