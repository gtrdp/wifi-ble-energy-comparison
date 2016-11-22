//
//  SelectMethodViewController.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 26/04/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit

class SelectMethodViewController: UITableViewController {
    
    var methods:[String] = ["Wi-Fi (HTTP)", "Bluetooth"]
    var selectedMethod:String? {
        didSet {
            if let method = selectedMethod {
                selectedMethodIndex = methods.indexOf(method)!
            }
        }
    }
    var selectedMethodIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return methods.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MethodCell", forIndexPath: indexPath)
        cell.textLabel?.text = methods[indexPath.row]
        
        if indexPath.row == selectedMethodIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Other row is selected -- ned to deselect it
        if let index = selectedMethodIndex {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            cell?.accessoryType = .None
        }
        
        selectedMethod = methods[indexPath.row]
        
        // update the checkmark for the current row
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveSelectedMethod" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    selectedMethod = methods[index]
                }
            }
        }
    }

}
