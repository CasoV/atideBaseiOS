//
//  ReorderVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/30.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ReorderVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var dataArr:Array<ReorderModel> = []
    var queryArr:Array<String> = []
    let queryMenus:Dictionary = ["A.CODE_ ASC":"清单编号↑","A.NAME_ ASC":"清单名称↑","A.PILE_NO_ ASC":"起讫桩号↑"]
    
    @IBOutlet weak var tableV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadData()
        self.tableV.separatorStyle = .none
        self.setNav()
    }
    func setNav(){
        self.navigationItem.title = "重排计量单"
        let custemView = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        let btn1 = UIButton.init(type: .custom)
        btn1.frame = CGRect(x: 40, y: 0, width: 30, height: 30)
        btn1.setImage(UIImage.init(named: "icon_filter_bk"), for: .normal)
        btn1.addTarget(self, action: #selector(save), for: .touchUpInside)
        custemView.addSubview(btn1)
        let btn2 = UIButton.init(type: .custom)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setImage(UIImage.init(named: "ic_batch"), for: .normal)
        btn2.addTarget(self, action: #selector(reorder), for: .touchUpInside)
        custemView.addSubview(btn2)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: custemView)
    }
    func loadData() {
        NetWorkRequest(.getSimpleintermediateList(Dict: ["periodId":UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? "","orderQuery":queryArr.joined(separator: ",")])) { (response) -> (Void) in
            let jsonArr = JSON(parseJSON: response).arrayValue
            self.dataArr.removeAll()
            for json in jsonArr {
                let model = ReorderModel(dictionary: json)
                self.dataArr.append(model)
            }
            self.tableV.ccp.enable(effectType: .hover, datas: self.dataArr) { (data) in
                self.dataArr = data as! [ReorderModel]
            }
            self.tableV.reloadData()
        }
    }
    @IBAction func save(_ sender: Any) {
        var jsonArr:Array<SortModel> = Array()
        for model in self.dataArr {
            let smodel = SortModel()
            smodel.id = model.id
            smodel.orderNo = model.orderNo
            jsonArr.append(smodel)
        }
        let alert = UIAlertController(title: "", message:"是否确定保存？", preferredStyle:.alert)
        alert.addAction(title: "取消", style: .cancel)
        alert.addAction(title:"确定",style:.destructive){info in
            NetWorkRequest(.getOrderNo(Dict: ["periodId":UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? "","projectId":UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? "","sectId":UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? "","dataStr":self.jsonStrByArr(arr: jsonArr)])) { (responese) -> (Void) in
                let jsonArr = JSON(parseJSON: responese).arrayValue
                //重排计量单编号
                for json in jsonArr {
                    let dic = json.dictionaryValue
                    for model in self.dataArr{
                        if model.id == dic["id"]?.stringValue{
                            model.intermediateCode = dic["intermediateCode"]?.stringValue
                        }
                    }
                }
                self.saveUpdate()
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func reorder(_ sender: Any) {
        NavigationMenuShared.showPopMenuSelecteWithFrameWidth(width: itemWidth, height: 160, point: CGPoint(x: ScreenInfo.Width - 70, y:30), item: Array(queryMenus.values), imgSource: []) { (index) in
            switch index{
            case 0:
                self.judgeType(type: Array(self.queryMenus.keys)[0])
            case 1:
                self.judgeType(type:Array(self.queryMenus.keys)[1])
            case 2:
                self.judgeType(type:Array(self.queryMenus.keys)[2])
            default:
                break
            }
        }
    }
    func judgeType(type:String) {
        if queryArr.contains(type){
            return
        }
        queryArr.append(type)
        self.setupTableHeader()
    }
    func setupTableHeader() {
        self.loadData()
        if queryArr.count == 0{
            tableV.tableHeaderView = nil
            return
        }
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: screen_w, height: 30))
        tableV.tableHeaderView = headView
        for (index,title) in queryArr.enumerated() {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x:index * 80 + 10 , y: 0, width: 80, height: 30)
            btn.setTitle(queryMenus[title], for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 14)
            btn.addTarget(self, action: #selector(deleteJuage), for: .touchUpInside)
            btn.tag = 400 + index
            headView.addSubview(btn)
        }
    }
    @objc func deleteJuage(btn:UIButton) {
        queryArr.remove(at: btn.tag - 400)
        self.setupTableHeader()
    }
    func saveUpdate() {
        var saveMArr:Array<SortSaveModel> = Array()
        for model in self.dataArr {
            let uModel = SortSaveModel()
            uModel.id = model.id
            uModel.orderNo = model.orderNo
            uModel.intermediateCode = model.intermediateCode
            saveMArr.append(uModel)
        }
        NetWorkRequest(.saveUpdateOrderNo(Dict: ["periodId":UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? "","projectId":UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? "","sectId":UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? "","dataStr":self.jsonStrBySaveArr(arr: saveMArr)])) { (responese) -> (Void) in
            let jsonDic = JSON(parseJSON: responese).dictionaryValue
            SVProgressHUD.showSuccess(withStatus: jsonDic["msg"]?.stringValue)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK -DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.row]
        let cell:ReorderCell  = tableView.dequeueReusableCell(withIdentifier: "ReorderCell", for: indexPath) as! ReorderCell
        cell.setup(withModel: model)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.orderNoLb.text = "排序号：\(indexPath.row + 1)"
        model.orderNo = "\(indexPath.row + 1)"
        return cell
    }
    
    //数组转jsonStr
    func jsonStrByArr(arr:Array<SortModel>) -> String {
        if let jsonData = try? JSONEncoder().encode(arr) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            }
        }
        return ""
    }
    func jsonStrBySaveArr(arr:Array<SortSaveModel>) -> String {
        if let jsonData = try? JSONEncoder().encode(arr) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                return jsonString
            }
        }
        return ""
    }
}
