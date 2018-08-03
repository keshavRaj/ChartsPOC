//
//  SingleLineChartViewController.swift
//  ChartsPOC
//
//  Created by Keshav Raj on 23/07/18.
//  Copyright © 2018 Keshav Raj. All rights reserved.
//

import UIKit
import Charts

//MARK:- Style Struct for the X and Y axis
struct AxisStyle {
    let axisMinimum: Double
    let axisMaximum: Double
    let gridLineDashLength: [CGFloat]
    let chartLimitLine: [ChartLimitLine]?
    let font: UIFont
    let granularity: Double? //Minimum space between axis labels
    let valueFormatter: ((Double) -> String)? //If you want custom values to be shown on the axis. Else make it nil
    
    init(minimum: Double = 0, maximum: Double = 80, gridLineDashLength: [CGFloat] = [10,0], chartLimitLine: [ChartLimitLine]? = nil, font: UIFont = .systemFont(ofSize: 10),granularity: Double? = nil, valueFormatter: ((Double) -> String)? = nil) {
        self.axisMinimum = minimum
        self.axisMaximum = maximum
        self.gridLineDashLength = gridLineDashLength
        self.chartLimitLine = chartLimitLine
        self.font = font
        self.granularity = granularity
        self.valueFormatter = valueFormatter
    }
}

class LineChartViewController: UIViewController {
    
    private var chartView: LineChartView!
    private var xAxisStyle: AxisStyle!
    private var yAxisStyle: AxisStyle!
    private var isLayoutForFirstTime = true
    
    
    //MARK:- Convenience Initializer.
    /**
     Use this initializer to create an instance of it
     */
    convenience init(xAxisStyle: AxisStyle = AxisStyle(), yAxisStyle: AxisStyle = AxisStyle(), chartDescriptionEnabled: Bool = false,dataCalculationQueue: DispatchQueue, dataCalculationBlock: @escaping ()-> LineChartData) {
        self.init()
        self.edgesForExtendedLayout = []
        self.chartView = LineChartView()
        self.chartView.translatesAutoresizingMaskIntoConstraints = false
        self.chartView.chartDescription?.enabled = chartDescriptionEnabled
        self.chartView.dragXEnabled = true
        self.xAxisStyle = xAxisStyle
        self.yAxisStyle = yAxisStyle
        dataCalculationQueue.async {
            [weak self] in
            let data = dataCalculationBlock()
            DispatchQueue.main.async {
                [weak self] in
                self?.chartView.data = data
            }
        }
    }
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUpChartView()
    }
    
    //Pin the chart view to the left,right, top and bottom
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isLayoutForFirstTime {
            let views:[String: UIView] = [
                "lineChartView": chartView
            ]
            let horizonatlConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lineChartView]-|", options: [], metrics: nil, views: views)
            let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[lineChartView]-|", options: [], metrics: nil, views: views)
            NSLayoutConstraint.activate(horizonatlConstraint + verticalConstraint)
            isLayoutForFirstTime = false
        }
    }
    
    
    
    //MARK:- To be done only once
    
    /**
     Initializes the chart view and does the initial configuration such as setting its properties
     */
    private func setUpChartView() {
        
        view.addSubview(chartView)
        
        let yAxis = chartView.leftAxis
        yAxis.axisMinimum = yAxisStyle.axisMinimum
        yAxis.axisMaximum = yAxisStyle.axisMaximum
        yAxis.labelFont = yAxisStyle.font
        yAxis.gridLineDashLengths = yAxisStyle.gridLineDashLength
        if let chartLimitLines = yAxisStyle.chartLimitLine {
            for aChartLimitLine in chartLimitLines {
                yAxis.addLimitLine(aChartLimitLine)
            }
        }
        if let someGranularity = yAxisStyle.granularity {
            yAxis.granularity = someGranularity
        }
        if yAxisStyle.valueFormatter != nil {
            yAxis.valueFormatter = self
        }
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMaximum = xAxisStyle.axisMaximum
        xAxis.axisMinimum = xAxisStyle.axisMinimum
        xAxis.labelFont = xAxisStyle.font
        if let chartLimitLines = xAxisStyle.chartLimitLine {
            for aChartLimitLine in chartLimitLines {
                xAxis.addLimitLine(aChartLimitLine)
            }
        }
        if let someGranularity = xAxisStyle.granularity {
            xAxis.granularity = someGranularity
        }
        if xAxisStyle.valueFormatter != nil {
            xAxis.valueFormatter = self
        }
        
        chartView.rightAxis.enabled = false
        chartView.legend.form = .line
        
    }
    
    
    
    //Dummy method to create the data
    func setData() {
        let values = (0..<80).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(200) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let values2 =  (0..<80).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(200) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        let set2 = LineChartDataSet(values: values2, label: "DataSet2")
        let data = LineChartData(dataSets: [set1, set2])
        chartView.data = data
    }
    
}

extension LineChartViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double,
                        axis: AxisBase?) -> String {
        if axis === chartView.leftAxis,
            yAxisStyle.valueFormatter != nil {
            return yAxisStyle.valueFormatter!(value)
        } else if axis === chartView.xAxis,
            xAxisStyle.valueFormatter != nil {
            return xAxisStyle.valueFormatter!(value)
        } else {
            return ""
        }
        
    }
}
