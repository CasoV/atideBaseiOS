//
//  SectModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/24.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class SectModel {
    var sectionId: String?
    var prjid: String?
    var sectionType: String?
    var sectionName: String?
    var startPileNo: String?
    var endPileNo: String?
    var unitName: String?
    var designSectionId: String?
    var prjCode: String?
    var constractorUnit: String?
    var sectionMajor: String?
    var stdVersion: String?
    
    init(jsonData: JSON) {
        sectionId    = jsonData["sectionId"].stringValue
        prjid = jsonData["prjid"].stringValue
        sectionType  = jsonData["sectionType"].stringValue
        sectionName      = jsonData["sectionName"].stringValue
        startPileNo     = jsonData["startPileNo"].stringValue
        endPileNo    = jsonData["endPileNo"].stringValue
        unitName    = jsonData["unitName"].stringValue
        designSectionId    = jsonData["designSectionId"].stringValue
        prjCode    = jsonData["prjCode"].stringValue
        constractorUnit    = jsonData["constractorUnit"].stringValue
        sectionMajor    = jsonData["sectionMajor"].stringValue
        stdVersion    = jsonData["stdVersion"].stringValue
    }
}



