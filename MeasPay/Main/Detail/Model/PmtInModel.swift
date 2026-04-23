//
//  PmtInModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/16.
//  Copyright © 2019 高小伟. All rights reserved.
//


import Foundation
import SwiftyJSON

class PmtInModel : NSObject{
    
    var contractAmount : String?
    var createTime : String?
    var designAmount : String?
    var id : String?
    var periodId : String?
    var projectExpressionPeriodCode : String?
    var projectId : String?
    var projectName : String?
    var sectionId : String?
    var thisEndPaymentAmount : String?
    var thisPaymentAmount : String?
    var upEndPaymentAmount : String?
    var updateAmount : String?
    var updateTime : String?
    var userId : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        contractAmount = dictionary["contractAmount"] .stringValue
        createTime = dictionary["createTime"] .stringValue
        designAmount = dictionary["designAmount"] .stringValue
        id = dictionary["id"] .stringValue
        periodId = dictionary["periodId"] .stringValue
        projectExpressionPeriodCode = dictionary["projectExpressionPeriodCode"] .stringValue
        projectId = dictionary["projectId"] .stringValue
        projectName = dictionary["projectName"] .stringValue
        sectionId = dictionary["sectionId"] .stringValue
        thisEndPaymentAmount = dictionary["thisEndPaymentAmount"] .stringValue
        thisPaymentAmount = dictionary["thisPaymentAmount"] .stringValue
        upEndPaymentAmount = dictionary["upEndPaymentAmount"] .stringValue
        updateAmount = dictionary["updateAmount"] .stringValue
        updateTime = dictionary["updateTime"] .stringValue
        userId = dictionary["userId"] .stringValue
    }
}
