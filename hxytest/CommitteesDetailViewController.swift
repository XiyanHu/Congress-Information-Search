//
//  CommitteesDetailViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/30.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData
import SwiftSpinner

struct favComm{
    static var listComItems = [NSManagedObject]()
    
}



class CommitteesDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var comDetailTable: UITableView!
    
    var passedCommId = ""
    var passedComName = ""
    var passedData = [[String : AnyObject]]()

    var targetIndex = 0;
    var leftLabelContent = ["ID","Parent ID","Chamber","Office","Contact"]
    var rightLabelContent = [String]()
    var commIdList = [String]()
    var comNameList = [String]()
    
    var imagestar = "star"
    let btnName = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Committee Details"
        comDetailTable.dataSource = self
        comDetailTable.delegate = self
        
        for i in 0..<self.passedData.count{
            
            let targetCommid = String(describing: (passedData[i]["committee_id"])!)
            if (targetCommid == self.passedCommId){
                self.targetIndex = i;
            }
        }
        if (passedCommId == ""){
            for i in 0..<self.passedData.count{
                
                let targetCommname = String(describing: (passedData[i]["name"])!)
                if (targetCommname == self.passedComName){
                    self.targetIndex = i;
                }
            }
        
        }
        
        
        let targetcommid = String(describing: (passedData[targetIndex]["committee_id"])!)
        rightLabelContent.append(targetcommid)
       
        if (passedData[targetIndex]["parent_committee_id"] != nil){
            let targetparentid = String(describing: (passedData[targetIndex]["parent_committee_id"])!)
            rightLabelContent.append(targetparentid)
        
        }
        else {
            rightLabelContent.append("N.A")
        }
        
        
        
        let targetChamber = String(describing: (passedData[targetIndex]["chamber"])!)
        rightLabelContent.append(targetChamber)
        
        
        if (passedData[targetIndex]["office"] != nil){
            let targetoffice = String(describing: (passedData[targetIndex]["office"])!)
            rightLabelContent.append(targetoffice)
        }
        else {
            rightLabelContent.append("N.A")
        }
        
        if (passedData[targetIndex]["phone"] != nil){
            let targetcontact = String(describing: (passedData[targetIndex]["phone"])!)
            rightLabelContent.append(targetcontact)
        }
        else {
            rightLabelContent.append("N.A")
        }
        
        if (passedData[targetIndex]["name"] != nil){
            let targetname = String(describing: (passedData[targetIndex]["name"])!)
            titleLabel?.text = targetname
            comNameList.append(targetname)
        }
        else {
            titleLabel.text! = "N.A"
        }
        
        
        for person in favComm.listComItems{
            
            if ((person.value(forKey: "favComName") as! String?) == comNameList[0]){
                imagestar = "star_filled"
                break
            }
            else {
                imagestar = "star"
            }
        }
        
        btnName.setImage(UIImage(named: imagestar), for: .normal)
        btnName.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnName.addTarget(self, action: Selector("operateFavorite"), for: .touchUpInside)
        
        //.... Set Right/Left Bar Button item
        let starButton = UIBarButtonItem()
        starButton.customView = btnName
        self.navigationItem.rightBarButtonItem = starButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func operateFavorite(){
        print("yes!")
        var isExist = false;
        for person in favComm.listComItems{
            
            if ((person.value(forKey: "favComName") as! String?) == comNameList[0]){
                isExist = true
                break
            }
            else {
                isExist = false
            }
        }
        
        if (!isExist){
            self.saveItem(itemToSave: comNameList[0] ,itemKey: "favComName" )
            
            btnName.setImage(UIImage(named: "star_filled"), for: .normal)
        }
        else {
            self.deleteItem()
            
            btnName.setImage(UIImage(named: "star"), for: .normal)
            
        }
        
    }
    func saveItem(itemToSave :String, itemKey :String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "FavCom",in:managedContext)
        let item = NSManagedObject(entity: entity!,insertInto: managedContext)
        
        item.setValue(itemToSave, forKey: itemKey)
     
        
        do {
            try managedContext.save()
            //5
            favComm.listComItems.append(item)
            //print(favLegi.listItems)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteItem(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        var deleteItemIndex = 0;
        
        for person in favComm.listComItems{
            
            if ((person.value(forKey: "favComName") as! String?) != comNameList[0]){
                deleteItemIndex = deleteItemIndex+1
            }
            else {
                break
            }
            
        }
        
        managedContext.delete(favComm.listComItems[deleteItemIndex])
        favComm.listComItems.remove(at: deleteItemIndex)
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftLabelContent.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let detailCell = self.comDetailTable.dequeueReusableCell(withIdentifier: "comDetailCell", for: indexPath) as! comDetailTableViewCell
            detailCell.leftLabel.text = leftLabelContent[indexPath.row]
            detailCell.rightLabel.text = rightLabelContent[indexPath.row]
            return detailCell
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavCom")
        do  {
            let results = try managedContext.fetch(fetchRequest)
            favComm.listComItems = results as! [NSManagedObject]
        }
        catch{
            print("Error")
        }
        
    }


    
}
