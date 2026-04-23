//
//  ChangeOrderModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChangeOrderModel : Codable{
    
    var alterSum : String?
    var approvalNo : String?
    var approvalUnit : String?
    var changeContent : String?
    var changeItems : String?
    var changeReason : String?
    var changeType : String?
    var code : String?
    var createDate : String?
    var designUnitView : String?
    var estimateSum : String?
    var formula : String?
    var handle : String?
    var handleNo : String?
    var hanldType : String?
    var happenDate : String?
    var id : String?
    var materialContent : String?
    var meterPart : String?
    var name : String?
    var newFormFlag : String?
    var oldPic : String?
    var oldSum : String?
    var oneFormula : String?
    var orderNo : String?
    var page : String?
    var periodId : String?
    var place : String?
    var project : String?
    var projectCode : String?
    var projectId : String?
    var projectName : String?
    var readDate : String?
    var reportDate : String?
    var sectCode : String?
    var sectId : String?
    var sectName : String?
    var sqlPlus : String?
    var startNo : String?
    var status : String?
    var threeFormula : String?
    var totalNum : String?
    var transferContent : String?
    var twoFormula : String?
    var type : String?
    var userId : String?
    var userName : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary:JSON){
        alterSum = dictionary["alterSum"].stringValue
        approvalNo = dictionary["approvalNo"].stringValue
        approvalUnit = dictionary["approvalUnit"] .stringValue
        changeContent = dictionary["changeContent"].stringValue
        changeItems = dictionary["changeItems"].stringValue
        changeReason = dictionary["changeReason"] .stringValue
        changeType = dictionary["changeType"] .stringValue
        code = dictionary["code"] .stringValue
        createDate = dictionary["createDate"].stringValue
        designUnitView = dictionary["designUnitView"].stringValue
        estimateSum = dictionary["estimateSum"] .stringValue
        formula = dictionary["formula"].stringValue
        handle = dictionary["handle"].stringValue
        handleNo = dictionary["handleNo"].stringValue
        hanldType = dictionary["hanldType"] .stringValue
        happenDate = dictionary["happenDate"] .stringValue
        id = dictionary["id"] .stringValue
        materialContent = dictionary["materialContent"] .stringValue
        meterPart = dictionary["meterPart"] .stringValue
        name = dictionary["name"] .stringValue
        newFormFlag = dictionary["newFormFlag"].stringValue
        oldPic = dictionary["oldPic"].stringValue
        oldSum = dictionary["oldSum"].stringValue
        oneFormula = dictionary["oneFormula"].stringValue
        orderNo = dictionary["orderNo"].stringValue
        page = dictionary["page"].stringValue
        periodId = dictionary["periodId"].stringValue
        place = dictionary["place"].stringValue
        project = dictionary["project"] .stringValue
        projectCode = dictionary["projectCode"].stringValue
        projectId = dictionary["projectId"] .stringValue
        projectName = dictionary["projectName"] .stringValue
        readDate = dictionary["readDate"].stringValue
        reportDate = dictionary["reportDate"] .stringValue
        sectCode = dictionary["sectCode"].stringValue
        sectId = dictionary["sectId"] .stringValue
        sectName = dictionary["sectName"] .stringValue
        sqlPlus = dictionary["sqlPlus"].stringValue
        startNo = dictionary["startNo"] .stringValue
        status = dictionary["status"].stringValue
        threeFormula = dictionary["threeFormula"] .stringValue
        totalNum = dictionary["totalNum"] .stringValue
        transferContent = dictionary["transferContent"] .stringValue
        twoFormula = dictionary["twoFormula"] .stringValue
        type = dictionary["type"] .stringValue
        userId = dictionary["userId"] .stringValue
        userName = dictionary["userName"] .stringValue
    }
 
}
