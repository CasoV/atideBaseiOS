//
//  ReorderModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/30.
//  Copyright © 2019 高小伟. All rights reserved.
//

import Foundation
import SwiftyJSON

class SortModel: Codable {
    var id : String?
    var orderNo : String?
}
class SortSaveModel: Codable {
    var id : String?
    var orderNo : String?
    var intermediateCode:String?
}

class ReorderModel : Codable{
    
    var accessSql : String?
    var accountStatement : String?
    var action : String?
    var allAbandonedNum : String?
    var allChangeNum : String?
    var allDamagedNum : String?
    var allDesignNum : String?
    var allPerfectNum : String?
    var amountPrecision : String?
    var approvalNum : String?
    var billId : String?
    var calRule : String?
    var certificateNo : String?
    var changeCode : String?
    var code : String?
    var complete : String?
    var createTime : String?
    var dataForm : String?
    var declareNum : String?
    var designChartNum : String?
    var endTime : String?
    var id : String?
    var instanceId : String?
    var intermediateCode : String?
    var isCheck : String?
    var jssRemark : String?
    var lastAbandonedNum : String?
    var lastChangeNum : String?
    var lastComplete : String?
    var lastDamagedNum : String?
    var lastDesignNum : String?
    var lastPerfectNum : String?
    var ledgerId : String?
    var mainForm : String?
    var meterageDate : String?
    var meteragePartCode : String?
    var meteragePartId : String?
    var meteragePileNo : String?
    var name : String?
    var newFormFlag : String?
    var numPrecision : String?
    var onlyCode : String?
    var orderNo : String?
    var orderQuery : String?
    var orgId : String?
    var orgName : String?
    var page : String?
    var partCode : String?
    var periodId : String?
    var pileNo : String?
    var place : String?
    var position : String?
    var projectId : String?
    var sectId : String?
    var simpleName : String?
    var startTime : String?
    var status : String?
    var statuses : String?
    var sumNum : String?
    var surplusNum : String?
    var thisPeriodNum : String?
    var topCode : String?
    var type : String?
    var unit : String?
    var unitPrice : String?
    var userId : String?
    var userName : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary:JSON){
        accessSql = dictionary["accessSql"] .stringValue
        accountStatement = dictionary["accountStatement"] .stringValue
        action = dictionary["action"] .stringValue
        allAbandonedNum = dictionary["allAbandonedNum"] .stringValue
        allChangeNum = dictionary["allChangeNum"] .stringValue
        allDamagedNum = dictionary["allDamagedNum"] .stringValue
        allDesignNum = dictionary["allDesignNum"] .stringValue
        allPerfectNum = dictionary["allPerfectNum"] .stringValue
        amountPrecision = dictionary["amountPrecision"] .stringValue
        approvalNum = dictionary["approvalNum"] .stringValue
        billId = dictionary["billId"] .stringValue
        calRule = dictionary["calRule"] .stringValue
        certificateNo = dictionary["certificateNo"] .stringValue
        changeCode = dictionary["changeCode"] .stringValue
        code = dictionary["code"] .stringValue
        complete = dictionary["complete"] .stringValue
        createTime = dictionary["createTime"] .stringValue
        dataForm = dictionary["dataForm"] .stringValue
        declareNum = dictionary["declareNum"] .stringValue
        designChartNum = dictionary["designChartNum"] .stringValue
        endTime = dictionary["endTime"] .stringValue
        id = dictionary["id"] .stringValue
        instanceId = dictionary["instanceId"] .stringValue
        intermediateCode = dictionary["intermediateCode"] .stringValue
        isCheck = dictionary["isCheck"] .stringValue
        jssRemark = dictionary["jssRemark"] .stringValue
        lastAbandonedNum = dictionary["lastAbandonedNum"] .stringValue
        lastChangeNum = dictionary["lastChangeNum"] .stringValue
        lastComplete = dictionary["lastComplete"] .stringValue
        lastDamagedNum = dictionary["lastDamagedNum"] .stringValue
        lastDesignNum = dictionary["lastDesignNum"] .stringValue
        lastPerfectNum = dictionary["lastPerfectNum"] .stringValue
        ledgerId = dictionary["ledgerId"] .stringValue
        mainForm = dictionary["mainForm"] .stringValue
        meterageDate = dictionary["meterageDate"] .stringValue
        meteragePartCode = dictionary["meteragePartCode"] .stringValue
        meteragePartId = dictionary["meteragePartId"] .stringValue
        meteragePileNo = dictionary["meteragePileNo"] .stringValue
        name = dictionary["name"] .stringValue
        newFormFlag = dictionary["newFormFlag"] .stringValue
        numPrecision = dictionary["numPrecision"] .stringValue
        onlyCode = dictionary["onlyCode"] .stringValue
        orderNo = dictionary["orderNo"] .stringValue
        orderQuery = dictionary["orderQuery"] .stringValue
        orgId = dictionary["orgId"] .stringValue
        orgName = dictionary["orgName"] .stringValue
        page = dictionary["page"] .stringValue
        partCode = dictionary["partCode"] .stringValue
        periodId = dictionary["periodId"] .stringValue
        pileNo = dictionary["pileNo"] .stringValue
        place = dictionary["place"] .stringValue
        position = dictionary["position"] .stringValue
        projectId = dictionary["projectId"] .stringValue
        sectId = dictionary["sectId"] .stringValue
        simpleName = dictionary["simpleName"] .stringValue
        startTime = dictionary["startTime"] .stringValue
        status = dictionary["status"] .stringValue
        statuses = dictionary["statuses"] .stringValue
        sumNum = dictionary["sumNum"] .stringValue
        surplusNum = dictionary["surplusNum"] .stringValue
        thisPeriodNum = dictionary["thisPeriodNum"] .stringValue
        topCode = dictionary["topCode"] .stringValue
        type = dictionary["type"] .stringValue
        unit = dictionary["unit"] .stringValue
        unitPrice = dictionary["unitPrice"] .stringValue
        userId = dictionary["userId"] .stringValue
        userName = dictionary["userName"] .stringValue
    }
    
   
    
}
