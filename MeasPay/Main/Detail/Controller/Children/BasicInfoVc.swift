//
//  BasicInfoVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/8.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class BasicInfoVc: UITableViewController {
  
    @IBOutlet var tableV: UITableView!
    var datas = [Any]()
    var bizPk = ""
    var info:NSDictionary = NSDictionary()
    var type = MenuTypeConfig.mediateList
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableV.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 30
        tableV.reloadData()
    }

    //MARK: -加载数据
    func loadData(){
        switch type {
        case MenuTypeConfig.mediateList:
            NetWorkRequest(.intermediate(Dict: ["bizPk":bizPk])) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let data = jsonDic["data"]
                if  data.count == 0 {
                    self.tableV.reloadData()
                    return
                }
                let model = BasicModel(jsonData: data)
                self.datas = model.infos
                self.tableV.reloadData()
            }
        case MenuTypeConfig.changeOrder,MenuTypeConfig.processingCard:
            NetWorkRequest(.singleContent(Dict: ["id":bizPk])) { (response) -> (Void) in
                let jsonDic = JSON(parseJSON: response)
                let data = jsonDic["data"]
                if  data.count == 0 {
                    self.tableV.reloadData()
                    return
                }
                let model = BasicModel(sigleJsonData: data)
                self.datas = model.infos
                self.tableV.reloadData()
            }
        case MenuTypeConfig.supvisPayment:
            let model = BasicModel(supvisPayDic:self.info as! Dictionary<String, Any>)
            self.datas = model.infos
            self.tableV.reloadData()
        default:
            break
        }
    }
    
    //MARK: -UITABLEVIEWDELEGATE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            as UITableViewCell
        let model:BasicChildModel = datas[indexPath.row] as! BasicChildModel
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = model.name
        let infoLabel = cell.viewWithTag(1001) as! UILabel
        infoLabel.text = model.value
        cell.selectionStyle = .none
        return cell
    }
}
