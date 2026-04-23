//
//  BaseAuditCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit

class BaseAuditCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var statusBgView: UIView!
    @IBOutlet weak var statusLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.statusLb.transform = CGAffineTransform(rotationAngle: 0.75)
        self.bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.bgView.layer.shadowOpacity = 0.5
        self.bgView.layer.shadowColor =  UIColor.lightGray.cgColor
        self.bgView.cornerRadius = 5
        self.statusBgView.clipsToBounds = true
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }

    func setupStatus(status: String){
        
        switch status {
        case "","1","0":
            self.statusLb.text = "待申报"
            self.statusLb.backgroundColor = UIColor.init(red: 54/255.0, green: 54/255.0, blue: 54/255.0, alpha: 1.0)
            
        case "2":
            self.statusLb.text = "退回"
            self.statusLb.backgroundColor = UIColor.init(red: 255/255.0, green: 71/255.0, blue: 81/255.0, alpha: 1.0)
            
        case "3":
            self.statusLb.text = "流转中"
            self.statusLb.backgroundColor = UIColor.init(red: 92/255.0, green: 192/255.0, blue: 156/255.0, alpha: 1.0)
            
        case "4":
            self.statusLb.text = "审批通过"
            self.statusLb.backgroundColor = UIColor.init(red: 0/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1.0)
        default:
            self.statusLb.text = status
            self.statusLb.backgroundColor = UIColor.init(red: 92/255.0, green: 192/255.0, blue: 156/255.0, alpha: 1.0)
        }
    }
}
