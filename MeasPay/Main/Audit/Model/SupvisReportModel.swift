//
//  SupvisReportModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class SupvisReportModel : Codable{
    
    var code : String!
    var createDate : String!
    var flowStatus : String!
    var id : String!
    var orderNo : String!
    var periodId : String!
    var projectId : String!
    var remarks : String!
    var rownumber : String!
    var sectId : String!
    var text : String!
    var userId : String!
    var periodNum: Int?
    var payYear : String!
    var payMonth : String!
    var approvalStatus : String!
    var caculExpStr : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        code = dictionary["code"] .stringValue
        createDate = dictionary["createDate"] .stringValue
        flowStatus = dictionary["flowStatus"] .stringValue
        id = dictionary["id"] .stringValue
        orderNo = dictionary["orderNo"] .stringValue
        periodId = dictionary["periodId"] .stringValue
        projectId = dictionary["projectId"] .stringValue
        remarks = dictionary["remarks"] .stringValue
        rownumber = dictionary["rownumber"] .stringValue
        sectId = dictionary["sectId"] .stringValue
        text = dictionary["text"] .stringValue
        userId = dictionary["userId"] .stringValue
        periodNum = dictionary["periodNum"] .intValue
        payYear = dictionary["payYear"] .stringValue
        payMonth = dictionary["payMonth"] .stringValue
        approvalStatus =  dictionary["approvalStatus"] .stringValue
        caculExpStr =  dictionary["caculExpStr"] .stringValue
    }
   
    
}
