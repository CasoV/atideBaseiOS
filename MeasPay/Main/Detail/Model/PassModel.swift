//
//  PassModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/15.
//  Copyright © 2019 高小伟. All rights reserved.
//
import Foundation
import SwiftyJSON

class PassModel : NSObject{
    
    var assigneeNames : Array<JSON>?
    var forwardOpinions : Array<JSON>?
    var forwardStatus : String?
    var height : String?
    var id : String?
    var jsonTaskAssignees : String?
    var name : String?
    var opinions : Array<JSON>?
    var order : String?
    var parallelMulti : String?
    var pointx : String?
    var pointy : String?
    var procdefId : String?
    var selectScope : String?
    var selectUser : String?
    var skip : String?
    var status : String?
    var taskAssignees : Array<JSON>?
    var type : String?
    var unFinishTaskAssignees : Array<JSON>?
    var width : String?
    var nextStep : String?
    
    var nextStepUserName : String?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        assigneeNames = dictionary["assigneeNames"].arrayValue
        forwardOpinions = dictionary["forwardOpinions"] .arrayValue
        forwardStatus = dictionary["forwardStatus"] .stringValue
        height = dictionary["height"] .stringValue
        id = dictionary["id"] .stringValue
        jsonTaskAssignees = dictionary["jsonTaskAssignees"] .stringValue
        name = dictionary["name"] .stringValue
        opinions = dictionary["opinions"] .arrayValue
        order = dictionary["order"] .stringValue
        parallelMulti = dictionary["parallelMulti"] .stringValue
        pointx = dictionary["pointx"] .stringValue
        pointy = dictionary["pointy"] .stringValue
        procdefId = dictionary["procdefId"] .stringValue
        selectScope = dictionary["selectScope"] .stringValue
        selectUser = dictionary["selectUser"] .stringValue
        skip = dictionary["skip"] .stringValue
        status = dictionary["status"] .stringValue
        taskAssignees = dictionary["taskAssignees"].arrayValue
        type = dictionary["type"] .stringValue
        unFinishTaskAssignees = dictionary["unFinishTaskAssignees"].arrayValue
        width = dictionary["width"] .stringValue
        nextStep = dictionary["nextStep"] .stringValue
        nextStepUserName = dictionary["nextStepUserName"] .stringValue
    }
    
   
    
}
