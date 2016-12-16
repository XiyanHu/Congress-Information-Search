//
//  senateViewController.swift
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

var senateRes = [[String : AnyObject]]()


class senateViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

    @IBOutlet var senateTable: UITableView!
    let searchControllerS = UISearchController(searchResultsController:nil)
    var filterMembersS = [[String : AnyObject]]()
    var searchIcon = "search"
    let btnNames = UIButton()
    
    func filterContextForSearch(searchText:String){
        
        filterMembersS = senateRes.filter{ member in
            let fnameMatch = (member["first_name"] as? String)?.lowercased().range(of: searchText.lowercased()) != nil
            let lnameMatch = (member["last_name"] as? String)?.lowercased().range(of: searchText.lowercased()) != nil
            return fnameMatch || lnameMatch
        }
        
        self.senateTable.reloadData()
    }
    
    func updateSearchResults(for searchControllerS: UISearchController){
        filterContextForSearch(searchText: searchControllerS.searchBar.text!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        senateTable.dataSource = self
        senateTable.delegate = self
        
        btnNames.setImage(UIImage(named: searchIcon), for: .normal)
        btnNames.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        btnNames.addTarget(self, action: Selector("operateSearchBar"), for: .touchUpInside)
        
        let searchButton = UIBarButtonItem()
        searchButton.customView = btnNames
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
        
        for member in allDataForDetail {
            if (member["chamber"] as? String  == "senate"){
                senateRes.append(member)
            }
            
        }
        
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = false
        searchControllerS.searchResultsUpdater = self
        searchControllerS.dimsBackgroundDuringPresentation = false
        
        self.navigationController?.definesPresentationContext = false
        self.searchControllerS.hidesNavigationBarDuringPresentation = false
    
        self.tabBarController?.navigationItem.title = "Legislators"
        senateTable.reloadData()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func operateSearchBar(){
        print("yes!")
        if (searchIcon == "search"){
            searchIcon = "cancel"
            btnNames.setImage(UIImage(named: searchIcon), for: .normal)
            btnNames.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let searchButtonS = UIBarButtonItem()
            searchButtonS.customView = btnNames
            self.tabBarController?.navigationItem.rightBarButtonItem = searchButtonS
            
            searchControllerS.searchBar.isHidden = false
            searchControllerS.searchBar.showsCancelButton = false
            self.tabBarController?.navigationItem.titleView = searchControllerS.searchBar
            //      self.tabBarController?.navigationItem.titleView = nil
        }
        else if (searchIcon == "cancel"){
            searchIcon = "search"
            btnNames.setImage(UIImage(named: searchIcon), for: .normal)
            btnNames.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let searchButtonS = UIBarButtonItem()
            searchButtonS.customView = btnNames
            self.tabBarController?.navigationItem.rightBarButtonItem = searchButtonS
            
            searchControllerS.searchBar.isHidden = true
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.title = "Legislators"
            
        }
        
        
    }

    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonSenateCell")!
        
        
        
        var dict = senateRes[(indexPath as NSIndexPath).row]
        if searchControllerS.isActive && searchControllerS.searchBar.text != ""{
            dict =  filterMembersS[(indexPath as NSIndexPath).row]
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
    //    cell.imageView?.sd_setImage(with: NSURL(string: headImgUrl) as? URL)
        let urltemp = NSURL(string: headImgUrl)
        let datatemp = NSData(contentsOf: urltemp! as URL)
        if datatemp != nil {
            let imagetemp = UIImage(data: datatemp! as Data)
            cell.imageView?.image = imagetemp
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchControllerS.isActive && searchControllerS.searchBar.text != ""{
            return filterMembersS.count
        }

        return senateRes.count
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SwiftSpinner.show(duration:0.5, title:"Fetching data...")
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Legislators"
        btnNames.setImage(UIImage(named: "search"), for: .normal)
        btnNames.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let searchButtonS = UIBarButtonItem()
        searchButtonS.customView = btnNames
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButtonS
        searchControllerS.searchBar.showsCancelButton = false
        searchControllerS.searchBar.text! = ""

    }
    
    //senateToLegiDetail
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "senateToLegiDetail", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "senateToLegiDetail") {
            if let destination = segue.destination as? LegiDetailViewController{
                let path = senateTable.indexPathForSelectedRow!
                let cell = senateTable.cellForRow(at: path as IndexPath)

                destination.passedName = (cell?.textLabel?.text!)!
                destination.passedState = (cell?.detailTextLabel?.text!)!
                destination.passedData = allDataForDetail
           
            }
        }
    }

    



}
