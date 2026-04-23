//
//  ChangeOrderCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//


import UIKit

class ChangeOrderCell: BaseAuditCell {
    @IBOutlet weak var codeLb: UILabel!
    @IBOutlet weak var hanldType: UILabel!
    @IBOutlet weak var alterSumLb: UILabel!
    @IBOutlet weak var startNoLb: UILabel!
    @IBOutlet weak var changeTypeLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(withModel model: ChangeOrderModel){
        self.codeLb.text = model.code
        self.hanldType.text = "变更类型：\(self.hanldType(type:model.hanldType ?? ""))"
        self.alterSumLb.text = "变更金额：\(model.alterSum ?? "")"
        self.startNoLb.text = "起讫桩号：\(model.startNo ?? "")"
        self.changeTypeLb.text = "变更原因：\(model.changeType ?? "")"
        self.setupStatus(status: model.status ?? "")
        
    }
    
    func hanldType (type:String) ->  NSString{
        switch type {
        case "0":
            return "工程变更"
        case "1":
            return "工程废置"
        case "2":
            return "水毁工程"
        default:
            return "未知"
        }
    }
    
}
