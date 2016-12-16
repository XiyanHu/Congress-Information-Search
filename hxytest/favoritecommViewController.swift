//
//  favoritecommViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/24.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
import SwiftSpinner

class favoritecommViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var favComList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favComList.dataSource = self
        favComList.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         SwiftSpinner.show(duration:0.5, title:"Fetching data...")
        self.setNavigationBarItem()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavCom")
        do  {
            let results = try managedContext.fetch(fetchRequest)
            favBill.listBillItems = results as! [NSManagedObject]
        }
        catch{
            print("Error")
        }
        self.favComList.reloadData()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favComm.listComItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favComList.dequeueReusableCell(withIdentifier: "favComCell")! as UITableViewCell
        let item = favComm.listComItems[indexPath.row]
        let name = item.value(forKey: "favComName") as! String?
        cell.textLabel?.text = name
        
        //  cell.detailTextLabel?.text = IsActiveList[indexPath.row]
        cell.detailTextLabel?.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        //  SwiftSpinner.show("Fetching data...")
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath as IndexPath){
            
            self.performSegue(withIdentifier: "favToCommDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "favToCommDetail") {
            if let destination = segue.destination as? CommitteesDetailViewController{
                let path = favComList.indexPathForSelectedRow!
                let cell = favComList.cellForRow(at: path as IndexPath)
                
                destination.passedComName = (cell?.textLabel?.text)!
                
                    destination.passedData = allDataForCom
                
            }
        }

    }
}
