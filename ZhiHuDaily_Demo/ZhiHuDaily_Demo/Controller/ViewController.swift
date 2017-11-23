//
//  ViewController.swift
//  ZhiHuDaily_Demo
//
//  Created by Rick on 2017/11/3.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit
import SDWebImage




class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, NewsDataRequestDelegate {
   
    var tableView = UITableView()
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var newsCellModelArr = [NewsCellModel]()
    // 首页轮播条
    var headerScrollViewModelArr = [NewsCellModel]()
    var headerView = UIView()
    var scrollView = UIScrollView()
    var hearderButton = UIButton()
    var pageControl = UIPageControl()
    var request = DataRequest()
    
    //LatestNews
    let url = "http://news-at.zhihu.com/api/4/news/latest"
    //Refresh
    var refreshHeader =  MJRefreshGifHeader()
  
     override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .init(x: 0, y: 0, width: width, height: height), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        request = DataRequest()
        request.HomeDataDelegate = self
        request.alamofireRequest(url: url)
       
        
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 61/255.0, green: 198/255.0, blue: 252/255.0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let dict:NSDictionary = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [String : AnyObject]
        self.navigationItem.title = "今日新闻"
        
        self.addLeftBarButtonWithImage(UIImage(named: "Artboard")!)
        self.navigationItem.leftBarButtonItem?.image = UIImage(named: "Artboard")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        
        //MJ进行下拉刷新
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(ViewController.downRefresh))
        
        //MJ上拉加载
        self.tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(ViewController.upRefresh))
        
        self.view.addSubview(tableView)
        
        //定时器控制头条新闻进行跳转
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ViewController.AutoScroll), userInfo: nil, repeats: true)
        
        
    }
    
    func loadHeaderView(){
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height/3))
        self.tableView.tableHeaderView = headerView
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height/3))
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: width*7, height: height/3)
        
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        
        scrollView.showsHorizontalScrollIndicator = false
        headerView.addSubview(scrollView)
        
        hearderButton = UIButton(frame: CGRect(x: 0, y: 0, width: width*7, height: height/3))
        hearderButton.addTarget(self, action: #selector(ViewController.jumpNext), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(hearderButton)
        pageControl = UIPageControl(frame: CGRect(x: width/4, y: height/3.5, width: width/2, height: 25))
        pageControl.numberOfPages = 5
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        pageControl.currentPageIndicatorTintColor = UIColor.white
        headerView.addSubview(pageControl)
        
        
        for i in 1...self.headerScrollViewModelArr.count{
            let model = self.headerScrollViewModelArr[i - 1]
            let imageView = try? UIImageView(image: UIImage(data: .init(contentsOf: URL(string: model.newsImageStr)!)))
            imageView?.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height/3)
            scrollView.addSubview((imageView)!)
            let label = UILabel(frame: CGRect(x: (50 + CGFloat(i) * width), y: 150, width: width - 150, height: height/9))
            label.text = model.newsTitle
            label.textColor = UIColor.white
            label.shadowColor = UIColor.black
            label.textAlignment = .left
            label.numberOfLines = 3
            scrollView.addSubview(label)
        }
        //添加第一页和最后一页
        let imageViewFirst = try? UIImageView(image: UIImage(data: .init(contentsOf: URL(string: self.headerScrollViewModelArr.last!.newsImageStr)!)))
        let labelFirst = UILabel(frame: CGRect(x: 100 + CGFloat(0) * width, y: 100, width: width/2, height: height/9))
        labelFirst.text = self.headerScrollViewModelArr[4].newsTitle
        labelFirst.textColor = UIColor.white
        labelFirst.shadowColor = UIColor.black
        labelFirst.numberOfLines = 3
        imageViewFirst?.frame = CGRect(x: width*CGFloat(0), y: 0, width: width, height: height/3)
        
        let imageViewLast = try? UIImageView(image: UIImage(data: .init(contentsOf: URL(string: self.headerScrollViewModelArr.first!.newsImageStr)!)))
        let labelLast = UILabel(frame: CGRect(x: 100 + CGFloat(6) * width, y: 100, width: width/2, height: height/9))
        labelLast.text = self.headerScrollViewModelArr[0].newsTitle
        labelLast.textColor = UIColor.white
        labelLast.shadowColor = UIColor.black
        labelLast.numberOfLines = 3
        imageViewLast?.frame = CGRect(x: width*CGFloat(6), y: 0, width: width, height: height/3)
        
        scrollView.addSubview(imageViewFirst!)
        scrollView.addSubview(labelFirst)
        scrollView.addSubview(imageViewLast!)
        scrollView.addSubview(labelLast)
    }
    
    func downRefresh(){
        self.tableView.mj_header.beginRefreshing()
        request = DataRequest()
        request.alamofireRequest(url: url)
        
        self.tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
    }
    
    func upRefresh(){
        self.tableView.mj_footer.beginRefreshing()
                self.tableView.reloadData()
        self.tableView.mj_footer.endRefreshing()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / width)
        if page == 0{
            scrollView.scrollRectToVisible(CGRect(x: CGFloat(self.headerScrollViewModelArr.count) * width, y: 0, width: width, height: height/3), animated: false)
        }
        else if page == self.headerScrollViewModelArr.count + 1{
            scrollView.scrollRectToVisible(CGRect(x: width, y: 0, width: width, height: height/3), animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / width
        self.pageControl.currentPage = Int(page - 1)
    }
    
    
    func AutoScroll(){
        var page = self.pageControl.currentPage
        page += 1
        page = page > 4 ? 0 : page
        self.pageControl.currentPage = page
        scrollView.scrollRectToVisible(CGRect(x: CGFloat(page) * width + width , y: 0, width: width, height: height/3), animated: false)
    }
    
    func jumpNext(){
        let newsController = NewsDetailViewController()
        let page = self.scrollView.contentOffset.x/width
        let index = Int(page)
        if index == 0{
            newsController.id = self.headerScrollViewModelArr[index + self.headerScrollViewModelArr.count - 1].id
        }
        else if (index == 6){
            newsController.id = self.headerScrollViewModelArr[index % 5 - 1].id
        }
        else{
            newsController.id = self.headerScrollViewModelArr[index - 1].id
        }
        self.navigationController?.pushViewController(newsController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SDImageCache.shared().clearDisk()
        SDImageCache.shared().clearMemory()
    }

    // 实现 NewsDataRequestDelegate
    func transForValue(newsCellModel: AnyObject) {
        self.newsCellModelArr = newsCellModel as! [NewsCellModel]
        let num = self.newsCellModelArr.count
        self.headerScrollViewModelArr = [newsCellModelArr[num - 5], newsCellModelArr[num - 4], newsCellModelArr[num - 3], newsCellModelArr[num - 2], newsCellModelArr[num - 1]]
        loadHeaderView()
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsCellModelArr.count - headerScrollViewModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let initIdentifier = "MyCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: initIdentifier) as? HomeNewsTableViewCell
        if cell == nil{
            tableView.register(UINib(nibName: "HomeNewsTableViewCell", bundle: nil), forCellReuseIdentifier: initIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: initIdentifier) as? HomeNewsTableViewCell
        }
        //进行cell的绘制
        let model = self.newsCellModelArr[indexPath.row]
        
         let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = "正在加载中，请稍候"
            
            
            DispatchQueue(label: "com.rick.apple", qos: .background).async {
                
                //global(qos: .background).async {
                cell?.homeNewsImage.sd_setAnimationImages(with: [URL(string: model.newsImageStr)!])
                
                
                DispatchQueue.main.async {
                    cell?.homeNewsLabel.text = model.newsTitle
                    cell?.selectionStyle = .none
                    hud.hide(animated: true)
                    hud.removeFromSuperview()
                }
            }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsController = NewsDetailViewController()
        newsController.id = self.newsCellModelArr[indexPath.row].id
        self.navigationController?.pushViewController(newsController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 60)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeTranslation(1, 1, 1)
        })
    }
    

}

