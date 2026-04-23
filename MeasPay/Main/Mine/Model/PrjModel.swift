//
//  PrjModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/24.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class PrjModel {
    var prjid: String?
    var prjName: String?
    var prjType: String?
    var adminGrade: String?
    var createUsernam: String?
    var abbrName: String?
    var roadGrade: String?
    var createUserid: String?
    
    
    init(jsonData: JSON) {
        prjid    = jsonData["prjid"].stringValue
        prjName = jsonData["prjName"].stringValue
        prjType  = jsonData["prjType"].stringValue
        adminGrade      = jsonData["adminGrade"].stringValue
        createUsernam     = jsonData["createUsernam"].stringValue
        abbrName    = jsonData["abbrName"].stringValue
        roadGrade    = jsonData["roadGrade"].stringValue
        createUserid    = jsonData["createUserid"].stringValue
    }
}
