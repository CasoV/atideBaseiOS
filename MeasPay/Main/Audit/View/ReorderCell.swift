//
//  ReorderCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/30.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit

class ReorderCell: UITableViewCell {
@IBOutlet weak var orderNoLb: UILabel!
@IBOutlet weak var intermediateCodeLb: UILabel!
@IBOutlet weak var codeLb: UILabel!
@IBOutlet weak var nameLb: UILabel!
@IBOutlet weak var pileNoLb: UILabel!
@IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.bgView.layer.shadowOpacity = 0.5
        self.bgView.layer.shadowColor =  UIColor.lightGray.cgColor
        self.bgView.cornerRadius = 5
    }
    func setup(withModel model: ReorderModel){
        self.intermediateCodeLb.text = "计量单编号：\(model.intermediateCode ?? "")"
        self.codeLb.text = "清单编号：\(model.code ?? "")"
        self.nameLb.text = "清单名称：\(model.name ?? "")"
        self.pileNoLb.text = "起讫桩号：\(model.pileNo ?? "")"
    }

}
