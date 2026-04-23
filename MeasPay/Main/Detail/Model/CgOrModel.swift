//
//  CgOrModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/17.
//  Copyright © 2019 高小伟. All rights reserved.
//

import Foundation
import SwiftyJSON

class CgOrModel : NSObject {
    
    var alterNo : String?
    var alterNum : String?
    var alterPlace : String?
    var alterType : String?
    var beginNo : String?
    var billId : String?
    var changeCode : String?
    var changeId : String?
    var code : String?
    var complete : String?
    var completeTotal : String?
    var createDate : String?
    var designNum : String?
    var endNo : String?
    var expensePercentage : String?
    var id : String?
    var key : String?
    var lastComplete : String?
    var lastCompleteTotal : String?
    var loadName : String?
    var meteCode : String?
    var meterPart : String?
    var name : String?
    var newFormFlag : String?
    var newlyPrice : String?
    var numPic : String?
    var numPrecision : String?
    var numTotal : String?
    var oldNum : String?
    var onlyCode : String?
    var orderNo : String?
    var page : String?
    var partCode : String?
    var partName : String?
    var perfectDate : String?
    var perfectNo : String?
    var perfectNum : String?
    var periodId : String?
    var picNo : String?
    var place : String?
    var ppp : String?
    var price : String?
    var priceType : String?
    var projectCode : String?
    var projectId : String?
    var projectName : String?
    var remark : String?
    var sectCode : String?
    var sectId : String?
    var sectName : String?
    var sqlPlus : String?
    var startNo : String?
    var stdVersion : String?
    var supplyNum : String?
    var tableName : String?
    var temporaryPrice : String?
    var topCode : String?
    var twoComplete : String?
    var twoCompleteTotal : String?
    var type : String?
    var unit : String?
    var unitPrice : String?
    var uselessNum : String?
    var userId : String?
    var userName : String?
    var waterNum : String?
    var alterSum : String?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary:JSON){
        alterNo = dictionary["alterNo"] .stringValue
        alterNum = dictionary["alterNum"] .stringValue
        alterPlace = dictionary["alterPlace"] .stringValue
        alterType = dictionary["alterType"] .stringValue == "1" ? "新增" : "变更"
        beginNo = dictionary["beginNo"] .stringValue
        billId = dictionary["billId"] .stringValue
        changeCode = dictionary["changeCode"] .stringValue
        changeId = dictionary["changeId"] .stringValue
        code = dictionary["code"] .stringValue
        complete = dictionary["complete"] .stringValue
        completeTotal = dictionary["completeTotal"] .stringValue
        createDate = dictionary["createDate"] .stringValue
        designNum = dictionary["designNum"] .stringValue
        endNo = dictionary["endNo"] .stringValue
        expensePercentage = dictionary["expensePercentage"] .stringValue
        id = dictionary["id"] .stringValue
        key = dictionary["key"] .stringValue
        lastComplete = dictionary["lastComplete"] .stringValue
        lastCompleteTotal = dictionary["lastCompleteTotal"] .stringValue
        loadName = dictionary["loadName"] .stringValue
        meteCode = dictionary["meteCode"] .stringValue
        meterPart = dictionary["meterPart"] .stringValue
        name = dictionary["name"] .stringValue
        newFormFlag = dictionary["newFormFlag"] .stringValue
        newlyPrice = dictionary["newlyPrice"] .stringValue
        numPic = dictionary["numPic"] .stringValue
        numPrecision = dictionary["numPrecision"] .stringValue
        numTotal = dictionary["numTotal"] .stringValue
        oldNum = dictionary["oldNum"] .stringValue
        onlyCode = dictionary["onlyCode"] .stringValue
        orderNo = dictionary["orderNo"] .stringValue
        page = dictionary["page"] .stringValue
        partCode = dictionary["partCode"] .stringValue
        partName = dictionary["partName"] .stringValue
        perfectDate = dictionary["perfectDate"] .stringValue
        perfectNo = dictionary["perfectNo"] .stringValue
        perfectNum = dictionary["perfectNum"] .stringValue
        periodId = dictionary["periodId"] .stringValue
        picNo = dictionary["picNo"] .stringValue
        place = dictionary["place"] .stringValue
        ppp = dictionary["ppp"] .stringValue
        price = dictionary["price"] .stringValue
        priceType = dictionary["priceType"] .stringValue
        projectCode = dictionary["projectCode"] .stringValue
        projectId = dictionary["projectId"] .stringValue
        projectName = dictionary["projectName"] .stringValue
        remark = dictionary["remark"] .stringValue
        sectCode = dictionary["sectCode"] .stringValue
        sectId = dictionary["sectId"] .stringValue
        sectName = dictionary["sectName"] .stringValue
        sqlPlus = dictionary["sqlPlus"] .stringValue
        startNo = dictionary["startNo"] .stringValue
        stdVersion = dictionary["stdVersion"] .stringValue
        supplyNum = dictionary["supplyNum"] .stringValue
        tableName = dictionary["tableName"] .stringValue
        temporaryPrice = dictionary["temporaryPrice"] .stringValue
        topCode = dictionary["topCode"] .stringValue
        twoComplete = dictionary["twoComplete"] .stringValue
        twoCompleteTotal = dictionary["twoCompleteTotal"] .stringValue
        type = dictionary["type"] .stringValue
        unit = dictionary["unit"] .stringValue
        unitPrice = dictionary["unitPrice"] .stringValue
        uselessNum = dictionary["uselessNum"] .stringValue
        userId = dictionary["userId"] .stringValue
        userName = dictionary["userName"] .stringValue
        waterNum = dictionary["waterNum"] .stringValue
    }
    
}
