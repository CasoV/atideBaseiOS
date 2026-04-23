//
//  AttachmentCell.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/11.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit

class AttachmentCell: UICollectionViewCell {
    @IBOutlet weak var tagImg: UIImageView!
    @IBOutlet weak var fileNameLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setup(model:AttachmentModel) {
        self.tagImg.image = UIImage.init(named: self.fileHeadImg(type: model.extName ?? ""))
        self.fileNameLb.text = model.metaData?.fileName  
    }
    
    
    func fileHeadImg(type:String) -> String{
        
    
        switch type {
        case "pdf":
            return "ic_parttern_icon_pdf"
        case "doc","docx":
            return "ic_parttern_icon_doc"
        case "xls","xlsx":
            return "ic_parttern_icon_xls"
        case "png","jpg","jpeg":
            return "ic_parttern_icon_png"
        default:
            return "ic_parttern_icon_nofind"
        }

    }
    
}
