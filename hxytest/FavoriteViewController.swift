//
//  FavoriteViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/24.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit

class FavoriteViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite"
        tabBar.items?[0].title = "Legislators"
        tabBar.items?[1].title = "Bills"
        tabBar.items?[2].title = "Committee"
   
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
