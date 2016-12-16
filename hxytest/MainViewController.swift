//
//  MainViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/23.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class MainViewController: UITabBarController {

        override func viewDidLoad() {
            super.viewDidLoad()
            navigationItem.title = "Legislators"

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
    
    extension MainViewController: SlideMenuControllerDelegate {
        
        func leftWillOpen() {
            print("SlideMenuControllerDelegate: leftWillOpen")
        }
        
        func leftDidOpen() {
            print("SlideMenuControllerDelegate: leftDidOpen")
        }
        
        func leftWillClose() {
            print("SlideMenuControllerDelegate: leftWillClose")
        }
        
        func leftDidClose() {
            print("SlideMenuControllerDelegate: leftDidClose")
        }
        
        func rightWillOpen() {
            print("SlideMenuControllerDelegate: rightWillOpen")
        }
        
        func rightDidOpen() {
            print("SlideMenuControllerDelegate: rightDidOpen")
        }
        
        func rightWillClose() {
            print("SlideMenuControllerDelegate: rightWillClose")
        }
        
        func rightDidClose() {
            print("SlideMenuControllerDelegate: rightDidClose")
        }
        
        
}
