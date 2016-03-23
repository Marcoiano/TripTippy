//
//  MustViewController.swift
//  MyPianification
//
//  Created by Marco Tabacchino on 12/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import Parse
import UIKit
import CoreData


class MustViewController : PFQueryTableViewController {
    
    var date : Date?
    var flag : NSString = ""
    var tripFlag : NSString = ""
    var city : String = ""
    var città : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        città = city
    }
    
    
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = città+"Must"
        self.textKey = "Name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    
    
    
    
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: city+"Must")
        query.orderByAscending("Name")
        return query
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! MustViewCell!
        if cell == nil {
            cell = MustViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CustomCell")
        }
        
        
        // Extract values from the PFObject to display in the table cell
        if let mustName = object?["Name"] as? String {
            cell.mustName.text = mustName
        }
        
        // Display flag image
        let initialThumbnail = UIImage(named: "qthumb")
        cell.thumb.image = initialThumbnail
        if let thumbnail = object?["thumb"] as? PFFile {
            cell.thumb.file = thumbnail
            cell.thumb.loadInBackground()
        }
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        // Refresh the table to ensure any data changes are displayed
        
        
        tableView.reloadData()
        print ("il flag è: \(flag)")
        print ("la città è: \(city)")
        print ("il trip flag è: \(tripFlag)")
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "goToMustDetails" {
            let detailController : DetailsMustViewController = segue.destinationViewController as! DetailsMustViewController
            detailController.flag = flag
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










