//
//  ChartVc.swift
//  YXPrjMng
//
//  Created by 高小伟 on 2019/1/22.
//  Copyright © 2019 高小伟. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class ChartVc: UIViewController {
    
    @IBOutlet weak var chartView: HorizontalBarChartView!
    var info:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupChart()
    }
    func setupChart() {
        //不显示图例
        chartView.legend.enabled = false
        //x轴显示在左侧
        chartView.xAxis.labelPosition = .bottom
        //y轴起始刻度为0
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.axisMinimum = 0

        //data
        let items:JSON = info["data"] as! JSON
        var xValues = [String]()
        var index = 0
        var dataEntries = [BarChartDataEntry]()
        for item in items.arrayValue {
            xValues.append(item["SECT_NAME_"].stringValue)
            let entry = BarChartDataEntry(x: Double(index), y: Double(item["END_AMT_"].doubleValue/10000))
            dataEntries.append(entry)
            index += 1
        }
        
        //left - Axi
        let xAxis:XAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularity = 1.0;
        xAxis.valueFormatter = IndexAxisValueFormatter.init(values: xValues)
        
        //top - Axi
        let lftAxisFmt = NumberFormatter()
        lftAxisFmt.minimumFractionDigits = 0
        lftAxisFmt.maximumFractionDigits = 1
        lftAxisFmt.negativeSuffix = " 万"
        lftAxisFmt.positiveSuffix = " 万"
        let lftAxis:YAxis = chartView!.leftAxis
        lftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: lftAxisFmt)
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        //目前柱状图只包括1组立柱
        let chartData = BarChartData(dataSets: [chartDataSet])
        //设置柱状图数据
        chartView.data = chartData
        chartView.rightAxis.enabled = false
        chartView.fitScreen()
    }

}
