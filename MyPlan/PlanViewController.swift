//
//  PlanTripViewController.swift
//  MyPlan
//
//  Created by Marco Tabacchino on 12/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI
import Social
import FBSDKShareKit

class PlanViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var trip : Trip?
    var date : Date?
    var plan : Plan?
    var flag : NSString = ""
    var tripFlag : NSString = ""
    var city : String = ""
    
    @IBOutlet weak var slideButton: UIBarButtonItem!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let flagD = flag
        
        print ("il flag è \(flagD)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if revealViewController() != nil  {
            slideButton.target = revealViewController()
            slideButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            
        }
        
        trip = appDelegate.trip
        city = appDelegate.city
        flag = appDelegate.tripFlag
        tripFlag = appDelegate.tripFlag
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
    }
    
    // MARK:- PrepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "goToMosaic" {
            let mosaicController : MosaicPlanViewController = segue.destinationViewController as! MosaicPlanViewController
            mosaicController.flag = flag
            mosaicController.city = city
            mosaicController.tripFlag = tripFlag
            mosaicController.trip = trip
            
        }
        if segue.identifier == "showPlanMustDetails" {
            
            let detailMustPlan : PlanMustDetailsVC = segue.destinationViewController as! PlanMustDetailsVC
            detailMustPlan.city = city
            detailMustPlan.activity = appDelegate.activity
            detailMustPlan.startH =  appDelegate.startH
            detailMustPlan.endH = appDelegate.endH
            
        }
            
        else  if segue.identifier == "showPlanEventDetails" {
            let detailEventPlan : PlanEventDetailsVC = segue.destinationViewController as! PlanEventDetailsVC
            detailEventPlan.city = city
            detailEventPlan.activity = appDelegate.activity
            detailEventPlan.startH =  appDelegate.startH
            detailEventPlan.endH = appDelegate.endH
            
            
        }
    }
    
    // MARK:- Retrieve Tasks
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Plan")
        let sortDescriptor = NSSortDescriptor(key: "activity", ascending: true)
        fetchRequest.predicate = NSPredicate(format:"flag = %@", self.tripFlag)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = PlanTableViewCell()
        let plan = self.fetchedResultController.fetchedObjects![indexPath.row] as! Plan
        let type = cell.getType(plan)
        
        //print(type)
        
        switch type {
        case "M":
            appDelegate.activity = cell.getActivity(plan)
            appDelegate.startH = cell.getStartH(plan)
            appDelegate.endH = cell.getEndH(plan)
            performSegueWithIdentifier("showPlanMustDetails", sender: self)
            
            break;
        case "E":
            appDelegate.activity = cell.getActivity(plan)
            appDelegate.startH = cell.getStartH(plan)
            appDelegate.endH = cell.getEndH(plan)
            performSegueWithIdentifier("showPlanEventDetails", sender: self)
            
            break;
        default:
            break;
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Plan Cell", forIndexPath: indexPath) as! PlanTableViewCell
        
        let plan = self.fetchedResultController.fetchedObjects![indexPath.row] as! Plan
        cell.setPlan(plan)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        
        let shareFB = UITableViewRowAction(style: .Normal, title: "FB") { action, index in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let fbShare : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                let url : NSURL = NSURL (string: "immagine")!
                fbShare.addURL(url)
                self.presentViewController(fbShare, animated: true, completion : nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
            
        }
        
        let shareTW = UITableViewRowAction(style: .Normal, title: "TW") { action, index in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                let twShare : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                let url : NSURL = NSURL (string:"immagine")!
                twShare.addURL(url)
                self.presentViewController(twShare, animated: true, completion : nil)
            } else {
                let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        }
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            
            let managedObject:NSManagedObject = self.fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
            self.managedObjectContext.deleteObject(managedObject)
            do {
                try self.managedObjectContext.save()
            } catch _ {
            }
            
        }
        
        shareFB.backgroundColor = UIColor.blueColor()
        deleteAction.backgroundColor = UIColor.redColor()
        
        
        return [deleteAction,shareFB,shareTW]
        
    }
    // MARK: - TableView Deletee
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        managedObjectContext.deleteObject(managedObject)
        do {
            try managedObjectContext.save()
        } catch _ {
        }
    }
    
    // MARK: - TableView Refresh
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("goToMosaic", sender: date)
        self.tableView.setEditing(false, animated: true)
        
    }
    
}
