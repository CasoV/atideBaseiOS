//
//  OnlineExcelVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/21.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class OnlineExcelVc: UIViewController,WKNavigationDelegate {
//    @IBOutlet weak var web: WKWebView!
    var info:NSDictionary = NSDictionary()
    var excelType =  ExcelTypeConfig.second
    var type = MenuTypeConfig.pmtReport
    var excelUrl = String()
    let web:WKWebView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let web = WKWebView.init(frame:CGRect(x: 0, y: 20, width: screen_w, height: screen_h - 20))
        self.view .addSubview(web)
        
        self.setupUI()
    }
    
    func setupUI() {
        if type == MenuTypeConfig.pmtReport{
            if(excelUrl.count > 0){
                web.load(URLRequest.init(url: URL(string: excelUrl)!))
            }
            return
        }
        web.navigationDelegate = self
        if let url = Bundle.main.url(forResource: "sp", withExtension: "html"){
            let request = URLRequest(url: url)
            web.load(request)
        }
        
    }
    
    //Mark: -WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        switch type {
        case MenuTypeConfig.pmtReport:
            var key:String? = String()
            var param:Dictionary<String, Any>? = Dictionary()
            var tempName1:String? = String()
            var tempName2:String? = String()
            if  excelType == ExcelTypeConfig.first{
                key = "yx.zongbao.zhifu.4"
                param = ["index": "1",
                         "newFormFlag": "0",
                         "bizPk": self.info["id"] ?? "",
                         "projectId": self.info["projectId"] ?? "",
                         "sectId": self.info["sectId"] ?? "",
                         "periodId": self.info["periodId"] ?? "",
                         "ppp": self.info["sectId"] ?? "",
                         "dataFrom": self.info["sectId"] ?? "",
                         "calculationType":  "",
                         "type":  "1"]
                tempName1 = "initMiddleSheet"
                tempName2 = "loadMiddleData"
            }else if excelType == ExcelTypeConfig.second {
                key = "yx.pay.one.3"
                param = ["index": "3",
                         "newFormFlag": "0",
                         "bizPk": self.info["id"] ?? "",
                         "projectId": self.info["projectId"] ?? "",
                         "sectId": self.info["sectId"] ?? "",
                         "periodId": self.info["periodId"] ?? "",
                         "ppp": self.info["sectId"] ?? "",
                         "dataFrom": self.info["sectId"] ?? "",
                         "calculationType":  "",
                         "pageSize":  "23"]
                tempName1 = "initDetailSheet"
                tempName2 = "loadDetailData"
            }
            NetWorkRequest(.getExcelTemplate(Dict: ["key":key ?? "","periodId":info["periodId"] ?? ""])) { (response) -> (Void) in
                self.web.evaluateJavaScript( "\(tempName1 ?? "")(\(response))", completionHandler: { (any, error) in
                    if error != nil {
                        SVProgressHUD.showInfo(withStatus: "模板加载失败")
                    }else{
                        NetWorkRequest(.sheetData(Dict:param ?? Dictionary())) { (response) -> (Void) in
                            self.web.evaluateJavaScript("\(tempName2 ?? "")(\(response))", completionHandler: { (any, error) in
                                if error != nil {
                                    SVProgressHUD.showInfo(withStatus: "数据加载失败")
                                }
                            })
                        }
                    }
                })
            }
        case MenuTypeConfig.supvisReport:
             var tempName:String? = String()
            if  excelType == ExcelTypeConfig.first{
                tempName = "loadSupvisCer"
            }else if excelType == ExcelTypeConfig.second {
                tempName = "loadSupvisMid"
            }
            NetWorkRequest(.getById(Dict: ["id": self.info["id"] ?? "","newFormFlag": "0"])) { (response) -> (Void) in
                self.web.evaluateJavaScript( "\(tempName ?? "")(\(response))", completionHandler: { (any, error) in
                    if error != nil {
                        SVProgressHUD.showInfo(withStatus: "模板加载失败")
                    }
                })
            }
        default:
            break
        }
    }

}
