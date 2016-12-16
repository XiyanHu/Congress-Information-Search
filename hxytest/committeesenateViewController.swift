//
//  committeesenateViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/24.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftSpinner

var allDataForComSenateDetail = [[String : AnyObject]]()

class committeesenateViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating, UISearchBarDelegate {
    
     var arrRes = [[String:AnyObject]]() //Array of dictionary
    @IBOutlet var comSenateTable: UITableView!
    
    let searchController = UISearchController(searchResultsController:nil)
    var filterMembersCS = [[String : AnyObject]]()
    var searchIcon = "search"
    let btnNameh = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comSenateTable.dataSource = self
        comSenateTable.delegate = self
        
        btnNameh.setImage(UIImage(named: searchIcon), for: .normal)
        btnNameh.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        btnNameh.addTarget(self, action: Selector("operateSearchBar"), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
        
        let searchButton = UIBarButtonItem()
        searchButton.customView = btnNameh
       
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        self.tabBarController?.navigationItem.title = "Committees"

        
        
        
        Alamofire.request("http://104.198.0.197:8080/committees?&chamber=senate&apikey=a7f9b14e379e4735bcec3569f9fa73b8&per_page=all").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let resultsPart = swiftyJsonVar["results"]
                if var resData = resultsPart.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    let dataDiscriptor = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
                    resData = (self.arrRes as NSArray).sortedArray(using: [dataDiscriptor])
                    
                    
                    self.arrRes = resData as! [[String:AnyObject]]
                    allDataForComSenateDetail = self.arrRes
                    
                    
                    
                }
                if self.arrRes.count > 0 {
                    self.comSenateTable.reloadData()
                }
            }
            
        }
    }
    func filterContextForSearch(searchText:String){
        
        filterMembersCS = arrRes.filter{ member in
            
            let titleMatch = (member["name"] as? String)?.lowercased().range(of: searchText.lowercased()) != nil
           
            return titleMatch
        }
        print(filterMembersCS)
        self.comSenateTable.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController){
        filterContextForSearch(searchText: searchController.searchBar.text!)
    }
    
    func operateSearchBar(){
        print("yes!")
        if (searchIcon == "search"){
            searchIcon = "cancel"
            btnNameh.setImage(UIImage(named: searchIcon), for: .normal)
            btnNameh.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let searchButton = UIBarButtonItem()
            searchButton.customView = btnNameh
            self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
            
            searchController.searchBar.isHidden = false
            searchController.searchBar.showsCancelButton = false
            self.tabBarController?.navigationItem.titleView = searchController.searchBar
            
        }
        else if (searchIcon == "cancel"){
            searchIcon = "search"
            btnNameh.setImage(UIImage(named: searchIcon), for: .normal)
            btnNameh.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let searchButton = UIBarButtonItem()
            searchButton.customView = btnNameh
            self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
            
            searchController.searchBar.isHidden = true
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.title = "Committees"
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        SwiftSpinner.show(duration:0.5, title:"Fetching data...")
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Committees"
        btnNameh.setImage(UIImage(named: "search"), for: .normal)
        btnNameh.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let searchButtonS = UIBarButtonItem()
        searchButtonS.customView = btnNameh
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButtonS
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.text! = ""
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comSenateCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "comSenateCell")!
        
        var dict = arrRes[(indexPath as NSIndexPath).row]
        if  searchController.searchBar.text != ""{
            dict =  filterMembersCS[(indexPath as NSIndexPath).row]
            
        }

        
        comSenateCell.textLabel?.text = dict["name"] as? String
        comSenateCell.detailTextLabel?.text = dict["committee_id"] as? String
        return comSenateCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  searchController.searchBar.text != ""{
            return filterMembersCS.count
        }
        return self.arrRes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
     //   SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "commSenateToDetail", sender: self)
            
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("123")
        
        if (segue.identifier == "commSenateToDetail") {
            if let destination = segue.destination as? CommitteesDetailViewController{
                let path = comSenateTable.indexPathForSelectedRow!
                let cell = comSenateTable.cellForRow(at: path as IndexPath)
          
                destination.passedCommId = (cell?.detailTextLabel?.text)!
                destination.passedData = allDataForComSenateDetail
            }
        }
    }

    

    
    

}
