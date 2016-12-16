//
//  detailWithLinkTableViewCell.swift
//  hxytest
//
//  Created by apple apple on 16/11/26.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit

class detailWithLinkTableViewCell: UITableViewCell {

    @IBOutlet weak var LeftLabel: UILabel!
    
    @IBOutlet weak var rightButton: UIButton!
    
    var passedUrl = ""

    @IBAction func link(_ sender: Any) {
        let url = URL(string: passedUrl)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            //If you want handle the completion block than
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
