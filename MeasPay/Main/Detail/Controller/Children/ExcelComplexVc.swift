//
//  ExcelComplexVc.swift
//  ycxm
//
//  Created by 高小伟 on 2020/12/1.
//  Copyright © 2020 末末班车. All rights reserved.
//
import UIKit
import LMReport
import SwiftyJSON

//有合并表头的excel表格

class ExcelComplexVc: UIViewController,LMReportViewDatasource {
    var reportView:LMReportView!
    var excelType = ""
    var type = MenuTypeConfig.mediateList
    var btmToolHidden:Bool = false
    var datas = [NSMutableArray]()
    var bizPk = ""
    var tagTitle = ""
    
    
    let headTitles1 = ["序号","科目名称","签约合同金额","设计金额","实际完成金额"]
    let titles1 = ["序号","科目名称","签约合同金额","设计金额","完善金额","变更金额","总金额","到本期末完成","到上期末完成","本期完成"]
    
    var headTitles2 = ["子目号","子目名称","单位","单价","到本期末完成","到上期末完成","本期完成"]
    let titles2 = ["子目号","子目名称","单位","合同","新增","数量","金额","数量","金额","数量","金额","数量","金额"]
    
    var headTitles3 = ["子目号","子目名称","单位","起讫桩号","位置描述","单价","到本期末完成","到上期末完成","本期完成"]
    let titles3 = ["子目号","子目名称","单位","起讫桩号","位置描述","合同","新增","数量","金额","数量","金额","数量","金额","数量","金额"]
    
    let headTitles4 = ["子目号","子目名称","单位","起讫桩号","位置描述","变更令","单价","变更","到本期末完成","到上期末完成","本期完成"]
    let titles4 = ["子目号","子目名称","单位","起讫桩号","位置描述","变更令","合同","新增","数量","金额","数量","金额","数量","金额","数量","金额"]
    
    let headTitles5 = ["标段名称","子目号","子目名称","单位","起讫桩号","位置描述","单价","变更","到本期末完成","到上期末完成","本期完成","变更令"]
    let titles5 = ["标段名称","子目号","子目名称","单位","起讫桩号","位置描述","合同","新增","数量","金额","数量","金额","数量","金额","数量","金额"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupReportView()
        switch excelType {
        case "T_Bill", "T_Design", "T_Change", "T_Abandon", "T_CalDay":
            self.headTitles2.insert(self.getName(), at: 4)
        case "T_BillDetail":
            self.headTitles3.insert(self.getName(), at: 6)
        default:
            break
        }
        self.loadPayRepData()
    }
    func getName() -> String {
        if (excelType.contains("T_Bill")) {
            return "清单"
        } else if (excelType.contains("T_Design")) {
            return "施工图设计"
        } else if (excelType.contains("T_Change")) {
            return "变更"
        } else if (excelType.contains("T_Abandon")) {
            return "废置"
        } else if (excelType.contains("T_CalDay")) {
            return "计日工"
        } else {
            return ""
        }
    }
    func setupReportView() {
        self.reportView =  LMReportView.init(frame: CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h - 210))
        if (self.btmToolHidden){
            self.reportView.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h - 180)
            if(!UIDevice().isX()){
                self.reportView.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h - 120)
            }
        }else{
            if(!UIDevice().isX()){
                self.reportView.frame = CGRect.init(x: 0, y: 0, width: screen_w, height: screen_h - 150)
            }
        }
        self.reportView.style =  self.greenStyle()
        self.view.addSubview(self.reportView)
    }
    func loadPayRepData(){
        var parmas = ["bizPk":self.bizPk,"tabCode":self.excelType,"pageNo":"1","pageSize":"999"]
        if(self.type == MenuTypeConfig.pmtReport){
            parmas["audit"] = "1"
        }
        NetWorkRequest(.getPayRepData(Dict: parmas)) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            
                let jsonArr = jsonDic["data"].array
                var dataArr = [ComplexModel]()
                for dic in jsonArr ?? Array(){
                    let model:ComplexModel  = ComplexModel(dictionary: dic)
                    dataArr.append(model)
                }
            DispatchQueue.main.async(execute: {
                self.reportView.datasource = self
                
                switch self.excelType {
                case "T_PayCert":
                    self.dealMobileData(arr:dataArr)
                case "T_Bill", "T_Design", "T_Change", "T_Abandon", "T_CalDay":
                    let jsonArr = jsonDic["data"]["rows"].array
                    var dataArr = [ComplexModel]()
                    for dic in jsonArr ?? Array(){
                        let model:ComplexModel  = ComplexModel(dictionary: dic)
                        dataArr.append(model)
                    }
                    self.dealMobileData2(arr:dataArr)
                case "T_BillDetail":
                    let jsonArr = jsonDic["data"]["rows"].array
                    var dataArr = [ComplexModel]()
                    for dic in jsonArr ?? Array(){
                        let model:ComplexModel  = ComplexModel(dictionary: dic)
                        dataArr.append(model)
                    }
                    self.dealMobileData3(arr:dataArr)
                case "T_ChangeDetail":
                    let jsonArr = jsonDic["data"]["rows"].array
                    var dataArr = [ComplexModel]()
                    for dic in jsonArr ?? Array(){
                        let model:ComplexModel  = ComplexModel(dictionary: dic)
                        dataArr.append(model)
                    }
                    self.dealMobileData4(arr:dataArr)
                case "T_ChangeSumDetail":
                    let jsonArr = jsonDic["data"]["rows"].array
                    var dataArr = [ComplexModel]()
                    for dic in jsonArr ?? Array(){
                        let model:ComplexModel  = ComplexModel(dictionary: dic)
                        dataArr.append(model)
                    }
                    self.dealMobileData5(arr:dataArr)
                default:
                    break
                    
                }
                
            })
        }
    }
    func dealMobileData5(arr:Array<ComplexModel>) {
        if arr.count > 0 {
            //Header
            for i in 0..<2 {
                let grids:NSMutableArray = NSMutableArray()
                if i == 0{
                    for title in self.headTitles5{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        //  横向占位
                        case "单价","变更","到本期末完成","到上期末完成","本期完成":
                            grid.colspan = 2;
                            grids.add(grid)
                            grids.add(NSNull());
                        //  竖直表头占位
                        case "标段名称","子目号","子目名称","单位","起讫桩号","位置描述":
                            grid.rowspan = 2;
                            grids.add(grid)
                        default:
                            break;
                        }
                    }
                }else{
                    for title in self.titles5{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        case  "合同","新增","数量","金额":
                            grids.add(grid);
                            break;
                        default:
                            grids.add(NSNull());
                            break;
                        }
                    }
                    
                }
                self.datas.append(grids)
            }
            
        }
        for model in arr {
            //Content
            let grids:NSMutableArray = NSMutableArray()
            for k in 0..<self.titles5.count{
                let grid:LMRGrid = LMRGrid()
                switch k{
                case 0:
                    grid.text = model.sectName
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 1:
                    grid.text = model.listCode
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 2:
                    grid.text = model.listName
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 3:
                    grid.text = model.listUnit
                    grid.rowspan = 1
                    grids.add(grid)
                case 4:
                    grid.text = model.startNo
                    grid.rowspan = 1
                    grids.add(grid)
                case 5:
                    grid.text = model.place
                    grid.rowspan = 1
                    grids.add(grid)
                case 6:
                    grid.text =  String(format:"%.f",model.contractPrice ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 7:
                    grid.text =  String(format:"%.f",model.newlyPrice ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 8:
                    grid.text =  String(format:"%.f",model.listNum ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 9:
                    grid.text =  String(format:"%.f",model.listAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 10:
                    grid.text =  String(format:"%.f",model.tcompQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 11:
                    grid.text =  String(format:"%.f",model.tcompAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                      
                case 12:
                    grid.text =  String(format:"%.f",model.pcompQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 13:
                    grid.text =  String(format:"%.f",model.pcompAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 14:
                    grid.text =  String(format:"%.f",model.compQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 15:
                    grid.text =  String(format:"%.f",model.compAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
              
                default:
                    break
                }
            }
            self.datas.append(grids)
        }
        self.reportView.reloadData()
    }
    func dealMobileData4(arr:Array<ComplexModel>) {
        if arr.count > 0 {
            //Header
            for i in 0..<2 {
                let grids:NSMutableArray = NSMutableArray()
                if i == 0{
                    for title in self.headTitles4{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        //  横向占位
                        case "单价","变更","到本期末完成","到上期末完成","本期完成":
                            grid.colspan = 2;
                            grids.add(grid)
                            grids.add(NSNull());
                        //  竖直表头占位
                        case "子目号","子目名称","单位","起讫桩号","位置描述","变更令":
                            grid.rowspan = 2;
                            grids.add(grid)
                        default:
                            break;
                        }
                    }
                }else{
                    for title in self.titles4{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        case  "合同","新增","数量","金额":
                            grids.add(grid);
                            break;
                        default:
                            grids.add(NSNull());
                            break;
                        }
                    }
                    
                }
                self.datas.append(grids)
            }
            
        }
        for model in arr {
            //Content
            let grids:NSMutableArray = NSMutableArray()
            for k in 0..<self.titles4.count{
                let grid:LMRGrid = LMRGrid()
                switch k{
                case 0:
                    grid.text = model.listCode
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 1:
                    grid.text = model.listName
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 2:
                    grid.text = model.listUnit
                    grid.rowspan = 1
                    grids.add(grid)
                case 3:
                    grid.text = model.startNo
                    grid.rowspan = 1
                    grids.add(grid)
                case 4:
                    grid.text = model.place
                    grid.rowspan = 1
                    grids.add(grid)
                case 5:
                    grid.text = model.changeCode
                    grid.rowspan = 1
                    grids.add(grid)
                case 6:
                    grid.text =  String(format:"%.f",model.contractPrice ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 7:
                    grid.text =  String(format:"%.f",model.newlyPrice ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 8:
                    grid.text =  String(format:"%.f",model.listNum ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 9:
                    grid.text =  String(format:"%.f",model.listAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 10:
                    grid.text =  String(format:"%.f",model.tcompQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 11:
                    grid.text =  String(format:"%.f",model.tcompAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                      
                case 12:
                    grid.text =  String(format:"%.f",model.pcompQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 13:
                    grid.text =  String(format:"%.f",model.pcompAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 14:
                    grid.text =  String(format:"%.f",model.compQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 15:
                    grid.text =  String(format:"%.f",model.compAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
              
                default:
                    break
                }
            }
            self.datas.append(grids)
        }
        self.reportView.reloadData()
    }
    func dealMobileData3(arr:Array<ComplexModel>) {
        if arr.count > 0 {
            //Header
            for i in 0..<2 {
                let grids:NSMutableArray = NSMutableArray()
                if i == 0{
                    for title in self.headTitles3{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        //  横向占位
                        case "单价",self.getName(),"到本期末完成","到上期末完成","本期完成":
                            grid.colspan = 2;
                            grids.add(grid)
                            grids.add(NSNull());
                        //  竖直表头占位
                        case "子目号","子目名称","单位","起讫桩号","位置描述":
                            grid.rowspan = 2;
                            grids.add(grid)
                        default:
                            break;
                        }
                    }
                }else{
                    for title in self.titles3{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        case  "合同","新增","数量","金额":
                            grids.add(grid);
                            break;
                        default:
                            grids.add(NSNull());
                            break;
                        }
                    }
                    
                }
                self.datas.append(grids)
            }
            
        }
        for model in arr {
            //Content
            let grids:NSMutableArray = NSMutableArray()
            for k in 0..<self.titles3.count{
                let grid:LMRGrid = LMRGrid()
                switch k{
                case 0:
                    grid.text = model.listCode
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 1:
                    grid.text = model.listName
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 2:
                    grid.text = model.listUnit
                    grid.rowspan = 1
                    grids.add(grid)
                case 3:
                    grid.text = model.startNo
                    grid.rowspan = 1
                    grids.add(grid)
                case 4:
                    grid.text = model.place
                    grid.rowspan = 1
                    grids.add(grid)
                case 5:
                    grid.text =  String(format:"%.f",model.contractPrice ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 6:
                    grid.text =  String(format:"%.f",model.newlyPrice ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 7:
                    grid.text =  String(format:"%.f",model.listNum ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 8:
                    grid.text =  String(format:"%.f",model.listAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 9:
                    grid.text =  String(format:"%.f",model.tcompQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 10:
                    grid.text =  String(format:"%.f",model.tcompAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                      
                case 11:
                    grid.text =  String(format:"%.f",model.pcompQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 12:
                    grid.text =  String(format:"%.f",model.pcompAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 13:
                    grid.text =  String(format:"%.f",model.compQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 14:
                    grid.text =  String(format:"%.f",model.compAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
              
                default:
                    break
                }
            }
            self.datas.append(grids)
        }
        self.reportView.reloadData()
    }
    func dealMobileData2(arr:Array<ComplexModel>) {
        if arr.count > 0 {
            //Header
            for i in 0..<2 {
                let grids:NSMutableArray = NSMutableArray()
                if i == 0{
                    for title in self.headTitles2{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        //  横向占位
                        case "单价",self.getName(),"到本期末完成","到上期末完成","本期完成":
                            grid.colspan = 2;
                            grids.add(grid)
                            grids.add(NSNull());
                        //  竖直表头占位
                        case "子目号","子目名称","单位":
                            grid.rowspan = 2;
                            grids.add(grid)
                        default:
                            break;
                        }
                    }
                }else{
                    for title in self.titles2{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        case  "合同","新增","数量","金额":
                            grids.add(grid);
                            break;
                        default:
                            grids.add(NSNull());
                            break;
                        }
                    }
                    
                }
                self.datas.append(grids)
            }
            
        }
        for model in arr {
            //Content
            let grids:NSMutableArray = NSMutableArray()
            for k in 0..<self.titles2.count{
                let grid:LMRGrid = LMRGrid()
                switch k{
                case 0:
                    grid.text = model.listCode
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 1:
                    grid.text = model.listName
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case 2:
                    grid.text = model.listUnit
                    grid.rowspan = 1
                    grids.add(grid)
                case 3:
                    grid.text =  String(format:"%.f",model.contractPrice ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 4:
                    grid.text =  String(format:"%.f",model.newlyPrice ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 5:
                    grid.text =  String(format:"%.f",model.listNum ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 6:
                    grid.text =  String(format:"%.f",model.listAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 7:
                    grid.text =  String(format:"%.f",model.tcompQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 8:
                    grid.text =  String(format:"%.f",model.tcompAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                      
                case 9:
                    grid.text =  String(format:"%.f",model.pcompQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 10:
                    grid.text =  String(format:"%.f",model.pcompAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    
                case 11:
                    grid.text =  String(format:"%.f",model.compQuantity ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case 12:
                    grid.text =  String(format:"%.f",model.compAmt ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
              
                default:
                    break
                }
            }
            self.datas.append(grids)
        }
        self.reportView.reloadData()
    }
    func dealMobileData(arr:Array<ComplexModel>) {
        if arr.count > 0 {
            //Header
            for i in 0..<2 {
                let grids:NSMutableArray = NSMutableArray()
                if i == 0{
                    for title in self.headTitles1{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        
                        switch (title) {
                        case "设计金额":
                            grid.colspan = 4;
                            grids.add(grid)
                            grids.add(NSNull());
                            grids.add(NSNull());
                            grids.add(NSNull());
                        case "实际完成金额":
                            grid.colspan = 3;
                            grids.add(grid)
                            grids.add(NSNull());
                            grids.add(NSNull());
                        case "序号":
                            grid.rowspan = 2;
                            grids.add(grid)
                        case "科目名称":
                            grid.rowspan = 2;
                            grids.add(grid)
                        case "签约合同金额":
                            grid.rowspan = 2;
                            grids.add(grid)
                        default:
                            break;
                        }
                    }
                }else{
                    for title in self.titles1{
                        let grid:LMRGrid = LMRGrid()
                        grid.text = title
                        switch (title) {
                        case  "设计金额","完善金额","变更金额","总金额","到本期末完成","到上期末完成","本期完成":
                            grids.add(grid);
                            break;
                        default:
                            grids.add(NSNull());
                            break;
                        }
                    }
                    
                }
                self.datas.append(grids)
            }
            
        }
        var count = 0
        for model in arr {
            count += 1
            //Content
            let grids:NSMutableArray = NSMutableArray()
            for title in self.titles1{
                let grid:LMRGrid = LMRGrid()
                switch title{
                case "序号":
                    grid.text = String(count)
                    grid.rowspan = 1
                    grids.add(grid)
                case "科目名称":
                    grid.text = model.costName
                    grid.rowspan = 1
                    grid.textAlignment = .left
                    grids.add(grid)
                case "签约合同金额":
                    grid.text =  String(format:"%.f",model.contractAMT ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case "设计金额":
                    grid.text = String(format:"%.f",model.designAMT ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case "完善金额":
                    grid.text =  String(format:"%.f",model.bargainAMT ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                    break;
                case "变更金额":
                    grid.text =  String(format:"%.f",model.changeAMT ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case "总金额":
                    grid.text =  String(format:"%.f",model.totalAMT ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case "到本期末完成":
                    grid.text =  String(format:"%.f",model.cCompAMT ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case "到上期末完成":
                    grid.text =  String(format:"%.f",model.pCompAMT ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                case "本期完成":
                    grid.text =  String(format:"%.f",model.compAMT ?? 0.0)
                    grid.rowspan = 1
                    grid.textAlignment = .right
                    grids.add(grid)
                default:
                    break
                }
            }
            self.datas.append(grids)
        }
        self.reportView.reloadData()
    }
    
    
    
    //Mark: -LMReportViewDatasource
    func numberOfRows(in reportView: LMReportView!) -> Int {
        return self.datas.count
    }
    func numberOfHeadRows(in reportView: LMReportView!) -> Int {
        return 2
    }
    func numberOfCols(in reportView: LMReportView!) -> Int {
        switch excelType {
        case "T_PayCert":
             return 10
        case"T_Bill", "T_Design", "T_Change", "T_Abandon", "T_CalDay":
             return 13
        case"T_BillDetail":
             return 15
        case "T_ChangeDetail":
            return 16
        case "T_ChangeSumDetail":
            return 16
        default:
            return 0
        }
    }
    func reportView(_ reportView: LMReportView!, widthOfCol col: Int) -> CGFloat {
        switch excelType {
        case "T_PayCert":
                if col == 0{
//                    序号
                    return 50
                }else{
                    return 100
                }
        case "T_Bill", "T_Design", "T_Change", "T_Abandon", "T_CalDay":
             return 100
        case "T_BillDetail":
             return 100
        case "T_ChangeDetail":
            return 100
        case "T_ChangeSumDetail":
            return 100
        default:
            return 0
        }
        
    }
    func reportView(_ reportView: LMReportView!, gridAt indexPath: IndexPath!) -> LMRGrid! {
        let model =  self.datas[indexPath.row][indexPath.section]
        if model is LMRGrid {
            return (model as! LMRGrid)
        }else{
            return nil
        }
    }
    
    func greenStyle() -> LMRStyle {
        let styleDic:Dictionary = [
            LMRHeightOfHeaderRowSettingName: 36,
            LMRHeightOfRowSettingName: 36,
            LMRWidthOfFirstColSettingName: 74,
            LMRWidthOfColSettingName: 75,
            LMRFontOfHeaderSettingName:  UIFont.systemFont(ofSize: 13),
            LMRFontSettingName: UIFont.systemFont(ofSize: 12),
            LMRBorderInsetsSettingName: NSValue.init(uiEdgeInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)),
            LMRBackgroundColorOfHeaderSettingName:UIColor(red: 236/255.0, green: 245/255.0, blue: 255/255.0, alpha:1),
            LMRBorderColorSettingName: UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0 , alpha:1),
            LMRTextColorOfHeaderSettingName: UIColor(red: 96/255.0, green: 98/255.0, blue: 102/255.0 , alpha:1),
            LMRTextColorSettingName:UIColor.init(white: 0.25, alpha: 1),
            LMRStripeTextColorSettingName:UIColor.black,
            //            LMRStripeBackgroundColorSettingName: UIColor(red: 239/255.0, green: 238/255.0, blue: 239/255.0 , alpha:1)
        ] as [String : Any]
        return LMRStyle.init(settings: styleDic)
    }
}

