//
//  MineVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/20.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class MineVc: UIViewController {
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var departLb: UILabel!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var helperView: UIView!
    @IBOutlet weak var prjBtn: UIButton!
    @IBOutlet weak var secBtn: UIButton!
    
    var prjArr = NSMutableArray()
    var selePrj = 0
    var seleSec = 0
    var secArr:[SectModel] = [] {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSecArr"), object: nil)
        }
    }
    
    var selePrjId = ""
    var seleSecId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadDataArr()
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(self.selePrjId, forKey: ScrInfo().projectId)
        UserDefaults.standard.set(self.seleSecId, forKey: ScrInfo().sectId)
    }
    
    //MARK: - 加载数据及UI
    func setupUI() {
        
        headImg.layer.masksToBounds = true
        headImg.layer.cornerRadius = 25
        nameLb.text = UserDefaults.standard.object(forKey: "name") as? String
        departLb.text = UserDefaults.standard.object(forKey: "orgName") as? String
        exitBtn.layer.masksToBounds = true
        exitBtn.layer.cornerRadius = 5
        
        self.shareView.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(option1))
        tap1.numberOfTapsRequired = 1
        self.shareView.addGestureRecognizer(tap1)
        
        self.settingView.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(option2))
        tap2.numberOfTapsRequired = 1
        self.settingView.addGestureRecognizer(tap2)
        
        self.helperView.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(option3))
        tap3.numberOfTapsRequired = 1
        self.helperView.addGestureRecognizer(tap3)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(secComplete(notification:)),
                                               name: NSNotification.Name(rawValue: "loadSecArr"), object: nil)
        
    }
    
    func loadDataArr() {
        self.selePrjId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
        self.seleSecId = UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? ""
        NetWorkRequest(.prjList){ (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic.array
            if data == nil{
                return
            }
            for (index,dataDic)  in data!.enumerated() {
                let model = PrjModel(jsonData: dataDic)
                //默认项目ID
                if model.prjid ==  self.selePrjId {
                    self.selePrj = Int(index)
                    self.prjBtn.setTitle(model.prjName, for: .normal)
                }
                self.prjArr.add(model)
            }
            if self.selePrjId.count == 0{
                let model:PrjModel = self.prjArr[0] as! PrjModel
                self.selePrjId = model.prjid!
                self.prjBtn.setTitle(model.prjName, for: .normal)
            }
            self.loadSecArr()
        }
    }
    
    func loadSecArr() {
        let model:PrjModel = self.prjArr[selePrj] as!PrjModel
        self.selePrjId = model.prjid!
        NetWorkRequest(.sectionList(Dict: ["prjid":model.prjid!]) ){ (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic.array
            var dataArr = [SectModel]()
            for (index,dataDic)  in data!.enumerated() {
                let model = SectModel(jsonData: dataDic)
                //默认标段ID
                if model.sectionId ==  self.seleSecId {
                    self.seleSec = Int(index)
                    self.secBtn.setTitle(model.sectionName, for: .normal)
                }
                dataArr.append(model)
            }
            self.secArr = dataArr
        }
    }
    
    func secAlert() {
        if self.secArr.count == 0 {
            self.secBtn.setTitle("", for: .normal)
            return
        }
        let alert = UIAlertController(title: "选择标段", message: "", preferredStyle: .alert)
        let pickerViewValues = NSMutableArray()
        for value in self.secArr{
            let model:SectModel = value
            pickerViewValues.add(model.sectionName!)
        }
        let pickerViewValues1: [[String]] = [pickerViewValues] as! [[String]]
        //默认选中
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: self.seleSec)
        alert.addPickerView(values: pickerViewValues1, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.seleSec = index.row
        }
        alert.addAction(title: "确定", style: .cancel){info in
            let model:SectModel = self.secArr[self.seleSec]
            self.secBtn.setTitle(model.sectionName, for: .normal)
            if self.seleSecId != model.sectionId{
                self.seleSecId = model.sectionId!
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - 按钮事件
    @IBAction func choosePrj(_ sender: Button) {
        if self.prjArr.count == 0 {
            return
        }
        let alert = UIAlertController(title: "选择项目", message: "", preferredStyle: .alert)
        let pickerViewValues = NSMutableArray()
        for value in self.prjArr{
            let model:PrjModel = value as! PrjModel
            pickerViewValues.add(model.prjName!)
        }
        let pickerViewValues1: [[String]] = [pickerViewValues] as! [[String]]
        //默认选中
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: self.selePrj)
        alert.addPickerView(values: pickerViewValues1, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            self.selePrj = index.row
        }
        alert.addAction(title: "确定", style: .cancel){info in
            let model:PrjModel = self.prjArr[self.selePrj] as! PrjModel
            sender.setTitle(model.prjName, for: .normal)
            self.loadSecArr()
            if self.selePrjId != model.prjid{
                self.selePrjId = model.prjid!
                self.seleSecId = ""
                self.seleSec = 0
            }
        }
        self.present(alert, animated: true, completion: nil)
    }

    //MARK: 选择标段
    @IBAction func chooseSec(_ sender: Any) {
        self.secAlert()
    }
    
    //MARK: 注销
    @IBAction func logout(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - 个人选项
    @objc func option1() {
        //FIXME: 分享功能
        SVProgressHUD.showInfo(withStatus: "敬请期待")
    }
    
    @objc func option2() {
        //FIXME: 设置
        SVProgressHUD.showInfo(withStatus: "敬请期待")
    }
    
    @objc func option3() {
        //FIXME: 帮助中心
        SVProgressHUD.showInfo(withStatus: "敬请期待")
    }
    
    @objc func secComplete(notification: Notification) {
        if self.secArr.count > 0 {
            let model:SectModel = self.secArr[self.seleSec]
            self.secBtn.setTitle(model.sectionName, for: .normal)
            if self.seleSecId.count == 0{
                self.seleSecId = model.sectionId ?? ""
            }
        }else{
            self.secBtn.setTitle("", for: .normal)
        }  
    }
    
}
