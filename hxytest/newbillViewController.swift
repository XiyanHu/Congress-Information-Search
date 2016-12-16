//
//  newbillViewController.swift
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


var allDataForNBillDetail = [[String : AnyObject]]()
var billpdfNew :JSON=nil

class newbillViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating, UISearchBarDelegate  {
    
    var arrResNew = [[String:AnyObject]]()
    
    
    
    @IBOutlet var newBillTable: UITableView!
    
    
    
    let searchControllerNew = UISearchController(searchResultsController:nil)
    var filterMembersNew = [[String : AnyObject]]()
    var searchIcon = "search"
    let btnNamenew = UIButton()


    

    override func viewDidLoad() {
        super.viewDidLoad()
        newBillTable.dataSource = self
        newBillTable.delegate = self
        
        btnNamenew.setImage(UIImage(named: searchIcon), for: .normal)
        btnNamenew.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        
        btnNamenew.addTarget(self, action: Selector("operateSearchBar"), for: .touchUpInside)
         SwiftSpinner.show("Fetching data...")
        //.... Set Right/Left Bar Button item
        
        let searchButton = UIBarButtonItem()
        searchButton.customView = btnNamenew
        // navigationController?.navigationItem.
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
        
        searchControllerNew.searchResultsUpdater = self
        searchControllerNew.dimsBackgroundDuringPresentation = false
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.definesPresentationContext = true
        self.searchControllerNew.hidesNavigationBarDuringPresentation = false
        
        self.tabBarController?.navigationItem.title = "Bills"

        
        
        Alamofire.request("http://104.198.0.197:8080/bills?history.active=false&apikey=a7f9b14e379e4735bcec3569f9fa73b8&per_page=50").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let resultsPart = swiftyJsonVar["results"]
                billpdfNew = resultsPart
                if var resData = resultsPart.arrayObject {
                    self.arrResNew = resData as! [[String:AnyObject]]
                    
                    let dataDiscriptor = NSSortDescriptor(key: "introduced_on", ascending: false, selector: #selector(NSString.caseInsensitiveCompare(_:)))
                    resData = (self.arrResNew as NSArray).sortedArray(using: [dataDiscriptor])
                    
                    self.arrResNew = resData as! [[String:AnyObject]]
                    allDataForNBillDetail = self.arrResNew
                }
                if self.arrResNew.count > 0 {
                    self.newBillTable.reloadData()
                }
            }
            
        }
    }
    
    
    func filterContextForSearch(searchText:String){
        
        filterMembersNew = arrResNew.filter{ member in
            let titleMatch = (member["official_title"] as? String)?.lowercased().range(of: searchText.lowercased()) != nil
            // print(titleMatch)
            return titleMatch
        }
        self.newBillTable.reloadData()
    }
    
    func updateSearchResults(for searchControllerNew: UISearchController){
      //  print(searchControllerNew.searchBar.text!)
        filterContextForSearch(searchText: searchControllerNew.searchBar.text!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func operateSearchBar(){
        print("yes!")
        if (searchIcon == "search"){
            searchIcon = "cancel"
            btnNamenew.setImage(UIImage(named: searchIcon), for: .normal)
            btnNamenew.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let searchButton = UIBarButtonItem()
            searchButton.customView = btnNamenew
            self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
            
            searchControllerNew.searchBar.isHidden = false
            searchControllerNew.searchBar.showsCancelButton = false
            self.tabBarController?.navigationItem.titleView = searchControllerNew.searchBar
            
        }
        else if (searchIcon == "cancel"){
            searchIcon = "search"
            btnNamenew.setImage(UIImage(named: searchIcon), for: .normal)
            btnNamenew.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            let searchButton = UIBarButtonItem()
            searchButton.customView = btnNamenew
            self.tabBarController?.navigationItem.rightBarButtonItem = searchButton
            
            searchControllerNew.searchBar.isHidden = true
            self.tabBarController?.navigationItem.titleView = nil
            self.tabBarController?.navigationItem.title = "Bills"
            
        }
        
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        
        let nBillCell = newBillTable.dequeueReusableCell(withIdentifier: "newBillCell", for: indexPath) as! activeBillTableViewCell
        
        
        var dict = arrResNew[(indexPath as NSIndexPath).row]
     //   print(filterMembersNew.count)
        if searchControllerNew.isActive && searchControllerNew.searchBar.text != ""{
            dict =  filterMembersNew[(indexPath as NSIndexPath).row]
        }
        
      //  print(dict)
        nBillCell.topLabel?.text = dict["bill_id"] as? String
        nBillCell.textLabel?.text = dict["bill_id"] as? String
        nBillCell.textLabel?.isHidden = true
        nBillCell.midLabel?.text = dict["official_title"] as? String
        
        let  introducedOn = dict["introduced_on"] as? String
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        //   let months = dateFormatter.shortMonthSymbols
        let showDate = inputFormatter.date(from: introducedOn!)
        inputFormatter.dateFormat = "dd MMM yyyy"
        
        let resultString = inputFormatter.string(from: showDate!)
        
        nBillCell.bottomLabel?.text = resultString
         SwiftSpinner.hide()
        return nBillCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(searchControllerNew.isActive)
        print(filterMembersNew.count)
        if   searchControllerNew.searchBar.text != ""{
            return filterMembersNew.count
        }

        return self.arrResNew.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        
        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Bills"
        btnNamenew.setImage(UIImage(named: "search"), for: .normal)
        btnNamenew.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let searchButtonS = UIBarButtonItem()
        searchButtonS.customView = btnNamenew
        self.tabBarController?.navigationItem.rightBarButtonItem = searchButtonS
        searchControllerNew.searchBar.showsCancelButton = false
        searchControllerNew.searchBar.text! = ""
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
   //     SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "newToDetail", sender: self)
            
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      //  print("123")
        
        if (segue.identifier == "newToDetail") {
            if let destination = segue.destination as? billDetailViewController{
                let path = newBillTable.indexPathForSelectedRow!
                let cell = newBillTable.cellForRow(at: path as IndexPath)
                destination.passedBillId = (cell?.textLabel?.text)!
                destination.passedData = allDataForNBillDetail
                passedIsActive = false
                // print(allDataForDetail)
                
                // print(allDataForDetail)
            }
        }
    }


    
    

}
