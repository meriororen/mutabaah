//
//  GraphViewController.swift
//  
//
//  Created by Isa Ansharullah on 8/26/16.
//
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    var chartData: NSDictionary
    var startDate: NSDate
    var endDate: NSDate
    
    @IBAction func backButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setChart(dataPoints: [String], values:[Double]) {
        //barChartView.noDataText = "Nothing to show"
        
        let data = chartData.valueForKeyPath("data") as! [NSDictionary]
        var chartDataEntries: [BarChartDataEntry] = []
        var chartDataYVals: [String] = []
        
        for i in 0..<data.count {
            let val = (data[i]["value"] as! NSString).doubleValue;
            let date = data[i]["date"] as! String
            print ("val : \(val), date : \(date)")
            let chartEntry = BarChartDataEntry(value: val, xIndex: i)
            chartDataEntries.append(chartEntry)
            chartDataYVals.append(date)
        }
        
        
        let chartDataSet = BarChartDataSet(yVals: chartDataEntries, label: "records")
        let _chartData = BarChartData(xVals: chartDataYVals, dataSet: chartDataSet)
        
        barChartView.data = _chartData
        
        
        chartDataSet.colors = [UIColor(red: 0.5, green: 0.5, blue: 1, alpha: 1)]
        
        
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawLabelsEnabled = false
        barChartView.xAxis.labelWidth = 3
        barChartView.xAxis.axisLineWidth = 1
        barChartView.xAxis.labelTextColor = UIColor.blackColor()
        barChartView.xAxis.axisLineColor = UIColor.whiteColor()
        barChartView.xAxis.labelPosition = .Bottom
        
        
        barChartView.rightAxis.enabled = false
        
        
        barChartView.drawBarShadowEnabled = false
        
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.enabled = true
        barChartView.leftAxis.axisLineColor = UIColor.blackColor()
        barChartView.leftAxis.labelTextColor = UIColor.blackColor()
        barChartView.leftAxis.labelCount = 4
        barChartView.leftAxis.axisLineWidth = 1
        
        barChartView.legend.enabled = false
        
    }
    
    init(data initData: NSDictionary, start: NSDate, end: NSDate) {
        self.chartData = initData
        self.startDate = start
        self.endDate = end
        super.init(nibName: "GraphViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setChart([], values: [])
        //print(chartData)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
