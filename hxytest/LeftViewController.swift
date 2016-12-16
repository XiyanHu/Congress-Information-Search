//
//  LeftViewController.swift
//  hxytest
//
//  Created by apple apple on 16/11/21.
//  Copyright © 2016年 xiyanhu. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case main = 0
   
   
   
    case bills
    case committees
    case favorite
    case about
    
}
protocol LeftMenuProtocol: class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController: UIViewController, LeftMenuProtocol
{

    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["Legislators","Bills","Committees","Favorite","About"]
    var mainViewController: UIViewController!
    var billsViewController: UIViewController!
    var committeesViewController: UIViewController!
    var favoriteViewController: UIViewController!
    var aboutViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex:"CDCDCD")
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        self.tableView.backgroundColor =  UIColor(hex:"EEF7E3")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let billsViewController = storyboard.instantiateViewController(withIdentifier: "BillsViewController") as! BillsViewController
        self.billsViewController = UINavigationController(rootViewController: billsViewController)
        
        let committeesViewController = storyboard.instantiateViewController(withIdentifier: "CommitteesViewController") as! CommitteesViewController
        self.committeesViewController = UINavigationController(rootViewController: committeesViewController)
        
        let favoriteViewController = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        self.favoriteViewController = UINavigationController(rootViewController: favoriteViewController)
        
        let aboutViewController = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.aboutViewController = UINavigationController(rootViewController: aboutViewController)
        
        //        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
             case .bills:
            self.slideMenuController()?.changeMainViewController(self.billsViewController, close: true)
        case .committees:
            self.slideMenuController()?.changeMainViewController(self.committeesViewController, close: true)
        case .favorite:
            self.slideMenuController()?.changeMainViewController(self.favoriteViewController, close: true)
        case .about:
            self.slideMenuController()?.changeMainViewController(self.aboutViewController, close: true)
        }
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main,  .bills, .committees, .favorite, .about:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .main,  .bills, .committees, .favorite, .about:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}


