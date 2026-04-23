//
//  PmtReportModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class PmtReportModel : Codable{
    
    var accessSql : String?
    var calculationType : String?
    var code : String?
    var createDate : String?
    var dataFrom : String?
    var dataFromName : String?
    var dataFroms : String?
    var endTime : String?
    var firstSum : String?
    var id : String?
    var ifAdvance : String?
    var instanceId : String?
    var meter : String?
    var newFormFlag : String?
    var orderNo : String?
    var orgId : String?
    var orgName : String?
    var page : String?
    var periodId : String?
    var ppp : String?
    var pppName : String?
    var projectCode : String?
    var projectId : String?
    var projectName : String?
    var remark : String?
    var sectCode : String?
    var sectId : String?
    var sectName : String?
    var sqlPlus : String?
    var startTime : String?
    var status : String?
    var statuses : String?
    var type : String?
    var userId : String?
    var userName : String?
    var periodNum: Int?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init( dictionary:JSON){
        accessSql = dictionary["accessSql"] .stringValue
        calculationType = dictionary["calculationType"] .stringValue
        code = dictionary["code"] .stringValue
        createDate = dictionary["createDate"] .stringValue
        dataFrom = dictionary["dataFrom"] .stringValue
        dataFromName = dictionary["dataFromName"] .stringValue
        dataFroms = dictionary["dataFroms"] .stringValue
        endTime = dictionary["endTime"] .stringValue
        firstSum = dictionary["firstSum"] .stringValue
        id = dictionary["id"] .stringValue
        ifAdvance = dictionary["ifAdvance"] .stringValue
        instanceId = dictionary["instanceId"] .stringValue
        meter = dictionary["meter"] .stringValue
        newFormFlag = dictionary["newFormFlag"] .stringValue
        orderNo = dictionary["orderNo"] .stringValue
        orgId = dictionary["orgId"] .stringValue
        orgName = dictionary["orgName"] .stringValue
        page = dictionary["page"] .stringValue
        periodId = dictionary["periodId"] .stringValue
        ppp = dictionary["ppp"] .stringValue
        pppName = dictionary["pppName"] .stringValue
        projectCode = dictionary["projectCode"] .stringValue
        projectId = dictionary["projectId"] .stringValue
        projectName = dictionary["projectName"] .stringValue
        remark = dictionary["remark"] .stringValue
        sectCode = dictionary["sectCode"] .stringValue
        sectId = dictionary["sectId"] .stringValue
        sectName = dictionary["sectName"] .stringValue
        sqlPlus = dictionary["sqlPlus"] .stringValue
        startTime = dictionary["startTime"] .stringValue
        status = dictionary["status"] .stringValue
        statuses = dictionary["statuses"] .stringValue
        type = dictionary["type"] .stringValue
        userId = dictionary["userId"] .stringValue
        periodNum = dictionary["periodNum"] .intValue
        userName = dictionary["userName"] .stringValue
    }
}
