//
//  UIView.swift
//  SlideMenueControllerExample
//
//  Created by Jeff Schmitz on 10/15/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}

