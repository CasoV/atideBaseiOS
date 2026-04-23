//
//  NoPassCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/15.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoPassCell: UITableViewCell {
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var unFinishLb: UILabel!
    @IBOutlet weak var statusLb: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var btmView: UIView!
    @IBOutlet weak var tagImg: UIImageView!
    @IBOutlet weak var choosePeopleLb: UILabel!
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
        if model.status == "2"{
            self.topView.backgroundColor = UIColor(red: 92/255.0, green: 192/255.0, blue: 156/255.0, alpha: 1.0)
            self.headImg.image = UIImage(named: "dot_blue")
            self.statusLb.isHidden = false
            
        }else{
            self.topView.backgroundColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
            self.headImg.image = UIImage(named: "dot_gray")
            self.statusLb.isHidden = true
        }
        self.setupLb(model: model,indexPath: indexPath)
    }
    
    func setupBackCell(model:PassModel,indexPath:IndexPath) {
        self.headImg.image = UIImage(named: "head")
        self.tagImg.image = UIImage(named: "ic_return_white")
        self.topView.backgroundColor = UIColor(red: 0/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1.0)
        self.btmView.backgroundColor = UIColor(red: 0/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1.0)
        self.setupLb(model: model,indexPath: indexPath)
        self.statusLb.text = "退回到该步"
        self.statusLb.isHidden = true
    }
    
    func setupLb(model:PassModel,indexPath:IndexPath) {
        var agentArr = [String]()
        for dic in model.taskAssignees ?? Array(){
//            if dic.dictionaryValue["taskKey"]?.stringValue == model.id{
            if dic.dictionaryValue["checked"]?.stringValue == "1"{
                agentArr.append((dic.dictionaryValue["userName"]?.stringValue) ?? "")
            }
               
//            }
        }
        choosePeopleLb.isHidden = model.nextStep != "1"
//        if(model.nextStep == "1"){
////            下一步默认经办人
//            unFinishLb.text =  "经办人：\( model.taskAssignees?[0].dictionaryValue["userName"] ?? "")"
//        }else{
//            unFinishLb.text =  "经办人：\(agentArr.joined(separator: " "))"
//        }
        if model.nextStepUserName == nil || model.nextStepUserName == ""{
             unFinishLb.text =  "经办人：\(agentArr.joined(separator: " "))"
        }else{
            unFinishLb.text =  "经办人：\(model.nextStepUserName ?? "")"
        }
        nameLb.text = model.name
        self.topView.isHidden = indexPath.row == 0 ? true : false
        self.btmView.isHidden = indexPath.row == self.dataArr.count - 1 ? true : false
    }

}
