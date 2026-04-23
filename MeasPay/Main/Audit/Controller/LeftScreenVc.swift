//
//  LeftScreenVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/26.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class LeftScreenVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var prjView: UIView!
    @IBOutlet weak var sectView: UIView!
    @IBOutlet weak var periodView: UIView!
    @IBOutlet weak var prjLb: UILabel!
    @IBOutlet weak var sectLb: UILabel!
    @IBOutlet weak var periodLb: UILabel!
    @IBOutlet weak var partialTable: UITableView!
    @IBOutlet weak var tableRight: NSLayoutConstraint!
    
    var pathView: UIScrollView!
    
    var prjArr = NSMutableArray()
    var titleArr = NSMutableArray()
    var dataArr = NSMutableArray()
    var childrenArr = NSMutableArray()
    
    var selePrj = 0
    var seleSec = 0
    var selePer = 0
    
    var selePrjId = ""
    var seleSecId = ""
    var selePerId = ""
    var isMedia = false
    
    var proType:String = ""
    
    var callBack: (() -> ())?
    
    var secArr:[ProjectInfo] = [] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "screenSecArr"), object: nil)
        }
    }
    var perArr:[PeriodModel] = [] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "screenPerArr"), object: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.loadDataArr()
    }
    
    //MARK: -网络请求
    func loadDataArr() {
        self.selePrjId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
        self.seleSecId = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
        self.selePerId = UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""
        UserDefaults.standard.set("", forKey: ScrInfo().meteragePartCode)
        
        self.prjArr = UserAgent.default().projectInfos
        for (index, temp) in self.prjArr.enumerated() {
            let model = temp as! ProjectInfo
            if model.id == self.selePrjId {
                self.selePrj = Int(index)
                self.prjLb.text = model.text
            }
        }

        if self.selePrjId.count == 0{
            let model:ProjectInfo = self.prjArr[0] as! ProjectInfo
            self.selePrjId = model.id
            self.prjLb.text = model.text
        }
        self.loadSecArr()
    }
    func loadSecArr() {
        let model:ProjectInfo = self.prjArr[selePrj] as!ProjectInfo
        self.selePrjId = model.id
        //按权限过滤
        if(self.proType.count > 0){
            let list = NSMutableArray()
            for ix in model.children {
                if( !(ix.otherInfo["sectMajor"] is NSNull) && self.proType.range(of:ix.otherInfo["sectMajor"] as! String) != nil) {
                        list.add(ix)
                    }
            }
            self.secArr = list as! [ProjectInfo]
        }else{
            self.secArr = model.children
        }
        
        for (index,model) in self.secArr.enumerated() {
            //默认标段ID
            if model.id ==  self.seleSecId {
                self.seleSec = Int(index)
                self.sectLb.text = model.text
            }
        }
        
        if seleSecId.count == 0{
            let model:ProjectInfo = self.secArr[0]
            self.seleSec = 0
            self.seleSecId = model.id
            self.sectLb.text = model.text
        }
        
        self.loadPeriodArr()
    }
    
    func loadPeriodArr() {
        //重新加载分部分项
        self.dataArr.removeAllObjects()
        self.titleArr.removeAllObjects()
        self.childrenArr.removeAllObjects()
        self.loadTree(id:"-9999",meteragePartCode: "", periodId: "", sectName: "目录",childern:[])
        
        if self.secArr.count == 0 {
            self.periodLb.text = ""
            self.selePerId = ""
            return
        }
        let model:ProjectInfo = self.prjArr[selePrj] as! ProjectInfo
        let modelSec:ProjectInfo = self.secArr[seleSec]
        self.seleSecId = modelSec.id
        NetWorkRequest(.periodList(Dict: ["projectId":model.id ?? "","sectId":modelSec.id ?? ""]) ){ (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic.array
            var dataArr = [PeriodModel]()
            for (index,dataDic) in data!.enumerated() {
                let model = PeriodModel(jsonData: dataDic)
                //默认
                if model.id ==  self.selePerId {
                    self.selePer = Int(index)
                    self.periodLb.text = model.periodNum
                }
                dataArr.append(model)
            }
            self.perArr = dataArr
            
            UserDefaults.standard.set(self.selePrjId, forKey: ScrInfo().projectId)
            UserDefaults.standard.set(self.seleSecId, forKey: ScrInfo().sectId)
            UserDefaults.standard.set(self.selePerId, forKey: ScrInfo().periodId)
            UserDefaults.standard.synchronize()
            
            
            
        }
        //更新选中的项目信息
        NetWorkRequest(.setProjectInfo(Dict: ["typeKey":model.attributes["key"] ?? "",
                                                "projectId":model.id ?? "" ,
                "mainPrjName":model.text ?? "" ,
                "mainPrjCode":model.otherInfo["projectCode"] ?? "" ,
                "projectPlanSn":model.otherInfo["projectPlanSn"] ?? "" ,
                "mainSectionId":modelSec.id ?? "" ,
                "mainSectionName":modelSec.text,
//                "mainSectionCode":modelSec.otherInfo["sectCode"] ?? "" ,
//                "stdVersion":modelSec.otherInfo["stdVersion"] ?? "" ,
//                "sectionMajor":modelSec.otherInfo["sectMajor"] ?? "",
        ])) { (response) -> (Void) in
        }
    }
    func loadTree(id:NSString, meteragePartCode:NSString, periodId:NSString, sectName:NSString, childern:Array<Any>) {
        if(!isMedia) {
            return
        }
        NetWorkRequest(.getTree(Dict: ["id":"\(id)","type":"3","meteragePartCode":"\(meteragePartCode)","periodId":"\(periodId)"]) ){ (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic.array
            let jsonArr = NSMutableArray()
            //子项
            for model in childern {
                jsonArr.add(model)
            }
            
//            if data?.count > 0 {
                self.titleArr.add(sectName)
                self.setPathScrollView()
//            }else{
//
//            }
            for dataDic in data! {
                let model = TreeModel(jsonData: dataDic)
                self.childrenArr = NSMutableArray.init(array:model.children!)
                jsonArr.add(model)
            }
            
            self.dataArr.add(jsonArr)
            self.partialTable.reloadData()
        }
    }
    
    
    //MARK: -标段&&期数加载完毕
    @objc func secComplete(notification: Notification) {
        if self.seleSecId.count != 0{
            return
        }
        self.seleSec = 0
        if self.secArr.count > 0 {
            let model:ProjectInfo = self.secArr[self.seleSec]
            self.sectLb.text = model.text
            self.seleSecId = model.id
        }else{
            self.sectLb.text = ""
            self.seleSecId = ""
        }
    }
    
    @objc func perComplete(notification: Notification) {
        if self.selePerId.count != 0{
            return
        }
        self.selePer = 0
        if self.perArr.count > 0 {
            let model:PeriodModel = self.perArr[self.selePer]
            self.periodLb.text = model.periodNum
            self.selePerId = model.id!
        }else{
            self.periodLb.text = ""
            self.selePerId = ""
        }
    }
    
    
    //MARK: -UI加载
    func initUI(){
        self.prjView.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action:#selector(tapAction1))
        tap1.numberOfTapsRequired = 1
        self.prjView.addGestureRecognizer(tap1)
        
        self.sectView.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action:#selector(tapAction2))
        tap2.numberOfTapsRequired = 1
        self.sectView.addGestureRecognizer(tap2)
        
        self.periodView.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action:#selector(tapAction3))
        tap3.numberOfTapsRequired = 1
        self.periodView.addGestureRecognizer(tap3)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(secComplete(notification:)),
                                               name: NSNotification.Name(rawValue: "screenSecArr"), object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(perComplete(notification:)),
                                               name: NSNotification.Name(rawValue: "screenPerArr"), object: nil)
        
        if !isMedia {
            self.partialTable.isHidden = true
            return
        }
        self.partialTable.delegate = self
        self.partialTable.dataSource = self
        self.partialTable.rowHeight = UITableView.automaticDimension
        self.partialTable.estimatedRowHeight = 120
    }
    
    //路径设置
    func setPathScrollView() {
        if self.pathView != nil {
            self.pathView.removeFromSuperview()
        }
        let array = NSMutableArray()
        for (index,title) in titleArr.enumerated(){
            if index == 0{
                array.add(title)
            }else{
                array.add(" > \(title)")
            }
        }
        
        let height = 40
        var widthSum = 0
        self.pathView = UIScrollView(frame:CGRect(x: 10, y: 200, width:Int(view.frame.size.width), height: height))
        
        for (index,title) in array.enumerated() {
            let string:NSString = title as! NSString
            let size: CGSize = string.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)])
            
            let width = Int(size.width)
            let button = UIButton.init(frame:CGRect(x: widthSum, y: 0, width: Int(width), height: height))
            button.tag = 100 + index
            button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
            button.addTarget(self, action: #selector(popBeforePath(button:)), for: .touchUpInside)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitle(title as? String, for: .normal)
            widthSum += width
            self.pathView.addSubview(button)
        }
        self.pathView.contentSize = CGSize(width: widthSum + 130, height: 0)
        self.pathView.showsHorizontalScrollIndicator = false
        self.pathView.isScrollEnabled = true
        if widthSum > Int(self.pathView.size.width) {
            let bottomOffset = CGPoint(x: self.pathView.contentSize.width - self.pathView.bounds.size.width, y: 0)
            self.pathView.setContentOffset(bottomOffset, animated: true)
        }
        self.view.addSubview(pathView)
        
    }
    
    @objc func popBeforePath(button:UIButton) {
        self.titleArr.removeObjects(in: NSRange(location: button.tag-100 + 1, length: self.titleArr.count - button.tag + 100 - 1))
        self.dataArr.removeObjects(in: NSRange(location: button.tag-100 + 1, length: self.dataArr.count - button.tag + 100 - 1))
        self.partialTable.reloadData()
        self.setPathScrollView()
    }
    
    @objc func tapAction1() {
        self.prjAlert()
    }
    @objc func tapAction2() {
        self.secAlert()
    }
    @objc func tapAction3() {
        self.perAlert()
    }
    
    
    //MARK: -选取筛选条件Alert
    func prjAlert() {
        if self.prjArr.count == 0 {
            return
        }
        let alert = UIAlertController(title: "选择项目", message: "", preferredStyle: .alert)
        let pickerViewValues = NSMutableArray()
        for value in self.prjArr{
            let model:ProjectInfo = value as! ProjectInfo
            pickerViewValues.add(model.text!)
        }
        let pickerViewValues1: [[String]] = [pickerViewValues] as! [[String]]
        //默认选中
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: self.selePrj)
        alert.addPickerView(values: pickerViewValues1, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.selePrj = index.row
        }
        alert.addAction(title: "确定", style: .cancel){info in
            let model:ProjectInfo = self.prjArr[self.selePrj] as! ProjectInfo
            self.prjLb.text =  model.text
            if self.selePrjId != model.id{
                self.selePrjId = model.id!
                self.seleSecId = ""
                self.seleSec = 0
                self.selePerId = ""
                self.selePer = 0
            }
            
            self.loadSecArr()
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func secAlert() {
        if self.secArr.count == 0 {
            self.sectLb.text =  ""
            self.selePerId =  ""
            return
        }
        let alert = UIAlertController(title: "选择项目", message: "", preferredStyle: .alert)
        let pickerViewValues = NSMutableArray()
        for value in self.secArr{
            let model:ProjectInfo = value
            pickerViewValues.add(model.text!)
        }
        let pickerViewValues1: [[String]] = [pickerViewValues] as! [[String]]
        //默认选中
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: self.seleSec)
        alert.addPickerView(values: pickerViewValues1, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.seleSec = index.row
        }
        alert.addAction(title: "确定", style: .cancel){info in
            let model:ProjectInfo = self.secArr[self.seleSec]
            self.sectLb.text = model.text
            if self.seleSecId != model.id{
                self.seleSecId = model.id
                self.selePerId = ""
                self.selePer = 0
            }
            
            self.loadPeriodArr()
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func perAlert() {
        if self.perArr.count == 0 {
            self.periodLb.text =  ""
            return
        }
        let alert = UIAlertController(title: "选择期数", message: "", preferredStyle: .alert)
        let pickerViewValues = NSMutableArray()
        for value in self.perArr{
            let model:PeriodModel = value
            pickerViewValues.add(model.periodNum!)
        }
        let pickerViewValues1: [[String]] = [pickerViewValues] as! [[String]]
        //默认选中
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: self.selePer)
        alert.addPickerView(values: pickerViewValues1, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.selePer = index.row
        }
        alert.addAction(title: "确定", style: .cancel){info in
            let model:PeriodModel = self.perArr[self.selePer]
            self.selePerId = model.id!
            self.periodLb.text = model.periodNum
            
            UserDefaults.standard.set(self.selePerId, forKey: ScrInfo().periodId)
            UserDefaults.standard.synchronize()
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - UITABLEVIEWDELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArr.count > 0{
            let arr:NSArray = self.dataArr.lastObject as! NSArray
            return arr.count
        }else{
            return self.dataArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr:NSArray = self.dataArr.lastObject as! NSArray
        let model = arr[indexPath.row]
        let cell:TreeTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "TreeTableViewCell", for: indexPath) as! TreeTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if model is TreeModel{
            cell.setup(withTitle: (model as! TreeModel).text!)
            cell.typeImg.image = UIImage(named: "ic_parttern_icon_folder")
            cell.chooseBtn.isHidden = false
            cell.titleLbLeft.constant = 10
        }else{
            cell.setup(withTitle: "\((model as! TreeChildModel).code!)\((model as! TreeChildModel).name!)")
            cell.typeImg.image = UIImage(named: "ic_parttern_icon_nofind")
            cell.chooseBtn.isHidden = true
            cell.titleLbLeft.constant = -50
        }
        cell.chooseBtn.tag = indexPath.row + 200
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let periodId:NSString
        if self.perArr.count > 0 {
            let perModel:PeriodModel = self.perArr[self.selePer]
            periodId = perModel.id! as NSString
        }else{
            periodId = ""
        }
        
        if periodId.length == 0 {
            return
        }
        
        let arr:NSArray = self.dataArr.lastObject as! NSArray
        let model = arr[indexPath.row]
        if model is TreeModel{
            loadTree(id: (model as! TreeModel).id! as NSString, meteragePartCode:  (model as! TreeModel).code! as NSString, periodId:periodId, sectName: (model as! TreeModel).text! as NSString, childern: (model as! TreeModel).children!)
        }else{
            UserDefaults.standard.set((model as! TreeChildModel).code!, forKey: ScrInfo().meteragePartCode)
            DispatchQueue.main.async(execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        
        
    }
    @IBAction func choose(_ sender: UIButton) {
        let arr:NSArray = self.dataArr.lastObject as! NSArray
        let model = arr[sender.tag - 200]
        if model is TreeModel{
            UserDefaults.standard.set((model as! TreeModel).code!, forKey: ScrInfo().meteragePartCode)
            UserDefaults.standard.synchronize()
            callBack?()
        }else{
            
        }
        
    }
}


