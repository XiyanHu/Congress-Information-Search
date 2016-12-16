//
//  LegiDetailViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/25.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData
import SwiftSpinner



struct favLegi{
    static var listItems = [NSManagedObject]()
    
}


class LegiDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    @IBOutlet weak var legiDetailTable: UITableView!

   
    @IBOutlet weak var headerImage: UIImageView!
    
    var passedValue = ""
    var passedName = ""
    var passedState = ""
    var passedData = [[String : AnyObject]]()
    var targetIndex = 0;
    var leftLabelContent = ["First Name","Last Name","State","Birth Date","Gender","Chamber","Fax No.","Office No.","End Term"]
    
    var leftLabelLink = ["Twitter","Facebook","Website"]
    var rightButtonLink = ["Twitter Link","Facebook Link","Website Link"]
    var rightLabelContent = [String]()
    var rightButtonContentLink = [String]()
    var bioIdList = [String]()
    
    var imagestar = "star"
    let btnName = UIButton()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.hide()
        
        navigationItem.title = "Legislators Details"
    
        for i in 0..<self.passedData.count{

        let targetFname = String(describing: (passedData[i]["first_name"])!)
        let targetLname = String(describing: (passedData[i]["last_name"])!)
        let targetName = targetLname+","+targetFname
            if (targetName==self.passedName){
                self.targetIndex = i;
            }
        }
        
      
        let targetBioId = String(describing: (passedData[targetIndex]["bioguide_id"])!)
        bioIdList.append(targetBioId)
        let headImgUrl = "https://theunitedstates.io/images/congress/225x275/"+targetBioId+".jpg"
        headerImage.sd_setImage(with: NSURL(string: headImgUrl) as? URL)
//        let urltemp = NSURL(string: headImgUrl)
//        let datatemp = NSData(contentsOf: urltemp! as URL)
//        if datatemp != nil {
//            let imagetemp = UIImage(data: datatemp! as Data)
//            headerImage.image = imagetemp
//        }
        
        
        
        
        let targetFirstName = String(describing: (passedData[targetIndex]["first_name"])!)
        rightLabelContent.append(targetFirstName)
        bioIdList.append(targetFirstName)
        let targetLastName = String(describing: (passedData[targetIndex]["last_name"])!)
        rightLabelContent.append(targetLastName)
        bioIdList.append(targetLastName)
        let targetStateName = String(describing: (passedData[targetIndex]["state_name"])!)
        rightLabelContent.append(targetStateName)
        bioIdList.append(targetStateName)
        
        let targetBirth = String(describing: (passedData[targetIndex]["birthday"])!)
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        //   let months = dateFormatter.shortMonthSymbols
        let showDate = inputFormatter.date(from: targetBirth)
        inputFormatter.dateFormat = "dd MMM yyyy"
        
        let resultBirthString = inputFormatter.string(from: showDate!)
        
        rightLabelContent.append(resultBirthString)
        let targetGender = String(describing: (passedData[targetIndex]["gender"])!)
        rightLabelContent.append(targetGender)
        let targetChamber = String(describing: (passedData[targetIndex]["chamber"])!)
        rightLabelContent.append(targetChamber)
        if (passedData[targetIndex]["fax"] != nil){
            let targetFax = String(describing: (passedData[targetIndex]["fax"])!)
            rightLabelContent.append(targetFax)
        }
        else {
            rightLabelContent.append("N.A")
        }
//        if (passedData[targetIndex]["twitter_id"] != nil){
//            let targetTwitter = String(describing: (passedData[targetIndex]["twitter_id"])!)
//            rightLabelContent.append(targetTwitter)
//        }
//        else {
//            rightLabelContent.append("N.A")
//        }
//        if (passedData[targetIndex]["facebook_id"] != nil){
//        let targetFacebook = String(describing: (passedData[targetIndex]["facebook_id"])!)
//        rightLabelContent.append(targetFacebook)
//        }
//        else{
//            rightLabelContent.append("N.A")
//        }
//        if (passedData[targetIndex]["website"] != nil){
//        let targetWebsite = String(describing: (passedData[targetIndex]["website"])!)
//        rightLabelContent.append(targetWebsite)
//        }
//        else {
//            rightLabelContent.append("N.A")
//        }
        if (passedData[targetIndex]["office"] != nil){
            let targetOffice = String(describing: (passedData[targetIndex]["office"])!)
            let start = targetOffice.index(targetOffice.startIndex, offsetBy: 0)
            let end = targetOffice.index(targetOffice.endIndex, offsetBy: -15)
            let range = start..<end
            let targetOfficeNo = targetOffice.substring(with: range)
            rightLabelContent.append(targetOfficeNo)
        }
        else {
            rightLabelContent.append("N.A")
        }
        if (passedData[targetIndex]["term_end"] != nil){
            let targetTermEnd = String(describing: (passedData[targetIndex]["term_end"])!)
            rightLabelContent.append(targetTermEnd)
        }
        else {
            rightLabelContent.append("N.A")
        }
        
        
        
        
        if (passedData[targetIndex]["twitter_id"] != nil){
            let targetTwitter = String(describing: (passedData[targetIndex]["twitter_id"])!)
            let targetTwitterUrl = "http://www.twitter.com/"+targetTwitter
            rightButtonContentLink.append(targetTwitterUrl)
        }
        else {
            rightButtonContentLink.append("N.A")
        }
        if (passedData[targetIndex]["facebook_id"] != nil){
            let targetFacebook = String(describing: (passedData[targetIndex]["facebook_id"])!)
            let targetFacebookUrl = "http://www.facebook.com/"+targetFacebook
            rightButtonContentLink.append(targetFacebookUrl)
        }
        else{
            rightButtonContentLink.append("N.A")
        }
        if (passedData[targetIndex]["website"] != nil){
            let targetWebsiteUrl = String(describing: (passedData[targetIndex]["website"])!)
            
            rightButtonContentLink.append(targetWebsiteUrl)
        }
        else {
            rightButtonContentLink.append("N.A")
        }
        
        
        
        
        for person in favLegi.listItems{
            
            if ((person.value(forKey: "favLegiBioId") as! String?) == bioIdList[0]){
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
        for person in favLegi.listItems{
            
            if ((person.value(forKey: "favLegiBioId") as! String?) == bioIdList[0]){
                isExist = true
                break
            }
            else {
                isExist = false
            }
        }
       
        if (!isExist){
            
            var saveList = [String]()
            saveList.append(rightLabelContent[1])
            saveList.append(rightLabelContent[0])
            saveList.append(rightLabelContent[2])
            saveList.append(bioIdList[0])
            var keyList = ["favLegiLname","favLegiFname","favLegiState","favLegiBioId"]
            
            
            self.saveItem(itemToSave: saveList, itemKey: keyList)

              btnName.setImage(UIImage(named: "star_filled"), for: .normal)
        }
        else {
        self.deleteItem()
        
        btnName.setImage(UIImage(named: "star"), for: .normal)
        
        }
        
    }
    
   
    
    func saveItem(itemToSave :[String], itemKey :[String] ){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "FavLegi",in:managedContext)
        let item = NSManagedObject(entity: entity!,insertInto: managedContext)
        
        for i in 0..<4 {
            item.setValue(itemToSave[i], forKey: itemKey[i])
        }
        
     
        print(item)
        
        do {
            try managedContext.save()
            favLegi.listItems.append(item)
            print(favLegi.listItems)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteItem(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        var index=0;
        
        for person in favLegi.listItems{
            
            if person.value(forKey: "favLegiBioId") as! String == bioIdList[0]{
                managedContext.delete(person)
                break
            }
            index = index + 1
        }
        favLegi.listItems.remove(at: index)
        
        
        do {
            try managedContext.save()
            //5)
            //print(favLegi.listItems)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }


    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftLabelContent.count+3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  (indexPath.row < 7){
            let detailCell = self.legiDetailTable.dequeueReusableCell(withIdentifier: "detailTableCell", for: indexPath) as! detailTableViewCell
            detailCell.leftLabel.text = leftLabelContent[indexPath.row]
            detailCell.rightLabel.text = rightLabelContent[indexPath.row]
            return detailCell
        }
        else if  (indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9){
        let linkCell = self.legiDetailTable.dequeueReusableCell(withIdentifier: "detailWithLinkTableViewCell", for: indexPath) as! detailWithLinkTableViewCell
            linkCell.LeftLabel.text = leftLabelLink[indexPath.row-7]
            linkCell.rightButton.setTitle(rightButtonLink[indexPath.row-7], for: .normal)
            linkCell.passedUrl = rightButtonContentLink[indexPath.row-7]
            return linkCell
        }
        else {
            let detailCell = self.legiDetailTable.dequeueReusableCell(withIdentifier: "detailTableCell", for: indexPath) as! detailTableViewCell
            detailCell.leftLabel.text = leftLabelContent[indexPath.row-3]
            detailCell.rightLabel.text = rightLabelContent[indexPath.row-3]
            return detailCell

            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
    }
    

}
