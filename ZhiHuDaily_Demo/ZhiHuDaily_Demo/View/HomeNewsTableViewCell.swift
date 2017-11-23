//
//  HomeNewsTableViewCell.swift
//  ZhiHuDaily_Demo
//
//  Created by Rick on 2017/11/4.
//  Copyright © 2017年 Rick. All rights reserved.
//

import UIKit

class HomeNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var homeNewsLabel: UILabel!
    @IBOutlet weak var homeNewsImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
