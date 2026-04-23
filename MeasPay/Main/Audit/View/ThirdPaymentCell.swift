//
//  ThirdPaymentCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit

class ThirdPaymentCell: BaseAuditCell {
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var remarkLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setup(withModel model: PaymentModel){
        self.dateLb.text = self.timeStampToTime(stamp:model.createTime! as NSString)
        self.remarkLb.text = "备注：\(model.remark ?? "")"
        self.setupStatus(status: model.status ?? "")
    }
    
    func timeStampToTime (stamp:NSString) ->  String{
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(stamp.doubleValue/1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd"
        print("对应的日期时间：\(dformatter.string(from: date))")
        return dformatter.string(from: date)
    }

}
