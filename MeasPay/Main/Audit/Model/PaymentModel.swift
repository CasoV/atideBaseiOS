//
//  PaymentModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//
import UIKit
import SwiftyJSON

class PaymentModel : Codable{
    
    var createTime : String?
    var id : String?
    var page : String?
    var paymentType : String?
    var periodId : String?
    var projectId : String?
    var remark : String?
    var sectionId : String?
    var status : String?
    var type : String?
    var updateTime : String?
    var userId : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary:JSON){
        createTime = dictionary["createTime"].stringValue
        id = dictionary["id"].stringValue
        page = dictionary["page"].stringValue
        paymentType = dictionary["paymentType"].stringValue
        periodId = dictionary["periodId"].stringValue
        projectId = dictionary["projectId"].stringValue
        remark = dictionary["remark"].stringValue
        sectionId = dictionary["sectionId"].stringValue
        status = dictionary["status"].stringValue
        type = dictionary["type"].stringValue
        updateTime = dictionary["updateTime"].stringValue
        userId = dictionary["userId"].stringValue
    }
}
