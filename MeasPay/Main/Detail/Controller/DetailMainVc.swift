//
//  DetailMainVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/8.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class DetailMainVc: UIViewController {
    private var pageTitleView: SGPageTitleView? = nil
    private var pageContentCollectionView: SGPageContentCollectionView? = nil
    @objc var info:NSDictionary = NSDictionary()
    @objc var isWorkBen:Bool = false
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var toolBarHeight: NSLayoutConstraint!
    @objc var type = MenuTypeConfig.mediateList
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setTitle()
//        if type ==  MenuTypeConfig.supvisReport {
//            getTitChildrens()
//        }else{
           setupSGPagingView()
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        if type !=  MenuTypeConfig.statiMea &&  type !=  MenuTypeConfig.processingCard{
            self.perform(#selector(setupToolbar), with: nil, afterDelay: 1)
        
        }
    }
    func setTitle() {
        switch type {
        case .pmtReport:
            self.navigationItem.title = "中期支付报表(工区)"
        case .totalPackage:
            self.navigationItem.title = "中期支付报表(总包)"
        case .supvisReport:
            self.navigationItem.title = "监理计量支付"
        case .workBench:
            self.navigationItem.title = "详情"
        case .statiMea:
            self.navigationItem.title = "投资进度详情"
        case .thirdPayment:
            self.navigationItem.title = "第三方支付详情"
        case .changeOrder:
            self.navigationItem.title = "变更令详情"
        case .supvisPayment:
            self.navigationItem.title = "监理计量详情"
        case .mediateList:
            self.navigationItem.title = "中间计量单详情"
        case .processingCard:
            self.navigationItem.title = "处理卡详情"
        case .mainlineTechnology:
            self.navigationItem.title = "主线技术服务"
        case .centralLaboratory:
            self.navigationItem.title = "中心实验室"
        case .informationConstruction:
            self.navigationItem.title = "信息化建设"
        case .auditUnit:
            self.navigationItem.title = "审计单位"
        case .thirdParty2: self.navigationItem.title = "勘察设计1标"
        case .thirdParty3: self.navigationItem.title = "勘察设计3标"
        case .thirdParty4: self.navigationItem.title = "水土保持检测服务项目"
        case .thirdParty5 : self.navigationItem.title = "水土保持设施验收"
        case .thirdParty6: self.navigationItem.title = "水文地质勘察"
        case .thirdParty7 : self.navigationItem.title = "环境监测项目"
        case .thirdParty8 : self.navigationItem.title = "勘察设计2标"
        case .thirdParty9 : self.navigationItem.title = "委托代建"
        case .thirdParty10 : self.navigationItem.title = "初步设计3标"
        case .thirdParty11 : self.navigationItem.title = "供地手续办理技术服务（玉溪）"
        case .thirdParty12 : self.navigationItem.title = "洪水项目评价"
        case .thirdParty13 : self.navigationItem.title = "安全技术咨询"
        case .thirdParty14 : self.navigationItem.title = "登楼山超前水平地质预报"
        case .thirdParty15: self.navigationItem.title = "通海县临时用地"
        case .thirdParty16: self.navigationItem.title = "弥勒县临时用地"
        case .thirdParty17: self.navigationItem.title = "供地手续办理技术服务（弥勒）"
        case .thirdParty18 : self.navigationItem.title = "供地手续办理技术服务（华宁）"
        case .thirdParty19: self.navigationItem.title = "供地手续办理技术服务（主线）"
        case .thirdParty20 : self.navigationItem.title = "水土保持变更编制"
            
        
        }
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private lazy var configure: SGPageTitleViewConfigure = {
        let configure = SGPageTitleViewConfigure()
        configure.indicatorStyle = .Dynamic
        configure.titleAdditionalWidth = 35
        configure.titleColor = UIColor(red: 157/255.0, green: 157/255.0, blue: 157/255.0, alpha: 1.0)
        configure.titleSelectedColor = .black
        configure.titleFont = UIFont.systemFont(ofSize: 13)
        configure.titleSelectedFont = UIFont.systemFont(ofSize: 16)
        configure.indicatorHeight = 8
        configure.indicatorCornerRadius = 4
        configure.indicatorDynamicWidth = 8
        configure.showBottomSeparator = false
        return configure
    }()
}

extension DetailMainVc {
    private func getTitChildrens(){
        NetWorkRequest(.getChildren(Dict: [
           "sectId":UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? "",
           "periodId": UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? "",
           "treeCode":  type ==  MenuTypeConfig.pmtReport ? "pentaho" : "supervisorPay"
        ])) { (response) -> (Void) in
            let jsonArr = JSON(parseJSON: response)
            var titleArr:Array<ChildrenModel> = []
            for dic in jsonArr.arrayValue {
                let model = ChildrenModel(dictionary: dic)
                titleArr.append(model)
            }
            self.setupByNet(titleArr: titleArr)
        }
    }
    private func setupByNet(titleArr:Array<ChildrenModel>) {
        let statusHeight = UIApplication.shared.statusBarFrame.height
        var pageTitleViewY: CGFloat = 0.0
        if statusHeight == 20 {
            pageTitleViewY = 64 + 15
        } else {
            pageTitleViewY = 88 + 15
        }
        var  titles:Array<String> = []
        var childVCs:Array<UIViewController> = []
 
        
        for model in titleArr {
            if(model.text == "中期支付证书" || model.text == "中期支付报表" || model.text == "支付证书" || model.text == "监理服务费计算表" || model.text == "扣预付款"){
                let fileVc:MiddleAttachVc = UIStoryboard(name: "MiddleAttach", bundle: nil).instantiateViewController(withIdentifier: "MiddleAttachVc") as! MiddleAttachVc
                titles.append(model.text ?? "")
                childVCs.append(fileVc)
                dealVc(model: model, fileVc: fileVc)
            }
        }
//        if(type == MenuTypeConfig.supvisReport){
//            titles.append("审核信息")
//            let adtVc:AuditInforVc = UIStoryboard(name:"AuditInfor" , bundle: nil).instantiateViewController(withIdentifier: "AuditInforVc") as! AuditInforVc
//            adtVc.bizPk = self.getBizPk()
//            childVCs.append(adtVc)
//        }
        self.pageTitleView = SGPageTitleView(frame: CGRect(x: 0, y: pageTitleViewY, width: view.frame.size.width, height: 44), delegate: self, titleNames: titles as [NSString], configure: self.configure)
        view.addSubview(pageTitleView!)
        var contentViewHeight = view.frame.size.height - self.pageTitleView!.frame.maxY  -  self.toolBarHeight.constant
        print(screen_h)
        if UIDevice.current.isX(){
            contentViewHeight -= 30
        }
        let contentRect = CGRect(x: 0, y: (pageTitleView?.frame.maxY)!, width: view.frame.size.width, height: contentViewHeight)
        self.pageContentCollectionView = SGPageContentCollectionView(frame: contentRect, parentVC: self, childVCs: childVCs)
        pageContentCollectionView?.delegateCollectionView = self
        view.addSubview(pageContentCollectionView!)
    }
    
    func dealVc(model:ChildrenModel,fileVc:MiddleAttachVc){
        let param = ["index": "0",
                     "bizPk": self.getBizPk(),
                     "projectId": UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? "",
                     "sectId": UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? "",
                     "periodId": UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? "",
                     "ppp": UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""]
        NetWorkRequest(.sheetData(Dict:param)) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            var paramDic = jsonDic["data"].dictionaryObject
            
            paramDic?["fileUri"] =  model.sedId!.removingPercentEncoding 
            
            paramDic?["fileName"] = model.text! + model.id!
            paramDic?["pdfId"] = model.id
            paramDic?["newFormFlag"] = "0"
            paramDic?["bizPk"] = self.getBizPk()
            paramDic?["projectId"] = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
            paramDic?["sectId"] = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
            paramDic?["periodId"] = UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""
            paramDic?["periodNum"] = self.info["periodNum"]
            paramDic?["ppp"] = ""
            paramDic?["dataFrom"] = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
            paramDic?["treeCode"] = "pentaho"
            NetWorkRequest(.generateKey(Dict:paramDic!)) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response).dictionaryObject
                let fileId  =  "\(jsonDic?["data"] ?? "")"
                let name = (model.text! + model.id!) .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                let path = "\(NSHomeDirectory())/Documents/\(name!).pdf"
                if !self.checkDownload(filePath: name! + ".pdf") {
                    NetWorkRequest(.mFileDownload(assetName:fileId)) { (response) -> (Void) in
                        fileVc.filePath = path
                        fileVc.reload()
                    }
                }else{
                    fileVc.filePath = path
                    fileVc.reload()
                }
            }
            
        }
    }
    func checkDownload(filePath:String) -> Bool {
        for item in  FileManager.default.subpaths(atPath: "\(NSHomeDirectory())/Documents")! {
            if item == filePath {
                return true
            }
        }
         return false
    }

    private func setupSGPagingView() {
        let pageTitleViewY: CGFloat = UIApplication.shared.statusBarFrame.height + 44
        var  titles:Array<String> = []
        switch type {
        case MenuTypeConfig.mediateList:
            titles = ["基本信息", "台账详情", "计算式", "附件", "审核信息"]
        case MenuTypeConfig.thirdPayment:
            titles = ["支付凭单", "中期支付证书", "附件", "审核信息"]
        case MenuTypeConfig.changeOrder:
            titles = ["基本信息", "明细", "附件", "审核信息"]
        case MenuTypeConfig.supvisPayment:
            titles = ["基本信息","监理支付情况","监理人员考勤","出勤表","附件","审核信息"]
        case MenuTypeConfig.pmtReport:
            titles = ["中期支付证书","清单支付汇总表","清单支付明细表","变更设计支付汇总表","变更设计支付明细表"]
            if self.info["status"] as! String != "0"{
                titles.append("审核信息")
            }
           
        case MenuTypeConfig.totalPackage:
            titles = ["中期支付证书","清单支付汇总表","变更设计支付汇总表","变更设计支付明细表(总承包)"]
            if self.info["status"] as! String != "0"{
                titles.append("审核信息")
            }
        case MenuTypeConfig.supvisReport:
            titles = ["监理支付情况","支付情况","审核信息"]
        case MenuTypeConfig.statiMea:
            titles = ["计量统计图","计量情况"]
        case MenuTypeConfig.workBench:
            titles = ["附件","审核信息"]
        case MenuTypeConfig.processingCard:
            titles = ["基本信息", "明细", "附件"]
        case MenuTypeConfig.centralLaboratory, MenuTypeConfig.mainlineTechnology, MenuTypeConfig.informationConstruction, MenuTypeConfig.auditUnit
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
            titles = ["支付凭单", "支付情况", "审核信息"]
        }
        self.pageTitleView = SGPageTitleView(frame: CGRect(x: 0, y: pageTitleViewY, width: view.frame.size.width, height: 44), delegate: self, titleNames: titles as [NSString], configure: self.configure)
        view.addSubview(pageTitleView!)
        
        let basicVc:BasicInfoVc = UIStoryboard(name:"BasicInfo" , bundle: nil).instantiateViewController(withIdentifier: "BasicInfoVc") as! BasicInfoVc
        basicVc.bizPk = self.getBizPk()
        basicVc.type = self.type
        let fmaVc:FormulaVc = UIStoryboard(name:"Formula" , bundle: nil).instantiateViewController(withIdentifier: "FormulaVc") as! FormulaVc
        fmaVc.bizPk = self.getBizPk()
        let cmpVc:CompletVc = UIStoryboard(name:"Complet" , bundle: nil).instantiateViewController(withIdentifier: "CompletVc") as! CompletVc
        cmpVc.bizPk = self.getBizPk()
        let atmVc:AttachmentVc = UIStoryboard(name:"Attachment" , bundle: nil).instantiateViewController(withIdentifier: "AttachmentVc") as! AttachmentVc
        atmVc.bizPk = self.getBizPk()
        let adtVc:AuditInforVc = UIStoryboard(name:"AuditInfor" , bundle: nil).instantiateViewController(withIdentifier: "AuditInforVc") as! AuditInforVc
        adtVc.bizPk = self.getBizPk()
        let excelVc:ExcelVc = UIStoryboard(name:"Excel" , bundle: nil).instantiateViewController(withIdentifier: "ExcelVc") as! ExcelVc
        excelVc.info = self.info
        excelVc.excelType = ExcelTypeConfig.first
        excelVc.type = self.type
        let excelCerVc:ExcelVc = UIStoryboard(name:"Excel" , bundle: nil).instantiateViewController(withIdentifier: "ExcelVc") as! ExcelVc
        excelCerVc.info = self.info
        excelCerVc.excelType = ExcelTypeConfig.second
        
        let excelMeFVc:ExcelMergeVc = UIStoryboard(name:"ExcelMerge" , bundle: nil).instantiateViewController(withIdentifier: "ExcelMergeVc") as! ExcelMergeVc
        excelMeFVc.info = self.info
        excelMeFVc.excelType = ExcelTypeConfig.first
        excelMeFVc.type = self.type
        
        let excelMeSVc:ExcelMergeVc = UIStoryboard(name:"ExcelMerge" , bundle: nil).instantiateViewController(withIdentifier: "ExcelMergeVc") as! ExcelMergeVc
        excelMeSVc.info = self.info
        excelMeSVc.excelType = ExcelTypeConfig.second
        excelMeSVc.type = self.type
        
        let excelMeTVc:ExcelMergeVc = UIStoryboard(name:"ExcelMerge" , bundle: nil).instantiateViewController(withIdentifier: "ExcelMergeVc") as! ExcelMergeVc
        excelMeTVc.info = self.info
        excelMeTVc.excelType = ExcelTypeConfig.third
        excelMeTVc.type = self.type
        
        let newExcelVc1:ExcelComplexVc = ExcelComplexVc.init()
        newExcelVc1.excelType = "T_PayCert"
        newExcelVc1.bizPk = self.getBizPk()
        newExcelVc1.type = self.type
        newExcelVc1.tagTitle = "中期支付证书"
        
        let newExcelVc2:ExcelComplexVc = ExcelComplexVc.init()
        newExcelVc2.excelType = "T_Bill"
        newExcelVc2.bizPk = self.getBizPk()
        newExcelVc2.type = self.type
        newExcelVc2.tagTitle = "清单支付汇总表"
        
        let newExcelVc3:ExcelComplexVc = ExcelComplexVc.init()
        newExcelVc3.excelType = "T_Change"
        newExcelVc3.bizPk = self.getBizPk()
        newExcelVc3.type = self.type
        newExcelVc3.tagTitle = "变更设计支付汇总表"
        
        let newExcelVc4:ExcelComplexVc = ExcelComplexVc.init()
        newExcelVc4.excelType = "T_ChangeSumDetail"
        newExcelVc4.bizPk = self.getBizPk()
        newExcelVc4.tagTitle = "变更设计支付明细表(总承包)"
        
        let newExcelVc5:ExcelComplexVc = ExcelComplexVc.init()
        newExcelVc5.excelType = "T_BillDetail"
        newExcelVc5.bizPk = self.getBizPk()
        newExcelVc5.type = self.type
        newExcelVc5.tagTitle = "清单支付明细表"
        
        let newExcelVc6:ExcelComplexVc = ExcelComplexVc.init()
        newExcelVc6.excelType = "T_ChangeDetail"
        newExcelVc6.bizPk = self.getBizPk()
        newExcelVc6.type = self.type
        newExcelVc6.tagTitle = "变更设计支付明细表"
        
        
        let midBasicVc:MiddleMeasureDetailVc = UIStoryboard(name:"MiddleMeasureDetail" , bundle: nil).instantiateViewController(withIdentifier: "MiddleMeasureDetailVc") as! MiddleMeasureDetailVc
        midBasicVc.bizPk = self.getBizPk()
        
        
        let supvisReportDetailVc:SupvisReportDetailVc = UIStoryboard(name:"SupvisReportDetail" , bundle: nil).instantiateViewController(withIdentifier: "SupvisReportDetailVc") as! SupvisReportDetailVc
        supvisReportDetailVc.info = self.info
        
        let serversPayInfoDetailVc:ServersPayInfoDetailVc = UIStoryboard(name:"ServersPayInfoDetail" , bundle: nil).instantiateViewController(withIdentifier: "ServersPayInfoDetailVc") as! ServersPayInfoDetailVc
        serversPayInfoDetailVc.info = self.info
        serversPayInfoDetailVc.type = self.type
        
        
        if self.toolBarHeight.constant  == 0 {
            excelVc.btmToolHidden = true
            excelCerVc.btmToolHidden = true
            excelMeFVc.btmToolHidden = true
            excelMeSVc.btmToolHidden = true
            excelMeTVc.btmToolHidden = true
            
            newExcelVc1.btmToolHidden = true
        }
        
        let onlineExcelVc1:OnlineExcelVc = UIStoryboard(name:"OnlineExcel" , bundle: nil).instantiateViewController(withIdentifier: "OnlineExcelVc") as! OnlineExcelVc
        onlineExcelVc1.info = self.info
        onlineExcelVc1.excelType = ExcelTypeConfig.first
        onlineExcelVc1.type = self.type
        
        let onlineExcelVc2:OnlineExcelVc = UIStoryboard(name:"OnlineExcel" , bundle: nil).instantiateViewController(withIdentifier: "OnlineExcelVc") as! OnlineExcelVc
        onlineExcelVc2.info = self.info
        onlineExcelVc2.excelType = ExcelTypeConfig.second
        onlineExcelVc2.type = self.type
        
        let chartVc:ChartVc = UIStoryboard(name:"Chart" , bundle: nil).instantiateViewController(withIdentifier: "ChartVc") as! ChartVc
        chartVc.info = self.info
        
        let mprPdfVc = MiddleMeasureReportPdfController.init()
        mprPdfVc.info = self.info as! [AnyHashable : Any]
        
        var childVCs:Array<UIViewController> = []
        switch type {
        case MenuTypeConfig.mediateList:
            childVCs = [midBasicVc, cmpVc, fmaVc, atmVc, adtVc]
        case MenuTypeConfig.thirdPayment:
            childVCs = [excelVc, excelCerVc, atmVc, adtVc]
        case MenuTypeConfig.changeOrder:
            childVCs = [basicVc, excelVc, atmVc, adtVc]
        case MenuTypeConfig.supvisPayment:
            basicVc.info = self.info
            childVCs = [basicVc, excelMeFVc, excelMeSVc, excelMeTVc, atmVc, adtVc]
        case MenuTypeConfig.pmtReport:
            childVCs = [newExcelVc1,newExcelVc2,newExcelVc5,newExcelVc3,newExcelVc6]
            if self.info["status"] as! String != "0"{
                childVCs.append(adtVc)
            }
        case MenuTypeConfig.totalPackage:
            childVCs = [newExcelVc1,newExcelVc2,newExcelVc3,newExcelVc4]
            if self.info["status"] as! String != "0"{
                childVCs.append(adtVc)
            }
        case MenuTypeConfig.supvisReport:
            childVCs = [excelVc,supvisReportDetailVc,adtVc]
        case MenuTypeConfig.centralLaboratory,MenuTypeConfig.mainlineTechnology
             ,MenuTypeConfig.informationConstruction,MenuTypeConfig.auditUnit
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
            childVCs = [excelVc,serversPayInfoDetailVc,adtVc]
        case MenuTypeConfig.statiMea:
            childVCs = [chartVc,excelMeFVc]
        case MenuTypeConfig.workBench:
             childVCs = [atmVc, adtVc]
        case MenuTypeConfig.processingCard:
             childVCs = [basicVc, excelVc, atmVc]
        }
        var contentViewHeight = view.frame.size.height - self.pageTitleView!.frame.maxY  -  self.toolBarHeight.constant
        print(screen_h)
        if UIDevice.current.isX(){
             contentViewHeight -= 30
        }
        let contentRect = CGRect(x: 0, y: (pageTitleView?.frame.maxY)!, width: view.frame.size.width, height: contentViewHeight)
        self.pageContentCollectionView = SGPageContentCollectionView(frame: contentRect, parentVC: self, childVCs: childVCs)
        pageContentCollectionView?.delegateCollectionView = self
        view.addSubview(pageContentCollectionView!)
    }
    func getBizPk() -> String {
        if  self.type ==  MenuTypeConfig.statiMea {
            return ""
        }else if isWorkBen{
           return self.info["bizPk"] as! String
        }else{
           return self.info["id"] as! String
        }
    }
    @objc private func setupToolbar() {
        NetWorkRequest(.getFlowToolbar(Dict: ["bizPk":self.getBizPk()])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let dataArr = jsonDic["data"].array
            var btnCount:CGFloat = 0
            var count:CGFloat = 0
            for dic in dataArr ?? Array(){
                if dic["name"].stringValue == "删除" && (self.type ==  MenuTypeConfig.pmtReport || self.type ==  MenuTypeConfig.supvisReport || self.type ==  MenuTypeConfig.totalPackage){
                    continue
                }
                if dic["name"].stringValue != "打印" && dic["name"].stringValue != "保存" {
                     btnCount += 1
                }
            }
            if btnCount == 0{
                self.toolBarHeight.constant  = 0
                self.pageTitleView?.removeFromSuperview()
                self.pageContentCollectionView?.removeFromSuperview()
                self.toolBarView?.removeFromSuperview()
//                if self.type ==  MenuTypeConfig.supvisReport{
//                    self.getTitChildrens()
//                }else{
                    self.setupSGPagingView()
//                }
                
                return
            }
            self.toolBarView.subviews.forEach{
                $0.removeFromSuperview()
            }
            for dic in dataArr ?? Array(){
                if dic["name"].stringValue == "打印" || dic["name"].stringValue == "保存"{
                    continue
                }
                if dic["name"].stringValue == "删除" && (self.type ==  MenuTypeConfig.pmtReport || self.type ==  MenuTypeConfig.supvisReport || self.type == MenuTypeConfig.totalPackage){
                    continue
                }
                let btn = UIButton(type:.custom)
                btn.frame  = CGRect(x: screen_w / btnCount * count, y: 5, width: screen_w / btnCount, height: 30)
                switch dic["name"]{
                case "通过":
                     btn.setImage(UIImage(named: "ic_pass"), for: .normal)
                case "退回":
                    btn.setImage(UIImage(named: "ic_return"), for: .normal)
                case "撤回":
                    btn.setImage(UIImage(named: "ic_reject"), for: .normal)
                case "删除":
                    btn.setImage(UIImage(named: "ic_delete"), for: .normal)
                case "提交":
                    btn.setImage(UIImage(named: "ic_pass"), for: .normal)
                default:
                    break
                }
                btn.setTitle(dic["name"].stringValue, for: .normal)
                btn.setTitleColor(.black, for: .normal)
                btn.addTarget(self, action: #selector(self.clickOption(btn:)), for: .touchUpInside)
                self.toolBarView.addSubview(btn)
                count += 1
            }
        }
    }
    @objc func clickOption(btn:UIButton) {
        switch  btn.title(for: .normal){
        case "删除":
            self.delete(bizPk:self.getBizPk())
        case "通过":
            let vc:PassVc = UIStoryboard(name: "Pass", bundle: nil).instantiateViewController(withIdentifier: "PassVc") as! PassVc
            vc.bizPk = self.getBizPk()
            vc.type = OptionTypeConfig.pass
            vc.parentType = self.type
            self.navigationController?.pushViewController(vc, animated: true)
        case "提交":
            let vc:PassVc = UIStoryboard(name: "Pass", bundle: nil).instantiateViewController(withIdentifier: "PassVc") as! PassVc
            vc.bizPk = self.getBizPk()
            vc.type = OptionTypeConfig.submit
            vc.parentType = self.type
            self.navigationController?.pushViewController(vc, animated: true)
        case "退回":
            let vc:PassVc = UIStoryboard(name: "Pass", bundle: nil).instantiateViewController(withIdentifier: "PassVc") as! PassVc
            vc.bizPk = self.getBizPk()
            vc.type = OptionTypeConfig.back
            vc.parentType = self.type
            self.navigationController?.pushViewController(vc, animated: true)
        case "撤回":
            self.revoke(bizPk:self.getBizPk())
        default:
            break
        }
    }
    
    func delete(bizPk:String) {
        let alert = UIAlertController(title: "", message:"是否确定删除？", preferredStyle:.alert)
        alert.addAction(title: "取消", style: .cancel)
        alert.addAction(title:"确定",style:.destructive){info in
            NetWorkRequest(.deleteMedia(Dict: ["bizPk":bizPk,"id":bizPk])) { (responese) -> (Void) in
                SVProgressHUD.showSuccess(withStatus: "删除成功")
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func revoke(bizPk:String) {
        let alert = UIAlertController(title: "", message:"是否确定撤回？", preferredStyle:.alert)
        alert.addAction(title: "取消", style: .cancel)
        alert.addAction(title:"确定",style:.destructive){info in
            NetWorkRequest(.revokeTask(Dict: ["bizPk":bizPk,"id":bizPk])) { (responese) -> (Void) in
                SVProgressHUD.showSuccess(withStatus: "撤回成功")
                self.navigationController?.popViewController(animated: true)
            } 
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension DetailMainVc: SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate {
    func pageTitleView(pageTitleView: SGPageTitleView, index: Int) {
        pageContentCollectionView?.setPageContentCollectionView(index: index)
    }
    func pageContentCollectionView(pageContentCollectionView: SGPageContentCollectionView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        
        if targetIndex == 0 {
            self.pageTitleView?.resetIndicatorColor(color: .red)
        }else if targetIndex == 1 {
            self.pageTitleView?.resetIndicatorColor(color: .yellow)
        }else if targetIndex == 2 {
            self.pageTitleView?.resetIndicatorColor(color: UIColor(red: 50/255.0, green: 235/255.0, blue: 247/255.0, alpha: 1.0))
        }else if targetIndex == 3{
            self.pageTitleView?.resetIndicatorColor(color: UIColor(red: 10/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1.0))
        }else{
            self.pageTitleView?.resetIndicatorColor(color: UIColor(red: 210/255.0, green: 121/255.0, blue: 255/255.0, alpha: 1.0))
        }
        
        pageTitleView?.setPageTitleView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
