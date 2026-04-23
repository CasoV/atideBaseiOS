//
//  ExcelMergeVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/18.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import LMReport
import SwiftyJSON

//有底部标题的excel表格

class ExcelMergeVc: UIViewController,LMReportViewDatasource {
    var info:NSDictionary = NSDictionary()
    var reportView:LMReportView!
    var excelType =  ExcelTypeConfig.first
    var type = MenuTypeConfig.mediateList
    var btmToolHidden:Bool = false
    var datas = [NSMutableArray]()
    let attTitles = ["项目名称","性别","专业分类","日期","出勤天数","合计"]
    let payTitles = ["项目名称","申请付款额"]
    var dailyTitles = ["姓名","月份"]
    var statiMeaData = ["标段名称","合同总额（元）","累计完成（元）","累计支付（元）","累计支付占累计完成比例","累计支付占合同总额比例"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupReportView()
        switch type {
        case MenuTypeConfig.supvisPayment:
            if  excelType == ExcelTypeConfig.first{
                self.loadPaymentsData()
            }else if excelType == ExcelTypeConfig.second {
                self.loadData()
            }else if excelType == ExcelTypeConfig.third {
                self.loadDailyData()
            }
        case MenuTypeConfig.statiMea:
            if  excelType == ExcelTypeConfig.first{
                self.loadStatiMeaData()
            }   
        default:
            break
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
    func loadStatiMeaData() {
        let json:JSON = info["data"] as! JSON
        let arr = json.arrayValue
        if arr.count > 0 {
            //Header
            let grids:NSMutableArray = NSMutableArray()
            for title in self.statiMeaData{
                let grid:LMRGrid = LMRGrid()
                grid.text = title
                grids.add(grid)
            }
            self.datas.append(grids)
        }
        //Content
        for dic in arr{
            let grids:NSMutableArray = NSMutableArray()
            for title in self.statiMeaData{
                let grid:LMRGrid = LMRGrid()
                switch title{
                case "标段名称":
                    grid.text = dic["SECT_NAME_"].stringValue
                    grids.add(grid)
                case "合同总额（元）":
                    grid.text = String.init(format:"%.f",dic["CONTRACT_AMT_"].doubleValue)
                    grids.add(grid)
                case "累计完成（元）":
                    grid.text = String.init(format:"%.f",dic["END_AMT_"].doubleValue)
                    grids.add(grid)
                case "累计支付（元）":
                    grid.text = String.init(format:"%.f",dic["PAY_AMT_"].doubleValue)
                    grids.add(grid)
                case "累计支付占累计完成比例":
                    if dic["PAY_AMT_"].doubleValue == 0{
                        grid.text = "0%"
                    }else if dic["END_AMT_"].doubleValue == 0{
                        grid.text = "100%"
                    }else{
                        grid.text = "\(String.init(format:"%.1f",dic["PAY_AMT_"].doubleValue / dic["END_AMT_"].doubleValue * 100))%"
                    }
                    grids.add(grid)
                case "累计支付占合同总额比例":
                    if dic["PAY_AMT_"].doubleValue == 0{
                        grid.text = "0%"
                    }else if dic["CONTRACT_AMT_"].doubleValue == 0{
                        grid.text = "100%"
                    }else{
                        grid.text = "\(String.init(format:"%.1f",dic["PAY_AMT_"].doubleValue / dic["CONTRACT_AMT_"].doubleValue * 100))%"
                    }
                    grids.add(grid)
                default:
                    break
                }
            }
            self.datas.append(grids)
        }
        self.reportView.datasource = self
        self.reportView.reloadData()
    }
    //Mark: -出勤表
    func loadDailyData() {
        NetWorkRequest(.listAll_mobile_3(Dict: ["prjId":info["projectId"] ?? "","sectionId":info["sectionId"] ?? "","periodId":info["periodId"] ?? "","id":info["id"] ?? "","newFormFlag":"0"])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic["data"]["rows"].array
            let days:Int = jsonDic["data"]["days"].intValue
            for i in 1...days{
                self.dailyTitles.append("\(i)")
            }
            self.dailyTitles.append("出勤天数")
            var dataArr = [ListAllMobile3]()
            for dic in jsonArr ?? Array(){
                let model:ListAllMobile3  = ListAllMobile3(dictionary: dic)
                dataArr.append(model)
            }
            DispatchQueue.main.async(execute: {
                self.reportView.datasource = self
                self.dealDailyData(arr:dataArr)
            })
        }
    }
    func dealDailyData(arr:Array<ListAllMobile3>) {
        if arr.count > 0 {
            //Header
            let grids:NSMutableArray = NSMutableArray()
            for title in self.dailyTitles{
                let grid:LMRGrid = LMRGrid()
                grid.text = title
                grids.add(grid)
            }
            self.datas.append(grids)
        }
        //Content
        for (index,model) in arr.enumerated() {
            let grids:NSMutableArray = NSMutableArray()
            for title in self.dailyTitles{
                let grid:LMRGrid = LMRGrid()
                switch title{
                case "姓名":
                    if index % 2 == 0{
                        grid.text = model.name
                        grid.rowspan = 2
                        grids.add(grid)
                    }else{
                        grids.add(NSNull())
                    }
                case "月份":
                    grid.text = model.month
                    grids.add(grid)
                case "1":
                    grid.text = model.one
                    grids.add(grid)
                case "2":
                    grid.text = model.two
                    grids.add(grid)
                case "3":
                    grid.text = model.three
                    grids.add(grid)
                case "4":
                    grid.text = model.four
                    grids.add(grid)
                case "5":
                    grid.text = model.five
                    grids.add(grid)
                case "6":
                    grid.text = model.six
                    grids.add(grid)
                case "7":
                    grid.text = model.seven
                    grids.add(grid)
                case "8":
                    grid.text = model.eight
                    grids.add(grid)
                case "9":
                    grid.text = model.nine
                    grids.add(grid)
                case "10":
                    grid.text = model.ten
                    grids.add(grid)
                case "11":
                    grid.text = model.eleven
                    grids.add(grid)
                case "12":
                    grid.text = model.twelve
                    grids.add(grid)
                case "13":
                    grid.text = model.thirteen
                    grids.add(grid)
                case "14":
                    grid.text = model.fourteen
                    grids.add(grid)
                case "15":
                    grid.text = model.fifteen
                    grids.add(grid)
                case "16":
                    grid.text = model.sixteen
                    grids.add(grid)
                case "17":
                    grid.text = model.seventeen
                    grids.add(grid)
                case "18":
                    grid.text = model.eighteen
                    grids.add(grid)
                case "19":
                    grid.text = model.nineteen
                    grids.add(grid)
                case "20":
                    grid.text = model.twenty
                    grids.add(grid)
                case "21":
                    grid.text = model.twentyOne
                    grids.add(grid)
                case "22":
                    grid.text = model.twentyTwo
                    grids.add(grid)
                case "23":
                    grid.text = model.twentyThree
                    grids.add(grid)
                case "24":
                    grid.text = model.twentyFour
                    grids.add(grid)
                case "25":
                    grid.text = model.twentyFive
                    grids.add(grid)
                case "26":
                    grid.text = model.twentySix
                    grids.add(grid)
                case "27":
                    grid.text = model.twentySeven
                    grids.add(grid)
                case "28":
                    grid.text = model.twentyEight
                    grids.add(grid)
                case "29":
                    grid.text = model.twentyNine
                    grids.add(grid)
                case "30":
                    grid.text = model.thirty
                    grids.add(grid)
                case "31":
                    grid.text = model.thirtyOne
                    grids.add(grid)
                case "出勤天数":
                    grid.text = model.total
                    grids.add(grid)
                default:
                    break
                }
            }
            self.datas.append(grids)
        }
        self.reportView.reloadData()
    }
    //Mark: -加载监理人员考勤
    func loadPaymentsData(){
        NetWorkRequest(.listAll_mobile_1(Dict: ["prjId":info["projectId"] ?? "","sectionId":info["sectionId"] ?? "","periodId":info["periodId"] ?? "","id":info["id"] ?? "","newFormFlag":"0"])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic["data"]["rows"].array
            var dataArr = [ListAllMobile1]()
            for dic in jsonArr ?? Array(){
                let model:ListAllMobile1  = ListAllMobile1(dictionary: dic)
                dataArr.append(model)
            }
            
            DispatchQueue.main.async(execute: {
                self.reportView.datasource = self
                self.dealPaymentsData(arr:dataArr)
            })
        }
    }
    func dealPaymentsData(arr:Array<ListAllMobile1>) {
        if arr.count > 0 {
            //Header
            let grids:NSMutableArray = NSMutableArray()
            for title in self.payTitles{
                let grid:LMRGrid = LMRGrid()
                grid.text = title
                grids.add(grid)
            }
            self.datas.append(grids)
        }
        //Content
        for model in arr {
            let grids:NSMutableArray = NSMutableArray()
            for title in self.payTitles{
                let grid:LMRGrid = LMRGrid()
                switch title{
                case "项目名称":
                    grid.text = model.name
                    grids.add(grid)
                case "申请付款额":
                    grid.text = model.payAmount
                    grids.add(grid)
                default:
                    break
                }
            }
             self.datas.append(grids)
        }
        self.reportView.reloadData()
    }
    //MARK: -加载监理人员考勤数据
    func loadData(){
        NetWorkRequest(.listAll_mobile_2(Dict: ["prjId":info["projectId"] ?? "","sectionId":info["sectionId"] ?? "","periodId":info["periodId"] ?? "","id":info["id"] ?? "","newFormFlag":"0"])) { (response) -> (Void) in
            let jsonDic = JSON(parseJSON: response)
            let jsonArr = jsonDic["data"]["rows"].array
            var dataArr = [ListAllMobile2]()
            for dic in jsonArr ?? Array(){
                let model:ListAllMobile2  = ListAllMobile2(dictionary: dic)
                dataArr.append(model)
            }
            DispatchQueue.main.async(execute: {
                self.reportView.datasource = self
                self.dealMobileData(yearMonth:jsonDic["data"]["yearMonth"].arrayValue.count, arr:dataArr)
            })
        }
    }
    
    func dealMobileData(yearMonth:Int,arr:Array<ListAllMobile2>) {
        if arr.count > 0 {
            //Header
            let grids:NSMutableArray = NSMutableArray()
            for title in self.attTitles{
                let grid:LMRGrid = LMRGrid()
                grid.text = title
                grids.add(grid)
            }
            self.datas.append(grids)
        }
        for model in arr {
            //Foot
            if model.name == "合计(人*月)"{
                let grids:NSMutableArray = NSMutableArray()
                for title in self.attTitles{
                    let grid:LMRGrid = LMRGrid()
                    if title == "项目名称"{
                        grid.text = model.name
                    }else if title == "合计"{
                        grid.text = model.total
                    }
                    grids.add(grid)
                }
                self.datas.append(grids)
                continue
            }
            //Content
            for i in 0..<yearMonth {
                let grids:NSMutableArray = NSMutableArray()
                for title in self.attTitles{
                    let grid:LMRGrid = LMRGrid()
                    switch title{
                    case "项目名称":
                        if i == 0 {
                            grid.text = model.name
                            grid.rowspan = yearMonth
                            grids.add(grid)
                        }else{
                            grids.add(NSNull())
                        }
                    case "性别":
                        if i == 0 {
                            grid.text = model.sex
                            grid.rowspan = yearMonth
                            grids.add(grid)
                        }else{
                            grids.add(NSNull())
                        }
                    case "专业分类":
                        if i == 0 {
                            grid.text = model.specialty
                            grid.rowspan = yearMonth
                            grids.add(grid)
                        }else{
                            grids.add(NSNull())
                        }
                    case "日期":
                        grid.text = model.yearMonthList[i].key
                        grids.add(grid)
                    case "出勤天数":
                        grid.text = model.yearMonthList[i].value
                        grids.add(grid)
                    case "合计":
                        if i == 0 {
                            grid.text = model.total
                            grid.rowspan = yearMonth
                            grids.add(grid)
                        }else{
                            grids.add(NSNull())
                        }
                    default:
                        break
                    }
                    
                }
                self.datas.append(grids)
            }
            
        }
        self.reportView.reloadData()
    }
    
    
    //Mark: -LMReportViewDatasource
    func numberOfRows(in reportView: LMReportView!) -> Int {
        return self.datas.count
    }
    func numberOfHeadRows(in reportView: LMReportView!) -> Int {
        return 1
    }
    func numberOfCols(in reportView: LMReportView!) -> Int {
        switch type {
        case MenuTypeConfig.supvisPayment:
            if  excelType == ExcelTypeConfig.first{
                return self.payTitles.count
            }else if excelType == ExcelTypeConfig.second {
               return self.attTitles.count
            }else if excelType == ExcelTypeConfig.third {
                return self.dailyTitles.count
            }else{
                return 0
            }
        case MenuTypeConfig.statiMea:
            return self.statiMeaData.count
        default:
           return 0
        }
    }
    func reportView(_ reportView: LMReportView!, widthOfCol col: Int) -> CGFloat {
        switch type {
        case MenuTypeConfig.supvisPayment:
            if  excelType == ExcelTypeConfig.first{
                 return screen_w/2
            }else{
                return 100
            }
        case MenuTypeConfig.statiMea:
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
            LMRFontSettingName: UIFont.systemFont(ofSize: 13),
            LMRBorderInsetsSettingName: NSValue.init(uiEdgeInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)),
            LMRBackgroundColorOfHeaderSettingName:UIColor(red: 93/255.0, green: 158/255.0, blue: 139/255.0, alpha:1),
            LMRBorderColorSettingName: UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0 , alpha:1),
            LMRTextColorOfHeaderSettingName: UIColor.white,
            LMRTextColorSettingName:UIColor.init(white: 0.25, alpha: 1),
            LMRStripeTextColorSettingName:UIColor.black,
//            LMRStripeBackgroundColorSettingName: UIColor(red: 239/255.0, green: 238/255.0, blue: 239/255.0 , alpha:1)
            ] as [String : Any]
        return LMRStyle.init(settings: styleDic)
    }
}
