//
//  BillsViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/24.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit

class BillsViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Bills"
        tabBar.items?[0].title = "Active"
        tabBar.items?[1].title = "New"
        //        self.tableView.registerCellNib(DataTableViewCell.self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
