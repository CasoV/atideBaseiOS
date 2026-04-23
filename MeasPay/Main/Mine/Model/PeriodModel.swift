//
//  PeriodModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/26.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class PeriodModel: NSObject {
    var id: String?
    var periodNum: String?
    var projectId: String?
    var sectId: String?
    var userId: String?
    var userName: String?
    var orgId: String?
    var createTime: String?
    var startDate: String?
    var endDate: String?
    var lastPeriodId: String?
    var lastPeriodName: String?
    var code: String?
    var orderNo: String?
    var havePay: String?
    
    init(jsonData: JSON) {
        id    = jsonData["id"].stringValue
        periodNum = jsonData["periodNum"].stringValue
        projectId  = jsonData["projectId"].stringValue
        sectId      = jsonData["sectId"].stringValue
        userId     = jsonData["userId"].stringValue
        userName    = jsonData["userName"].stringValue
        orgId    = jsonData["orgId"].stringValue
        createTime    = jsonData["createTime"].stringValue
        startDate    = jsonData["startDate"].stringValue
        endDate    = jsonData["endDate"].stringValue
        lastPeriodId    = jsonData["lastPeriodId"].stringValue
        lastPeriodName    = jsonData["lastPeriodName"].stringValue
        code    = jsonData["code"].stringValue
        orderNo    = jsonData["orderNo"].stringValue
        havePay    = jsonData["havePay"].stringValue
    }
}
