//
//  BaseTypeCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/20.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit

class BaseTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var tagImg: UIImageView!
    @IBOutlet weak var detailLb: UILabel!
    
    override func awakeFromNib() {
        self.tagImg.layer.masksToBounds = true
        self.tagImg.layer.cornerRadius = 20
        self.tagImg.image = UIImage(named:"bg_middle_measure")
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.1
        self.layer.backgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 0.1).cgColor
    }

}
