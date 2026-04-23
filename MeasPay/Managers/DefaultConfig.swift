//
//  DefaultConfig.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/28.
//  Copyright © 2018 高小伟. All rights reserved.
//
import UIKit
// 筛选条件
struct ScrInfo {
    let projectId = "projectId"
    let sectId = "sectId"
    let periodId = "periodId"
    let meteragePartCode = "meteragePartCode"
}

// 菜单类型配置
@objc enum MenuTypeConfig : Int{
    case mediateList = 0
    case thirdPayment = 1
    case changeOrder = 2
    case supvisPayment = 3
    case pmtReport = 4 //中期支付报表（工区）
    case supvisReport = 5
    case statiMea = 6
    case workBench = 7
    case processingCard = 8
    case totalPackage = 9 //中期支付报表（总包）
    case centralLaboratory = 10 //中心实验室
    case mainlineTechnology = 11 //主线技术服务
    case informationConstruction = 12 //信息化建设
    case auditUnit = 13 //审计单位
    case thirdParty2 = 14//勘察设计1标
    case thirdParty3 = 15//勘察设计3标
    case thirdParty4 = 16//水土保持检测服务项目
    case thirdParty5 = 17//水土保持设施验收
    case thirdParty6 = 18//水文地质勘察
    case thirdParty7 = 19//环境监测项目
    case thirdParty8 = 20//勘察设计2标
    case thirdParty9 = 21//委托代建
    case thirdParty10 = 22//初步设计3标
    case thirdParty11 = 23//供地手续办理技术服务（玉溪）
    case thirdParty12 = 24//洪水项目评价
    case thirdParty13 = 25//安全技术咨询
    case thirdParty14 = 26//登楼山超前水平地质预报
    case thirdParty15 = 27//通海县临时用地
    case thirdParty16 = 28//弥勒县临时用地
    case thirdParty17 = 29//供地手续办理技术服务（弥勒）
    case thirdParty18 = 30//供地手续办理技术服务（华宁）
    case thirdParty19 = 31//供地手续办理技术服务（主线）
    case thirdParty20 = 32//水土保持变更编制
}

// 操作类型配置
enum OptionTypeConfig{
    case pass
    case submit
    case back
}

// Excel页面类型
enum ExcelTypeConfig{
    case first
    case second
    case third
}

//判断机型
extension UIDevice {
    
    public func isX() -> Bool {
        let size = UIScreen.main.bounds.size
               let notchValue: Int = Int(size.width/size.height * 100)
               
               if 216 == notchValue || 46 == notchValue {
                   
                   return true
               }
               
               return false
        
    }
    
}
