//
//  MainViewController.swift
//  Main
//
//  Created by Marco Tabacchino on 20/10/15.
//  Copyright © 2015 Marco Tabacchino. All rights reserved.
//

import UIKit
import CoreData
import Parse
import ParseUI
import FBSDKCoreKit
import FBSDKLoginKit

protocol MainViewControllerDelegate {
    func toggleLeftPanel()
    func collapseSidePanels()
}

class MainViewController: UITableViewController, NSFetchedResultsControllerDelegate,
PFLogInViewControllerDelegate {
    
    
    var delegate: MainViewControllerDelegate?
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultController = getFetchedResultController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let myTripPage = self.storyboard?.instantiateViewControllerWithIdentifier("MyTripViewController") as! MyTripViewController
        
        let myTripPageNav = UINavigationController(rootViewController: myTripPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = myTripPageNav
        let cell = tableView.dequeueReusableCellWithIdentifier("Trip Cell", forIndexPath: indexPath) as! TripTableViewCell
        //let cell = sender as! UITableViewCell as! TripTableViewCell
        let trip : Trip = fetchedResultController.objectAtIndexPath(indexPath) as! Trip
        myTripPage.trip = trip
        myTripPage.city = cell.getDestination(trip)
        myTripPage.startDate = cell.getArrDate(trip)
        myTripPage.endDate = cell.getDepDate(trip)
        myTripPage.tripFlag = cell.getFlag(trip)
        
    }
    
    
    // MARK:- Retrieve Tasks
    
    func getFetchedResultController() -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func taskFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        let sortDescriptor = NSSortDescriptor(key: "destination", ascending: true)
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Trip Cell", forIndexPath: indexPath) as! TripTableViewCell
        let trip = self.fetchedResultController.fetchedObjects![indexPath.row] as! Trip
        cell.setTrip(trip)
        
        cell.delButton.tag = indexPath.row
        cell.delButton.addTarget(self, action: #selector(MainViewController.delAction(_:)), forControlEvents: .TouchUpInside)
        
        
        return cell
        
    }
    
    
    @IBAction func delAction(sender: UIButton) {
        let index = sender.tag
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
        
        let deleteAlert = UIAlertController(title: "Attention!", message: "All data about your trip will be lost", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.managedObjectContext.deleteObject(managedObject)
            do {
                try self.managedObjectContext.save()
            } catch _ {
            }
            
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Travel not cancelled")
        }))
        
        presentViewController(deleteAlert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    // MARK: - TableView Refresh
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    
    
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("goToCreateNewTrip", sender: nil)
        self.tableView.setEditing(false, animated: true)
        
    }
    
    
    
    @IBAction func goToSlideMenu(sender: AnyObject) {
        delegate?.toggleLeftPanel()
        //PFUser.logOut()
        //self.logIn()
        
        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    
}

extension MainViewController: SidePanelViewControllerDelegate{
    func optionSelected(option : SlideOption) {
        delegate!.collapseSidePanels()
        
    }
    
    
}


