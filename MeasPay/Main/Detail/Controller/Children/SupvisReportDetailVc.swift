//
//  SupvisReportDetailVc.swift
//  ycxm
//
//  Created by 高小伟 on 2020/12/2.
//  Copyright © 2020 末末班车. All rights reserved.
//

import UIKit
import SwiftyJSON

class SupvisReportDetailVc: UIViewController {
    var info:NSDictionary = NSDictionary()
    
    @IBOutlet weak var infoLb1: UILabel!
    @IBOutlet weak var infoLb2: UILabel!
    @IBOutlet weak var infoLb3: UILabel!
    @IBOutlet weak var infoLb4: UILabel!
    @IBOutlet weak var infoLb5: UILabel!
    @IBOutlet weak var infoLb6: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadData();
        
    }
    
    //MARK: -加载数据
    func loadData(){
        NetWorkRequest(.getBySectIdAndPeriodId(Dict: ["sectId":self.info["sectId"] ?? UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? "" ,"periodId":self.info["periodId"] ?? UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? ""])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            self.infoLb1.text = jsonDic["data"]["personnelRemarks"].string
            self.infoLb2.text = jsonDic["data"]["equipmentRemarks"].string
            self.infoLb3.text = jsonDic["data"]["deductionRemarks"].string
            self.infoLb4.text = jsonDic["data"]["caculBasis"].string
            self.infoLb5.text = jsonDic["data"]["caculExpStr"].string
            self.infoLb6.text = jsonDic["data"]["remarks"].string
        }
            
        }
        
}



