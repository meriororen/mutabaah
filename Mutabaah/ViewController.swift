//
//  ViewController.swift
//  Mutabaah
//
//  Created by Isa Ansharullah on 8/21/16.
//  Copyright © 2016 DuldulStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var SJ = 0, SR = 0, WQ = 0, SD = 0,
        ZS = 0, ZP = 0, SM = 0, PS = 0

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
    
    
    func getNextOrPrevDate(day: NSDate, nop: Int) -> NSDate {
        let daysComponents: NSDateComponents = NSDateComponents()
        daysComponents.day = nop
        
        let calendar: NSCalendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let retDate: NSDate = calendar.dateByAddingComponents(daysComponents, toDate: day, options: NSCalendarOptions(rawValue: 0))!
        
        return retDate
    }
    
    func sendHttpRequest() {

        let dFormat = NSDateFormatter()
        dFormat.dateFormat = "dd_MM_YYYY"
        let dateString = dFormat.stringFromDate(dateToSend)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://blaku.tk/cgi-bin/mutabaah.cgi?date=\(dateString)&SJ=\(SJ)&SR=\(SR)&WQ=\(WQ)&SD=\(SD)&ZS=\(ZS)&ZP=\(ZP)&SM=\(SM)&PS=\(PS)")!)
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
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        
        task.resume()
    }
    
    @IBAction func changeDatePrev(sender: UIButton) {
        dateToSend = getNextOrPrevDate(dateToSend, nop: -1)
        DateLabel.text = dateFormatter.stringFromDate(dateToSend)
        nextDateButton.enabled = true
    }
    
    @IBAction func changeDateNext(sender: UIButton) {
        if (!dateToSend.isEqualToDate(currentDate)) {
            dateToSend = getNextOrPrevDate(dateToSend, nop: 1)
            DateLabel.text = dateFormatter.stringFromDate(dateToSend)
        } else {
            nextDateButton.enabled = false
        }
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
        sendHttpRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter.dateFormat = "dd/MM/YYYY"
        DateLabel.text = dateFormatter.stringFromDate(currentDate)
        dateToSend = currentDate
        nextDateButton.adjustsImageWhenDisabled = true
        nextDateButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

