//
//  PassCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/15.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class PassCell: UITableViewCell {
    @IBOutlet weak var taskTitleLb: UILabel!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var messageLb: UILabel!
    @IBOutlet weak var signatureImg: UIImageView!
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btmView: UIView!
    @IBOutlet weak var intervalLb: UILabel!
    @IBOutlet weak var btmViewTop: NSLayoutConstraint!
    
    var dataArr = [PassModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.bgView.layer.shadowOpacity = 0.5
        self.bgView.layer.shadowColor =  UIColor.lightGray.cgColor
        self.bgView.cornerRadius = 5
        self.statusLb.layer.masksToBounds = true
        self.statusLb.cornerRadius = 5
        self.selectionStyle = .none
    }

    func setupCell(model:PassModel,indexPath:IndexPath) {
        self.taskTitleLb.text = model.name
        if model.forwardOpinions?.count > 0 {
            let option:Dictionary = (model.forwardOpinions?.first)!.dictionaryValue
            self.userNameLb.text = ("经办人：\(option["userName"]?.stringValue ?? "")")
            self.messageLb.text =  option["message"]?.stringValue
            self.timeLb.text =  option["time"]?.stringValue
            let data = NSData(base64Encoded:option["signature"]?.stringValue ?? "",options: .ignoreUnknownCharacters)
            self.signatureImg.image =  UIImage.init(data: data! as Data)
            if model.order == "0"{
                self.intervalLb.text = self.convertStrToTime(timeStr: option["duration"]?.stringValue ?? "0")
                self.btmViewTop.constant = -1
            }else{
                self.btmViewTop.constant = -12
                self.intervalLb.text = ""
            }
        }else{
            
        }
        self.topView.isHidden = indexPath.row == 0 ? true : false
        self.btmView.isHidden = indexPath.row == self.dataArr.count - 1 ? true : false
    }
    
    func convertStrToTime(timeStr:String) -> String {
        let second = Int(timeStr)!/1000
        let minute = second/60
        let hour = minute/60
        let day = hour/24
        if day > 0 {
            return "经过\(day)天\(hour%24)小时\(minute%60)分"
        }else if hour > 0 {
             return "经过\(hour%24)小时\(minute%60)分"
        }else if hour > 0 {
            return "经过\(minute%60)分"
        }else{
            return ""
        }
    }

}
