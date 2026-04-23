//
//  SupvisPaymentCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/2.
//  Copyright © 2019 高小伟. All rights reserved.
//


import UIKit

class SupvisPaymentCell: BaseAuditCell {
    @IBOutlet weak var actualStaffLb: UILabel!
    @IBOutlet weak var equipmentSituationLb: UILabel!
    @IBOutlet weak var explainLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setup(withModel model: SupvisPaymentModel){
        self.setupStatus(status: model.flowStatus ?? "")
        self.actualStaffLb.text = "本月实际到位的监理人员情况：\(model.actualStaff ?? "")"
        self.equipmentSituationLb.text = "本月试验及检测设备的完好情况：\(model.equipmentSituation ?? "")"
        self.explainLb.text = "说明：\(model.explain ?? "")"
    }
}

