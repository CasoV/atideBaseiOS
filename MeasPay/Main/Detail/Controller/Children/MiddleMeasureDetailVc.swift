//
//  MiddleMeasureDetailVc.swift
//  ycxm
//
//  Created by 高小伟 on 2020/11/30.
//  Copyright © 2020 末末班车. All rights reserved.
//


import UIKit
import SwiftyJSON

class MiddleMeasureDetailVc: UIViewController {
    var bizPk = ""
    var info:NSDictionary = NSDictionary()
    
    @IBOutlet weak var tvIntermediateCode: UILabel!
    @IBOutlet weak var tvCertificateNo: UILabel!
    @IBOutlet weak var tvMeterageDate: UILabel!
    @IBOutlet weak var tvMeteragePileNo: UILabel!
    
    @IBOutlet weak var tvPosition: UILabel!
    @IBOutlet weak var tvApprovalNum: UILabel!
    @IBOutlet weak var tvBili: UILabel!
    @IBOutlet weak var tvThisPeriodNum: UILabel!
    @IBOutlet weak var tvSurplusNum: UILabel!
    @IBOutlet weak var tvCumulativeNum: UILabel!
    @IBOutlet weak var tvApprovalMsg: UILabel!
    
    
    @IBOutlet weak var tvLastComplete: UILabel!
    @IBOutlet weak var tvComplete: UILabel!
    @IBOutlet weak var tvEndComplete: UILabel!
    
    @IBOutlet weak var tvName: UILabel!
    @IBOutlet weak var tvCode: UILabel!
    @IBOutlet weak var tvUnit: UILabel!
    @IBOutlet weak var tvPileNo: UILabel!
    @IBOutlet weak var tvPlace: UILabel!
    @IBOutlet weak var tvPartCode: UILabel!
    @IBOutlet weak var tvTypeName: UILabel!
    @IBOutlet weak var tvDesignChartNum: UILabel!
    @IBOutlet weak var tvChangeCode: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadData();
        
    }
    
    //MARK: -加载数据
    func loadData(){
        NetWorkRequest(.intermediate(Dict: ["bizPk":bizPk])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic["data"]
            if  data.count == 0 {
                return
            }
            let bean:MediateModel = MediateModel(jsonData: data)
            var lastji:Float = 0.0
            var totalNum:Float = 0.0
            var approval:Float = 0.0
            if (bean.approvalNum != 0.0) {
                approval = bean.approvalNum ?? 0.0
            } else {
                approval = bean.thisPeriodNum ?? 0.0
            }
            switch bean.type {
            case "1":
                self.tvTypeName.text = "设计"
                lastji = bean.lastDesignNum ?? 0.0
                totalNum = bean.allDesignNum ?? 0.0
                
            case   "2" :
                self.tvTypeName.text = "完善"
                lastji = bean.lastPerfectNum ?? 0.0
                totalNum = bean.allPerfectNum ?? 0.0
                
            case "3":
                self.tvTypeName.text = "变更"
                lastji = bean.lastChangeNum ?? 0.0
                totalNum = bean.allChangeNum ?? 0.0
                
            case "4":
                self.tvTypeName.text = "废置"
                lastji = bean.lastAbandonedNum ?? 0.0
                totalNum = bean.allAbandonedNum ?? 0.0
                
            case "5" :
                self.tvTypeName.text = "水毁"
                lastji = bean.lastDamagedNum ?? 0.0
                totalNum = bean.allDesignNum ?? 0.0
                
            default:break
            }
            
            self.tvIntermediateCode.text = bean.intermediateCode
            self.tvCertificateNo.text = bean.certificateNo
            self.tvMeterageDate.text = bean.meterageDate
            self.tvMeteragePileNo.text = bean.meteragePileNo
            self.tvPosition.text = bean.position
            self.tvApprovalMsg.text = bean.approvalMsg
            self.tvApprovalNum.text = String(format:"%.2f",bean.approvalNum ?? 0.0)
            self.tvThisPeriodNum.text = String(format:"%.2f",bean.approvalNum ?? 0.0)
            self.tvSurplusNum.text = String(format:"%.2f",totalNum - approval)
            self.tvCumulativeNum.text = String(format:"%.2f",lastji + approval)
            
            //形象进度
            self.tvLastComplete.text =  String(format:"%.2f",bean.lastComplete ?? 0.0)
            self.tvComplete.text =  String(format:"%.2f",(bean.lastComplete ?? 0.0) + (bean.complete ?? 0.0))
            self.tvEndComplete.text =  String(format:"%.2f",bean.approvalNum ?? 0.0)
            
            //清单信息
            self.tvName.text = bean.name
            self.tvCode.text = bean.code
            self.tvUnit.text = bean.unit
            self.tvPileNo.text = String(format:"%.2f",bean.pileNo ?? 0.0)
            self.tvPlace.text = bean.place
            self.tvPartCode.text = bean.partCode
            self.tvDesignChartNum.text = bean.designChartNum
            self.tvChangeCode.text = bean.changeCode
            
            
        }
        
    }
}


