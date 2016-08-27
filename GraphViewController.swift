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
        barChartView.noDataText = "Nothing to show"
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
