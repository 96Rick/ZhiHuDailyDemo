//
//  NewsDetailViewController.swift
//  ZhiHuDaily_Demo
//
//  Created by Rick on 2017/11/4.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    var webView = UIWebView(frame: CGRect(x: 0, y: -90, width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height + 90))
    var listUrl = "http://daily.zhihu.com/story/"
    var id:Int!
    
    var bottomView: UIView = UIView()
    var bottomBackBtn: UIButton = UIButton(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //加载新闻详情
        loadRequest(url: listUrl+String(self.id))
        self.view.addSubview(webView)
        
        bottomView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-44, width: UIScreen.main.bounds.width, height: 44)
        bottomView.backgroundColor = UIColor.init(red: 61/255, green: 198/255, blue: 252/255, alpha: 0.7)
       
        
        
        bottomBackBtn.frame = CGRect(x: 20, y: 10, width: 60, height: 24)
        bottomBackBtn.setTitle("<Back", for: UIControlState.normal)
        bottomBackBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        bottomBackBtn.setTitleShadowColor(UIColor.black, for: .normal)
        bottomBackBtn.addTarget(self, action: #selector(returnLastView), for: .touchUpInside)
        
        
        self.view.addSubview(bottomView)
        bottomView.addSubview(bottomBackBtn)
        
        
    }
    
    func returnLastView(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadRequest(url: String){
        self.webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
