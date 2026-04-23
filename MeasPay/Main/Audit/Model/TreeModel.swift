//
//  TreeModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/27.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class TreeModel {
    var id: String?
    var type: String?
    var text: String?
    var state: String?
    var checked: String?
    var code: String?
    var children: Array<Any>?
    
    init(jsonData: JSON) {
        id    = jsonData["id"].stringValue
        type  = jsonData["type"].stringValue
        text  = jsonData["text"].stringValue
        state = jsonData["state"].stringValue
        checked = jsonData["checked"].stringValue
        code = jsonData["otherInfo"]["code"].stringValue
        let childrenArr  = NSMutableArray()
        for dic in jsonData["children"].arrayValue {
            let cdModel = TreeChildModel.init(jsonData:dic)
            childrenArr.add(cdModel)
        }
        children = childrenArr as? Array<Any>
    }
    
    
}

class TreeChildModel {
    var id: String?
    var type: String?
    var text: String?
    var state: String?
    var checked: String?
    var code: String?
    var name: String?
    var childern: Array<Any>?
    
    init(jsonData: JSON) {
        id    = jsonData["id"].stringValue
        type  = jsonData["type"].stringValue
        text  = jsonData["text"].stringValue
        state = jsonData["state"].stringValue
        checked = jsonData["checked"].stringValue
        code = jsonData["otherInfo"]["code"].stringValue
        name = jsonData["otherInfo"]["name"].stringValue
    }
}

