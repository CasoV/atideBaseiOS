//
//  MediateModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/29.
//  Copyright © 2018 高小伟. All rights reserved.
//

import Foundation
import SwiftyJSON

class MediateModel: Codable  {
    
    var id: String?
    var userId: String?
    var orgId: String?
    var createTime: String?
    var periodId: String?
    var meteragePartId: String?
    var meteragePartCode: String?
    var billId: String?
    var code: String?
    var name: String?
    var unit: String?
    var unitPrice: String?
    var thisPeriodNum: Float?
    var status: String?
    var projectId: String?
    var sectId: String?
    var intermediateCode: String?
    var meterageDate: String?
    var ledgerId: String?
    var allDesignNum: Float?
    var allPerfectNum: Float?
    var userName: String?
    var newFormFlag: String?
    var orderNo: String?
    var type: String?
    var topCode: String?
    var onlyCode: String?
    var numPrecision: Int?
    var amountPrecision: String?
    var action: String?
    var place: String?
    var meteragePileNo: String?
    var approvalNum: Float?
    var isSelect: Bool?
    
    var lastDesignNum: Float?
    var lastPerfectNum: Float?
    var allChangeNum: Float?
    var lastChangeNum: Float?
    var allAbandonedNum: Float?
    var lastAbandonedNum: Float?
    var allDamagedNum: Float?
    var lastDamagedNum: Float?
    var designChartNum: String?
    var pileNo: Float?
    
    
    
    var certificateNo: String?
    var position: String?
    var approvalMsg: String?
    var partCode: String?
    var changeCode: String?
    
    var lastComplete:Float?
    var complete:Float?
    
    var listStatus: String?
    
    init(jsonData: JSON) {
        id    = jsonData["id"].stringValue
        userId  = jsonData["userId"].stringValue
        orgId  = jsonData["orgId"].stringValue
        createTime = jsonData["createTime"].stringValue
        periodId = jsonData["periodId"].stringValue
        meteragePartId = jsonData["meteragePartId"].stringValue
        meteragePartCode = jsonData["meteragePartCode"].stringValue
        billId    = jsonData["billId"].stringValue
        code  = jsonData["code"].stringValue
        name  = jsonData["name"].stringValue
        unit = jsonData["unit"].stringValue
        unitPrice = jsonData["unitPrice"].stringValue
        thisPeriodNum = jsonData["thisPeriodNum"].floatValue
        status = jsonData["status"].stringValue
        projectId    = jsonData["projectId"].stringValue
        sectId  = jsonData["sectId"].stringValue
        intermediateCode  = jsonData["intermediateCode"].stringValue
        meterageDate = jsonData["meterageDate"].stringValue
        ledgerId = jsonData["ledgerId"].stringValue
        allDesignNum = jsonData["allDesignNum"].floatValue
        allPerfectNum = jsonData["allPerfectNum"].floatValue
        userName    = jsonData["userName"].stringValue
        newFormFlag  = jsonData["newFormFlag"].stringValue
        orderNo  = jsonData["orderNo"].stringValue
        type = jsonData["type"].stringValue
        topCode = jsonData["topCode"].stringValue
        onlyCode = jsonData["onlyCode"].stringValue
        numPrecision = jsonData["numPrecision"].intValue
        amountPrecision = jsonData["amountPrecision"].stringValue
        action = jsonData["action"].stringValue
        place = jsonData["place"].stringValue
        meteragePileNo = jsonData["meteragePileNo"].stringValue
        approvalNum = jsonData["approvalNum"].floatValue
        
        certificateNo = jsonData["certificateNo"].stringValue
        position = jsonData["position"].stringValue
        approvalMsg = jsonData["approvalMsg"].stringValue
        partCode = jsonData["partCode"].stringValue
        changeCode = jsonData["changeCode"].stringValue
        designChartNum = jsonData["designChartNum"].stringValue
        
        listStatus = jsonData["listStatus"].stringValue
        isSelect = false
        
        lastDesignNum = jsonData["lastDesignNum"].floatValue
        lastPerfectNum = jsonData["lastPerfectNum"].floatValue
        allChangeNum = jsonData["allChangeNum"].floatValue
        lastChangeNum = jsonData["lastChangeNum"].floatValue
        allAbandonedNum = jsonData["allAbandonedNum"].floatValue
        lastAbandonedNum = jsonData["lastAbandonedNum"].floatValue
        allDamagedNum = jsonData["allDamagedNum"].floatValue
        lastDamagedNum = jsonData["lastDamagedNum"].floatValue
        
        lastComplete = jsonData["lastComplete"].floatValue
        complete = jsonData["complete"].floatValue
    }

}
