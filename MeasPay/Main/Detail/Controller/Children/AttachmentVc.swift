//
//  AttachmentVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/11.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import SwiftyJSON

class AttachmentVc: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var bizPk = ""
    static let identify:String = "AttachmentCell"
    var  datas = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(self.collectionView)
        self.loadData(fileType: 1)
        
    }
    
    func loadData(fileType:Int) {
        var jsonData = [AttachmentModel]()
        NetWorkRequest(.fileSeach(Dict: ["metaData.fileType":"\(fileType)","metaData.formId":bizPk])) { (response) -> (Void) in
            let jsonArr = JSON(parseJSON: response)
            for json in jsonArr.arrayValue {
               jsonData.append(AttachmentModel.init(dictionary: json))
            }
            if jsonArr.count != 0{
                let typeDic = NSMutableDictionary()
                typeDic.setValue(jsonData, forKey: "data")
                typeDic.setValue(fileType, forKey: "type")
                self.datas.append(typeDic)
            }
            if fileType == 3{
                self.collectionView.reloadData()
            }else{
                self.loadData(fileType: fileType + 1)
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: screen_w/3 - 20, height: 100)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: self.view.bounds.size.width, height: 21)
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView.init(frame: CGRect(x:0, y:0, width:self.view.bounds.size.width, height:self.view.bounds.size.height), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName:AttachmentVc.identify, bundle: nil), forCellWithReuseIdentifier:AttachmentVc.identify)
        collectionView.register(AttachmentHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

        return collectionView
    }()

    //MARK -- DELEGATE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let arr:NSArray = self.datas[section]["data"] as! NSArray
        return arr.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let type:Int  = self.datas[indexPath.section]["type"] as! Int
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionHeader  , withReuseIdentifier: "header", for: indexPath)
        let lb = UILabel(frame: CGRect(x: 10, y: 5, width:100, height: 21))
        switch type{
            case 1:
            lb.text = "附件"
            case 2:
            lb.text = "图纸"
            case 3:
            lb.text = "书"
            default:
            break
        }
        lb.font = .systemFont(ofSize:13)
        headerView.addSubview(lb)
        return headerView;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: self.view.bounds.size.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:AttachmentCell = collectionView.dequeueReusableCell(withReuseIdentifier: AttachmentVc.identify, for: indexPath) as! AttachmentCell
        let arr:NSArray = self.datas[indexPath.section]["data"] as! NSArray
        let model:AttachmentModel = arr[indexPath.row] as! AttachmentModel
        cell.setup(model:model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let arr:NSArray = self.datas[indexPath.section]["data"]! as! NSArray
        let model:AttachmentModel = arr[indexPath.row] as! AttachmentModel
        let name  =  "\(model.id!).\(model.extName!)"
        let path = "\(NSHomeDirectory())/Documents/\(name)"
        if !self.checkDownload(filePath: name) {
            NetWorkRequest(.fileDownload(assetName:name)) { (response) -> (Void) in
                self.reviewAttach(path: path)
            }
        }else{
            self.reviewAttach(path: path)
        }
        
    }
    func reviewAttach(path:String) {
        let fileVc:ReviewFileVc = UIStoryboard(name: "ReviewFile", bundle: nil).instantiateViewController(withIdentifier: "ReviewFileVc") as! ReviewFileVc
        fileVc.filePath = path
        self.navigationController?.pushViewController(fileVc, animated: true)
        
    }
    func checkDownload(filePath:String) -> Bool {
        for item in  FileManager.default.subpaths(atPath: "\(NSHomeDirectory())/Documents")! {
            if item == filePath {
                return true
            }
        }
         return false
    }

}
