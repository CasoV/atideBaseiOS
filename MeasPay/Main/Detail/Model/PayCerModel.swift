//
//  PayCerModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/17.
//  Copyright © 2019 高小伟. All rights reserved.
//


import Foundation
import SwiftyJSON

class PayCerModel : NSObject{
    
    var amount : String?
    var billQuantityId : String?
    var compactNo : String?
    var detectionCode : String?
    var id : String?
    var mount : String?
    var name : String?
    var page : String?
    var place : String?
    var projectMeteringBillId : String?
    var remark : String?
    var stakeNumber : String?
    var surplusAmount : String?
    var surplusMount : String?
    var thiPaymentAmount : String?
    var thisEndPaymentAmount : String?
    var thisEndPaymentMount : String?
    var thisPaymentNum : String?
    var thisPlace : String?
    var thisStakeNumber : String?
    var unit : String?
    var unitPrice : String?
    var upEndPaymentAmount : String?
    var upEndPaymentMount : String?
    var updateAmount : String?
    var updateMount : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary:JSON){
        amount = dictionary["amount"] .stringValue
        billQuantityId = dictionary["billQuantityId"] .stringValue
        compactNo = dictionary["compactNo"] .stringValue
        detectionCode = dictionary["detectionCode"] .stringValue
        id = dictionary["id"] .stringValue
        mount = dictionary["mount"] .stringValue
        name = dictionary["name"] .stringValue
        page = dictionary["page"] .stringValue
        place = dictionary["place"] .stringValue
        projectMeteringBillId = dictionary["projectMeteringBillId"] .stringValue
        remark = dictionary["remark"] .stringValue
        stakeNumber = dictionary["stakeNumber"] .stringValue
        surplusAmount = dictionary["surplusAmount"] .stringValue
        surplusMount = dictionary["surplusMount"] .stringValue
        thiPaymentAmount = dictionary["thiPaymentAmount"] .stringValue
        thisEndPaymentAmount = dictionary["thisEndPaymentAmount"] .stringValue
        thisEndPaymentMount = dictionary["thisEndPaymentMount"] .stringValue
        thisPaymentNum = dictionary["thisPaymentNum"] .stringValue
        thisPlace = dictionary["thisPlace"] .stringValue
        thisStakeNumber = dictionary["thisStakeNumber"] .stringValue
        unit = dictionary["unit"] .stringValue
        unitPrice = dictionary["unitPrice"] .stringValue
        upEndPaymentAmount = dictionary["upEndPaymentAmount"] .stringValue
        upEndPaymentMount = dictionary["upEndPaymentMount"] .stringValue
        updateAmount = dictionary["updateAmount"] .stringValue
        updateMount = dictionary["updateMount"] .stringValue
    }

}
