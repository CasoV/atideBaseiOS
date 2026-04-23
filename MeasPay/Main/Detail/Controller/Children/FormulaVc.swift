//
//  FormulaVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/11.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class FormulaVc: UIViewController {
    var bizPk = ""
    @IBOutlet weak var calcuLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadData()
    }
    
    //MARK: -加载数据
    func loadData(){
        NetWorkRequest(.intermediate(Dict: ["bizPk":bizPk])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            self.calcuLb.text = jsonDic["data"]["jssRemark"].stringValue
        }
    }

}
