//
//  WorkModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/21.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class WorkModel:Codable {
    var instanceId: String?
    var title: String?
    var doUrl: String?
    var bizPk: String?
    var drafter: String?
    var drafterName: String?
    var drafterOrgId: String?
    var drafterOrgName: String?
    var createTime: String?
    var taskArrivalTime: String?
    var handleTime: String?
    var taskKey: String?
    var taskName: String?
    var flowStatus: String?
    var flowStatusName: String?
    var bizType: String?
    var bizTypeId: String?
    var bizTypeName: String?
    

    
    init(jsonData: JSON) {
        instanceId    = jsonData["instanceId"].stringValue
        title = jsonData["title"].stringValue
        doUrl  = jsonData["doUrl"].stringValue
        bizPk      = jsonData["bizPk"].stringValue
        drafter     = jsonData["drafter"].stringValue
        drafterName    = jsonData["drafterName"].stringValue
        drafterOrgId = jsonData["drafterOrgId"].stringValue
        drafterOrgName  = jsonData["drafterOrgName"].stringValue
        createTime      = jsonData["createTime"].stringValue
        taskArrivalTime     = jsonData["taskArrivalTime"].stringValue
        handleTime    = jsonData["handleTime"].stringValue
        taskKey = jsonData["taskKey"].stringValue
        taskName  = jsonData["taskName"].stringValue
        flowStatus      = jsonData["flowStatus"].stringValue
        flowStatusName     = jsonData["flowStatusName"].stringValue
        bizType    = jsonData["bizType"].stringValue
        bizTypeId = jsonData["bizTypeId"].stringValue
        bizTypeName  = jsonData["bizTypeName"].stringValue
    }
}

