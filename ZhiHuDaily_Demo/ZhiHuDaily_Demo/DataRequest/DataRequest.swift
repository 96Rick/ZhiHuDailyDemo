//
//  DataRequest.swift
//  ZhiHuDaily_Demo
//
//  Created by Rick on 2017/11/4.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class DataRequest: NSObject {
    var homeNewsArr: [NewsCellModel] = []
    var HomeDataDelegate: NewsDataRequestDelegate?
    
    var themeListArr: [ThemeCellModel] = []
    var ThemeDataDelegate: ThemeDataRequestDelegaete?
    
    
    func alamofireRequest(url: String) {
        Alamofire.request(url, method: .get, parameters: ["foo": "bar"]).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                if let JSON = response.result.value as? Dictionary<String,Any> {
                    if let json = JSON["stories"] as? Array<Any> {
                        for i in 0..<json.count {
                            let newsData = json[i] as! Dictionary<String,Any>
                            let id = newsData["id"] as! Int
                            let newsTitle = newsData["title"] as! String
                            let imageArr = newsData["images"] as! Array<Any>
                            let newsImageStr = imageArr[0] as! String
                            self.homeNewsArr.append(NewsCellModel(id: id, newsTitle: newsTitle, newsImageStr: newsImageStr))
                        }
                    
                    if let json = JSON["top_stories"] as? Array<Any> {
                        for i in 0..<json.count {
                            let newsData = json[i] as! Dictionary<String,Any>
                            let id = newsData["id"] as! Int
                            let newsTitle = newsData["title"] as! String
                            let newsImgaeStr = newsData["image"] as! String
                            self.homeNewsArr.append(NewsCellModel(id: id, newsTitle: newsTitle, newsImageStr: newsImgaeStr))
                        }
                    }
                    self.HomeDataDelegate?.transForValue(newsCellModel: self.homeNewsArr as AnyObject)
                }
            }
            case .failure(_):
                print("Alamofire Request Fail")
            }
        }
    }
    
    func getThemeData() {
        Alamofire.request("http://news-at.zhihu.com/api/4/themes", method: .get).responseJSON { (response) in
            switch response.result {
                
            case .success(_):
                if let JSON = response.result.value as? Dictionary<String,Any> {
                    if let json = JSON["others"] as? Array<Any> {
                        for i in 0..<json.count {
                            let themeData = json[i] as! Dictionary<String,Any>
                            let id = themeData["id"] as! Int
                            let name = themeData["name"] as! String
                            let themeDescription = themeData["description"] as! String
                            let themeImageUrl = themeData["thumbnail"] as! String
                            self.themeListArr.append(ThemeCellModel(id: id, name: name, themeDescription: themeDescription, themeImgaeURL: themeImageUrl))
                        }
                        self.ThemeDataDelegate?.transForThemeDataValue(themeData: self.themeListArr as AnyObject)
                    }
                }
                
            case .failure(_):
                print("ThemeData Request Fail!")
            }
        }
    }
}
