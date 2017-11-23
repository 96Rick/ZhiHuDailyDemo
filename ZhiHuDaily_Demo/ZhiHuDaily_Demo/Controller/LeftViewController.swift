//
//  LeftViewController.swift
//  ZhiHuDaily_Demo
//
//  Created by Rick on 2017/11/4.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit

class LeftViewController: UITableViewController, ThemeDataRequestDelegaete {
    
    
    
    var themeData: [ThemeCellModel] = []
    
    func transForThemeDataValue(themeData: AnyObject) {
        self.themeData = themeData as! [ThemeCellModel]
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: UIScreen.main.bounds, style: .grouped)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4))
        headerView.backgroundColor = UIColor.init(red: 35/255.0, green: 43/255.0, blue: 48/255.0, alpha: 1)
        
        let heardViewlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 2 * UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height/8))
        heardViewlabel.text = "这里可以添加~\n各种东西~\n真的是各种东西"
        heardViewlabel.numberOfLines = 4
        heardViewlabel.textAlignment = .center
        heardViewlabel.textColor = UIColor.darkGray
        
        headerView.addSubview(heardViewlabel)
        
        self.tableView.tableHeaderView = headerView
        self.view.backgroundColor = UIColor.init(red: 35/255.0, green: 43/255.0, blue: 48/255.0, alpha: 1)
        
        let request = DataRequest()
        request.ThemeDataDelegate = self
        request.getThemeData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return themeData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        if indexPath.section == 0{
            cell.textLabel?.text = "首页"
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        else{
            cell.textLabel?.text = themeData[indexPath.row].name
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.darkGray
        cell.tintColor = UIColor.black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            //关掉侧面菜单
            self.slideMenuController()?.closeLeft()
        }
        else{
            let newViewController = ThemeDataViewController()
            newViewController.id = themeData[indexPath.row].id
            newViewController.themeTitle = themeData[indexPath.row].name
            let nav = UINavigationController(rootViewController: newViewController)
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
