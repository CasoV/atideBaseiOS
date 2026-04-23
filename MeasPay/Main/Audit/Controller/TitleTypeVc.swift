//
//  TitleTypeVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/25.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit

class TitleTypeVc: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var config:[NSDictionary] = NSArray() as! [NSDictionary]
    var fileKey = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCol()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initCol(){
        let conView = ConfigTypeView(rowHeigth: 60, frame: CGRect(x: 0, y: 260, width: screen_w, height: 120 + 10*3))
        conView.collectionView.delegate = self
        conView.collectionView.dataSource = self
        self.view.addSubview(conView)
        let path = Bundle.main.path(forResource: "MenuConfig", ofType: "plist")
        config = (NSDictionary(contentsOfFile:path!)?[fileKey]! as! NSArray) as! [NSDictionary]
    }
    
    
    //MARK: - DELEGATE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return config.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:BaseTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier:HomeVc.Identify, for: indexPath) as! BaseTypeCell
        cell.titleLb.text = config[indexPath.row]["title"] as? String
        cell.detailLb.text = config[indexPath.row]["detail"] as? String
        cell.tagImg.image = UIImage(named: config[indexPath.row]["img"]! as! String)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch fileKey {
        case "mea":
            let sb = UIStoryboard(name: "MediateList", bundle: nil)
            let vc:MediateListVc = sb.instantiateViewController(withIdentifier:"MediateListVc") as! MediateListVc
            if indexPath.row == 0{
                vc.type = MenuTypeConfig.mediateList
            }else if indexPath.row == 1{
                vc.type = MenuTypeConfig.thirdPayment
            }else if indexPath.row == 2{
                vc.type = MenuTypeConfig.changeOrder
            }else if indexPath.row == 3{
                vc.type = MenuTypeConfig.supvisPayment
            }
            self.navigationController?.pushViewController(vc, animated: true)
        case "report":
            let sb = UIStoryboard(name: "MediateList", bundle: nil)
            let vc:MediateListVc = sb.instantiateViewController(withIdentifier:"MediateListVc") as! MediateListVc
            if indexPath.row == 0{
                vc.type = MenuTypeConfig.pmtReport
            }else if indexPath.row == 1{
                vc.type = MenuTypeConfig.supvisReport
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print(fileKey)
        }
    }
    
}
