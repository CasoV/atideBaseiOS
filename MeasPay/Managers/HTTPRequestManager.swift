//
//  HTTPRequestManager.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/19.
//  Copyright © 2018 高小伟. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import SVProgressHUD

/// 定义返回的JSON数据字段
let RESULT_CODE = "succeed"      //状态码
let RESULT_MESSAGE = "msg"  //错误消息提示


/// 超时时长
private var requestTimeOut:Double = 30
///endpointClosure
private let myEndpointClosure = { (target: API) -> Endpoint in
    ///主要是为了解决URL带有？无法请求正确的链接地址的bug
    let url = target.baseURL.absoluteString + target.path
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
        
    )
    switch target {
    default:
        requestTimeOut = 30//设置默认的超时时长
        return endpoint
    }
}

private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        //设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        }else{
            print("\(request.url!)"+"\(String(describing: request.httpMethod))")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
 publicKeys: ServerTrustPolicy.publicKeysInBundle(),
 validateCertificateChain: true,
 validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
//private public func defaultAlamofireManager() -> Manager {
//
//    let configuration = URLSessionConfiguration.default
//
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//
//    manager.startRequestsImmediately = false
//
//    return manager
//}

/// NetworkActivityPlugin插件用来监听网络请求
private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
    
    print("networkPlugin \(changeType)")
    //targetType 是当前请求的基本信息
    switch(changeType){
    case .began:
        print("开始请求网络")
        
    case .ended:
        print("结束")
    }
}

//stubClosure   用来延时发送网络请求
let Provider = MoyaProvider<API>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

///先添加一个闭包用于成功时后台返回数据的回调
typealias successCallback = ((String) -> (Void))
///再次用一个方法封装provider.request()
func NetWorkRequest(_ target: API, completion: @escaping successCallback ){
    //先判断网络是否有链接 显示hud
//    SVProgressHUD.show(withStatus: "")
    Provider.request(target) { (result) in
        //隐藏hud
//        SVProgressHUD.dismiss()
        switch result {
        case let .success(response):
            do {
                //下载文件
                if response.data.count == 0{
                    completion(String(data: response.data, encoding: String.Encoding.utf8)!)
                    return
                }
                //这里转JSON用的swiftyJSON框架
                let jsonData = try JSON(data: response.data)
                
                if (jsonData.array != nil)  {
                    completion(String(data: response.data, encoding: String.Encoding.utf8)!)
                    return
                }
  
                let keys = [String]((jsonData.dictionary?.keys)!)
                if !keys.contains(RESULT_CODE){
                    completion(String(data: response.data, encoding: String.Encoding.utf8)!)
                    return
                }
                //判断后台返回的code码没问题就把数据闭包返回
                if jsonData[RESULT_CODE].boolValue{
                    completion(String(data: response.data, encoding: String.Encoding.utf8)!)
                }else{
//                    SVProgressHUD.showInfo(withStatus: jsonData[RESULT_MESSAGE].stringValue)
                }
            } catch {
            }
        case let .failure(error):
            print("网络连接失败,Error=\(error)")
        }
    }
}
