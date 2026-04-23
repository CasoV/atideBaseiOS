//
//  MediateListCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/26.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class MediateListCell: BaseAuditCell {
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var intermediateCodeLb: UILabel!
    @IBOutlet weak var codeLb: UILabel!
    @IBOutlet weak var placeLb: UILabel!
    @IBOutlet weak var unitLb: UILabel!
    @IBOutlet weak var meteragePileNoLb: UILabel!
    @IBOutlet weak var approvalNumLb: UILabel!
    @IBOutlet weak var thisPeriodNumLb: UILabel!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var selectImg: UIImageView!
    var dataArr = [MediateModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(withModel model: MediateModel){
        self.userNameLb.text = model.userName
        self.nameLb.text = model.name
        self.intermediateCodeLb.text = model.intermediateCode
        self.codeLb.text = "清单编号：\(model.code ?? "")"
        self.placeLb.text = "位置：\(model.place ?? "")"
        self.unitLb.text = "单位：\(model.unit ?? "")"
        self.meteragePileNoLb.text = "清单桩号：\(model.meteragePileNo ?? "")"
        self.approvalNumLb.text = "核定数量：\(model.approvalNum ?? 0)"
        self.thisPeriodNumLb.text = "申报数量：\(model.thisPeriodNum ?? 0)"
        self.setupStatus(status: model.status ?? "")
        self.selectImg.isHidden = !model.isSelect!
        switch model.status  {
        case "1":
            self.btn1.setTitle("详情", for: .normal)
            self.btn2.setTitle("计量", for: .normal)
            self.btn3.setTitle("申报", for: .normal)
            self.btn2.setTitleColor(UIColor(red: 95/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
            self.btn3.setTitleColor(UIColor(red: 0/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1.0), for: .normal)
            self.btn2.isHidden = false
            self.btn3.isHidden = false
        case "2":
            self.btn1.setTitle("详情", for: .normal)
            self.btn2.setTitle("计量", for: .normal)
            self.btn3.setTitle("申报", for: .normal)
            self.btn2.setTitleColor(UIColor(red: 95/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0), for: .normal)
            self.btn3.setTitleColor(UIColor(red: 0/255.0, green: 191/255.0, blue: 216/255.0, alpha: 1.0), for: .normal)
            self.btn2.isHidden = false
            self.btn3.isHidden = false
        case "3":
//            if (model.listStatus == "5") {
                self.btn2.setTitle("通过", for: .normal)
                self.btn3.setTitle("退回", for: .normal)
                self.btn2.setTitleColor(UIColor(red: 92/255.0, green: 192/255.0, blue: 156/255.0, alpha: 1.0), for: .normal)
                self.btn3.setTitleColor(UIColor(red: 255/255.0, green: 78/255.0, blue: 87/255.0, alpha: 1.0), for: .normal)
                self.btn2.isHidden = false
                self.btn3.isHidden = false
//            } else {
//                self.btn2.setTitle("", for: .normal)
//                self.btn3.setTitle("", for: .normal)
//                self.btn2.isHidden = true
//                self.btn3.isHidden = true
//            }
            self.btn1.setTitle("详情", for: .normal)
        case "4":
            self.btn2.setTitle("", for: .normal)
            self.btn3.setTitle("", for: .normal)
            self.btn1.setTitle("详情", for: .normal)
            self.btn2.isHidden = true
            self.btn3.isHidden = true
        case "999":
            self.btn2.setTitle("", for: .normal)
            self.btn3.setTitle("", for: .normal)
            self.btn1.setTitle("详情", for: .normal)
            self.btn2.isHidden = true
            self.btn3.isHidden = true
        default:
            break
            
        }
    }
    @IBAction func detail(_ sender: UIButton) {
        let model = self.dataArr[sender.tag - 100]
        let infoDic =  self.getDictionaryFromJSONString(jsonString: self.jsonStrBy(model: model))
        let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
        detailVc.info = infoDic
        detailVc.type = MenuTypeConfig.mediateList
        self.getCurrentVC?.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    @IBAction func meaOrPass(_ sender: UIButton) {
        let model = self.dataArr[sender.tag - 200]
        if sender.titleLabel?.text == "计量" {
            self.alertPick(title: sender.titleLabel?.text ?? "", message: "计量比例（%）", placehoder: "0~100之间",text:"",model: model,type:0)
        }else if sender.titleLabel?.text == "通过" {
//            不选人
//            self.alertPick(title: sender.titleLabel?.text ?? "", message: "请输入意见", placehoder: "请输入意见",text:"同意本期计量",model:model,type:2)
//            选人
            let vc:PassVc = UIStoryboard(name: "Pass", bundle: nil).instantiateViewController(withIdentifier: "PassVc") as! PassVc
            vc.bizPk = model.id!
            vc.type = OptionTypeConfig.pass
            self.getCurrentVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func responOrBack(_ sender: UIButton) {
        let model = self.dataArr[sender.tag - 300]
        if sender.titleLabel?.text == "申报" {
            self.alertPick(title: sender.titleLabel?.text ?? "", message: "请输入意见", placehoder: "请输入意见",text:"同意本期计量",model: model,type: 1)
            
        }else if sender.titleLabel?.text == "退回" {
//            不选人
            //            self.alertPick(title:  sender.titleLabel?.text ?? "", message: "请填入退回意见", placehoder: "请填入退回意见",text:"",model: model, type:3)
//            选人
            let vc:PassVc = UIStoryboard(name: "Pass", bundle: nil).instantiateViewController(withIdentifier: "PassVc") as! PassVc
            vc.bizPk = model.id!
            vc.type = OptionTypeConfig.back
            self.getCurrentVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //获取父控制器
    var getCurrentVC: UIViewController? {
        var next = superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is UIViewController) {
                return nextResponder as? UIViewController
            }
            next = next?.superview
        }
        return nil
    }
    
    func alertPick(title:String,message:String,placehoder:String,text:String,model:MediateModel,type:Int) {
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
                self.measur(prop:propStr,model: model)
            default:
                self.batchOperation(prop: propStr, type: type,model: model)
            }
            
        }
        alert.addAction(title: "取消", style: .cancel)
        self.getCurrentVC?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: -批量计量申报通过退回
    func batchOperation(prop:NSString,type:Int,model:MediateModel) {
        var jsonArr = [String]()
        switch type{
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
        
        switch type{
        case 1,3:
            NetWorkRequest(.submitApproval(Dict: ["bizKey":"intermediate_measurement","type" :"rejectTask","bizPk":jsonArr.joined(separator: ","),"comment":prop,"jsonTaskAssignees":"[]"])) { (response) -> (Void) in
                self.dealComplete(response: response)
            }
        case 2:
            NetWorkRequest(.backApproval(userId: UserDefaults.standard.string(forKey:"userId") ?? "",periodId: UserDefaults.standard.string(forKey:"periodId") ?? "" ,Dict: ["bizKey":"intermediate_measurement","type" :"completeTask","bizPk":jsonArr.joined(separator: ","),"comment":prop])) { (response) -> (Void) in
                self.dealComplete(response: response)
            }
        default:
            return
        }
    }
    //MARK: -计量
    func measur(prop:NSString,model:MediateModel) {
        if prop.length == 0 {
            SVProgressHUD.showInfo(withStatus:"请输入计量比例")
            return
        }
        var propFloat:Float =  Float(prop.floatValue)
        if propFloat >= 100 {
            propFloat = 100
        }
        var jsonArr = [NSMutableDictionary]()
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
//        model.approvalNum = model.thisPeriodNum!
        model.designChartNum = "2"
        model.pileNo = 1
        
        if let jsonData = try? JSONEncoder().encode(model) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                let jsonDic:NSMutableDictionary = self.getDictionaryFromJSONString(jsonString: jsonString) as! NSMutableDictionary
                jsonDic.removeObject(forKey: "isSelect")
                jsonArr.append(jsonDic)
            }
        }
        NetWorkRequest(.intermediateUpdate(Dict: ["dataStr":self.getJSONStringFromDictionary(arr: jsonArr)])) { (response) -> (Void) in
            self.dealComplete(response: response)
        }
    }
    func dealComplete(response:String ){
        let jsonDic = JSON(parseJSON: response)
        let data = jsonDic.dictionary
        SVProgressHUD.showSuccess(withStatus:data!["msg"]?.string)
        let vc:MediateListVc =  self.getCurrentVC as! MediateListVc
        vc.loadNew()
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
    
    //数组转jsonStr
    func jsonStrBy(model:MediateModel) -> String {
        if let jsonData = try? JSONEncoder().encode(model) {
            if let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8) {
                print("jsonString:" + "\(jsonString)")
                return jsonString
            }
        }
        return ""
    }
}
