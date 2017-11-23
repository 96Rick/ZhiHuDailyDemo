//
//  NewsCellModel.swift
//  ZhiHuDaily_Demo
//
//  Created by Rick on 2017/11/4.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit

class NewsCellModel: NSObject {
    var id: Int!
    var newsTitle: String!
    var newsImageStr: String!
    
    init(id: Int, newsTitle: String) {
        self.id = id
        self.newsTitle = newsTitle
    }
    
    init(id: Int, newsTitle: String, newsImageStr: String) {
        self.id = id
        self.newsTitle = newsTitle
        self.newsImageStr = newsImageStr
    }
    

}
