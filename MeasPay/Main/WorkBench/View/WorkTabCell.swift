//
//  WorkTabCellTableViewCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/21.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit

class WorkTabCell: UITableViewCell {

    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var headLb: UILabel!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var creatTimeLb: UILabel!
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var statusBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.statusLb.transform = CGAffineTransform(rotationAngle: 0.75)
        self.backView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.backView.layer.shadowOpacity = 0.5
        self.backView.layer.shadowColor =  UIColor.lightGray.cgColor
        self.backView.cornerRadius = 5
        self.statusBgView.clipsToBounds = true
        self.selectionStyle = UITableViewCell.SelectionStyle.none

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
