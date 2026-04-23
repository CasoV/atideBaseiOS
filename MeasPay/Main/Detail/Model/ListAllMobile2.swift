//
//  listAllMobile1.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/18.
//  Copyright © 2019 高小伟. All rights reserved.
//

import Foundation
import SwiftyJSON


class ListAllMobile2 : NSObject{
    
    var name : String?
    var sex : String?
    var specialty : String?
    var supervisorId : String?
    var total : String?
    var yearMonthList : [YearMonthList]!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        name = dictionary["name"] .stringValue
        sex = dictionary["sex"] .stringValue
        specialty = dictionary["specialty"] .stringValue
        supervisorId = dictionary["supervisorId"] .stringValue
        total = dictionary["total"] .stringValue
        yearMonthList = [YearMonthList]()
        for dic in dictionary["yearMonthList"].arrayValue{
            let value = YearMonthList(dictionary: dic)
            yearMonthList.append(value)
        }
    }
}


class YearMonthList : NSObject{
    
    var key : String?
    var value : String?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary:JSON){
        key = dictionary["key"] .stringValue
        value = dictionary["value"] .stringValue
    }
    
}
