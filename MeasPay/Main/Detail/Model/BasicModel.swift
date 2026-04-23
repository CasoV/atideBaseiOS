//
//  BasicModel.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/8.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class BasicModel {
    var infos =  [Any]()
    
    init(jsonData: JSON) {
        for (key,value) in jsonData {
            let ketStr:String = key
            switch ketStr{
            case "intermediateCode":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"计量单号","value":value.stringValue,"count":0]))
            case "code":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"清单编号","value":value.stringValue,"count":1]))
            case "name":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"清单名称","value":value.stringValue,"count":2]))
            case "unit":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"计量单位","value":value.stringValue,"count":3]))
            case "pileNo":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"起讫桩号","value":value.stringValue,"count":4]))
            case "place":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"位置","value":value.stringValue,"count":5]))
            case "type":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"清单类型","value":self.getTypeValue(value: value.stringValue),"count":6]))
            case "thisPeriodNum":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"核定数量","value":value.stringValue,"count":7]))
            case "changeCode":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"变更令","value":value.stringValue,"count":8]))
            case "meteragePileNo":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"计量桩号","value":value.stringValue,"count":9]))
            case "position":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"部位","value":value.stringValue,"count":10]))
            case "certificateNo":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"中间交工证书编号","value":value.stringValue,"count":11]))
            case "designChartNum":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"设计图号","value":value.stringValue,"count":12]))
            case "meterageDate":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"计量日期","value":value.stringValue,"count":13]))
            default:
                break
            }
        }
        self.infos =  self.infos.sorted(by: { (a, b) -> Bool in
            return (a as!BasicChildModel).count < (b as!BasicChildModel).count
        })
    }
    init(sigleJsonData: JSON) {
        for (key,value) in sigleJsonData {
            let ketStr:String = key
            switch ketStr{
            case "code":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"编号","value":value.stringValue,"count":0]))
            case "oldPic":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"原设计图纸号","value":value.stringValue,"count":1]))
            case "name":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"工程名称","value":value.stringValue,"count":2]))
            case "place":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"位置","value":value.stringValue,"count":3]))
            case "startNo":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"起讫桩号","value":value.stringValue,"count":4]))
            case "readDate":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"签订日期","value":value.stringValue,"count":5]))
            case "createDate":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"录入时间","value":value.stringValue,"count":6]))
            case "changeType":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"工程变更原因","value":value.stringValue,"count":7]))
            case "changeLevel":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"变更级别","value":value.stringValue,"count":8]))
            case "changeReason":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"工程变更理由及说明","value":value.stringValue,"count":9]))
            case "changeContent":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"工程变更设计内容","value":value.stringValue,"count":10]))
            case "handle":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"处理意见","value":value.stringValue,"count":11]))
            case "happenDate":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"发生时间","value":value.stringValue,"count":12]))
            case "oldSum":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"原设计金额","value":value.stringValue,"count":13]))
            case "reportDate":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"处理卡上报时间","value":value.stringValue,"count":14]))
            case "estimateSum":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"估算金额","value":value.stringValue,"count":15]))
            case "constructUnitSign":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"施工单位代表","value":value.stringValue,"count":16]))
            case "superUnitSign":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"监理单位代表","value":value.stringValue,"count":17]))
            case "designUnitSign":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"设计单位代表","value":value.stringValue,"count":18]))
            case "superOfficeSign":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"监管办代表","value":value.stringValue,"count":18]))
            case "projectCompSign":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"项目公司代表","value":value.stringValue,"count":19]))
            case "oneFormula":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"原设计数量","value":value.stringValue,"count":20]))
            case "twoFormula":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"变更后数量","value":value.stringValue,"count":21]))
            case "threeFormula":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"变更增减数量","value":value.stringValue,"count":22]))
                
                
            default:
                break
            }
        }
        self.infos =  self.infos.sorted(by: { (a, b) -> Bool in
            return (a as!BasicChildModel).count < (b as!BasicChildModel).count
        })
    }
    init(supvisPayDic: Dictionary<String, Any>) {
        for (key,value) in supvisPayDic {
            let ketStr:String = key
            switch ketStr{
            case "actualStaff":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"本月实际到位的监理人员情况","value":value,"count":0]))
            case "equipmentSituation":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"本月试验及检测设备的完好情况","value":value,"count":0]))
            case "explain":
                self.infos.append(BasicChildModel.init(dictionary: ["name":"说明","value":value,"count":0]))
            default:
                break
            }
        }
        self.infos =  self.infos.sorted(by: { (a, b) -> Bool in
            return (a as!BasicChildModel).count < (b as!BasicChildModel).count
        })
    }
    func getTypeValue(value:String) -> String {
        switch value {
        case "1":
            return "设计"
        case "2":
            return "完善"
        case "3":
            return "变更"
        case "4":
            return "废置"
        case "5":
            return "水毁"
        default:
            return ""
        }
        
    }
 
}

class BasicChildModel {
    var name :String
    var value :String
    var count :Int
    init(dictionary:Dictionary<String, Any>) {
        name = dictionary["name"] as! String
        value = dictionary["value"] as! String
        count = dictionary["count"] as! Int
    }
    
}
