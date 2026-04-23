//
//  SupvisReportDetailVc.swift
//  ycxm
//
//  Created by 高小伟 on 2020/12/2.
//  Copyright © 2020 末末班车. All rights reserved.
//

import UIKit
import SwiftyJSON

class ServersPayInfoDetailVc: UIViewController {
    var info:NSDictionary = NSDictionary()
    var type = MenuTypeConfig.mediateList
    
    @IBOutlet weak var infoLb1: UILabel!
    @IBOutlet weak var infoLb2: UILabel!
    @IBOutlet weak var infoLb3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        switch type {
        case MenuTypeConfig.centralLaboratory:
            self.loadData(type: "3")
        case MenuTypeConfig.mainlineTechnology:
            self.loadData(type: "5")
        case MenuTypeConfig.informationConstruction:
            self.loadData(type: "3")
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
            self.loadData(type: "3")
        default:
            break
        }
    }
    
    //MARK: -加载数据
    func loadData(type:String){
        NetWorkRequest(.getInfoBySectIdAndPeriodId(Dict: ["sectId":self.info["sectId"] ?? UserDefaults.standard.string(forKey: ScrInfo().sectId) ?? "" ,"periodId":self.info["periodId"] ?? UserDefaults.standard.string(forKey: ScrInfo().periodId) ?? "","type":type])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            self.infoLb1.text = jsonDic["data"]["caculBasis"].string
            self.infoLb2.text = jsonDic["data"]["caculExpStr"].string
            self.infoLb3.text = jsonDic["data"]["remarks"].string
        }
            
        }
        
}



