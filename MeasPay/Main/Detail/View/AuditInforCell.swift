//
//  AuditInforCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/10.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit

class AuditInforCell: UITableViewCell {
    
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var activeNameLb: UILabel!
     @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var difTimeLb: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btmView: UIView!
    @IBOutlet weak var btmTop: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.bgView.layer.shadowOpacity = 0.5
        self.bgView.layer.shadowColor =  UIColor.lightGray.cgColor
        self.bgView.cornerRadius = 5
        self.selectionStyle = .none
        
    }
    func setup(model:AuditInfoModel){
        self.activeNameLb.text = model.activeName
        self.message.text = model.message
        self.timeLb.text = "\(model.time ?? "") \(model.userName ?? "")"
        if model.differTime == "经过" || model.differTime == nil{
            btmTop.constant = -12
            self.difTimeLb.text = nil
        }else{
            btmTop.constant = 0
            self.difTimeLb.text = model.differTime
        }
        if model.doRet == "退回" {
            self.activeNameLb.textColor = .red
            self.statusImg.image = UIImage(named: "ic_return_white")
        }else{
            self.activeNameLb.textColor = UIColor(red: 94/255.0, green: 192/255.0, blue: 156/255.0, alpha: 1.0)
            self.statusImg.image = UIImage(named: "ic_pass_white")
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
