//
//  ViewController.swift
//  Mutabaah
//
//  Created by Isa Ansharullah on 8/21/16.
//  Copyright © 2016 DuldulStudio. All rights reserved.
//

import UIKit
import Haneke

class ViewController: UIViewController {
    
    var SJ = 0, SR = 0, WQ = 0, SD = 0,
        ZS = 0, ZP = 0, SM = 0, PS = 0

    let sharedCache = Shared.JSONCache
    
    let currentDate = NSDate()
    let dateFormatter = NSDateFormatter()
    
    var dateToSend: NSDate!
    
    @IBOutlet weak var SJButton: UIButton!
    @IBOutlet weak var SRButton: UIButton!
    @IBOutlet weak var WQButton: UIButton!
    @IBOutlet weak var SDButton: UIButton!
    @IBOutlet weak var ZSButton: UIButton!
    @IBOutlet weak var ZPButton: UIButton!
    @IBOutlet weak var SMButton: UIButton!
    @IBOutlet weak var PSButton: UIButton!
    
    @IBOutlet weak var SJCount: UILabel!
    @IBOutlet weak var SRCount: UILabel!
    @IBOutlet weak var WQCount: UILabel!
    @IBOutlet weak var SDCount: UILabel!
    @IBOutlet weak var ZSCount: UILabel!
    @IBOutlet weak var ZPCount: UILabel!
    @IBOutlet weak var SMCount: UILabel!
    @IBOutlet weak var PSCount: UILabel!
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var nextDateButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    
    let asparagusColor = UIColor.init(colorLiteralRed: 135.0, green: 169.0, blue: 107.0, alpha: 1.0)
    
    func sendHttpRequest(update: Int) {
        let dFormat = NSDateFormatter()
        dFormat.dateFormat = "dd_MM_YYYY"
        let dateString = dFormat.stringFromDate(dateToSend)
        let dataString = "SJ=\(SJ)&SR=\(SR)&WQ=\(WQ)&SD=\(SD)&ZS=\(ZS)&ZP=\(ZP)&SM=\(SM)&PS=\(PS)"
        let urlstr = "http://blaku.tk/cgi-bin/mutabaah.cgi?user=test&update=\(update)&date=\(dateString)"
        let url = NSURL(string: urlstr+"&"+dataString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let fix_button: () -> () = {
            if (!self.sendButton.enabled) { self.sendButton.enabled = true; self.sendButton.backgroundColor = UIColor.redColor() }
        }
        
        
        #if true
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    return
                }
                
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateCounts(data!)
                        fix_button()
                    })
                }
            }
            
            task.resume()
        #else
        let on_success: (JSON) -> () = { JSON in
            fix_button()
            self.sharedCache.set(value: JSON, key: urlstr)
            self.updateCounts(JSON.asData())
        }
        
        let on_failure: (NSError?) -> () = {_ in
            fix_button()
        }
        
        if (update == 1) {
            print("updating..")
            sharedCache.fetchSkipCache(URL: url).onSuccess({ JSON in
                fix_button()
                self.updateCounts(JSON.asData())
            }).onFailure(on_failure)
        } else {
            sharedCache.fetch(URL: NSURL(string: urlstr)!).onSuccess(on_success).onFailure(on_failure)
        }
        #endif
    }
    
    func sendHttpRequestForGraph(dataType: Int, startDate: NSDate, endDate: NSDate) {
        let dFormat = NSDateFormatter()
        dFormat.dateFormat = "dd_MM_YYYY"
        let start = dFormat.stringFromDate(startDate)
        let end = dFormat.stringFromDate(endDate)
        #if true
            let request = NSMutableURLRequest(URL: NSURL(string: "http://blaku.tk/cgi-bin/graph.cgi?user=test&start=\(start)&end=\(end)&data=\(dataType)")!)
            //print(request)
            request.HTTPMethod = "GET"
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                } else {
                    //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                    dispatch_async(dispatch_get_main_queue(), {
                        self.dispatchGraphView(data!)
                    })
                }
            }
            
            task.resume()
        #else
            let url = NSURL(string: "http://blaku.tk/cgi-bin/graph.cgi?user=test&start=\(start)&end=\(end)&data=\(dataType)")!
        sharedCache.fetch(URL: url).onSuccess { JSON in
            self.dispatchGraphView(JSON.asData())
        }
        #endif
    }
    
    func updateCountLabels() {
        SJCount.text = String(SJ)
        SRCount.text = String(SR)
        WQCount.text = String(WQ)
        SDCount.text = String(SD)
        ZSCount.text = String(ZS)
        ZPCount.text = String(ZP)
        SMCount.text = String(SM)
        PSCount.text = String(PS)
    }
    
    func updateCounts(data: NSData) {
        do {
        let jsonResult: NSDictionary = try (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)!
            if (jsonResult["status"] as! String == "OK") {
                SJ = Int(jsonResult["SJ"] as! String)!
                SR = Int(jsonResult["SR"] as! String)!
                WQ = Int(jsonResult["WQ"] as! String)!
                SD = Int(jsonResult["SD"] as! String)!
                ZS = Int(jsonResult["ZS"] as! String)!
                ZP = Int(jsonResult["ZP"] as! String)!
                SM = Int(jsonResult["SM"] as! String)!
                PS = Int(jsonResult["PS"] as! String)!
            } else if (jsonResult["status"] as! String == "NA") {
                SJ = 0; SR = 0; WQ = 0
                SD = 0; ZS = 0; ZP = 0
                SM = 0; PS = 0
            }
            updateCountLabels()
        } catch {
            print("Error!\n")
        }
        
    }
    
    func getNextOrPrevDate(day: NSDate, nop: Int) -> NSDate {
        let daysComponents: NSDateComponents = NSDateComponents()
        daysComponents.day = nop
        
        let calendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let retDate: NSDate = calendar.dateByAddingComponents(daysComponents, toDate: day, options: NSCalendarOptions(rawValue: 0))!
        
        return retDate
    }
    
    @IBAction func changeDatePrev(sender: UIButton) {
        dateToSend = getNextOrPrevDate(dateToSend, nop: -1)
        DateLabel.text = dateFormatter.stringFromDate(dateToSend)
        nextDateButton.hidden = false
        sendHttpRequest(0)
    }
    
    @IBAction func changeDateNext(sender: UIButton) {
        if (!dateToSend.isEqualToDate(currentDate)) {
            dateToSend = getNextOrPrevDate(dateToSend, nop: 1)
            DateLabel.text = dateFormatter.stringFromDate(dateToSend)
        } else {
            nextDateButton.hidden = true
        }
        sendHttpRequest(0)
    }
    
    @IBAction func SJchangeCounter(sender: UIButton) {
        SJ = SJ >= 5 ? 0 : SJ + 1
        SJCount.text = String(SJ)
    }

    @IBAction func SRchangeCounter(sender: UIButton) {
        SR = SR >= 20 ? 0 : SR + 1
        SRCount.text = String(SR)
    }

    @IBAction func WQchangeCounter(sender: UIButton) {
        WQ += 1
        WQCount.text = String(WQ)
    }

    @IBAction func SDchangeCounter(sender: UIButton) {
        if (SD == 0) { SD = 1 }
        else { SD = 0 }
        SDCount.text = String(SD)
    }

    @IBAction func ZSchangeCounter(sender: UIButton) {
        ZS = ZS == 1 ? 0 : 1
        ZSCount.text = String(ZS)
    }
    
    @IBAction func ZPchangeCounter(sender: UIButton) {
        ZP = ZP == 1 ? 0 : 1
        ZPCount.text = String(ZP)
    }

    @IBAction func SMchangeCounter(sender: UIButton) {
        SM = SM == 1 ? 0 : 1
        SMCount.text = String(SM)
    }

    @IBAction func PSchangeCounter(sender: UIButton) {
        PS = PS == 1 ? 0 : 1
        PSCount.text = String(PS)
    }
    
    @IBAction func sendData(sender: UIButton) {
        sendButton.backgroundColor = UIColor.grayColor()
        sendButton.enabled = false
        sendButton.setTitle("Sedang Mengirim..", forState: UIControlState.Disabled)
        sendHttpRequest(1)
    }
    
    
    func dispatchGraphView(graphData: NSData) {
       // print("start!")
        do {
            let jsonResult: NSDictionary = try (NSJSONSerialization.JSONObjectWithData(graphData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)!
            
            if (jsonResult["status"] as! String == "OK") {
                let gvc = GraphViewController(data: jsonResult, start:self.getNextOrPrevDate(currentDate, nop: -6), end:currentDate)
         //       print("go!")
                self.presentViewController(gvc, animated: true, completion: nil)
            } else {
                print("wat")
            }
        } catch {
            print("Error processing graph data")
        }
    }
    
    func pressLong(sender: UILongPressGestureRecognizer) {
        if (sender.state == .Began) {
            //dbglabel.text = "Began"
            let start = getNextOrPrevDate(currentDate, nop: -6)
            let end = currentDate
            switch (sender.view as! UIButton) {
            case SJButton: sendHttpRequestForGraph(0, startDate: start, endDate: end)
            case SRButton: sendHttpRequestForGraph(1, startDate: start, endDate: end)
            case WQButton: sendHttpRequestForGraph(2, startDate: start, endDate: end)
            case SDButton: sendHttpRequestForGraph(3, startDate: start, endDate: end)
            case ZSButton: sendHttpRequestForGraph(4, startDate: start, endDate: end)
            case ZPButton: sendHttpRequestForGraph(5, startDate: start, endDate: end)
            case SMButton: sendHttpRequestForGraph(6, startDate: start, endDate: end)
            case PSButton: sendHttpRequestForGraph(7, startDate: start, endDate: end)
            default:
                print("error no such thing")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter.dateFormat = "dd/MM/YYYY"
        DateLabel.text = dateFormatter.stringFromDate(currentDate)
        dateToSend = currentDate
        nextDateButton.hidden = true
        
        for button: UIButton in [SJButton, SRButton, WQButton, SDButton, ZSButton, ZPButton, SMButton, PSButton] {
            let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.pressLong(_:)))
            button.addGestureRecognizer(longPress)
        }
        
        sendHttpRequest(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

