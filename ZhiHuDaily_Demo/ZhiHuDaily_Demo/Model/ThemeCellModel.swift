//
//  ThemeCellModel.swift
//  ZhiHuDaily_Demo
//
//  Created by Rick on 2017/11/4.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit
import Foundation

class ThemeCellModel: NSObject {
    var id: Int!
    var name: String!
    var themeDescription: String!
    var themeImageURL: String!
    

    init(id: Int, name: String, themeDescription: String, themeImgaeURL: String) {
        self.id = id
        self.name = name
        self.themeDescription = themeDescription
        self.themeImageURL = themeImgaeURL
    }
}
