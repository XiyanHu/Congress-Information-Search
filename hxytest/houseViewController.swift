//
//  houseViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/23.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SwiftSpinner

var houseRes = [[String : AnyObject]]()

class houseViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{
    

    @IBOutlet var houseTable: UITableView!
    
    let searchController = UISearchController(searchResultsController:nil)
    var filterMembers = [[String : AnyObject]]()
    var searchIcon = "search"
     let btnNameh = UIButton()
    
    func filterContextForSearch(searchText:String){
        
        filterMembers = houseRes.filter{ member in
 
            let fnameMatch = (member["first_name"] as? String)?.lowercased().range(of: searchText.lowercased()) != nil
            let lnameMatch = (member["last_name"] as? String)?.lowercased().range(of: searchText.lowercased()) != nil
            return fnameMatch || lnameMatch
        }
        houseTable.reloadData()
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController){

        filterContextForSearch(searchText: searchController.searchBar.text!)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
            

        
        houseTable.dataSource = self
        houseTable.delegate = self
        btnNameh.setImage(UIImage(named: searchIcon), for: .normal)
        btnNameh.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        btnNameh.addTarget(self, action: Selector("operateSearchBar"), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
      
        let searchButton = UIBarButtonItem()
        searchButton.customView = btnNameh
       // navigationController?.navigationItem.
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
        
        for member in allDataForDetail {
            if (member["chamber"] as? String  == "house"){
                houseRes.append(member)
            }
            
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false

        self.tabBarController?.navigationItem.title = "Legislators"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                self.tabBarController?.navigationItem.title = "Legislators"
        
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonHouseCell")!
        
        
           var dict = houseRes[(indexPath as NSIndexPath).row]
        if searchController.isActive && searchController.searchBar.text != ""{
                dict =  filterMembers[(indexPath as NSIndexPath).row]
        }
                cell.textLabel?.text = dict["last_name"] as? String
                var str = (cell.textLabel?.text)!
                cell.textLabel?.text = dict["first_name"] as? String
                str = str+","+(cell.textLabel?.text)!
                cell.textLabel?.text = str
        
                cell.detailTextLabel?.text = dict["state_name"] as? String
        
        let bioguide_id = (dict["bioguide_id"] as? String)!
                let headImgUrl = "https://theunitedstates.io/images/congress/225x275/"+bioguide_id+".jpg"
                // let headImgUrl = "http://cs-server.usc.edu:45678/hw/hw8/images/d.png"
               // cell.imageView?.sd_setImage(with: NSURL(string: headImgUrl) as? URL)
        let urltemp = NSURL(string: headImgUrl)
        let datatemp = NSData(contentsOf: urltemp! as URL)
        if datatemp != nil {
            let imagetemp = UIImage(data: datatemp! as Data)
            cell.imageView?.image = imagetemp
        }

      
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return filterMembers.count
        }
        
        return houseRes.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show(duration:0.5, title:"Fetching data...")
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Legislators"
        btnNameh.setImage(UIImage(named: "search"), for: .normal)
        btnNameh.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let searchButtonS = UIBarButtonItem()
        searchButtonS.customView = btnNameh
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButtonS
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.text! = ""
        
    }

    //houseToLegiDetail
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "houseToLegiDetail", sender: self)
            
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("123")
        
        if (segue.identifier == "houseToLegiDetail") {
            if let destination = segue.destination as? LegiDetailViewController{
                let path = houseTable.indexPathForSelectedRow!
                let cell = houseTable.cellForRow(at: path as IndexPath)
                destination.passedName = (cell?.textLabel?.text!)!
                destination.passedState = (cell?.detailTextLabel?.text!)!
   
            }
        }
    }

    
    
    
    
}
