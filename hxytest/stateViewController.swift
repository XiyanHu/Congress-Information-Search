//
//  stateViewController.swift
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

 var allDataForDetail = [[String : AnyObject]]()
var wholeLegiRes = [[String : AnyObject]]()
var allStateName = ["All States","Alabama","Alaska","American Samoa","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Guam","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Marshall Islands","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Northern Mariana Islands","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virgin Island","Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
var choosenState = "All States"

class stateViewController: UIViewController,UITableViewDataSource,UITabBarDelegate, UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var statePickerView: UIPickerView!

    @IBOutlet weak var stateTable: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    var fruitList = [[String]]()
    var filterMembers = [[String : AnyObject]]()
    var fruitListGrouped = NSDictionary() as! [String : [[String]]]
    var detailInformation = [String](repeating:"",count:10);
    var sectionTitleList = [String]()
    let btnState = UIButton()
    
    
    // pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return allStateName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allStateName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosenState = allStateName[row]
        filterContext()
        DispatchQueue.main.asyncAfter(deadline:
            DispatchTime.now()
                + Double(Int64(3*NSEC_PER_SEC))/Double(NSEC_PER_SEC)){
                    print("+1s")
                    self.stateTable.isHidden = false
                    self.statePickerView.isHidden = true;
                    
        }

    }
    
    //filter for pickerview
    func filterContext() {
        filterMembers = arrRes.filter{ member in
            let   stateMatch = (member["state_name"] as? String)?.lowercased().range(of: choosenState.lowercased()) != nil
            return stateMatch
        }
        stateTable.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statePickerView.delegate = self
        statePickerView.dataSource = self
//       "https://congress.api.sunlightfoundation.com/legislators?apikey=61bfda95a9d8443db6ca99b9cd659886&per_page=all"
        
        btnState.setTitle("Filter",for: .normal)
        btnState.setTitleColor(self.view.tintColor, for: .normal)  //self.view.tintColor
        btnState.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        
        btnState.addTarget(self, action: Selector("filterByState"), for: .touchUpInside)
        
        let filterButton = UIBarButtonItem()
        filterButton.customView = btnState

        self.tabBarController?.navigationItem.rightBarButtonItem = filterButton

        SwiftSpinner.show(duration:2.5, title:"Fetching data...")
    
        Alamofire.request("http://h19x93yhhdingo1s.us-west-2.elasticbeanstalk.com/hw8.php/?key=legislatorByStates").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                let resultsPart = swiftyJsonVar["results"]

                if var resData = resultsPart.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    wholeLegiRes = resData as! [[String:AnyObject]]
                     let nameDiscriptor = NSSortDescriptor(key: "state_name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
                    let nameDiscriptoradd = NSSortDescriptor(key: "last_name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
                    resData = (self.arrRes as NSArray).sortedArray(using: [nameDiscriptor,nameDiscriptoradd])
   
                    self.arrRes = resData as! [[String:AnyObject]]
                    allDataForDetail = self.arrRes
 
                    
                    // create data for the list
                    self.createData()
                    
                    // split data into section
                    self.splitDataInToSection()
                    
                }
                if self.arrRes.count > 0 {
                    self.stateTable.reloadData()
                }
            }
            
        }
      //  SwiftSpinner.hide()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if (choosenState == "All States"){
            return self.fruitListGrouped.count
        }
        else {
            return 1
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")!
        if (choosenState == "All States"){
           
            
            // find section title
            let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
            //  print(sectionTitle)
            // find fruit list for given section title
            let fruits = self.fruitListGrouped[sectionTitle]
            cell.textLabel?.text = fruits![2][(indexPath as NSIndexPath).row]
            var nameStr = (cell.textLabel?.text)!
            cell.textLabel?.text = fruits![1][(indexPath as NSIndexPath).row]
            nameStr = nameStr+","+(cell.textLabel?.text)!
            detailInformation[0] = nameStr
            cell.textLabel?.text = nameStr
            cell.detailTextLabel?.text = fruits![0][(indexPath as NSIndexPath).row]
            detailInformation[1] = (cell.detailTextLabel?.text)!
            let bioguide_id = (fruits![3][(indexPath as NSIndexPath).row])
            let headImgUrl = "https://theunitedstates.io/images/congress/225x275/"+bioguide_id+".jpg"
         //   cell.imageView?.sd_setImage(with: NSURL(string: headImgUrl) as? URL)
            
            
            
            let urltemp = NSURL(string: headImgUrl)
            let datatemp = NSData(contentsOf: urltemp! as URL)
            if datatemp != nil {
            let imagetemp = UIImage(data: datatemp! as Data)
                cell.imageView?.image = imagetemp
            }
            
        
            
         //      cell.imageView?.sd_setImage(with: NSURL(string: headImgUrl) as? URL)

            // cell.layoutIfNeeded()
            return cell
        }
        else {
      //      print(filterMembers)
            var dict = filterMembers[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = dict["last_name"] as? String
            var str = (cell.textLabel?.text)!
            cell.textLabel?.text = dict["first_name"] as? String
            str = str+","+(cell.textLabel?.text)!
            cell.textLabel?.text = str
            
            cell.detailTextLabel?.text = dict["state_name"] as? String
            
            let bioguide_id = (dict["bioguide_id"] as? String)!
            let headImgUrl = "https://theunitedstates.io/images/congress/225x275/"+bioguide_id+".jpg"
            // let headImgUrl = "http://cs-server.usc.edu:45678/hw/hw8/images/d.png"
            //cell.imageView?.sd_setImage(with: NSURL(string: headImgUrl) as? URL)
            let urltemp = NSURL(string: headImgUrl)
            let datatemp = NSData(contentsOf: urltemp! as URL)
            if datatemp != nil {
                let imagetemp = UIImage(data: datatemp! as Data)
                cell.imageView?.image = imagetemp
            }

            return cell

        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   
        numberOfRowsInSection section: Int) -> Int {
        // find section title
        
        if (choosenState == "All States"){
        let sectionTitle = self.sectionTitleList[section]
       // print(sectionTitle)
        
        // find fruit list for given section title
        let fruits = self.fruitListGrouped[sectionTitle]
       // print(fruits)
        // return count for fruits
            return fruits![0].count
        }
        else {
            return filterMembers.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (choosenState == "All States"){
            return self.sectionTitleList[section]
        }
        else {
            return String(choosenState.characters.prefix(1))
        }
        
    }
    
    // return title list for section index
     func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if (choosenState == "All States"){
            return self.sectionTitleList
        }
        else{
            var sectionTitle = [String]()
            sectionTitle.append(String(choosenState.characters.prefix(1)))
            return sectionTitle
        }
        
    }
    // return section for given section index title
     func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return index
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "showLegiDetail", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showLegiDetail") {
            if let destination = segue.destination as? LegiDetailViewController{
                let path = stateTable.indexPathForSelectedRow!
                let cell = stateTable.cellForRow(at: path as IndexPath)
                destination.passedName = (cell?.textLabel?.text!)!
                destination.passedState = (cell?.detailTextLabel?.text!)!
                destination.passedData = allDataForDetail
               // print(allDataForDetail)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func createData() {
          var stateName = [String]()
        var firstName = [String]()
        var lastName = [String]()
        var bioguideId = [String]()
    
        for i in 0..<self.arrRes.count{
           // self.fruitList.append((self.arrRes[i]["state_name"])! as! String)
            stateName.append((self.arrRes[i]["state_name"])! as! String)
            firstName.append((self.arrRes[i]["first_name"])! as! String)
            lastName.append((self.arrRes[i]["last_name"])! as! String)
            bioguideId.append((self.arrRes[i]["bioguide_id"])! as! String)
            
        }
        self.fruitList.append(stateName);
        self.fruitList.append(firstName);
        self.fruitList.append(lastName);
        self.fruitList.append(bioguideId);
        
  //  print(self.fruitList)
    }
    
    
    fileprivate func splitDataInToSection() {
        
        // set section title "" at initial
        var sectionTitle: String = ""
        var currentRecordArray = [String]()
        var currentRecordfnameArray = [String]()
        var currentRecordlnameArray = [String]()
        var currentRecordbioidArray = [String]()
        // iterate all records from array
        for i in 0..<self.fruitList[0].count {
            
            
            // get current record
            let currentRecord = self.fruitList[0][i]
            let currentRecordfname = self.fruitList[1][i]
            let currentRecordlname = self.fruitList[2][i]
            let currentRecordbioid = self.fruitList[3][i]
            
            if (i==0){
             currentRecordArray.append(currentRecord)
                currentRecordfnameArray.append(currentRecordfname)
             currentRecordlnameArray.append(currentRecordlname)
                currentRecordbioidArray.append(currentRecordbioid)
             
            }
            
            // find first character from current record
            let firstChar = currentRecord[currentRecord.startIndex]
            
            // convert first character into string
            let firstCharString = "\(firstChar)"
            
            // if first character not match with past section title then create new section
            if firstCharString != sectionTitle {
                
                // set new title for section
                sectionTitle = firstCharString
               
                // add new section having key as section title and value as empty array of string
                self.fruitListGrouped[sectionTitle] = [[String]]()
                
                // append title within section title list
                self.sectionTitleList.append(sectionTitle)
            }
            
            // add record to the section
            if(i==0||(fruitListGrouped[firstCharString]?.isEmpty)!){
                self.fruitListGrouped[firstCharString]?.append([currentRecord])
                self.fruitListGrouped[firstCharString]?.append([currentRecordfname])
                self.fruitListGrouped[firstCharString]?.append([currentRecordlname])
                self.fruitListGrouped[firstCharString]?.append([currentRecordbioid])
            }
            else {
                self.fruitListGrouped[firstCharString]?[0].append(currentRecord)
                self.fruitListGrouped[firstCharString]?[1].append(currentRecordfname)
                self.fruitListGrouped[firstCharString]?[2].append(currentRecordlname)
                self.fruitListGrouped[firstCharString]?[3].append(currentRecordbioid)
            
            }
            

        }
        
    }
    func filterByState(){
        if (stateTable.isHidden == true){
            stateTable.isHidden = false;
            statePickerView.isHidden = true;
            
//            DispatchQueue.main.asyncAfter(deadline:
//                DispatchTime.now()
//                    + Double(Int64(5*NSEC_PER_SEC))/Double(NSEC_PER_SEC)){
//                        print("+1s")
//                        self.stateTable.isHidden = false
//                        self.statePickerView.isHidden = true;
//                        
//            }

            stateTable.reloadData()
        }
        else if (stateTable.isHidden == false){
            stateTable.isHidden = true
            statePickerView.isHidden = false;
            stateTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.navigationItem.titleView = nil
        self.tabBarController?.navigationItem.title = "Legislators"
        btnState.setTitle("Filter",for: .normal)
        btnState.setTitleColor(UIColor(hex:"007aff"), for: .normal)   //self.view.tintColor
        btnState.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        statePickerView.isHidden = true
        stateTable.isHidden = false
        btnState.addTarget(self, action: Selector("filterByState"), for: .touchUpInside)
        
        let filterButton = UIBarButtonItem()
        filterButton.customView = btnState
        
        self.tabBarController?.navigationItem.rightBarButtonItem = filterButton
        
        
    }

   
}

