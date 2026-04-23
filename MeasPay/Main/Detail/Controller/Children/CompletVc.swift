//
//  CompletVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/8.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompletVc: UIViewController {
    var bizPk = ""
    
    @IBOutlet weak var designLb1: UILabel!
    @IBOutlet weak var designLb2: UILabel!
    @IBOutlet weak var perfectLb1: UILabel!
    @IBOutlet weak var perfectLb2: UILabel!
    @IBOutlet weak var changeLb1: UILabel!
    @IBOutlet weak var changeLb2: UILabel!
    @IBOutlet weak var nickLb1: UILabel!
    @IBOutlet weak var nickLb2: UILabel!
    @IBOutlet weak var wtlogLb1: UILabel!
    @IBOutlet weak var wtlogLb2: UILabel!
    @IBOutlet weak var totalLb1: UILabel!
    @IBOutlet weak var totalLb2: UILabel!
    
    @IBOutlet weak var issueLb1: UILabel!
    @IBOutlet weak var issueLb2: UILabel!
    @IBOutlet weak var cumulatLb1: UILabel!
    @IBOutlet weak var cumulatLb2: UILabel!
    @IBOutlet weak var remainLb1: UILabel!
    @IBOutlet weak var remainLb2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NetWorkRequest(.intermediate(Dict: ["bizPk":bizPk])) { [self] (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic["data"]
            if  data.count == 0 {
                return

            }
            let info = data
            self.designLb1.text = String.init(format:"%.1f", info["allDesignNum"].floatValue)
            self.perfectLb1.text = String.init(format:"%.1f",  info["allPerfectNum"].floatValue)
            self.changeLb1.text = String.init(format:"%.1f",  info["allChangeNum"].floatValue)
            self.nickLb1.text = String.init(format:"%.1f",  info["allAbandonedNum"].floatValue)
            self.wtlogLb1.text = String.init(format:"%.1f",  info["allDamagedNum"].floatValue)
            let totalA =   info["allDesignNum"].floatValue +   info["allPerfectNum"].floatValue +  info["allChangeNum"].floatValue + info["allAbandonedNum"].floatValue + info["allDamagedNum"].floatValue
            self.totalLb1.text = String.init(format:"%.1f", totalA)
            
            

            self.designLb2.text = String.init(format:"%.1f", info["lastDesignNum"].floatValue )
            self.perfectLb2.text = String.init(format:"%.1f",info["lastPerfectNum"].floatValue)
            self.changeLb2.text = String.init(format:"%.1f" ,info["lastChangeNum"].floatValue)
            self.nickLb2.text = String.init(format:"%.1f",info["lastAbandonedNum"].floatValue)
            self.wtlogLb2.text = String.init(format:"%.1f", info["lastDamagedNum"].floatValue)
            
            let totalB = info["lastDesignNum"].floatValue +
                info["lastPerfectNum"].floatValue +  info["lastChangeNum"].floatValue +  info["lastAbandonedNum"].floatValue +  info["lastDamagedNum"].floatValue
            self.totalLb2.text = String.init(format:"%.1f", totalB)

            let all:Float
            let last:Float
            switch  info["type"].stringValue  {
            case "1":
                all =  info["allDesignNum"].floatValue
                last = info["lastDesignNum"].floatValue
            case "2":
                all =  info["allPerfectNum"].floatValue
                last = info["lastPerfectNum"].floatValue
            case "3":
                all =  info["allChangeNum"].floatValue
                last = info["lastChangeNum"].floatValue
            case "4":
                all =  info["allAbandonedNum"].floatValue
                last = info["lastAbandonedNum"].floatValue
            case "5":
                all =  info["allDamagedNum"].floatValue
                last = info["lastDamagedNum"].floatValue
            default:
                all = 0
                last = 0
            }
            self.issueLb1.text =  String.init(format:"%.1f",info["thisPeriodNum"].floatValue)
            let cumulatNum:Float = info["thisPeriodNum"].floatValue +  last
            self.cumulatLb1.text = String.init(format:"%.1f", cumulatNum)

            self.issueLb2.text = "\(String(format: "%.f",  info["thisPeriodNum"].floatValue / all * 100))%"
            self.cumulatLb2.text =  "\(String(format: "%.f%", Float(cumulatNum / all * 100)))%"

            self.remainLb1.text = String(format: "%.1f", all - cumulatNum)
            self.remainLb2.text =  "\(String(format: "%.f", (all - cumulatNum) / all  * 100))%"
        }
        
        
        
        
       
        
    }
}
