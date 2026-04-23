//
//  Api.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/19.
//  Copyright © 2018 高小伟. All rights reserved.
//

//http://220.165.247.68:10000/login/main
//http://220.165.247.68:56388/login/main
import Foundation
import Moya

enum API{
    //无参数的接口
    case prjList
    //有参数的接口
    case testApiStr(para1:String,para2:String)
    //把参数包装成字典传入
    case login(Dict:[String:Any])
    case flowList(Dict:[String:Any])
    case sectionList(Dict:[String:Any])
    case periodList(Dict:[String:Any])
    case getTree(Dict:[String:Any])
    case intermediateList(Dict:[String:Any])
    case getPaymentInfo(Dict:[String:Any])
    case changeOrderList(Dict:[String:Any])
    case supvisPaymentList(Dict:[String:Any])
    case pmtReportList(Dict:[String:Any])
    case supvisReportList(Dict:[String:Any])
    case intermediateUpdate(Dict:[String:Any])
    case submitApproval(Dict:[String:Any])
    case backApproval(userId:String,periodId:String,Dict:[String:Any])
    case intermediate(Dict:[String:Any])
    case getComments(Dict:[String:Any])
    case fileSeach(Dict:[String:Any])
    case fileDownload(assetName:String) //下载文件1
    case mFileDownload(assetName:String) //下载文件2
    case getFlowToolbar(Dict:[String:Any])
    case deleteMedia(Dict:[String:Any])
    case pass(Dict:[String:Any])
    case completeTask(Dict:[String:Any])
    case reject(Dict:[String:Any])
    case rejectTask(Dict:[String:Any])
    case revokeTask(Dict:[String:Any])
    case paymentIndenture(Dict:[String:Any])
    case centralabData(Dict:[String:Any])
    case singleContent(Dict:[String:Any])
    case meterBill(Dict:[String:Any])
    case listAll_mobile_1(Dict:[String:Any])
    case listAll_mobile_2(Dict:[String:Any])
    case listAll_mobile_3(Dict:[String:Any])
    case getExcelTemplate(Dict:[String:Any])
    case sheetData(Dict:[String:Any])
    case getById(Dict:[String:Any])
    case getMeterTableData(Dict:[String:Any])
    case getChildren(Dict:[String:Any])
    case getSimpleintermediateList(Dict:[String:Any])
    case getOrderNo(Dict:[String:Any])
    case saveUpdateOrderNo(Dict:[String:Any])
    case generateKey(Dict:[String:Any])
    case setProjectInfo(Dict:[String:Any])
    case getPayRepData(Dict:[String:Any])
    case listServersInfoBysectId(Dict:[String:Any])
    case getBySectIdAndPeriodId(Dict:[String:Any])
    case getInfoBySectIdAndPeriodId(Dict:[String:Any])
    
    //监理计量支付审核
    case swCompleteTask(Dict:[String:Any])
    case swDeleteTask(Dict:[String:Any])
    case swRejectTask(Dict:[String:Any])
    case swRevokeTask(Dict:[String:Any])
    
    //报表审核
    case msCompleteTask(Dict:[String:Any])
    case msRejectTask(Dict:[String:Any])
    
}
extension API:TargetType{
    var baseURL: URL {
        return URL.init(string: protocolStr + "://" + serverHost + ":" + serverPort + "/")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "login/check"
        case .flowList:
            return "workflow/personalWork/getTodoList"
        case .prjList:
            return "meterage/projectInfo/getPrjList"
        case .sectionList:
            return "meterage/projectInfo/getSectionList"
        case .periodList:
            return "meterage/period/getMeteragePeriodList"
        case .getTree:
            return "meterage/meterPartBill/getTree"
        case .intermediateList:
            return "meterage/intermediateNew/getintermediateList"
        case .getPaymentInfo:
            return "meterage/thirdPartyPayment/getPaymentInfo"
        case .changeOrderList:
            return "meterage/changeInfo/getAllContentList"
        case .supvisPaymentList:
            return "meterage/payment/listPayment"
        case .pmtReportList:
            return "meterage/metaphasePay/getMetaphasePayList"
        case .supvisReportList:
            return "meterage/supervisorPayInfo/listSupervisorInfoBysectId"
        case .intermediateUpdate:
            return "meterage/intermediateNew/updateji"
        case .submitApproval:
//            return "meterage/intermediateNew/submitApprovalList"
            return "meterage/meter/submitBatchWorkFlow"
        case let .backApproval(userId,periodId,_):
//            return "meterage/intermediateNew/backApprovalList"
            return "meterage/meter/submitBatchWorkFlow?userId=\(userId)&periodId=\(periodId)"
        case .intermediate:
            return "meterage/intermediateNew/getMeterageIntermediate"
        case .getComments:
            return "workflow/commonFlow/getComments"
        case .fileSeach:
            return "fs/files/search"
        case let .fileDownload(assetName):
            return "fs/files/download/\(assetName)"
        case let .mFileDownload(assetName):
            return "meterage/file/download/\(assetName)"
        case .getFlowToolbar:
           return  "workflow/commonFlow/getFlowToolbar"
        case .deleteMedia:
            return "meterage/intermediateNew/delete"
        case .pass:
            return "workflow/mobileFlow/pass"
        case .completeTask:
            return "meterage/intermediateNew/completeTask"
        case .reject:
            return "workflow/mobileFlow/reject"
        case .rejectTask:
            return "meterage/intermediateNew/rejectTask"
        case .revokeTask:
            return "meterage/intermediateNew/revokeTask"
        case .paymentIndenture:
            return "meterage/thirdPartyPayment/getPaymentIndenture"
        case .centralabData:
            return "meterage/thirdPartyPayment/getCentralabData"
        case .singleContent:
            return "meterage/changeInfo/getSingleContent"
        case .meterBill:
            return "meterage/changePlus/listChangeDetailByMainId"
        case .listAll_mobile_1:
            return "meterage/payment/listAll_mobile_1"
        case .listAll_mobile_2:
             return "meterage/payment/listAll_mobile_2"
        case .listAll_mobile_3:
            return "meterage/payment/listAll_mobile_3"
        case .getExcelTemplate:
            return "meterage/changeDesignBook/getExcelTemplate"
        case .sheetData:
            return "meterage/metaphasePay/sheetData"
        case .getById:
            return "meterage/measureReport/getById"
        case .getMeterTableData:
            return "login/getMeterTableData"
        case .getChildren:
//            return "meterage/reportPage/getChildren/130909543671529472"
            return "meterage/reportPage/getChildrenFilter/2"
        case .getSimpleintermediateList:
            return "meterage/intermediateNew/getSimpleintermediateList"
        case .getOrderNo:
            return "meterage/intermediateNew/getOrderNo"
        case .saveUpdateOrderNo:
            return "meterage/intermediateNew/saveUpdateOrderNo"
        case .generateKey:
            return "meterage/file/generateKey"
        case .setProjectInfo:
            return "api/login/setProjectInfo"
        case .getPayRepData:
            return "meterage/mpPay/getPayRepData"
        case .listServersInfoBysectId:
            return "meterage/serversPayInfo/listServersInfoBysectId"
        case .getBySectIdAndPeriodId:
            return "meterage/supervisorPayInfo/getBySectIdAndPeriodId"
        case .getInfoBySectIdAndPeriodId:
            return "meterage/serversPayInfo/getBySectIdAndPeriodId"
            
        case .swCompleteTask:
            return "meterage/supervisorWorkFlow/completeTask"
        case .swDeleteTask:
            return "meterage/supervisorWorkFlow/deleteTask"
        case .swRejectTask:
            return "meterage/supervisorWorkFlow/rejectTask"
        case .swRevokeTask:
            return "meterage/supervisorWorkFlow/revokeTask"
            
            
        case .msCompleteTask:
            return "meterage/metaphasePayFlow/completeTask"
        case .msRejectTask:
            return "meterage/metaphasePayFlow/rejectTask"
            
            
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fileDownload(_),.getChildren(_),.mFileDownload(_),.supvisReportList(_):
            return .get
        default:
            return .post
        }
    }
    
    /// 这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .prjList:
            return .requestPlain
        case let .testApiStr(para1, _):
            //后台的content-Type 为application/x-www-form-urlencoded时选择URLEncoding
            return .requestParameters(parameters: ["key":para1], encoding: URLEncoding.default)
        case let .flowList(dict) , let .login(dict) , let .sectionList(dict) , let .periodList(dict), let .getTree(dict), let .intermediateList(dict), let .getPaymentInfo(dict), let .changeOrderList(dict), let .supvisPaymentList(dict), let .pmtReportList(dict), let .supvisReportList(dict), let .intermediateUpdate(dict), let .submitApproval(dict), let .backApproval(_,_,dict),let .intermediate(dict),let .getComments(dict),let .fileSeach(dict),let .getFlowToolbar(dict),let .deleteMedia(dict),let .pass(dict),let .completeTask(dict),let .reject(dict),let .rejectTask(dict),let .revokeTask(dict),let .paymentIndenture(dict), let .centralabData(dict),let .singleContent(dict),let .meterBill(dict), let .listAll_mobile_1(dict), let .listAll_mobile_2(dict), let .listAll_mobile_3(dict),let .getExcelTemplate(dict),let .sheetData(dict),let .getById(dict), let .getMeterTableData(dict), let .getSimpleintermediateList(dict),let .getOrderNo(dict),let .saveUpdateOrderNo(dict),let .getChildren(dict),let .generateKey(dict),let .getPayRepData(dict),let .setProjectInfo(dict),let .listServersInfoBysectId(dict),let .getBySectIdAndPeriodId(dict),let .getInfoBySectIdAndPeriodId(dict),let .swCompleteTask(dict),let .swDeleteTask(dict),let .swRejectTask(dict),let .swRevokeTask(dict):
            return .requestParameters(parameters: dict, encoding: URLEncoding.default)
        case let .msCompleteTask(dict), let .msRejectTask(dict):
            return .requestParameters(parameters: dict, encoding:JSONEncoding.default)
        case .fileDownload(_),.mFileDownload(_):
            return .downloadDestination(DefaultDownloadDestination)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .msCompleteTask(_), .msRejectTask(_):
            return ["Content-Type": "application/json"]
        default:
            return ["Content-Type":"application/x-www-form-urlencoded",
                    "platform":"11"]
        }
       
    }
    
}

//定义下载的DownloadDestination（不改变文件名，同名文件不会覆盖）
private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    return (DefaultDownloadDir.appendingPathComponent(response.suggestedFilename!), [])
}

//默认下载保存地址（用户文档目录）
let DefaultDownloadDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()
