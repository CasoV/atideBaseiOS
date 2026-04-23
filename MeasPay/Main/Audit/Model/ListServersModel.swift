//
//  ListServersModel.swift
//  ycxm
//
//  Created by 高小伟 on 2020/12/2.
//  Copyright © 2020 末末班车. All rights reserved.
//

import Foundation
import SwiftyJSON

class ListServersModel:Codable {
    
    var id: String?
    var projectId: String?
    var sectId: String?
    var periodId: String?
    var periodNum: String?
    var createDate: String?
    var repCode: String?
    var type: Int?
    var remarks: String?
    var approvalStatus: String?
    var cBy: String?
    var caculBasis: String?
    var caculExpStr: String?
    
    init(jsonData: JSON) {
        id    = jsonData["id"].stringValue
        projectId  = jsonData["projectId"].stringValue
        sectId  = jsonData["sectId"].stringValue
        periodId = jsonData["periodId"].stringValue
        periodNum = jsonData["periodNum"].stringValue
        createDate = jsonData["createDate"].stringValue
        repCode = jsonData["repCode"].stringValue
        type = jsonData["type"].intValue
        remarks = jsonData["remarks"].stringValue
        approvalStatus = jsonData["approvalStatus"].stringValue
        cBy = jsonData["cBy"].stringValue
        caculBasis = jsonData["caculBasis"].stringValue
        caculExpStr = jsonData["caculExpStr"].stringValue
    
    }
    
    
}
