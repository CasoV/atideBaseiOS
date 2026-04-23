//
//  MediateListVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/26.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import GYSide
import SwiftyJSON
import MJRefresh
import LYEmptyView
import SVProgressHUD

class MediateListVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var typeBtn1: UIButton!
    @IBOutlet weak var typeBtn2: UIButton!
    @IBOutlet weak var typeBtn3: UIButton!
    @IBOutlet weak var typeBtn4: UIButton!
    @IBOutlet weak var typeBtn5: UIButton!
    @IBOutlet weak var typeBtn6: UIButton!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var tabTop: NSLayoutConstraint!
    
    @objc var type:MenuTypeConfig = MenuTypeConfig.mediateList
    @objc var proType:NSString = ""
    let dotV = UIView()
    var dataArr = [Any]()
    var page:NSInteger = 1
    var status = ""
    var batchArr = [MediateModel]()
    var needStatus = ""
    var total = 0;
    let backColorView = UIView.init(frame: UIScreen.main.bounds)
    var conditionController:LeftScreenVc? = nil
    let tagNumLb = UILabel.init(frame: CGRect(x: 70, y: 0, width: 150, height: 30));
    
    // 菜单类型
    enum MenuConfig: Int{
        case measurement = 0
        case declare = 1
        case through = 2
        case back = 3
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initSideView()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadNew()
        
        switch type {
        case MenuTypeConfig.mediateList:
            self.navigationItem.title = "中间计量单"
        case MenuTypeConfig.thirdPayment:
            self.navigationItem.title = "第三方支付"
        case MenuTypeConfig.changeOrder:
            self.navigationItem.title = "变更令"
        case MenuTypeConfig.supvisPayment:
            self.navigationItem.title = "监理费用支付"
        case MenuTypeConfig.pmtReport:
            self.navigationItem.title = "中期支付报表(工区)"
        case MenuTypeConfig.totalPackage:
            self.navigationItem.title = "中期支付报表(总包)"
        case MenuTypeConfig.supvisReport:
             self.navigationItem.title = "监理计量报表"
        case MenuTypeConfig.centralLaboratory:
             self.navigationItem.title = "中心实验室"
        case MenuTypeConfig.mainlineTechnology:
             self.navigationItem.title = "主线技术服务"
        case MenuTypeConfig.informationConstruction:
             self.navigationItem.title = "信息化建设"
        case MenuTypeConfig.auditUnit:
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
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }

    func initUI() {
        self.updateBtn(seleBtn: typeBtn1)
        self.listTable.delegate = self
        self.listTable.dataSource = self
        self.listTable.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.listTable.mj_header = MJRefreshNormalHeader()
        self.listTable.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(loadNew))
        self.listTable.mj_footer = MJRefreshAutoNormalFooter()
        self.listTable.mj_footer?.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
        switch type {
        case MenuTypeConfig.mediateList:
            self.setTabHead()
        case MenuTypeConfig.thirdPayment:
            let cellNib = UINib(nibName: "ThirdPaymentCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ThirdPaymentCell")
        case MenuTypeConfig.changeOrder:
            let cellNib = UINib(nibName: "ChangeOrderCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ChangeOrderCell")
        case MenuTypeConfig.supvisPayment:
            let cellNib = UINib(nibName: "SupvisPaymentCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "SupvisPaymentCell")
            self.setupTop()
        case MenuTypeConfig.pmtReport:
            let cellNib = UINib(nibName: "ReportCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ReportCell")
            self.setupTop()
        case MenuTypeConfig.totalPackage:
            let cellNib = UINib(nibName: "ReportCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ReportCell")
            self.setupTop()
        case MenuTypeConfig.supvisReport:
            let cellNib = UINib(nibName: "ReportCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ReportCell")
            self.setupTop()
        case MenuTypeConfig.centralLaboratory:
            let cellNib = UINib(nibName: "ReportCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ReportCell")
            self.setupTop()
        case MenuTypeConfig.mainlineTechnology:
            let cellNib = UINib(nibName: "ReportCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ReportCell")
            self.setupTop()
            
        case MenuTypeConfig.informationConstruction:
            let cellNib = UINib(nibName: "ReportCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ReportCell")
            self.setupTop()
        case MenuTypeConfig.auditUnit    ,MenuTypeConfig.thirdParty2
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
            let cellNib = UINib(nibName: "ReportCell", bundle: nil)
            self.listTable.register(cellNib, forCellReuseIdentifier: "ReportCell")
            self.setupTop()
        default:
            break
        }
        //设置导航栏
        self.setNavRightItem()
        let emptyView = LYEmptyView.emptyActionView(with: UIImage.init(named: "no_data"), titleStr: "    暂无数据！", detailStr: "", btnTitleStr: "", btnClick: nil)
        emptyView?.titleLabFont = UIFont.systemFont(ofSize: 15)
        emptyView?.titleLabTextColor = UIColor.init(red: 172/255.0, green: 172/255.0, blue: 172/255.0, alpha: 1.0)
        self.listTable.ly_emptyView = emptyView
        self.listTable.ly_emptyView.tapEmptyViewBlock  = {
            self.loadNew()
        }
    }
    func setNavRightItem(){
        switch type {
        case MenuTypeConfig.mediateList:
            let custemView = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
            let btn1 = UIButton.init(type: .custom)
            btn1.frame = CGRect(x: 40, y: 0, width: 30, height: 30)
            btn1.setImage(UIImage.init(named: "icon_filter_bk"), for: .normal)
            btn1.addTarget(self, action: #selector(showScreen), for: .touchUpInside)
            custemView.addSubview(btn1)
            let btn2 = UIButton.init(type: .custom)
            btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn2.setImage(UIImage.init(named: "ic_batch"), for: .normal)
            btn2.addTarget(self, action: #selector(batch), for: .touchUpInside)
            custemView.addSubview(btn2)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: custemView)
            break
        case MenuTypeConfig.pmtReport:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_filter_bk"), style: .plain, target: self, action:#selector(showScreen) )
            break
        case MenuTypeConfig.totalPackage:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_filter_bk"), style: .plain, target: self, action:#selector(showScreen) )
            break
        case MenuTypeConfig.centralLaboratory:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_filter_bk"), style: .plain, target: self, action:#selector(showScreen) )
            break
        case MenuTypeConfig.mainlineTechnology:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_filter_bk"), style: .plain, target: self, action:#selector(showScreen) )
            break
        case MenuTypeConfig.informationConstruction:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_filter_bk"), style: .plain, target: self, action:#selector(showScreen) )
            break
        case MenuTypeConfig.auditUnit    ,MenuTypeConfig.thirdParty2
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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_filter_bk"), style: .plain, target: self, action:#selector(showScreen) )
            break
        default:
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "icon_filter_bk"), style: .plain, target: self, action:#selector(showScreen) )
            break
            
        }
    }
    func setTabHead() {
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: screen_w, height: 30))
        listTable.tableHeaderView = headView
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        btn.setImage(UIImage.init(named: "ic_select"), for: .normal)
        btn.setImage(UIImage.init(named: "ic_selected"), for: .selected)
        btn.setTitle("全选", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(chooseAll), for: .touchUpInside)
        headView.addSubview(btn)
        
        tagNumLb.font = .systemFont(ofSize: 14)
        tagNumLb.text = "共0条/选中0条"
        headView.addSubview(tagNumLb)
        
        let reordBtn = UIButton.init(type: .custom)
        reordBtn.frame = CGRect(x: screen_w-60, y: 0, width: 60, height: 30)
        reordBtn.setImage(UIImage.init(named: "ic_sort"), for: .normal)
        reordBtn.setTitle("重排", for: .normal)
        reordBtn.setTitleColor(.black, for: .normal)
        reordBtn.titleLabel?.font = .systemFont(ofSize: 14)
        reordBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        reordBtn.addTarget(self, action: #selector(reorder), for: .touchUpInside)
        headView.addSubview(reordBtn)
    }
    
     @objc func reorder(btn: UIButton) {
        let reorderVc:ReorderVc =  UIStoryboard(name: "Reorder", bundle: nil).instantiateViewController(withIdentifier: "ReorderVc") as! ReorderVc
        self.navigationController?.pushViewController(reorderVc, animated: true)
    }
    
    @objc func chooseAll(btn: UIButton) {
        let select:Bool
        if batchArr.count == dataArr.count{
            select = false
            batchArr.removeAll()
        }else{
            select = true
            batchArr = dataArr as! [MediateModel]
        }
         btn.isSelected = select
        
        for model in dataArr{
            let mediModel:MediateModel = model as! MediateModel
            mediModel.isSelect = select
        }
        tagNumLb.text = "共\(total)条/选中\(batchArr.count)条"
        listTable.reloadData()
    }
    
    
    
    @objc func loadNew(){
        page = 1
        self.dataArr.removeAll()
        self.batchArr.removeAll()
        self.loadData( )
    }
    @objc func loadMore(){
        page += 1
        self.loadData()
    }
    func setupTop()  {
        self.typeBtn1.isHidden = true
        self.typeBtn2.isHidden = true
        self.typeBtn3.isHidden = true
        self.typeBtn4.isHidden = true
        self.typeBtn5.isHidden = true
        self.typeBtn6.isHidden = true
        self.tabTop.constant = -30
    }
    
    func loadData() {
        switch type {
        case MenuTypeConfig.mediateList:
            //在前端判断分页（后端分页有问题）
            if(self.page != 1 && self.total < (self.page - 1) * 10){
                self.listTable.mj_header?.endRefreshing()
                self.listTable.mj_footer?.endRefreshing()
                self.listTable.mj_footer?.isHidden = true
                return
            }
            let meteragePartCode = UserDefaults.standard.string(forKey: ScrInfo().meteragePartCode) ?? "-1"
            let sectId = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
            let projectId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
            let periodId = UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""
            let param = ["status":status,"meteragePartCode":meteragePartCode,"projectId": projectId,"sectId":sectId,"periodId":periodId,"ledgerId":"","page":"\(page)","rows":"10","needStatus":"\(needStatus)",]
            NetWorkRequest(.intermediateList(Dict: param)) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let data = jsonDic["data"]["rows"].array
                self.total = jsonDic["data"]["total"].int ?? 0
                self.tagNumLb.text = "共\(self.total)条/选中\(self.batchArr.count)条"
                for dataDic in data ?? Array() {
                    let model = MediateModel(jsonData: dataDic)
                    self.dataArr.append(model)
                }
                if self.dataArr.count == 0 {
                    self.listTable.mj_header?.endRefreshing()
                    self.listTable.mj_footer?.endRefreshing()
                    self.listTable.reloadData()
                    self.listTable.mj_footer?.isHidden = true
                    return
                }
                self.listTable.mj_footer?.isHidden = false
                self.listTable.mj_header?.endRefreshing()
                self.listTable.mj_footer?.endRefreshing()
                self.listTable.reloadData()
            }
        case MenuTypeConfig.thirdPayment:
            let sectId = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
            let projectId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
            let periodId = UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""
            let param = ["status":status,"projectId": projectId,"sectId":sectId,"periodId":periodId,"type":"1","page":"\(page)","rows":"15","code":""]
            NetWorkRequest(.getPaymentInfo(Dict: param)) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let data = jsonDic["rows"].array
                if data == nil  || data?.count == 0{
                    self.listTable.reloadData()
                    self.listTable.mj_footer?.isHidden = true
                    return
                }
                for dataDic in data! {
                    let model = PaymentModel(dictionary: dataDic)
                    self.dataArr.append(model)
                }
                self.listTable.mj_header?.endRefreshing()
                self.listTable.mj_footer?.endRefreshing()
                self.listTable.reloadData()
            }
        case MenuTypeConfig.changeOrder:
            let sectId = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
            let projectId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
            let periodId = UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""
            let param = ["status":status,"projectId": projectId,"sectId":sectId,"periodId":periodId,"type":"1","page":"\(page)","rows":"15"]
            NetWorkRequest(.changeOrderList(Dict: param)) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let data = jsonDic["rows"].array
                if data == nil  || data?.count == 0{
                    self.listTable.reloadData()
                    self.listTable.mj_footer?.isHidden = true
                    return
                }
                for dataDic in data! {
                    let model = ChangeOrderModel(dictionary: dataDic)
                    self.dataArr.append(model)
                }
                self.listTable.mj_header?.endRefreshing()
                self.listTable.mj_footer?.endRefreshing()
                self.listTable.reloadData()
            }
        case MenuTypeConfig.supvisPayment:
            let sectId = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
            let projectId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
            let periodId = UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""
            let param = ["status":status,"projectId": projectId,"sectionId":sectId,"periodId":periodId,"page":"\(page)","rows":"15"]
            NetWorkRequest(.supvisPaymentList(Dict: param)) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let data = jsonDic["rows"].array
                if data == nil  || data?.count == 0{
                    self.listTable.reloadData()
                    self.listTable.mj_footer?.isHidden = true
                    return
                }
                for dataDic in data! {
                    let model = SupvisPaymentModel(dictionary: dataDic)
                    self.dataArr.append(model)
                }
                self.listTable.mj_header?.endRefreshing()
                self.listTable.mj_footer?.endRefreshing()
                self.listTable.reloadData()
            }
        case MenuTypeConfig.pmtReport,MenuTypeConfig.totalPackage:
            let sectId = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
            let projectId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
            let param = ["projectId": projectId,"sectId":sectId,"type":"1", "ifAdvance":"0", "all":"1","page":"\(page)","rows":"999"]
            NetWorkRequest(.pmtReportList(Dict: param)) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let data = jsonDic["rows"].array
                if data == nil  || data?.count == 0{
                    self.listTable.reloadData()
                    self.listTable.mj_footer?.isHidden = true
                    return
                }
                for dataDic in data! {
                    let model = PmtReportModel(dictionary: dataDic)
                    self.dataArr.append(model)
                }
                self.listTable.mj_header?.endRefreshing()
                self.listTable.mj_footer?.endRefreshing()
                self.listTable.reloadData()
            }
        case MenuTypeConfig.supvisReport:
//            let sectId = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
//            let projectId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
//            let periodId = UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""
//            let param = ["status":status,"projectId": projectId,"sectionId":sectId,"periodId":periodId,"page":"\(page)","rows":"15"]
            NetWorkRequest(.supvisReportList(Dict: ["":""])) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let dic = jsonDic["data"].dictionary
                let data = dic?["rows"]?.array
                if data == nil  || data?.count == 0{
                    self.listTable.reloadData()
                    self.listTable.mj_footer?.isHidden = true
                    return
                }
                self.dataArr.removeAll()
                for dataDic in data! {
                    let model = SupvisReportModel(dictionary: dataDic)
                    self.dataArr.append(model)
                }
                self.listTable.mj_header?.endRefreshing()
                self.listTable.mj_footer?.endRefreshing()
                self.listTable.reloadData()
            }
        case MenuTypeConfig.centralLaboratory, MenuTypeConfig.mainlineTechnology, MenuTypeConfig.informationConstruction, MenuTypeConfig.auditUnit    ,MenuTypeConfig.thirdParty2
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
            
            var param:Dictionary<String, String>
            if(type ==  MenuTypeConfig.centralLaboratory){
                param = ["type":"3"]
            }else{
                param = ["type":"5"]
            }
            NetWorkRequest(.listServersInfoBysectId(Dict: param)) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let dic = jsonDic["data"].dictionary
                let data = dic?["rows"]?.array
                if data == nil  || data?.count == 0{
                    self.listTable.reloadData()
                    self.listTable.mj_footer?.isHidden = true
                    return
                }
                self.dataArr.removeAll()
                for dataDic in data! {
                    let model = ListServersModel(jsonData: dataDic)
                    self.dataArr.append(model)
                }
                self.listTable.mj_header?.endRefreshing()
                self.listTable.mj_footer?.endRefreshing()
                self.listTable.reloadData()
            }
        default:
            break
        }
    }
    //MARK: - 导航栏按钮点击事件
    @IBAction func showScreen(_ sender: Any) {
        tapCondition()
    }
    @IBAction func batch(_ sender: Any) {
        if(batchArr.count == 0){
            SVProgressHUD.showInfo(withStatus: "请选择计量单!")
            return
        }
        if(needStatus == "2"){
            SVProgressHUD.showInfo(withStatus: "当前环节不可处理!")
            return
        }
//        let items: [String] = ["批量计量","批量申报","批量通过","批量退回"]
        let items: [String] = ["批量申报","批量通过","批量退回"]
//        let items: [String] = ["批量通过","批量退回"]
//        let items: [String] = ["批量申报"]
        NavigationMenuShared.showPopMenuSelecteWithFrameWidth(width: itemWidth, height: 160, point: CGPoint(x: ScreenInfo.Width - 70, y:15), item: items, imgSource: []) { (index) in
            switch index{
//            case 0:
//                self.alertPick(title: items[0], message: "计量比例（%）", placehoder: "0~100之间", type: MenuConfig.measurement.rawValue,text:"")
            
        
            case 0:
                
                    self.batchOperation(prop: "", optionType:   MenuConfig.declare.rawValue)
//                self.alertPick(title: items[0], message: "请输入意见", placehoder: "请输入意见", type: MenuConfig.declare.rawValue,text:"申报")
            case 1:
                self.batchOperation(prop: "", optionType:   MenuConfig.through.rawValue)
//                self.alertPick(title: items[1], message: "请输入意见", placehoder: "请输入意见", type: MenuConfig.through.rawValue,text:"通过")
            case 2:
                self.batchOperation(prop: "", optionType:   MenuConfig.back.rawValue)
//                self.alertPick(title: items[2], message: "请填入退回意见", placehoder: "请填入退回意见", type: MenuConfig.back.rawValue,text:"退回")
            default:
                break
            }
        }
    }
    
    func alertPick(title:String,message:String,placehoder:String,type:Int,text:String) {
        if self.batchArr.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择计量单！")
            return
        }
        let alert = UIAlertController(title: title, message:message, preferredStyle:.alert)
        var propStr:NSString = text as NSString
        let textField: TextField.Config = { textField in
            textField.left(image: UIImage.init(named: "pen"), color: .black)
            textField.leftViewPadding = 12
            textField.becomeFirstResponder()
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.textColor = .black
            textField.placeholder = placehoder
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.returnKeyType = .done
            textField.text = text
            textField.action { textField in
                Log("textField = \(String(describing: textField.text))")
                propStr =  textField.text! as NSString
            }
        }
        alert.addOneTextField(configuration: textField)
        alert.addAction(title: "确定", style: .destructive){info in
            switch type{
            case 0:
               self.measur(prop:propStr)
            default:
               self.batchOperation(prop: propStr, optionType: type)
            }
            
        }
        alert.addAction(title: "取消", style: .cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: -批量计量
    func measur(prop:NSString) {
        if prop.length == 0 {
            SVProgressHUD.showInfo(withStatus:"请输入计量比例")
            return
        }
        var propFloat:Float =  Float(prop.floatValue)
        if propFloat >= 100 {
            propFloat = 100
        }
        var jsonArr = [NSMutableDictionary]()
        for model in batchArr{
            if model.status != "1" && model.status != "2"{
                 SVProgressHUD.showInfo(withStatus:"选中的\(model.intermediateCode ?? "")数据在已经申报或者流程已经结束，不能批量计量")
                return
            }
            if model.type == "1"{
                let allNum = model.allDesignNum!
                let lastNum = model.lastDesignNum!
                let numPrecision = model.numPrecision!
                model.thisPeriodNum =  Float(self.decimal(str:  String(format: "%.f", (allNum - lastNum) * (propFloat/100)), maxmum: numPrecision))
            }else if model.type == "2"{
                let allNum = model.allPerfectNum!
                let lastNum = model.lastPerfectNum!
                let numPrecision = model.numPrecision!
                model.thisPeriodNum =  Float(self.decimal(str:  String(format: "%.f", (allNum - lastNum) * (propFloat/100)), maxmum:numPrecision))
            }else if model.type == "3"{
                let allNum = model.allChangeNum!
                let lastNum = model.lastChangeNum!
                let numPrecision = model.numPrecision!
                model.thisPeriodNum =   Float(self.decimal(str:  String(format: "%.f", (allNum - lastNum) * (propFloat/100)), maxmum: numPrecision))
            }else if model.type == "4"{
                let allNum = model.allAbandonedNum!
                let lastNum = model.lastAbandonedNum!
                let numPrecision = model.numPrecision!
                model.thisPeriodNum =   Float(self.decimal(str:  String(format: "%.f", (allNum - lastNum) * (propFloat/100)), maxmum: numPrecision))
            }else if model.type == "5"{
                let allNum = model.allDamagedNum!
                let lastNum = model.lastDamagedNum!
                let numPrecision = model.numPrecision!
                model.thisPeriodNum =  Float( self.decimal(str:  String(format: "%.f", (allNum - lastNum) * (propFloat/100)), maxmum: numPrecision))
            }
//            model.approvalNum = model.thisPeriodNum!
            model.designChartNum = "2"
            model.pileNo = 1
            
            if let jsonData = try? JSONEncoder().encode(model) {
                if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                    let jsonDic:NSMutableDictionary = self.getDictionaryFromJSONString(jsonString: jsonString) as! NSMutableDictionary
                    jsonDic.removeObject(forKey: "isSelect")
                    jsonArr.append(jsonDic)
                }
            }
        }
        NetWorkRequest(.intermediateUpdate(Dict: ["dataStr":self.getJSONStringFromDictionary(arr: jsonArr)])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic.dictionary
            SVProgressHUD.showSuccess(withStatus:data!["msg"]?.string)
            self.loadNew()
        }
    }
    
    //MARK: -批量计量申报通过退回
    func batchOperation(prop:NSString,optionType:Int) {
        var jsonArr = [String]()
        for model in batchArr{
            switch optionType{
            case 1:
                if model.status != "1" && model.status != "2"{
                SVProgressHUD.showInfo(withStatus:"选中的\(model.intermediateCode ?? "")数据在已经申报或者流程已经结束，不能重复申报！")
                return
                }
                if model.approvalNum == 0{
                    SVProgressHUD.showInfo(withStatus:"选中的\(model.intermediateCode ?? "")的申报数量为空，不能申报！")
                    return
                }
            case 2:
                if model.status != "3" {
                    SVProgressHUD.showInfo(withStatus:"选中的\(model.intermediateCode ?? "")数据在草稿中，还未申报，不能审核！")
                    return
                }
            case 3:
                if model.status != "3" {
                    SVProgressHUD.showInfo(withStatus:"选中的\(model.intermediateCode ?? "")数据在草稿中或者已经审核通过，不能退回审核")
                    return
                }
            default:
            return
            }
            jsonArr.append(model.id!)
        }
        switch optionType{
        case 1,3:
//选人
//            NetWorkRequest(.submitApproval(Dict: ["bizKey":"intermediate_measurement","type" :"rejectTask","bizPk":jsonArr.joined(separator: ","),"comment":prop])) { (response) -> (Void) in
//                let jsonDic = JSON(parseJSON: response)
//                let data = jsonDic.dictionary
//                SVProgressHUD.showSuccess(withStatus:data!["msg"]?.string)
//                self.loadNew()
//            }
                let vc:PassVc = UIStoryboard(name: "Pass", bundle: nil).instantiateViewController(withIdentifier: "PassVc") as! PassVc
                vc.bizPk = jsonArr.joined(separator: ",")
                vc.type = OptionTypeConfig.back
                vc.parentType = type
                vc.isBatch = true
                self.navigationController?.pushViewController(vc, animated: true)
            
        case 2:
//不选人
//            NetWorkRequest(.backApproval(Dict: ["bizKey":"intermediate_measurement","type" :"completeTask","bizPk":jsonArr.joined(separator: ","),"comment":prop])) { (response) -> (Void) in
//                let jsonDic = JSON(parseJSON: response)
//                let data = jsonDic.dictionary
//                SVProgressHUD.showSuccess(withStatus:data!["msg"]?.string)
//                self.loadNew()
//            }
            let vc:PassVc = UIStoryboard(name: "Pass", bundle: nil).instantiateViewController(withIdentifier: "PassVc") as! PassVc
            vc.bizPk = jsonArr.joined(separator: ",")
            vc.type = OptionTypeConfig.pass
            vc.isBatch = true
            vc.parentType = type
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            return
        }
    }
    
    @IBAction func btnAction1(_ sender: Any) {
        //全部
        self.updateBtn(seleBtn: sender as! UIButton)
        self.status = ""
        self.needStatus = ""
        self.loadNew()
    }
    @IBAction func btnAction2(_ sender: Any) {
        //待审核
        self.updateBtn(seleBtn: sender as! UIButton)
        self.status = "3"
        self.needStatus = "1"
        self.loadNew()
    }
     
    
    @IBAction func btnAction3(_ sender: Any) {
        //待申报（申报员）”1“
        self.updateBtn(seleBtn: sender as! UIButton)
        self.status = "1"
        self.needStatus = ""
        self.loadNew()
    }
    @IBAction func btnAction4(_ sender: Any) {
        //退回
        self.updateBtn(seleBtn: sender as! UIButton)
        self.status = "2"
        self.needStatus = ""
        self.loadNew()
    }
    @IBAction func btnAction5(_ sender: Any) {
        //全部流转
        self.updateBtn(seleBtn: sender as! UIButton)
        self.status = "3"
        self.needStatus = "2"
        self.loadNew()
    }
    @IBAction func btnAction6(_ sender: Any) {
        //审批通过
        self.updateBtn(seleBtn: sender as! UIButton)
        self.status = "4"
        self.needStatus = ""
        self.loadNew()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func updateBtn(seleBtn:UIButton) {
        let btnArr:[UIButton] = [typeBtn1,typeBtn2,typeBtn3,typeBtn4,typeBtn5,typeBtn6]
        let colorArr:[UIColor] = [UIColor.red,UIColor.yellow,UIColor(red: 50/255.0, green: 235/255.0, blue: 247/255.0, alpha: 1.0),UIColor(red: 101/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1.0),UIColor(red: 210/255.0, green: 124/255.0, blue: 255/255.0, alpha: 1.0),UIColor.red]
        var count = 0
        for  btn in btnArr{
            if btn == seleBtn{
                dotV.frame = CGRect(x: btn.frame.size.width/2 - 4, y:btn.frame.size.height , width: 8, height: 8)
                dotV.backgroundColor = colorArr[count]
                dotV.layer.masksToBounds = true
                dotV.layer.cornerRadius = 4
                btn.addSubview(dotV)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                btn.titleLabel?.textColor = UIColor.black
                btn.setTitleColor( UIColor.black, for: .normal)
            }else{
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.setTitleColor( UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.0), for: .normal )
            }
            count += 1
        }
    }
    
    //MARK: -UITABLEVIEWDELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch type {
        case MenuTypeConfig.mediateList:
            return 158
        case MenuTypeConfig.thirdPayment:
            return 60
        case MenuTypeConfig.changeOrder:
            return 95
        case MenuTypeConfig.supvisPayment:
            return 84
        case MenuTypeConfig.pmtReport,MenuTypeConfig.totalPackage:
            return 84
        case MenuTypeConfig.supvisReport,MenuTypeConfig.mainlineTechnology,MenuTypeConfig.centralLaboratory,MenuTypeConfig.informationConstruction,MenuTypeConfig.auditUnit    ,MenuTypeConfig.thirdParty2
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
            return 84
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataArr.count == 0 {
            return UITableViewCell()
        }
        let model = dataArr[indexPath.row]
        switch type {
        case MenuTypeConfig.mediateList:
            let cell:MediateListCell  = tableView.dequeueReusableCell(withIdentifier: "MediateListCell", for: indexPath) as! MediateListCell
            cell.setup(withModel: model as! MediateModel)
            cell.btn1.tag = indexPath.row + 100
            cell.btn2.tag = indexPath.row + 200
            cell.btn3.tag = indexPath.row + 300
            cell.btn2.isHidden = needStatus == "2"
            cell.btn3.isHidden  = needStatus == "2"
            cell.dataArr = dataArr as! [MediateModel]
            return cell
        case MenuTypeConfig.thirdPayment:
            let cell:ThirdPaymentCell  = tableView.dequeueReusableCell(withIdentifier: "ThirdPaymentCell", for: indexPath) as! ThirdPaymentCell
            cell.setup(withModel: model as! PaymentModel)
            return cell
        case MenuTypeConfig.changeOrder:
            let cell:ChangeOrderCell  = tableView.dequeueReusableCell(withIdentifier: "ChangeOrderCell", for: indexPath) as! ChangeOrderCell
            cell.setup(withModel: model as! ChangeOrderModel)
            return cell
        case MenuTypeConfig.supvisPayment:
            let cell:SupvisPaymentCell  = tableView.dequeueReusableCell(withIdentifier: "SupvisPaymentCell", for: indexPath) as! SupvisPaymentCell
            cell.setup(withModel: model as! SupvisPaymentModel)
            return cell
        case MenuTypeConfig.pmtReport,MenuTypeConfig.totalPackage:
            let cell:ReportCell  = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            cell.setupPmt(withModel: model as! PmtReportModel)
            return cell
        case MenuTypeConfig.supvisReport:
            let cell:ReportCell  = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            cell.setup(withModel: model as! SupvisReportModel)
            return cell
        case MenuTypeConfig.mainlineTechnology,MenuTypeConfig.centralLaboratory,MenuTypeConfig.informationConstruction,MenuTypeConfig.auditUnit    ,MenuTypeConfig.thirdParty2
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
            let cell:ReportCell  = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            cell.setupServe(withModel: model as! ListServersModel)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        switch type {
        case MenuTypeConfig.mediateList:
            //选中效果
            let mediModel:MediateModel = model as! MediateModel
            mediModel.isSelect = !mediModel.isSelect!
            let cell:MediateListCell = tableView.cellForRow(at: indexPath) as! MediateListCell
            cell.selectImg.isHidden =  !mediModel.isSelect!
            //选中数据更新
            let hasModel = batchArr.contains { (media) -> Bool in
                if case mediModel.id = media.id {
                    return true
                }
                return false
            }
            if !hasModel{
                batchArr.append(mediModel)
            }else{
                batchArr.remove(mediModel)
            }
            tagNumLb.text = "共\(total)条/选中\(batchArr.count)条"
        case MenuTypeConfig.thirdPayment:
            if let jsonData = try? JSONEncoder().encode(model as! PaymentModel) {
                if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                    let infoDic =  self.getDictionaryFromJSONString(jsonString:jsonString)
                    let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
                    detailVc.info = infoDic
                    detailVc.type = MenuTypeConfig.thirdPayment
                    self.navigationController?.pushViewController(detailVc, animated: true)
                    
                }
            }
        case MenuTypeConfig.changeOrder:
            if let jsonData = try? JSONEncoder().encode(model as! ChangeOrderModel) {
                if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                    let infoDic =  self.getDictionaryFromJSONString(jsonString:jsonString)
                    let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
                    detailVc.info = infoDic
                    detailVc.type = MenuTypeConfig.changeOrder
                    self.navigationController?.pushViewController(detailVc, animated: true)
                   
                }
            }
        case MenuTypeConfig.supvisPayment:
            if let jsonData = try? JSONEncoder().encode(model as! SupvisPaymentModel) {
                if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                    let infoDic =  self.getDictionaryFromJSONString(jsonString:jsonString)
                    let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
                    detailVc.info = infoDic
                    detailVc.type = MenuTypeConfig.supvisPayment
                    self.navigationController?.pushViewController(detailVc, animated: true)
                    
                }
            }
        case MenuTypeConfig.pmtReport,MenuTypeConfig.totalPackage:
            if let jsonData = try? JSONEncoder().encode(model as! PmtReportModel) {
                if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                    let infoDic =  self.getDictionaryFromJSONString(jsonString:jsonString)
                    let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
                    detailVc.info = infoDic
                    detailVc.type = type
                    self.navigationController?.pushViewController(detailVc, animated: true)
                }
            }
        case MenuTypeConfig.supvisReport:
            if let jsonData = try? JSONEncoder().encode(model as! SupvisReportModel) {
                if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                    let infoDic =  self.getDictionaryFromJSONString(jsonString:jsonString)
                    let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
                    detailVc.info = infoDic
                    detailVc.type = MenuTypeConfig.supvisReport
                    self.navigationController?.pushViewController(detailVc, animated: true)
                }
            }
        case MenuTypeConfig.centralLaboratory,MenuTypeConfig.mainlineTechnology,MenuTypeConfig.informationConstruction,MenuTypeConfig.auditUnit    ,MenuTypeConfig.thirdParty2
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
            if let jsonData = try? JSONEncoder().encode(model as! ListServersModel) {
                if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                    let infoDic =  self.getDictionaryFromJSONString(jsonString:jsonString)
                    let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
                    detailVc.info = infoDic
                    detailVc.type = type
                    self.navigationController?.pushViewController(detailVc, animated: true)
                }
            }
        default:
            break
        }
    }
    
    
    //json转字典
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    
    // 字典转json
    func getJSONStringFromDictionary(arr:Array<Any>) -> String {
        if (!JSONSerialization.isValidJSONObject(arr)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: arr, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    //截取小数点后的位数
    func decimal(str:String,maxmum:Int) -> String {
        let nums:NSNumber = NSNumber(value:(str as NSString).floatValue)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = maxmum
        formatter.groupingSeparator = ""
        return formatter.string(from: nums) ?? ""
    }
    
    //数组转jsonStr
    func jsonStrByArr(arr:Array<MediateModel>) -> String {
        if let jsonData = try? JSONEncoder().encode(arr) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            }
        }
        return ""
    }
    
    //MARK: 初始化侧边栏
    func initSideView() {
        /* 创建一个阴影 */
        backColorView.backgroundColor = UIColor.black
        backColorView.alpha = 0
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(closeTap))
        backColorView.addGestureRecognizer(tapG)
        view.addSubview(backColorView)
        
        
        
        /* 创建第二页对象 */
        let sb = UIStoryboard(name:"LeftScreen", bundle: nil)
        conditionController = sb.instantiateViewController(withIdentifier: "LeftScreenVc") as? LeftScreenVc
        conditionController?.proType = self.proType as String
        if type ==  MenuTypeConfig.mediateList{
            conditionController!.isMedia = false
        }
        conditionController!.callBack = {
            self.closeTap()
        }
        conditionController!.view.frame = CGRect(x: screen_w, y: status_bar_h + nav_bar_h, width: screen_w - 50, height: screen_h - status_bar_h - nav_bar_h)
        addChild(conditionController!)
        view.addSubview(conditionController!.view)
    }
    
    @objc func closeTap() {
        self.loadNew()
        /* 关闭操作,先动画后移除 */
        UIView.animate(withDuration: 0.5) {
            self.backColorView.alpha = 0;
            self.conditionController?.view.frame = CGRect(x: screen_w, y: status_bar_h + nav_bar_h, width: screen_w - 50, height: screen_h - status_bar_h - nav_bar_h)
        }
    }
    
    func tapCondition() {
        view.bringSubviewToFront(backColorView)
        view.bringSubviewToFront(conditionController!.view)
        /* 出现的动画 */
        UIView.animate(withDuration: 0.5) {
            self.backColorView.alpha = 0.3;
            self.conditionController?.view.frame = CGRect(x: 50, y: status_bar_h + nav_bar_h, width: screen_w - 50, height: screen_h - status_bar_h - nav_bar_h)
        }
    }
}


