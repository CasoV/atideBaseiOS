//
//  ReportCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit

class ReportCell: BaseAuditCell {
    @IBOutlet weak var createDateLb: UILabel!
    @IBOutlet weak var codeLb: UILabel!
    @IBOutlet weak var remarkLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupServe(withModel model: ListServersModel
    ){
        self.setupStatus(status: model.approvalStatus ?? "")
        self.createDateLb.text = "第\(model.periodNum ?? "0")期 \(model.createDate ?? "")"
        self.codeLb.text = "计算式：\(model.caculExpStr ?? "")"
        self.remarkLb.text = "说明：\(model.remarks ?? "")"
    }
    func setupPmt(withModel model: PmtReportModel){
        self.setupStatus(status: model.status ?? "")
        self.createDateLb.text = "第\(model.periodNum ?? 0)期 \(model.createDate ?? "")"
        self.codeLb.text = "编码：\(model.code ?? "")"
        self.remarkLb.text = "备注：\(model.remark ?? "")"
    }
    
    func setup(withModel model: SupvisReportModel){
        self.setupStatus(status: model.approvalStatus ?? "")
        self.createDateLb.text = model.code
        self.createDateLb.text = "第\(model.periodNum ?? 0)期 监理计量"
        self.codeLb.text = "计算式：\(model.caculExpStr ?? "")"
        self.remarkLb.text = "说明：\(model.remarks ?? "")"
    }


    
}
