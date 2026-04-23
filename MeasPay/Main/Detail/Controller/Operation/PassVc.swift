//
//  PassVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/14.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class PassVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var texBgView: UIView!
    @IBOutlet weak var txView: UITextView!
    @IBOutlet weak var tableV: UITableView!
    
    var bizPk = ""
    var dataArr = [PassModel]()
    var jsonTasks = [Dictionary<String, Any>]()
    var type = OptionTypeConfig.pass
    @objc var parentType:MenuTypeConfig = MenuTypeConfig.mediateList
    var bkSeleModel:PassModel?
    var multipleArr = [MultipleModel]()
    var tempCell:NoPassCell?
    var tempModel:PassModel?
    var isBatch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        if type == OptionTypeConfig.back {
            self.loadRejectData()
        }else{
            self.loadData()
        }
    }
    
    func loadData() {
        var bizpk = self.bizPk;
        if(isBatch && bizpk.contains(",")){
            bizpk = bizpk.components(separatedBy: ",")[0]
        }
        NetWorkRequest(.pass(Dict: ["bizPk":bizpk])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            var jsonArr = jsonDic["data"].array
            //判断下一步
            var i = 0;
            for dic in jsonArr ?? Array(){
                if dic["status"].intValue == 2 && i+1 < jsonArr!.count{
                    jsonArr?[i+1]["nextStep"] = "1"
                }
                i+=1
            }
            for dic in jsonArr ?? Array(){
                if dic["order"].intValue < 0{
                    continue
                }
                let model = PassModel(dictionary: dic)
                self.dataArr.append(model)
            }
            self.tableV.reloadData()
        }
    }
    
    func loadRejectData() {
        NetWorkRequest(.reject(Dict: ["bizPk":self.bizPk])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic["data"].array
            for dic in jsonArr ?? Array(){
                if dic["order"].intValue < 0{
                    continue
                }
                let model = PassModel(dictionary: dic)
                self.dataArr.append(model)
            }
//            直接退到第一步，不需要选择
//            self.tab.reloadData()
        }
    }
    func setupUI() {
        texBgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        texBgView.layer.shadowOpacity = 0.5
        texBgView.layer.shadowColor =  UIColor.lightGray.cgColor
        texBgView.cornerRadius = 5
        txView.placeholder = self.type == OptionTypeConfig.back ? "请输入退回原因~" : "请输入通过原因~"
        let cellNib = UINib(nibName: "NoPassCell", bundle: nil)
        self.tableV.register(cellNib, forCellReuseIdentifier: "NoPassCell")
        self.tableV.separatorStyle = .none
        
        self.navigationItem.title = "审核"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: .plain, target: self, action: #selector(update))
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func update(_ sender: Any) {
//        判断
       
        let comment = txView.text
        
        if comment == nil || comment == "" {
            SVProgressHUD.showInfo(withStatus: "请输入意见！")
            return
        }

        if type == OptionTypeConfig.back {
//            退回
            if(parentType == MenuTypeConfig.supvisReport){
                NetWorkRequest(.swRejectTask(Dict: ["jsonTaskAssignees":"[]","bizKey":"intermediate_measurement","type" :"rejectTask","bizPk":bizPk,"comment":comment ?? ""])) { (responese) -> (Void) in
                    SVProgressHUD.showSuccess(withStatus: "操作成功")
                    self.navigationController?.popViewController(animated: true)
                }
            }else if(parentType == MenuTypeConfig.pmtReport || parentType == MenuTypeConfig.totalPackage){
                NetWorkRequest(.msRejectTask(Dict: ["jsonTaskAssignees":"[]","bizKey":"metaphase_pay_certificate","type" :"rejectTask","bizPk":bizPk,"comment":comment ?? "", "userId":UserDefaults.standard.string(forKey:"userId") ?? "","flowType": "finish","seal": "","signature": ""])) { (responese) -> (Void) in
                    SVProgressHUD.showSuccess(withStatus: "操作成功")
                    self.navigationController?.popViewController(animated: true)
                }

            }else{
                NetWorkRequest(.backApproval( userId: UserDefaults.standard.string(forKey:"userId") ?? "",periodId: UserDefaults.standard.string(forKey:"periodId") ?? "" ,Dict: ["jsonTaskAssignees":"[]","bizKey":"intermediate_measurement","type" :"rejectTask","bizPk":bizPk,"comment":comment ?? ""])) { (responese) -> (Void) in
                    SVProgressHUD.showSuccess(withStatus: "操作成功")
                    self.navigationController?.popViewController(animated: true)
                }

            }
        }else{
//            通过
            var taskKey = [String]()
            for model in self.dataArr {
                if model.status == "1"{
                    taskKey.append(model.id!)
                }
            }
            let jsonTaskAssignees = self.getJSONStringFromDictionary(arr: self.jsonTasks)
            if(parentType == MenuTypeConfig.supvisReport){
                NetWorkRequest(.swCompleteTask(Dict: ["jsonTaskAssignees":"[]","bizKey":"intermediate_measurement","type" :"rejectTask","bizPk":bizPk,"comment":comment ?? ""])) { (responese) -> (Void) in
                    SVProgressHUD.showSuccess(withStatus: "操作成功")
                    self.navigationController?.popViewController(animated: true)
                }
            }else if(parentType == MenuTypeConfig.pmtReport || parentType == MenuTypeConfig.totalPackage){
                
                if self.jsonTasks.count == 0{
                    SVProgressHUD.showInfo(withStatus: "请选择下一步人员！")
                    return
                }
                let destTaskKey = self.jsonTasks[0]["taskKey"] as! String
                NetWorkRequest(.msCompleteTask(Dict: ["jsonTaskAssignees":jsonTaskAssignees,"bizKey":"metaphase_pay_certificate","type" :"completeTask","bizPk":bizPk,"comment":comment ?? "", "userId":UserDefaults.standard.string(forKey:"userId") ?? "","flowType": "finish","seal": "","signature": "","destTaskKey":destTaskKey 
                ])) { (response) -> (Void) in
                               SVProgressHUD.showSuccess(withStatus: "操作成功")
                              self.navigationController?.popViewController(animated: true)
                }

            }else{
                NetWorkRequest(.backApproval(userId: UserDefaults.standard.string(forKey:"userId") ?? "",periodId: UserDefaults.standard.string(forKey:"periodId") ?? "" ,Dict: ["jsonTaskAssignees":jsonTaskAssignees,"bizKey":"intermediate_measurement","type" :"completeTask","bizPk":bizPk,"comment":comment ?? ""])) { (response) -> (Void) in
                               SVProgressHUD.showSuccess(withStatus: "操作成功")
                              self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    //MARK: -UITableviewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArr[indexPath.row]
        if model.forwardOpinions?.count > 0{
            return 137
        }else{
            return 87
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dataArr[indexPath.row]
        if type == OptionTypeConfig.back {
            let cell:NoPassCell = tableView.dequeueReusableCell(withIdentifier: "NoPassCell", for: indexPath) as! NoPassCell
            cell.dataArr = self.dataArr
            cell.setupBackCell(model: model,indexPath:indexPath)
            if indexPath.row == self.dataArr.count-1 {
                cell.bgView.addSubview(self.backSuLb)
                self.bkSeleModel = model
            }else{
                
            }
            return cell
        }else{
            if model.forwardOpinions?.count > 0{
                let cell:PassCell = tableView.dequeueReusableCell(withIdentifier: "PassCell", for: indexPath) as! PassCell
                cell.dataArr = self.dataArr
                cell.setupCell(model: model,indexPath:indexPath)
                return cell
            }else{
                let cell:NoPassCell = tableView.dequeueReusableCell(withIdentifier: "NoPassCell", for: indexPath) as! NoPassCell
                cell.dataArr = self.dataArr
                cell.setupCell(model: model,indexPath:indexPath)
                
//                if(model.nextStep == "1"){
//                //默认选择人员
//                let task:Dictionary = (model.taskAssignees?[0].dictionaryValue)!
//                self.jsonTasks.append(["orgId":task["orgId"]?.stringValue ?? "","orgName":task["orgName"]?.stringValue ?? "","userId":task["userId"]?.stringValue ?? "","userName":task["userName"]?.stringValue ?? "","taskKey":model.id ?? ""])
//
//                }else{
//
//                }
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dataArr[indexPath.row]
        if model.forwardOpinions?.count > 0 || model.status == "2"{
            return
        }
        let cell:NoPassCell = tableView.cellForRow(at: indexPath) as! NoPassCell
        if type == OptionTypeConfig.back {
            cell.bgView.addSubview(self.backSuLb)
            self.bkSeleModel = model
            return
        }
        if model.nextStep != "1"{
            return
        }
        self.agentAlert(model:model,cell: cell)
    }
    private lazy var backSuLb: UILabel = {
        let backSuLb = UILabel.init(frame: CGRect(x: screen_w - 66.5 - 93, y: 10, width: 66.5, height: 21))
        backSuLb.backgroundColor = .red
        backSuLb.text = "退回到该步"
        backSuLb.textColor = .white
        backSuLb.font = .systemFont(ofSize: 13.0)
        backSuLb.layer.masksToBounds = true
        backSuLb.cornerRadius = 5
        return backSuLb
    }()
    func agentAlert(model:PassModel,cell:NoPassCell) {
        let arr:Array<JSON> = model.taskAssignees ?? Array()
        if arr.count == 0 {
            return
        }
        if model.selectUser == "3" {
            let popView = ChooseMultiplePopView()
            if multipleArr.count == 0 {
                for item in arr {
                    let temp = MultipleModel()
                    temp.orgId = item["orgId"].stringValue
                    temp.orgName = item["orgName"].stringValue
                    temp.userId = item["userId"].stringValue
                    temp.userName = item["userName"].stringValue
                    multipleArr.append(temp)
                }
            }
            popView.title = model.name
            tempCell = cell
            tempModel = model
            weak var weakSelf = self
            popView.chooseResult = { (result: [MultipleModel]) in
                weakSelf?.handleMultipleResult()
            }
            popView.show(multipleArr)
        } else {
            let alert = UIAlertController(title: model.name, message: "", preferredStyle: .alert)
            var pickerViewValues = [String]()
            for value in arr{
                pickerViewValues.append(value.dictionaryValue["userName"]!.stringValue)
            }
            let pickerViewValues1: [[String]] = [pickerViewValues]
            var selectCount = 0
            let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectCount)
            alert.addPickerView(values: pickerViewValues1, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
                selectCount = index.row
            }
            alert.addAction(title: "确定", style: .destructive){info in
                cell.unFinishLb.text = "经办人：\(pickerViewValues[selectCount])"
                let task:Dictionary = arr[selectCount].dictionaryValue
                self.jsonTasks.removeAll()
                self.jsonTasks.append(["orgId":task["orgId"]?.stringValue ?? "","orgName":task["orgName"]?.stringValue ?? "","userId":task["userId"]?.stringValue ?? "","userName":task["userName"]?.stringValue ?? "","taskKey":model.id ?? ""])
                model.nextStepUserName = task["userName"]?.stringValue
            }
            alert.addAction(title: "取消", style: .cancel){info in
                
            }
            DispatchQueue.main.async(execute: {
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    // 处理多选数据
    func handleMultipleResult() {
        jsonTasks.removeAll()
        var names = ""
        for item in multipleArr {
            if (item.checked) {
                if names.count == 0 {
                    names = item.userName
                } else {
                    names = "\(names) \(item.userName)"
                }
                jsonTasks.append([
                    "orgId": item.orgId,
                    "orgName": item.orgName,
                    "userId": item.userId,
                    "userName": item.userName,
                    "taskKey": tempModel?.id ?? ""
                ])
            }
        }
        tempCell?.unFinishLb.text = "经办人：\(names)"
        tempModel?.nextStepUserName = names
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
}
