//
//  WorkBenchVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/20.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh

class WorkBenchVc: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating {
    
    @IBOutlet weak var flowTab: UITableView!
    var page:NSInteger = 1
    var dataArr:NSMutableArray = NSMutableArray()
    @IBOutlet weak var titleScroll: UIScrollView!
    @IBOutlet weak var typeBtn1: UIButton!
    @IBOutlet weak var typeBtn2: UIButton!
    @IBOutlet weak var typeBtn3: UIButton!
    @IBOutlet weak var typeBtn4: UIButton!
    @IBOutlet weak var typeBtn5: UIButton!
    @IBOutlet weak var typeBtn6: UIButton!
    //Search
    var countrySearchController = UISearchController()
    var searchArray:[WorkModel] = [WorkModel](){
        didSet  {self.flowTab.reloadData()}
    }
    let typeArr = ["","intermediate_measurement","measure_report","change_plus","metaphase_pay_certificate","third_party_payment"]
    var dotV = UIView()
    var bizKey:String = ""
    var screenedArr:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        self.loadNew()
        
    }
    
    override func viewDidLayoutSubviews() {
        //        var rect = countrySearchController.searchBar.frame
        //        rect.size.width =  screen_w - 200
        //        let  field:UITextField = countrySearchController.searchBar.value(forKey:"searchBarTextField") as! UITextField
        //        field.frame = rect
    }
    
    
    //MARK -- INIT
    func initUI() {
        self.flowTab.delegate = self
        self.flowTab.dataSource = self
        self.flowTab.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.flowTab.mj_header = MJRefreshNormalHeader()
        self.flowTab.mj_header?.setRefreshingTarget(self, refreshingAction: #selector(loadNew))
        self.flowTab.mj_footer = MJRefreshAutoNormalFooter()
        self.flowTab.mj_footer?.setRefreshingTarget(self, refreshingAction: #selector(loadMore))
        
        //SearchCon
        self.countrySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            controller.searchBar.barStyle = .default
            controller.delegate = self
            self.definesPresentationContext = true
            return controller
        })()
        
        let navH = !UIDevice().isX() ? 20 : 44
        let searchBarFrame = CGRect(x: 90, y:navH + 8, width: Int(screen_w - 100), height: 44)
        let searchBarContainer = UIView(frame: searchBarFrame)
        var rect = countrySearchController.searchBar.frame
        rect.size.width =  screen_w - 100
        countrySearchController.searchBar.frame = rect
        searchBarContainer.addSubview(countrySearchController.searchBar)
        countrySearchController.searchBar.sizeToFit()
        self.view.addSubview(searchBarContainer)
        titleScroll.showsHorizontalScrollIndicator = false
        self.updateBtn(seleBtn: typeBtn1)
        self.setTabHead()
    }
    func setTabHead() {
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: screen_w, height: 30))
        flowTab.tableHeaderView = headView
        
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect(x: screen_w - 38, y: 0, width: 30, height: 30)
        btn.setImage(UIImage.init(named: "ic_screening"), for: .normal)
        //        btn.setTitle("类型", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(screenMenu), for: .touchUpInside)
        headView.addSubview(btn)
    }
    
    @objc func screenMenu() {
        let items: [String] = ["全部","待申报","退回","流转中","审批通过"]
        NavigationMenuShared.showPopMenuSelecteWithFrameWidth(width: itemWidth, height: 180, point: CGPoint(x: ScreenInfo.Width - 30, y:110), item: items, imgSource: []) { (index) in
            switch index{
            case 0:
                self.dataArr = self.screenedArr
                self.flowTab.reloadData()
            default:
                self.screenData(type: "\(index)")
                break
            }
        }
    }
    
    func screenData(type:String) {
        let scrArr = NSMutableArray()
        for model in screenedArr {
            let wkModel:WorkModel = model as! WorkModel
            if wkModel.flowStatus == type{
                scrArr.add(wkModel)
            }
        }
        self.dataArr = scrArr
        self.flowTab.reloadData()
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        self.updateBtn(seleBtn: sender)
        self.bizKey = self.typeArr[sender.tag - 300]
        self.loadNew()
    }
    func updateBtn(seleBtn:UIButton) {
        let btnArr:[UIButton] = [typeBtn1,typeBtn2,typeBtn3,typeBtn4,typeBtn5,typeBtn6]
        let colorArr:[UIColor] = [UIColor.red,UIColor.yellow,UIColor(red: 50/255.0, green: 235/255.0, blue: 247/255.0, alpha: 1.0),UIColor(red: 101/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1.0),UIColor(red: 210/255.0, green: 124/255.0, blue: 255/255.0, alpha: 1.0),UIColor.orange]
        var count = 0
        for  btn in btnArr{
            if btn == seleBtn{
                dotV.frame = CGRect(x: btn.frame.size.width/2 - 4, y:btn.frame.size.height, width: 8, height: 8)
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
    
    @objc func loadNew() {
        page = 1
        NetWorkRequest(.flowList(Dict:self.loadParam() as! [String : Any])){ (response) -> (Void) in
            self.dataArr.removeAllObjects()
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic["rows"].array
            for dataDic in data ?? Array() {
                let model = WorkModel(jsonData: dataDic)
                self.dataArr.add(model)
            }
            self.screenedArr = self.dataArr
            self.flowTab.mj_header?.endRefreshing()
            self.flowTab.reloadData()
        }
    }
    
    @objc func loadMore() {
        page += 1
        NetWorkRequest(.flowList(Dict:self.loadParam() as! [String : Any])){ (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic["rows"].array
            for dataDic in data ?? Array() {
                let model = WorkModel(jsonData: dataDic)
                self.dataArr.add(model)
            }
            self.screenedArr = self.dataArr
            self.flowTab.mj_footer?.endRefreshing()
            self.flowTab.reloadData()
        }
    }
    
    func loadParam() -> (NSDictionary) {
        let param = NSMutableDictionary()
        param.setValue(self.bizKey, forKey: "bizKey")
        param.setValue("", forKey: "startTime")
        param.setValue("", forKey: "endTime")
        param.setValue("", forKey: "title")
        param.setValue("", forKey: "drafter")
        param.setValue("", forKey: "bizTitle")
        param.setValue("\(page)", forKey: "page")
        param.setValue("15", forKey: "rows")
        return param
    }
    
    
    //MARK -- DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.countrySearchController.isActive {
            return self.searchArray.count
        } else {
            return self.dataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:WorkTabCell = tableView.dequeueReusableCell(withIdentifier: "WorkTabCell", for: indexPath) as! WorkTabCell
        let model:WorkModel
        if self.countrySearchController.isActive {
            model = self.searchArray[indexPath.row]
        }else{
            model = self.dataArr[indexPath.row] as! WorkModel
        }
        cell.titleLb.text = model.title
        cell.headLb.text = model.drafterName
        cell.creatTimeLb.text = "\(model.createTime ?? "")  \( model.bizTypeName ?? "")"
        cell.statusLb.text = model.flowStatusName
        if model.flowStatusName == "草稿" {
            cell.statusLb.backgroundColor = UIColor.init(red: 54/255.0, green: 54/255.0, blue: 54/255.0, alpha: 1.0)
        }else if  model.flowStatusName == "退回" {
            cell.statusLb.backgroundColor = UIColor.init(red: 255/255.0, green: 71/255.0, blue: 81/255.0, alpha: 1.0)
        }else if  model.flowStatusName ==  "审批通过"{
            cell.statusLb.backgroundColor = UIColor.init(red: 0/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1.0)
        }else{
            cell.statusLb.backgroundColor = UIColor.init(red: 92/255.0, green: 192/255.0, blue: 156/255.0, alpha: 1.0)
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:WorkModel
        if self.countrySearchController.isActive {
            model = self.searchArray[indexPath.row]
        }else{
            model = self.dataArr[indexPath.row] as! WorkModel
        }
        switch model.bizType {
        case "intermediate_measurement":
            //中间计量单
            self.pushDetail(type: MenuTypeConfig.mediateList, model: model)
        case "measure_report":
            //监理计量报表
            self.pushDetail(type: MenuTypeConfig.pmtReport, model: model)
        case "change_plus":
            //变更令
            self.pushDetail(type: MenuTypeConfig.changeOrder, model: model)
//        case "metaphase_pay_certificate":
//            //中期支付证书
        case "third_party_payment":
            //第三方支付
            self.pushDetail(type: MenuTypeConfig.thirdPayment, model: model)
        default:
            self.pushDetail(type: MenuTypeConfig.workBench, model: model)
        }
        countrySearchController.isActive = false
        
    }
    
    func pushDetail(type:MenuTypeConfig,model:WorkModel){
        if let jsonData = try? JSONEncoder().encode(model ) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                let infoDic =  self.getDictionaryFromJSONString(jsonString:jsonString)
                let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
                detailVc.info = infoDic
                detailVc.type = type
                detailVc.isWorkBen = true
                self.navigationController?.pushViewController(detailVc, animated: true)
            }
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
    
    //实时进行搜索
    func updateSearchResults(for searchController: UISearchController) {
        var rect = countrySearchController.searchBar.frame
        rect.size.width =  screen_w - 100
        countrySearchController.searchBar.frame = rect
        self.searchArray = self.dataArr.filter { (value) -> Bool in
            let model:WorkModel = value as! WorkModel
            return model.title?.contains(searchController.searchBar.text!) ?? false
            } as! [WorkModel]
    }
    
    //点击搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchArray = self.dataArr.filter { (value) -> Bool in
            let model:WorkModel = value as! WorkModel
            return (model.title?.contains(searchBar.text!))!
            } as! [WorkModel]
    }
    //点击取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchArray = self.dataArr as! [WorkModel]
    }
    func didPresentSearchController(_ searchController: UISearchController) {
        let  field:UITextField = countrySearchController.searchBar.value(forKey:"_searchField") as! UITextField
        var rect = field.frame
        rect.size.width =  screen_w - 160
        field.frame = rect
        
        
        let btn =  countrySearchController.searchBar.value(forKey:"_cancelButton") as! UIButton
        btn .setTitle("取消", for: .normal)
        var rect1 = btn.frame
        rect1.origin.x =  screen_w - 145
        btn.frame = rect1
        self.searchArray = self.dataArr as! [WorkModel]
    }
    func didDismissSearchController(_ searchController: UISearchController) {
        var rect = countrySearchController.searchBar.frame
        rect.size.width =  screen_w - 100
        countrySearchController.searchBar.frame = rect
    }
    
}
