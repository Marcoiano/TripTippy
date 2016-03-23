//
//  EventsViewController.swift
//  MyPianification
//
//  Created by Marco Tabacchino on 03/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Parse
import UIKit
import CoreData


class EventsViewController : PFQueryTableViewController {
    
    var date : Date?
    var flag : NSString = ""
    var startHtoSend : NSDate?
    var endHToSend : NSDate?
    var city : String = ""
    var tripFlag : NSString = ""
    
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = city+"Events"
        self.textKey = "Name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    
    
    
    
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: city+"Events")
        query.whereKey("flagDate", equalTo: flag)
        return query
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! EventsViewCell!
        if cell == nil {
            cell = EventsViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let nameEvent = object?["Name"] as? String {
            cell.eventName.text = nameEvent
        }
        if let startH = object?["StartH"] as? NSDate {
            let formatter = NSDateFormatter()
            startHtoSend = startH
            formatter.dateFormat = "hh : mm a"
            cell.startH.text = formatter.stringFromDate(startH)
        }
        if let endH = object?["EndH"] as? NSDate {
            let formatter = NSDateFormatter()
            endHToSend = endH
            formatter.dateFormat = "hh : mm a"
            cell.endH.text = formatter.stringFromDate(endH)
        }
        
        
        
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        tableView.reloadData()
        
        print ("il flag è: \(flag)")
        
        
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToEventDetails" {
            let detailController : DetailsEventViewController = segue.destinationViewController as! DetailsEventViewController
            detailController.flag = flag
            detailController.startH = startHtoSend
            detailController.endH = endHToSend
            detailController.tripFlag = tripFlag
            detailController.city = city
            
            
            
            
            
            
            // Pass the selected object to the destination view controller
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailController.currentObject = objects?[row] as? PFObject
                
                
            }
        }
    }
    
}



