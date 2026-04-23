//
//  HomeVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2018/12/20.
//  Copyright © 2018 高小伟. All rights reserved.
//

import UIKit
import LLCycleScrollView
import SwiftyJSON
import SVProgressHUD

class HomeVc: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var banner: LLCycleScrollView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var homeScroll: UIScrollView!
    @IBOutlet weak var inverstSL: UISlider!
    @IBOutlet weak var prjGressView: UIView!
    @IBOutlet weak var inverAmLb: UILabel!
    static let Identify = "BaseTypeCell"
    var config:[NSDictionary] = NSArray() as! [NSDictionary]
    var gressRespon:Dictionary<String, Any>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //第一次加载默认选项
        let selePrjId = UserDefaults.standard.string(forKey: ScrInfo().projectId) ?? ""
        if selePrjId.count == 0{
            self.loadPrjDataArr()
        }else{
            self.loadData(prjId: selePrjId)
        }
    }
    
    func initUI() {
        
        //banner
        let path = Bundle.main.path(forResource: "MenuConfig", ofType: "plist")
        let serverImages =  (NSDictionary(contentsOfFile:path!)?["imgs"]! as! NSArray)
        self.banner.imagePaths = serverImages as! Array<String>
        self.banner.backgroundColor = UIColor.white
        self.banner.layer.masksToBounds = true
        self.banner.layer.cornerRadius = 5
        
        //newsView
        self.newsView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapGestureAction))
        tapGesture.numberOfTapsRequired = 1
        self.newsView.addGestureRecognizer(tapGesture)
        
        //Typs
        self.initCol()
        
        //Slide
        self.inverstSL.minimumTrackTintColor = UIColor(red: 0, green: 191/255.0, blue: 216/255.0, alpha: 1.0)
        self.inverstSL.setThumbImage(UIImage(named: "sli"), for:.normal)
        self.inverstSL.addTarget(self, action: #selector(valueChanged(slider:)), for:.valueChanged)
        
        //progressView
        self.prjGressView.isUserInteractionEnabled = true
        let tapGre = UITapGestureRecognizer(target: self, action:#selector(tapGress))
        tapGre.numberOfTapsRequired = 1
        self.prjGressView.addGestureRecognizer(tapGre)
    }
    
    func loadData(prjId:String) {
        NetWorkRequest(.getMeterTableData(Dict:["projectId":prjId])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic["data"].arrayValue
            if data.count > 0 {
                let amount = data.last?["END_AMT_"].doubleValue ?? 0
                self.inverAmLb.text = "已完成投资¥\(String(format:"%.2f",amount))"
            }
            self.gressRespon = jsonDic.dictionaryValue
        }
    }

    func initCol(){
        let conView = ConfigTypeView(rowHeigth: 60, frame: CGRect(x: 0, y: 260, width: screen_w, height: 120 + 10*3))
        conView.collectionView.delegate = self
        conView.collectionView.dataSource = self
        homeScroll.addSubview(conView)
        let path = Bundle.main.path(forResource: "MenuConfig", ofType: "plist")
        config = (NSDictionary(contentsOfFile:path!)?["root"]! as! NSArray) as! [NSDictionary]
    }
    
    
    //MARK -- SLIDERCHANGE
    @objc func valueChanged(slider:UISlider)  {
        self.inverstSL.setValue(0, animated: false)
    }
    
    
    //MARK -- DELEGATE
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
        let sb = UIStoryboard(name: "TitleType", bundle: nil)
        let vc:TitleTypeVc = sb.instantiateViewController(withIdentifier: "TitleTypeVc") as! TitleTypeVc
        switch indexPath.row {
        case 0:
            vc.fileKey = "mea"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            vc.fileKey = "report"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let listVc:MonitorListVc = UIStoryboard(name: "MonitorList", bundle: nil).instantiateViewController(withIdentifier: "MonitorListVc") as! MonitorListVc
            self.navigationController?.pushViewController(listVc, animated: true)
        default:
            print(indexPath.row)
        }
    }
    
    
    //MARK: TAP -- NEWSVIEW
    @objc func tapGestureAction(){
        print("Tap -- NewsView")
    }
    @objc func tapGress(){
        if self.gressRespon == nil{
            SVProgressHUD.showInfo(withStatus: "暂无统计数据")
            return
        }
        let detailVc:DetailMainVc = UIStoryboard.init(name: "DetailMain", bundle: nil).instantiateViewController(withIdentifier: "DetailMainVc") as! DetailMainVc
        detailVc.info = self.gressRespon! as NSDictionary
        detailVc.type = MenuTypeConfig.statiMea
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    //MARK: -网络请求
    func loadPrjDataArr() {
        NetWorkRequest(.prjList){ (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic.array
            let prjArr = NSMutableArray()
            for dataDic in data! {
                let model = PrjModel(jsonData: JSON(dataDic))
                prjArr.add(model)
            }
            let model:PrjModel = prjArr[0] as! PrjModel
            UserDefaults.standard.set(model.prjid ,forKey: ScrInfo().projectId)
            self.loadData(prjId: model.prjid!)
            self.loadSecArr(priId:model.prjid!)
        }
    }
    func loadSecArr(priId:String) {
        NetWorkRequest(.sectionList(Dict: ["prjid":priId]) ){ (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic.array
            var dataArr = [SectModel]()
            for dataDic in data! {
                let model = SectModel(jsonData: dataDic)
                dataArr.append(model)
            }
            if dataArr.count == 0 {
                 UserDefaults.standard.set("" ,forKey: ScrInfo().sectId)
                 UserDefaults.standard.set("" ,forKey: ScrInfo().periodId)
            }else{
                let model:SectModel = dataArr[0]
                UserDefaults.standard.set(model.sectionId ,forKey: ScrInfo().sectId)
                self.loadPeriodArr(projectId:priId,sectId: model.sectionId!)
            }
            
        }
    }
    
    func loadPeriodArr(projectId:String,sectId:String) {
        NetWorkRequest(.periodList(Dict: ["projectId":projectId,"sectId":sectId]) ){ (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let data = jsonDic.array
            var dataArr = [PeriodModel]()
            for dataDic in data! {
                let model = PeriodModel(jsonData: dataDic)
                dataArr.append(model)
            }
            if dataArr.count == 0 {
                UserDefaults.standard.set("" ,forKey: ScrInfo().periodId)
            }else{
                let model:PeriodModel = dataArr[0]
                UserDefaults.standard.set(model.id ,forKey: ScrInfo().periodId)
            }
        }
    }
}
