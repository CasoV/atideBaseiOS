//
//  SupvisPaymentModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class SupvisPaymentModel : Codable{
    
    var actualStaff : String?
    var createDate : String?
    var equipmentSituation : String?
    var explain : String?
    var flowStatus : String?
    var id : String?
    var periodId : String?
    var projectId : String?
    var sectionId : String?
    var userId : String?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        actualStaff = dictionary["actualStaff"].stringValue
        createDate = dictionary["createDate"].stringValue
        equipmentSituation = dictionary["equipmentSituation"].stringValue
        explain = dictionary["explain"].stringValue
        flowStatus = dictionary["flowStatus"].stringValue
        id = dictionary["id"].stringValue
        periodId = dictionary["periodId"].stringValue
        projectId = dictionary["projectId"].stringValue
        sectionId = dictionary["sectionId"].stringValue
        userId = dictionary["userId"].stringValue
    }
}
