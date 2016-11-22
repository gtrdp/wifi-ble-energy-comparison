//
//  HistoryTableViewController.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 25/05/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
   
    @IBOutlet var historyTableView: UITableView!
    var histories = [History]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        histories += [History(method: "Wi-Fi", sentPackets: "2000", timestamp: "2016-2-3 10:01:02", duration: "10:02:03"),
//                      History(method: "Wi-Fi", sentPackets: "2000", timestamp: "2016-2-3 10:01:02", duration: "10:02:03")]
        
        if let savedHistories = loadHistories() {
            histories = savedHistories
            histories = histories.reverse()
        } else {
            let alertCon = UIAlertController(title: "BTWF", message: "Failed to load histories.", preferredStyle: UIAlertControllerStyle.Alert)
            alertCon.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertCon, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let savedHistories = loadHistories() {
            histories = savedHistories
            histories = histories.reverse()
        } else {
            let alertCon = UIAlertController(title: "BTWF", message: "Failed to load histories.", preferredStyle: UIAlertControllerStyle.Alert)
            alertCon.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertCon, animated: true, completion: nil)
        }
        
        historyTableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "HistoryTableViewCell"
        let cell = historyTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! HistoryTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let history = histories[indexPath.row]
        
        cell.methodLabel.text = history.method
        cell.sentPacketsLabel.text = history.sentPackets
        cell.timestampLabel.text = history.timestamp
        cell.durationLabel.text = history.duration
        cell.timeIntervalLabel.text = history.timeInterval
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            histories.removeAtIndex(indexPath.row)
            saveHistories()
            historyTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
