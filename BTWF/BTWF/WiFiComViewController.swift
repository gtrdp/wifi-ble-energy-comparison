//
//  WiFiComViewController.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 10/05/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class WiFiComViewController: UIViewController {
    
    var communicationMethod:String = ""
    var timeInterval:Int = 0
    var serverAddress:String = ""
    var numberOfBeacon:Int = 0
    
    var histories = [History]()
    var currentTime: String = ""
    
    @IBOutlet weak var sentPacketsLabel: UILabel!
    @IBOutlet weak var communicationMethodLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var serverAddressLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    var timer = NSTimer()
    var clockTimer = NSTimer()
    
    var packetsCounter:Int = 0
    var secondsCounter:Int = 0
    var minutesCounter:Int = 0
    var hoursCounter:Int = 0
    
    // the data to send
    var occupancyData = ["nearby_data": [["proximity_zone": "NEAR","proximity_distance": 1.8456140098254021,"rssi":-81]],
                         "userId": "pratama"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // get current date and time
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(abbreviation: "CEST")
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        currentTime = formatter.stringFromDate(date)

        // Do any additional setup after loading the view.
        sentPacketsLabel.text = String(packetsCounter)
        communicationMethodLabel.text = communicationMethod
        timeIntervalLabel.text = String(timeInterval) + " ms"
        serverAddressLabel.text = serverAddress
        
        // Prepare the data
        // replicate the data to match the number of sensors
        var foo = [[String:NSObject]]()
        for _ in 1...numberOfBeacon {
            foo += [["proximity_zone": "NEAR","proximity_distance": 1.8456140098254021,"rssi":-81]]
        }
        occupancyData["nearby_data"] = foo
        
        // start the timer
        timer = NSTimer.scheduledTimerWithTimeInterval(Double(timeInterval)/1000, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            timer.invalidate()
            clockTimer.invalidate()
        }
        
        // save the data
        if let savedHistories = loadHistories() {
            histories += savedHistories
        }
        histories += [History(method: communicationMethod, sentPackets: sentPacketsLabel.text!,
            timestamp: currentTime, duration: counterLabel.text!, timeInterval: String(timeInterval))]
        saveHistories()
    }
    
    func updateClock() {
        secondsCounter += 1
        
        if secondsCounter == 60 {
            secondsCounter = 0
            minutesCounter += 1
        }
        if minutesCounter == 60 {
            minutesCounter = 0
            hoursCounter += 1
        }
        
        // check whether it is 3 minutes
        if minutesCounter == 3 {
            // play sound
            AudioServicesPlaySystemSound(systemSoundID)
        }
        
        // set the counter label
        counterLabel.text = String(format: "%02d", hoursCounter) + ":" + String(format: "%02d", minutesCounter) + ":" + String(format: "%02d", secondsCounter)
    }
    
    func timerFunction() {
        sendData()
        packetsCounter += 1
        sentPacketsLabel.text = String(packetsCounter)
    }
    
    func sendData() {
        let url: NSURL = NSURL(string: serverAddress)!
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(occupancyData, options: [])
        
        Alamofire.request(request)
            .validate()
            .responseString {response in
                print(response.request)
                print(response.response)
                print(response.result.value)
                print(response.result)
        }
    }
    
    // MARK: NSCoding
    func saveHistories() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(histories, toFile: History.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save histories...")
        }
    }
    
    func loadHistories() -> [History]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(History.ArchiveURL.path!) as? [History]
    }
}
