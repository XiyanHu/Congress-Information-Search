//
//  favoritebillViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/24.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import SwiftSpinner


class favoritebillViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var favBillList: UITableView!

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favBillList.dataSource = self
        favBillList.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         SwiftSpinner.show(duration:0.5, title:"Fetching data...")
        self.setNavigationBarItem()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavBill")
        do  {
            let results = try managedContext.fetch(fetchRequest)
            favBill.listBillItems = results as! [NSManagedObject]
        }
        catch{
            print("Error")
        }
        self.favBillList.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favBill.listBillItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favBillList.dequeueReusableCell(withIdentifier: "favBillCell")! as UITableViewCell
        let item = favBill.listBillItems[indexPath.row]
        let officalTitle = item.value(forKey: "favBillName") as! String?
        cell.textLabel?.text = officalTitle
        cell.textLabel?.numberOfLines = 4
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;

        cell.detailTextLabel?.isHidden = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
      //  SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "favToBillDetail", sender: self)
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if (segue.identifier == "favToBillDetail") {
            if let destination = segue.destination as? billDetailViewController{
                let path = favBillList.indexPathForSelectedRow!
                let cell = favBillList.cellForRow(at: path as IndexPath)
                
                destination.passedBillName = (cell?.textLabel?.text)!
                var targetot = (cell?.textLabel?.text)!
                var whichToPass = false
          
                for item in allDataForABillDetail {
                    var str = String(describing: item["official_title"])
                    let start = str.index(str.startIndex, offsetBy: 9)
                    let end = str.index(str.endIndex, offsetBy: -1)
                    let range = start..<end
                    str = str.substring(with: range)

                    if (str == targetot){
                        whichToPass = true
                        break
                    }
                    
                }
            
                if (whichToPass){
                    destination.passedData = allDataForABillDetail
                }
                else {
                    destination.passedData = allDataForNBillDetail
                }
               
            }
        }
    }
    



    
}
