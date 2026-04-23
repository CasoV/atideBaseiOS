//
//  AuditInfoModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/9.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class AuditInfos: NSObject {
    var infos =  [AuditInfoModel]()
    init(jsonData: Array<JSON>){
        var count = 0
        for info in jsonData {
            let auditModel =  AuditInfoModel.init(dictionary: info)
            if count < jsonData.count - 1{
                let nextInfo = jsonData[count + 1]
                let nextTime = nextInfo["time"].stringValue
            
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let date1 = dateFormatter.date(from: nextTime)
                let date2 = dateFormatter.date(from: auditModel.time!)
                let unitFlags:NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month , NSCalendar.Unit.day , NSCalendar.Unit.hour , NSCalendar.Unit.minute , NSCalendar.Unit.second]
                let components =  (Calendar.current as NSCalendar).components(unitFlags, from: date1!, to: date2!,options: [])
                var differTime = "经过"
                if components.year != 0 {
                    differTime = "\(differTime)\(components.year ?? 0)年"
                }
                if components.month != 0 {
                    differTime = "\(differTime)\(components.month ?? 0)月"
                }
                if components.day != 0 {
                    differTime = "\(differTime)\(components.day ?? 0)天"
                }
                if components.hour != 0 {
                    differTime = "\(differTime)\(components.hour ?? 0)小时"
                }
                if components.minute != 0 {
                    differTime = "\(differTime)\(components.minute ?? 0)分钟"
                }
                auditModel.differTime = differTime
            }
            count += 1
            self.infos.append(auditModel)
        }
        
    }
    

}
class AuditInfoModel: NSObject {
    var activeId : String?
    var activeName : String?
    var doRet : String?
    var duration : String?
    var groupId : String?
    var groupName : String?
    var id : String?
    var message : String?
    var orgName : String?
    var ownerId : String?
    var primary : String?
    var signature : String?
    var signet : String?
    var taskId : String?
    var taskTitle : String?
    var time : String?
    var userId : String?
    var userName : String?
    var differTime : String?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(dictionary: JSON){
        activeId = dictionary["activeId"].stringValue
        activeName = dictionary["activeName"].stringValue
        doRet = dictionary["doRet"] .stringValue
        duration = dictionary["duration"].stringValue
        groupId = dictionary["groupId"].stringValue
        groupName = dictionary["groupName"].stringValue
        id = dictionary["id"] .stringValue
        message = dictionary["message"].stringValue
        orgName = dictionary["orgName"].stringValue
        ownerId = dictionary["ownerId"].stringValue
        primary = dictionary["primary"].stringValue
        signature = dictionary["signature"].stringValue
        signet = dictionary["signet"].stringValue
        taskId = dictionary["taskId"].stringValue
        taskTitle = dictionary["taskTitle"].stringValue
        time = dictionary["time"].stringValue
        userId = dictionary["userId"].stringValue
        userName = dictionary["userName"].stringValue
    }
    
    

}
