//
//  billDetailViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/30.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//
import UIKit
import SDWebImage
import CoreData
import SwiftSpinner
import SwiftyJSON

var passedIsActive = true
var IsActiveList = [Bool]()
struct favBill{
    static var listBillItems = [NSManagedObject]()
    
}



class billDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var billDetailTable: UITableView!
   
    @IBOutlet var titleLabel: UILabel!
    

    var passedBillId = ""
    var passedBillName = ""
    var passedData = [[String : AnyObject]]()
   
    var targetIndex = 0;
    var leftLabelContent = ["Bill ID","Bill Type","Sponsor","Last Action","Chamber","Last Vote","Status"]
    
    var leftLabelLink = ["PDF"]
    var rightButtonLink = [String]()

    var rightLabelContent = [String]()
    var rightButtonContentLink = [String]()
    var billIdList = [String]()
    var billOTList = [String]()
    
    var imagestar = "star"
    let btnName = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Bill Details"
        billDetailTable.dataSource = self
        billDetailTable.delegate = self
        print(passedData.count)
        
        for i in 0..<self.passedData.count{
            
            let targetBillId = String(describing: (passedData[i]["bill_id"])!)
            let targetOT = String(describing: (passedData[i]["official_title"])!)
            if (targetBillId == self.passedBillId || targetOT == self.passedBillName){
                self.targetIndex = i;
            }
        }
        
        print("index")
        print(targetIndex)
        
        
        let targetbillid = String(describing: (passedData[targetIndex]["bill_id"])!)
        rightLabelContent.append(targetbillid)
        let targetbilltype = String(describing: (passedData[targetIndex]["bill_type"])!)
        rightLabelContent.append(targetbilltype)
        
        var targerSponsortitle = String(describing: (passedData[targetIndex]["sponsor"]?["title"])!)
        let start = targerSponsortitle.index(targerSponsortitle.startIndex, offsetBy: 9)
        let end = targerSponsortitle.index(targerSponsortitle.endIndex, offsetBy: -1)
        let range = start..<end
        let targerSponsorStrtitle = targerSponsortitle.substring(with: range)
        
        
        var targerSponsorlname = String(describing: (passedData[targetIndex]["sponsor"]?["last_name"])!)
        let startl = targerSponsorlname.index(targerSponsorlname.startIndex, offsetBy: 9)
        let endl = targerSponsorlname.index(targerSponsorlname.endIndex, offsetBy: -1)
        let rangel = startl..<endl
        let targerSponsorStrlname = targerSponsorlname.substring(with: rangel)
        
        var targerSponsorfname = String(describing: (passedData[targetIndex]["sponsor"]?["title"])!)
        let startf = targerSponsorfname.index(targerSponsorfname.startIndex, offsetBy: 9)
        let endf = targerSponsorfname.index(targerSponsorfname.endIndex, offsetBy: -1)
        let rangef = startf..<endf
        let targerSponsorStrfname = targerSponsorfname.substring(with: rangef)
        
        let targerSponsorStrReal = targerSponsorStrtitle + " " + targerSponsorStrlname + " " + targerSponsorStrfname
        
        rightLabelContent.append(targerSponsorStrReal)
        
        
        var pdfIndex = 0
        if (passedIsActive){
            for index in 0...49{
                if(billpdf[index]["bill_id"].stringValue == targetbillid){
                    pdfIndex = index
                    break
                }
            }
        
        }
        else{
            for index in 0...49{
                if(billpdfNew[index]["bill_id"].stringValue == targetbillid){
                    pdfIndex = index
                    break
                }
            }
        }
        

        
//        if (passedData[targetIndex]["last_action_at"] != nil){
//            let targetlastaction = String(describing: (passedData[targetIndex]["last_action_at"])!)
//            rightLabelContent.append(targetlastaction)
//        }
//        else {
//            rightLabelContent.append("N.A")
//        }
        
        if  ((String(describing: (passedData[targetIndex]["last_action_at"])!) != nil) &&  (String(describing: (passedData[targetIndex]["last_action_at"])!) != "<null>") ){
            let targetlastaction = String(describing: (passedData[targetIndex]["last_action_at"])!)
            let inputFormatter = DateFormatter()
            let inputFormatterShort = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            inputFormatterShort.dateFormat = "yyyy-MM-dd"
            //   let months = dateFormatter.shortMonthSymbols
            let showDate = inputFormatter.date(from: targetlastaction)
            let showDateShort = inputFormatterShort.date(from: targetlastaction)
            inputFormatter.dateFormat = "dd MMM yyyy"
            inputFormatterShort.dateFormat = "dd MMM yyyy"
            var resultActionString = ""
            if (showDate == nil ){
                resultActionString = inputFormatter.string(from: showDateShort!)
            }
            else if (showDateShort == nil){
                resultActionString = inputFormatter.string(from: showDate!)
            }
            rightLabelContent.append(resultActionString)
        }
        else {
            rightLabelContent.append("N.A")
        }
        
        
       
        
        let targetChamber = String(describing: (passedData[targetIndex]["chamber"])!)
        rightLabelContent.append(targetChamber)
        
        if  ((String(describing: (passedData[targetIndex]["last_vote_at"])!) != nil) &&  (String(describing: (passedData[targetIndex]["last_vote_at"])!) != "<null>") ){
            let targetlastaction = String(describing: (passedData[targetIndex]["last_vote_at"])!)
            let inputFormatter = DateFormatter()
            let inputFormatterShort = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            inputFormatterShort.dateFormat = "yyyy-MM-dd"
            //   let months = dateFormatter.shortMonthSymbols
            let showDate = inputFormatter.date(from: targetlastaction)
            let showDateShort = inputFormatterShort.date(from: targetlastaction)
            inputFormatter.dateFormat = "dd MMM yyyy"
            inputFormatterShort.dateFormat = "dd MMM yyyy"
            var resultActionString = ""
            if (showDate == nil ){
                resultActionString = inputFormatter.string(from: showDateShort!)
            }
            else if (showDateShort == nil){
                resultActionString = inputFormatter.string(from: showDate!)
            }
            rightLabelContent.append(resultActionString)
        }
        else {
            rightLabelContent.append("N.A")
        }
        
        
        
        if (passedIsActive){
            rightLabelContent.append("Active")
        }
        else {
            rightLabelContent.append("New")
        }
        
        if (passedIsActive){
            if (billpdf[pdfIndex]["last_version"]["urls"]["pdf"].stringValue != ""){
                let pdfurl = billpdf[pdfIndex]["last_version"]["urls"]["pdf"].stringValue
                rightButtonContentLink.append(pdfurl)
                rightButtonLink.append("PDF Link")
            }
            else {
                rightButtonContentLink.append("N.A")
                rightButtonLink.append("N.A")
            }
        
        
        }
        else {
            if (billpdfNew[pdfIndex]["last_version"]["urls"]["pdf"].stringValue != ""){
                let pdfurl = billpdfNew[pdfIndex]["last_version"]["urls"]["pdf"].stringValue
                rightButtonContentLink.append(pdfurl)
                rightButtonLink.append("PDF Link")
            }
            else {
                rightButtonContentLink.append("N.A")
                rightButtonLink.append("N.A")
            }
        }
        
        if (passedData[targetIndex]["official_title"] != nil){
         let targetocid = String(describing: (passedData[targetIndex]["official_title"])!)
            titleLabel?.text = targetocid
            billOTList.append(targetocid)
        }
        else {
            titleLabel.text! = "N.A"
        }
        
        for person in favBill.listBillItems{
            
            if ((person.value(forKey: "favBillName") as! String?) == billOTList[0]){
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
        for person in favBill.listBillItems{
            
            if ((person.value(forKey: "favBillName") as! String?) == billOTList[0]){
                isExist = true
                break
            }
            else {
                isExist = false
            }
        }
        
        if (!isExist){
            self.saveItem(itemToSave: billOTList[0] ,itemKey: "favBillName" )
           
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
        let entity =  NSEntityDescription.entity(forEntityName: "FavBill",in:managedContext)
        let item = NSManagedObject(entity: entity!,insertInto: managedContext)
        
        
        item.setValue(itemToSave, forKey: itemKey)

        
        do {
            try managedContext.save()
         
            favBill.listBillItems.append(item)
       
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteItem(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        var deleteItemIndex = 0;
        
        for person in favBill.listBillItems{
            
            if ((person.value(forKey: "favBillName") as! String?) != billOTList[0]){
                deleteItemIndex = deleteItemIndex+1
            }
            else {
                break
            }
        }
         managedContext.delete(favBill.listBillItems[deleteItemIndex])
        favBill.listBillItems.remove(at: deleteItemIndex)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftLabelContent.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  (indexPath.row < 4){
            let detailCell = self.billDetailTable.dequeueReusableCell(withIdentifier: "billDetailCell", for: indexPath) as! billDetailTableViewCell
            detailCell.leftLabel.text = leftLabelContent[indexPath.row]
            detailCell.rightLabel.text = rightLabelContent[indexPath.row]
            return detailCell
        }
        else if  (indexPath.row == 4){
            let linkCell = self.billDetailTable.dequeueReusableCell(withIdentifier: "linkbillDetailCell", for: indexPath) as! linkbillDetailTableViewCell
            linkCell.LeftLabel.text = leftLabelLink[indexPath.row-4]
            linkCell.rightButton.setTitle(rightButtonLink[indexPath.row-4], for: .normal)
            linkCell.passedUrl = rightButtonContentLink[indexPath.row-4]
            return linkCell
        }
        else {
            let detailCell = self.billDetailTable.dequeueReusableCell(withIdentifier: "billDetailCell", for: indexPath) as! billDetailTableViewCell
            detailCell.leftLabel.text = leftLabelContent[indexPath.row-1]
            detailCell.rightLabel.text = rightLabelContent[indexPath.row-1]
            return detailCell
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
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
        
    }
    



    
    

}
