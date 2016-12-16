//
//  NonMenuController.swift
//  hxytest
//
//  Created by apple apple on 16/11/21.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

//
//  NonMenuViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/21.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit



class NonMenuController: UIViewController {
    
    weak var delegate: LeftMenuProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.removeNavigationBarItem()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            guard let vc = (self.slideMenuController()?.mainViewController as? UINavigationController)?.topViewController else {
                return
            }
            if vc.isKind(of: NonMenuController.self)  {
                self.slideMenuController()?.removeLeftGestures()
                self.slideMenuController()?.removeRightGestures()
            }
        })
    }
    
    //    @IBAction func didTouchToMain(_ sender: UIButton) {
    //        delegate?.changeViewController(LeftMenu.main)
    //    }
}

