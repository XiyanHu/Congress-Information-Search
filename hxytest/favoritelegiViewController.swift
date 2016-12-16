//
//  favoritelegiViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/24.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import SwiftSpinner

class favoritelegiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

 
  
    @IBOutlet var favLegiList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favLegiList.dataSource = self
        favLegiList.delegate = self

        print("wozai zheli")
       
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         SwiftSpinner.show(duration:0.5, title:"Fetching data...")
        self.setNavigationBarItem()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavLegi")
        do  {
            let results = try managedContext.fetch(fetchRequest)
            
            favLegi.listItems = results as! [NSManagedObject]
        }
        catch{
            print("Error")
        }
        self.favLegiList.reloadData()
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(favLegi.listItems.count)
        return favLegi.listItems.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = favLegiList.dequeueReusableCell(withIdentifier: "favLegiCell")! as UITableViewCell
        let item = favLegi.listItems[indexPath.row]
 
        let lname = item.value(forKey: "favLegiLname") as! String?
        let fname = item.value(forKey: "favLegiFname") as! String?
        let state = item.value(forKey: "favLegiState") as! String?
        let bioid = item.value(forKey: "favLegiBioId") as! String?
        if (lname != nil && fname != nil && state != nil && bioid != nil){
            let wholeName  = lname! + "," + fname!
            cell.textLabel?.text = wholeName
            cell.detailTextLabel?.text = state
            let headImgUrl = "https://theunitedstates.io/images/congress/225x275/"+bioid!+".jpg"
            let urltemp = NSURL(string: headImgUrl)
            let datatemp = NSData(contentsOf: urltemp! as URL)
            if datatemp != nil {
                let imagetemp = UIImage(data: datatemp! as Data)
                cell.imageView?.image = imagetemp
            }

        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "favToLegiDetail", sender: self)
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "favToLegiDetail") {
            if let destination = segue.destination as? LegiDetailViewController{
                let path = favLegiList.indexPathForSelectedRow!
                let cell = favLegiList.cellForRow(at: path as IndexPath)
               
                destination.passedName = (cell?.textLabel?.text!)!
                destination.passedState = (cell?.detailTextLabel?.text!)!
                destination.passedData = allDataForDetail
            }
        }
    }
    
    

    
    
   

}
