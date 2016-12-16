//
//  activeBillTableViewCell.swift
//  hxytest
//
//  Created by apple apple on 16/11/30.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit

class activeBillTableViewCell: UITableViewCell {


 
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var midLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.font = UIFont.boldSystemFont(ofSize: 15)
        midLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
