//
//  detailTableViewCell.swift
//  hxytest
//
//  Created by apple apple on 16/11/26.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit

class detailTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
