//
//  AuditInforVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/9.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class AuditInforVc: UITableViewController {
    var datas = [AuditInfoModel]()
    var bizPk = ""
    @IBOutlet var tableV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableV.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
    }
    func loadData() {
        NetWorkRequest(.getComments(Dict: ["bizPk" : bizPk])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic["data"]
            if  data.count == 0 {
                self.tableV.reloadData()
                return
            }
            self.datas = AuditInfos(jsonData: data.array ?? []).infos
            self.tableV.reloadData()
        }
    }
    //MARK: -UITABLEVIEWDELEGATE
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  self.datas.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model:AuditInfoModel = datas[indexPath.row]
        let cell:AuditInforCell = tableView.dequeueReusableCell(withIdentifier: "AuditInforCell", for: indexPath) as! AuditInforCell
        cell.setup(model: model)
        cell.topView.isHidden = indexPath.row == 0 ? true : false
        cell.btmView.isHidden = indexPath.row == self.datas.count - 1 ? true : false
        return cell
    }
}
