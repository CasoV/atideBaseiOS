//
//  ListAllMobile1.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/21.
//  Copyright © 2019 高小伟. All rights reserved.
//

import Foundation
import SwiftyJSON


class ListAllMobile1 : NSObject{
    
    var id : String?
    var expressionId : String?
    var name : String?
    var payAmount : String?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        id = dictionary["id"] .stringValue
        expressionId = dictionary["expressionId"] .stringValue
        name = dictionary["name"] .stringValue
        payAmount = dictionary["payAmount"] .stringValue
    }
}
