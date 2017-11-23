//
//  ThemeDataViewController.swift
//  ZhiHuDaily_Demo
//
//  Created by Rick on 2017/11/4.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit
import Alamofire

class ThemeDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var id: Int!
    let url = "http://news-at.zhihu.com/api/4/theme/"
    var item = [NewsCellModel]()
    var tableView = UITableView()
    var themeTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newUrl = url + String(id)
        getThemeData(url: newUrl)
        
        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let backButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 25, height: 30)
        backButton.setImage(UIImage(named: "back"), for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(ThemeDataViewController.back), for: .touchUpInside)
        backButtonView.addSubview(backButton)
        
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButtonView)
        
        //        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(ThemeDataViewController.back))
        //        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        //
        self.navigationItem.title = themeTitle
        let dict:NSDictionary = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
        //标题颜色
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [String : AnyObject]
        
        self.view.addSubview(tableView)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.item.count
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let url = self.item[indexPath.row].newsImageStr
        if url == "empty"{
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel!.text = self.item[indexPath.row].newsTitle
            cell.textLabel?.numberOfLines = 3
            cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(15))
            return cell
        }else{
            let initIdentifier = "MyThemeCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: initIdentifier) as? ThemeDetailNewsTableView
            if cell == nil{
                tableView.register(UINib(nibName: "ThemeDetailNewsTableView", bundle: nil), forCellReuseIdentifier: initIdentifier)
                cell = tableView.dequeueReusableCell(withIdentifier: initIdentifier) as? ThemeDetailNewsTableView
            }
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "正在加载中，请稍候"
            
            DispatchQueue.global(qos: .background).async {
                cell?.themeDetailImage.sd_setAnimationImages(with: [URL(string: url!)!])
                
                DispatchQueue.main.async {
                    cell?.themeDetailLabel.text = self.item[indexPath.row].newsTitle
                    cell?.selectionStyle = UITableViewCellSelectionStyle.none
                    hud.hide(animated: true)
                    hud.removeFromSuperview()
                }
                
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let themeDataDetailView = NewsDetailViewController()
        themeDataDetailView.id = self.item[indexPath.row].id
        self.navigationController?.pushViewController(themeDataDetailView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.layer.transform = CATransform3DMakeRotation(60, 1, 1, 1)
    //        UIView.animate(withDuration: 0.5, animations: {
    //            cell.layer.transform = CATransform3DMakeTranslation(2, 2, 4)
    //        })
    //    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(2, 0.5, 60)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeTranslation(1, 1, 1)
        })
    }
    
    
    
    func getThemeData(url: String){
        Alamofire.request(url, method: .get).responseJSON { (response) in 
            
            let JSON = response.result.value as! Dictionary<String,Any>
            let json = JSON["stories"] as! Array<Any>
            for i in 0..<json.count {
                let data = json[i] as! Dictionary<String,Any>
                let str1 = data["id"] as! Int
                var str2: String?
                
                if (data["images"] != nil) {
                    let sth = data["images"] as! Array<String>
                    str2 = sth[0]
                } else {
                    str2 = "empty"
                }
                let str3 = data["title"] as! String
                
                self.item.append((NewsCellModel(id: str1, newsTitle: str3, newsImageStr: str2!)))
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func back(){
        //返回上一级视图
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
