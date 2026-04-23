//
//  ExcelVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/16.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class ExcelVc: UIViewController, AKExcelViewDelegate {
    var info:NSDictionary = NSDictionary()
    var arrM = [Any]()
    var excelView : AKExcelView!
    var excelType =  ExcelTypeConfig.first
    var type = MenuTypeConfig.mediateList
    var btmToolHidden:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupExcel()
        switch type {
        case MenuTypeConfig.thirdPayment:
            if  excelType == ExcelTypeConfig.first{
                self.loadData()
            }else{
                self.loadCerData()
            }
        case MenuTypeConfig.changeOrder,MenuTypeConfig.processingCard:
            self.loadCgOrData()
        case MenuTypeConfig.supvisReport:
            self.loadData1()
        case MenuTypeConfig.centralLaboratory:
            self.loadData2(type: "3")
        case MenuTypeConfig.mainlineTechnology:
            self.loadData2(type: "5")
        case MenuTypeConfig.informationConstruction:
            self.loadData2(type: "3")
        case MenuTypeConfig.auditUnit    
            ,MenuTypeConfig.thirdParty2
            ,MenuTypeConfig.thirdParty3
            ,MenuTypeConfig.thirdParty4
            ,MenuTypeConfig.thirdParty5
            ,MenuTypeConfig.thirdParty6
            ,MenuTypeConfig.thirdParty7
            ,MenuTypeConfig.thirdParty8
            ,MenuTypeConfig.thirdParty9
            ,MenuTypeConfig.thirdParty10
            ,MenuTypeConfig.thirdParty11
            ,MenuTypeConfig.thirdParty12
            ,MenuTypeConfig.thirdParty13
            ,MenuTypeConfig.thirdParty14
            ,MenuTypeConfig.thirdParty15
            ,MenuTypeConfig.thirdParty16
            ,MenuTypeConfig.thirdParty17
            ,MenuTypeConfig.thirdParty18
            ,MenuTypeConfig.thirdParty19
            ,MenuTypeConfig.thirdParty20:
            self.loadData2(type: "3")
        default:
            break
        }
    }
    
    func loadData2(type:String) {
        excelView.headerTitles = ["序号","项目名称","合同金额","本期末金额","上期末金额","本期申请付款额"]
        excelView.properties = ["no","costName","contractAmtStr","tcompAmtStr","pcompAmtStr","compAmtStr"]
        NetWorkRequest(.getInfoBySectIdAndPeriodId(Dict: ["sectId":self.info["sectId"] ?? UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? "" ,"periodId":self.info["periodId"] ?? UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? "","type":type])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic["data"]["serversPayCerts"].array
            var count = 0
            for json in jsonArr ?? Array(){
                count += 1
                let model = SupervisorPayModel(dictionary: json)
                model.no = String(count)
                self.arrM.append(model)
            }
            if self.arrM.count == 0 {
                return
            }
            self.excelView.contentData = self.arrM as! Array<SupervisorPayModel>
            self.excelView.reloadData()
            self.view.addSubview(self.excelView)
        }
    }
    func loadData1() {
        excelView.headerTitles = ["序号","项目名称","合同金额","本期末金额","上期末金额","本期申请付款额"]
        excelView.properties = ["no","costName","contractAmtStr","tcompAmtStr","pcompAmtStr","compAmtStr"]
        NetWorkRequest(.getBySectIdAndPeriodId(Dict: ["sectId":self.info["sectId"] ?? UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? "" ,"periodId":self.info["periodId"] ?? UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic["data"]["supervisorPayCerts"].array
            var count = 0
            for json in jsonArr ?? Array(){
                count += 1
                let model = SupervisorPayModel(dictionary: json)
                model.no = String(count)
                self.arrM.append(model)
            }
            if self.arrM.count == 0 {
                return
            }
            self.excelView.contentData = self.arrM as! Array<SupervisorPayModel>
            self.excelView.reloadData()
            self.view.addSubview(self.excelView)
        }
    }
    
    func setupExcel() {
        excelView  = AKExcelView.init(frame: CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h - 210))
        if (btmToolHidden){
            excelView.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h - 180)
            if(!UIDevice().isX()){
                excelView.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h - 120)
            }
        }else{
            if(!UIDevice().isX()){
                excelView.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h - 150)
            }
        }
        // 自动滚到最近的一列
        excelView.autoScrollToNearItem = true
        // 设置表头背景色
        excelView.headerBackgroundColor = UIColor(red: 236/255.0, green: 245/255.0, blue: 255/255.0, alpha:1)
        excelView.headerTextColor = .black
        // 设置间隙
        excelView.textMargin = 20
        // 设置左侧冻结栏数
        excelView.leftFreezeColumn = 1
    }
    
    func loadData() {
        excelView.headerTitles = ["项目名称","合同金额","设计金额","变更金额","本期未支付金额","上期末未支付金额","本期支付金额"]
        excelView.properties = ["projectName","contractAmount","designAmount","updateAmount","thisEndPaymentAmount","upEndPaymentAmount","thisPaymentAmount"]
        NetWorkRequest(.paymentIndenture(Dict: ["prjId":self.info["projectId"] ?? UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? "" ,"periodId":self.info["periodId"] ?? UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? "","sectionId":self.info["sectionId"] ?? UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic.array
            for json in jsonArr ?? Array(){
                let model = PmtInModel(dictionary: json)
                self.arrM.append(model)
            }
            if self.arrM.count == 0 {
                return
            }
            self.excelView.contentData = self.arrM as! Array<PmtInModel>
            self.excelView.reloadData()
            self.view.addSubview(self.excelView)
        }
    }
    func loadCerData() {
        excelView.headerTitles = ["项目内容","合同号","单位","单价","设计数量","设计金额","变更数量","变更金额","本期末支付数量","本期末支付金额","上期末支付数量","上期末支付金额","桩号","本次桩号","位置","本次位置","本期支付数量","本期支付金额","剩余数量","剩余金额","检测编号","备注"]
        excelView.properties = ["name","compactNo","unit","unitPrice","mount","amount","updateMount","updateAmount","thisEndPaymentMount","thisEndPaymentAmount","upEndPaymentMount","upEndPaymentAmount","stakeNumber","thisStakeNumber","place","thisPlace","thisPaymentNum","thiPaymentAmount","surplusMount","surplusAmount","detectionCode","remark"]
        
        NetWorkRequest(.centralabData (Dict: ["prjId":self.info["projectId"] as! String,"periodId":self.info["periodId"] as! String,"sectionId":self.info["sectionId"] as! String])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic["list"].array
            for json in jsonArr ?? Array(){
                let model = PayCerModel(dictionary: json)
                self.arrM.append(model)
            }
            if self.arrM.count == 0 {
                return
            }
            self.excelView.contentData = self.arrM as! Array<PayCerModel>
            self.excelView.reloadData()
            self.view.addSubview(self.excelView)
        }
    }
    
    func loadCgOrData() {
        //未找到 变更金额 alterSum 字段 替换为 price
        excelView.headerTitles = ["章节","子目号","子目名称","单位","桩号","位置","单价","原设计数量","补充数量","变更数量","变更金额","计量部位","变更桩号","变更位置","变更类型"]
        excelView.properties = ["topCode","code","name","unit","startNo","place","price","oldNum","supplyNum","alterNum","price","partName","alterNo","alterPlace","alterType"]
        NetWorkRequest(.meterBill (Dict: ["changeId":self.info["id"] ?? self.info["bizPk"] ?? "","periodId":self.info["periodId"] ?? UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic["data"]["row"].array
            var sum:Float = 0
            for json in jsonArr ?? Array(){
                let model = CgOrModel(dictionary: json)
                
                if ( (model.price != nil) && (model.alterNum != nil)) {
                    model.alterSum = String((model.price! as NSString).floatValue *  (model.alterNum! as NSString).floatValue)
                    sum += (model.alterSum! as NSString).floatValue
                }
                
                self.arrM.append(model)
            }
            if self.arrM.count == 0 {
                return
            }
            self.excelView.contentData = self.arrM as! Array<CgOrModel>
            self.excelView.reloadData()
            self.view.addSubview(self.excelView)
            
            let label = UILabel.init(frame: CGRect(x: screen_w - 120, y: 10, width: 120, height: 21))
            label.font = UIFont.systemFont(ofSize: 13)
            label.adjustsFontSizeToFitWidth=true
            label.text = String(format:"变更金额合计:%.2f",sum)
            self.view.addSubview(label)
            self.excelView.frame =  CGRect.init(x: 0, y: 30, width: screen_w, height: screen_h - 210 - 30)
            
            
   
        
    }
    
}

}
