//
//  ChildrenModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/30.
//  Copyright © 2019 高小伟. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChildrenModel : NSObject{
    
    var alowType : String?
    var attributes : String?
    var checked : String?
    var children : String?
    var id : String?
    var otherInfo : String?
    var parentId : String?
    var sedId : String?
    var state : String?
    var text : String?
    var type : String?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        alowType = dictionary["alowType"] .stringValue
        attributes = dictionary["attributes"] .stringValue
        checked = dictionary["checked"] .stringValue
        children = dictionary["children"] .stringValue
        id = dictionary["id"] .stringValue
        otherInfo = dictionary["otherInfo"] .stringValue
        parentId = dictionary["parentId"] .stringValue
        sedId = dictionary["sedId"] .stringValue
        state = dictionary["state"] .stringValue
        text = dictionary["text"] .stringValue
        type = dictionary["type"] .stringValue
    }
    
    
    
}
