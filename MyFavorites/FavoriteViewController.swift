//
//  FavoriteViewController.swift
//  TripTippy
//
//  Created by Marco Tabacchino on 06/11/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI
import Social
import FBSDKShareKit

class FavoriteViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var trip : Trip?
    var date : Date?
    var plan : Plan?
    var tripFlag : NSString = ""
    var weekD : String = ""
    var dayD : String = ""
    var city : String = ""
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    @IBAction func goBackToMosaic(sender: AnyObject) {
        let myMosaicPage = self.storyboard?.instantiateViewControllerWithIdentifier("MosaicViewController") as! MosaicPlanViewController
        
        let myMosaicPageNav = UINavigationController(rootViewController: myMosaicPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = myMosaicPageNav
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
    }
    
    
    // MARK:- Retrieve Tasks
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Favorite")
        let sortDescriptor = NSSortDescriptor(key: "activity", ascending: true)
        fetchRequest.predicate = NSPredicate (format: "trip = %@", self.trip!)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Fav Cell", forIndexPath: indexPath) as! FavoriteTableViewCell
        
        let fav = self.fetchedResultController.fetchedObjects![indexPath.row] as! Favorite
        cell.setFav(fav)
        
        if fav.type == "M" {
            cell.favTypeImage.image = UIImage (named: "mustM")
            
            
        } else if fav.type == "E" {
            cell.favTypeImage.image = UIImage (named: "eventE")
        }
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
    
    
    
    
    // MARK: - TableView Delete
    
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
    
    
    
    
}

