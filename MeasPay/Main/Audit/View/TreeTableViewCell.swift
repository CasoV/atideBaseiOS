//
//  TreeTableViewCell.swift
//  RATreeViewExamples
//
//  Created by Rafal Augustyniak on 22/11/15.
//  Copyright © 2015 com.Augustyniak. All rights reserved.
//

import UIKit

class TreeTableViewCell : UITableViewCell {
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var typeImg: UIImageView!
    @IBOutlet weak var titleLbLeft: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
    }

    func setup(withTitle title: String){
        titleLb.text = title
    }
}
