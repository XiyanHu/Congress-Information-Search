//
//  activebillViewController.swift
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

var allDataForABillDetail = [[String : AnyObject]]()
var allDataForBillDetail = [[String : AnyObject]]()
var billpdf :JSON=nil


class activebillViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating, UISearchBarDelegate {
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary

    
    @IBOutlet var activeBillTable: UITableView!
  
    let searchController = UISearchController(searchResultsController:nil)
    var filterMembers = [[String : AnyObject]]()
    var searchIcon = "search"
    let btnNameh = UIButton()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeBillTable.dataSource = self
        activeBillTable.delegate = self
        
      //  allDataForBillDetail = allDataForABillDetail + allDataForNBillDetail
        
        
        btnNameh.setImage(UIImage(named: searchIcon), for: .normal)
        btnNameh.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        btnNameh.addTarget(self, action: Selector("operateSearchBar"), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
         SwiftSpinner.show("Fetching data...")
        let searchButton = UIBarButtonItem()
        searchButton.customView = btnNameh
        // navigationController?.navigationItem.
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false

        self.tabBarController?.navigationItem.title = "Bills"

        
        
        
        
        Alamofire.request("http://104.198.0.197:8080/bills?history.active=true&apikey=a7f9b14e379e4735bcec3569f9fa73b8&per_page=50").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let resultsPart = swiftyJsonVar["results"]
              //  let haha = resultsPart[0]["urls"][]
                billpdf = resultsPart
                
                
                if var resData = resultsPart.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    let dataDiscriptor = NSSortDescriptor(key: "introduced_on", ascending: false, selector: #selector(NSString.caseInsensitiveCompare(_:)))
                    resData = (self.arrRes as NSArray).sortedArray(using: [dataDiscriptor])
                    
                    self.arrRes = resData as! [[String:AnyObject]]
                    allDataForABillDetail = self.arrRes
                }
                if self.arrRes.count > 0 {
                    self.activeBillTable.reloadData()
                }
            }
            
        }
    
    }
    
    
    func filterContextForSearch(searchText:String){
        
        filterMembers = arrRes.filter{ member in
            
            let titleMatch = (member["official_title"] as? String)?.lowercased().range(of: searchText.lowercased()) != nil
            return titleMatch
        }
        self.activeBillTable.reloadData()
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
            self.tabBarController?.navigationItem.title = "Bills"
            
        }
        
        
    }

    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Bills"
        btnNameh.setImage(UIImage(named: "search"), for: .normal)
        btnNameh.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let searchButtonS = UIBarButtonItem()
        searchButtonS.customView = btnNameh
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButtonS
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.text! = ""

        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aBillCell = activeBillTable.dequeueReusableCell(withIdentifier: "activeBillCell", for: indexPath) as! activeBillTableViewCell
        var dict = arrRes[(indexPath as NSIndexPath).row]
        if searchController.isActive && searchController.searchBar.text != ""{
            dict =  filterMembers[(indexPath as NSIndexPath).row]
        }

        aBillCell.topLabel?.text = dict["bill_id"] as? String
        aBillCell.textLabel?.text = dict["bill_id"] as? String
        aBillCell.textLabel?.isHidden = true
        aBillCell.midLabel?.text = dict["official_title"] as? String
        
        let  introducedOn = dict["introduced_on"] as? String
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
     //   let months = dateFormatter.shortMonthSymbols
        let showDate = inputFormatter.date(from: introducedOn!)
        inputFormatter.dateFormat = "dd MMM yyyy"
        
        let resultString = inputFormatter.string(from: showDate!)
        
        aBillCell.bottomLabel?.text = resultString
         SwiftSpinner.hide()
        return aBillCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  searchController.searchBar.text != ""{
            return filterMembers.count
        }
      
        return self.arrRes.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
       // SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "activeToDetail", sender: self)
            
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "activeToDetail") {
            if let destination = segue.destination as? billDetailViewController{
                let path = activeBillTable.indexPathForSelectedRow!
                let cell = activeBillTable.cellForRow(at: path as IndexPath)
                
                destination.passedBillId = (cell?.textLabel?.text)!
                destination.passedData = allDataForABillDetail
                passedIsActive = true
                // print(allDataForDetail)
            }
        }
    }

    
    
    
    
    
    
    
}
