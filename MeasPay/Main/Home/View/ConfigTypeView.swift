//
//  ConfigTypeView.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/20.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit

class ConfigTypeView: UIView {
//    var titles :NSArray = []
//    var details :NSArray = []
//    var conts :NSArray = []
    var collectionView :UICollectionView!
    var rowHeigth :CGFloat = 0
    convenience init(rowHeigth:CGFloat, frame: CGRect) {
        self.init(frame: frame)
//        self.titles = titles
//        self.details = details
//        self.conts = conts
        self.rowHeigth = rowHeigth
    }

    override init(frame: CGRect) {
        super.init(frame:frame)
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: screen_w/2 - 15, height: 60)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView.init(frame: CGRect(x:0, y:0, width:self.bounds.size.width, height:self.bounds.size.height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib.init(nibName:HomeVc.Identify, bundle: nil), forCellWithReuseIdentifier:HomeVc.Identify)
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
