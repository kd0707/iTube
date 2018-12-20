//
//  TableViewController.swift
//  iTube
//
//  Created by Kamaluddin Khan on 26/11/18.
//  Copyright © 2018 Kamaluddin Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class VideoSearchController: UITableViewController {
    
    var searchController = UISearchController(searchResultsController: nil)
    private var searchSuggetionArray = [String]()
    private var searchedKeywordArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- Searchbar Adding
        serachBarSetup()
        
    }
    
    @IBAction func cancelButtonTabbed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        super.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let time = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.searchController.searchBar.becomeFirstResponder()
        }
        if  (UserDefaults.standard.stringArray(forKey: SEARCH_HISTORY_KEY)) != nil{
            searchedKeywordArray = UserDefaults.standard.stringArray(forKey: SEARCH_HISTORY_KEY)!
            searchSuggetionArray = searchedKeywordArray
            tableView.reloadData()
        }
    }
    
}


extension VideoSearchController {
    
    // MARK: - Table view data source and delegates
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchSuggetionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchTableViewCell = tableView.dequeueReusableCell(withIdentifier: SEARCH_TABLE_VIEW_CELL_IDENTITY) as! SearchTableViewCell
        searchTableViewCell.worldLabel.text = searchSuggetionArray[indexPath.row]
        return searchTableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.endEditing(true)
        searchedKeywordResult(searchedKeyword: searchSuggetionArray[indexPath.row])
    }
    
}



extension VideoSearchController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    //MARK:- Update search result delegates
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            if searchSuggetionArray.count > 0{
                let filteredSearchSuggetionArray = searchSuggetionArray.filter {$0.lowercased().contains(searchText.lowercased())}
                searchSuggetionArray = filteredSearchSuggetionArray
                tableView.reloadData()
            }
            let modifiedSearchText = searchText.replacingOccurrences(of: " ", with: "%20")
            suggessionAPIHandeler(searchString: modifiedSearchText)
            self.tableView.reloadData()
        }else{
            if (UserDefaults.standard.stringArray(forKey: SEARCH_HISTORY_KEY)) != nil{
                searchSuggetionArray = UserDefaults.standard.stringArray(forKey: SEARCH_HISTORY_KEY)!
            }
            
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
}


extension VideoSearchController {
    
    //MARK:-  Suggetion data fetch
    func suggessionAPIHandeler(searchString:String)  {
        let url = suggessionHeadUrl + searchString + APIParameters.AND.rawValue + APIParameters.key.rawValue + API_KEY  + suggessionTailUrl
        Alamofire.request(url).responseJSON { (dataResponse) in
            print(dataResponse.result)
            let nsArray = dataResponse.result.value as? NSArray
            if let data = nsArray?[1] as? NSArray {
                for item in data{
                    if let value = item as? NSArray {
                        print(value[0])
                        self.searchSuggetionArray.append(value[0] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK:- Saving searched history
    func saveRecentSearch(keyword: String) {
        if (UserDefaults.standard.stringArray(forKey: SEARCH_HISTORY_KEY)) != nil{
            searchedKeywordArray = UserDefaults.standard.stringArray(forKey: SEARCH_HISTORY_KEY)!
        }
        if searchedKeywordArray.contains(keyword){
            return
        }
        if searchedKeywordArray.count >= 15 {
            searchedKeywordArray.remove(at: 0)
        }
        searchedKeywordArray.append(HISTORY_CLOCK_SYMBOL + keyword)
        UserDefaults.standard.setValue(searchedKeywordArray, forKey: SEARCH_HISTORY_KEY)
        print(searchedKeywordArray)
    }
    
    //MARK:- On search result function
    func searchedKeywordResult(searchedKeyword: String){
        if let searchResultTableViewController = storyboard?.instantiateViewController(withIdentifier: SERCH_VIEW_CONTROLLER_INDENTITY) as? SearchResultTableViewController {
            let data = searchedKeyword
            searchResultTableViewController.keyword = data
            navigationController?.pushViewController(searchResultTableViewController, animated: true)
            SVProgressHUD.show()
            saveRecentSearch(keyword: data)
        }
    }
    
    //MARk:- SearchBarController Setting
    func serachBarSetup() {
        searchController.searchBar.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationItem.titleView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        self.searchController.delegate = self
        searchController.searchBar.placeholder = SEARCH_BAR_PLACEHOLDER
        searchController.isActive = true
    }
    
}
